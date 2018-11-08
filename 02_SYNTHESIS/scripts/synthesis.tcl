# ------------------------------------------------------------------------------
# Standard synthesis flow.
# Edit the design_config.tcl file to set your design parameters
# Edit the design_tech.tcl file to set your technology parameters
#
# Thomas Vandenabeele
# 10/11/2017
# ------------------------------------------------------------------------------


# ------------------------------------------------------------------------------
# Set-up Design Configuration Options
# ------------------------------------------------------------------------------
source ../scripts/design_config.tcl


# ------------------------------------------------------------------------------
# Set-up Target Technology
# ------------------------------------------------------------------------------
source ../scripts/design_tech.tcl


# ------------------------------------------------------------------------------
# Set-up Target Libraries
# ------------------------------------------------------------------------------
set_app_var search_path [concat . $stdcell_search_path $search_path]

set_app_var synthetic_library dw_foundation.sldb
set_app_var target_library [concat $stdcell_library(db,$slow_corner_pvt)]
set_app_var link_library [concat * $target_library $synthetic_library]

# ------------------------------------------------------------------------------
# Associate libraries with min libraries
# ------------------------------------------------------------------------------
foreach max_lib [concat $stdcell_library(db,$slow_corner_pvt)] \
        min_lib [concat $stdcell_library(db,$fast_corner_pvt)] \
    {
        echo "set_min_library $max_lib -min_version $min_lib"
        set_min_library $max_lib -min_version $min_lib
    }


# ------------------------------------------------------------------------------
# Setup for SAIF name mapping database
# ------------------------------------------------------------------------------
saif_map -start

# ------------------------------------------------------------------------------
# Read in the design vhdl RTL
# ------------------------------------------------------------------------------

# Default to read vhdl as standard version 2001 (not 2005)
#set_app_var hdlin_vrlg_std 2001

# Don't optimize constants for Formality and ID registers.
#set_app_var compile_seqmap_propagate_constants false

# Identify architecturally instantiated clock gates
# Note: This application variable must be set BEFORE the RTL is read in.
#set_app_var power_cg_auto_identify true

# Check for latches in RTL
set_app_var hdlin_check_no_latch true

# Local directory for intermediate elaboration files
define_design_lib work -path elab

# Setup RTL files and paths
source ../scripts/${rm_project_top}_vhdl.tcl

# Tee analyze output to separate log file
redirect -tee ../reports/synthesis/${rm_project_top}.analyze_vhdl { \
  analyze -format vhdl $vhdl_image }

# Tee elaboration output to separate log file
redirect -tee ../reports/synthesis/${rm_project_top}.elaborate { \
  elaborate -architecture Behavioral ${rm_project_top}}


write -hierarchy -format ddc \
      -output ../data/${rm_project_top}.synthesis-unmapped.ddc

# ------------------------------------------------------------------------------
# Link the design
# ------------------------------------------------------------------------------

current_design $rm_project_top

link

check_design -no_warnings
check_design -multiple_designs > \
  ../reports/synthesis/${rm_project_top}_initial.check_design

# Disable register merging
set_register_merging [all_registers] false

suppress_message UID-341
# ------------------------------------------------------------------------------
# Clock and constraints
# ------------------------------------------------------------------------------

source -echo ../scripts/clocks.tcl

source ../scripts/constraints.tcl


# ------------------------------------------------------------------------------
# Set design context
# ------------------------------------------------------------------------------

# Set the maximum fanout value on the design
set_max_fanout ${max_fanout} $rm_project_top

# Set the maximum transition value on the design
set_max_transition $max_transition($typ_corner_pvt)  $rm_project_top

# Load all outputs with suitable capacitance
set_load $output_load [all_outputs]

# Derive list of clock ports
set clock_ports [filter_collection [get_attribute [get_clocks] sources] object_class==port]

# Drive input ports with a standard driving cell and input transition
set_driving_cell -library $target_library_name($slow_corner_pvt) \
                 -from_pin ${driving_from_pin} \
                 -input_transition_rise $max_transition($slow_corner_pvt) \
                 -input_transition_fall $max_transition($slow_corner_pvt) \
                 -lib_cell ${driving_cell} \
                 -pin ${driving_pin} \
                 [remove_from_collection [all_inputs] ${clock_ports} ]

set_driving_cell -library $target_library_name($slow_corner_pvt) \
                 -from_pin ${clock_driving_from_pin} \
                 -input_transition_rise $max_transition($slow_corner_pvt) \
                 -input_transition_fall $max_transition($slow_corner_pvt) \
                 -lib_cell ${clock_driving_cell} \
                 -pin ${clock_driving_pin} \
                 ${clock_ports}

# ------------------------------------------------------------------------------
# Set Operating conditions (Synthesis uses best case / worst case)
# ------------------------------------------------------------------------------

set_operating_conditions \
-max $operating_condition_name($slow_corner_pvt) -max_lib [get_libs $target_library_name($slow_corner_pvt)] \
-min $operating_condition_name($fast_corner_pvt) -min_lib [get_libs $target_library_name($fast_corner_pvt)] \
-analysis_type bc_wc

#-max $operating_condition_name($typ_corner_pvt) -max_lib $stdcell_library(db,$typ_corner_pvt) \
#-min $operating_condition_name($fast_corner_pvt) -min_lib $stdcell_library(db,$fast_corner_pvt) \
# ------------------------------------------------------------------------------
# Create default path groups
# ------------------------------------------------------------------------------

# Separating paths can help improve optimization.

set ports_clock_root [get_ports [all_fanout -flat -clock_tree -level 0]]

group_path -name Inputs  -from [remove_from_collection [all_inputs] \
                                                       $ports_clock_root]
group_path -name Outputs -to   [all_outputs]

# Group internal paths between registers
group_path -name Regs_to_Regs -from [all_registers] -to [all_registers]



# ------------------------------------------------------------------------------
# Apply synthesis tool options
# ------------------------------------------------------------------------------

set_app_var enable_recovery_removal_arcs true

# Case analysis required to support EMA value setting for memories
set_app_var case_analysis_with_logic_constants true

#set_app_var physopt_enable_via_res_support true

set_app_var write_name_nets_same_as_ports true
set_app_var report_default_significant_digits 6

# ------------------------------------------------------------------------------
# Additional optimization constraints
# ------------------------------------------------------------------------------

# Control DRC/Fanout for tie cells
# This allows a fanout of 1 on tie cells to be set:
set_auto_disable_drc_nets -constant false

# Prevent assignment statements in the vhdl netlist.
set_fix_multiple_port_nets -all -buffer_constants [get_designs]

# Critical range for core
set_critical_range [expr 0.10 * ${clock_period} ] ${rm_project_top}

# Isolate the ports for accurate timing model creation
#set clock_ports [filter_collection [get_attribute [get_clocks] sources] object_class==port]
#set isolated_inputs [remove_from_collection [all_inputs] $clock_ports ]

#set_isolate_ports -type buffer -force [get_ports ${isolated_inputs}]
#set_isolate_ports -type buffer -force [all_outputs]

# Set to enable full range of flops for synthesis consideration
set compile_filter_prune_seq_cells false

# ------------------------------------------------------------------------------
# Compile the design
# ------------------------------------------------------------------------------

# Ultimate compile (does more and longer optimizations to gain an extra 10% at the cost of a factor 2 (at least) computation time)
compile_ultra -no_autoungroup 

# Normal (faster compile)
#compile

# ------------------------------------------------------------------------------
# Change names before output
# ------------------------------------------------------------------------------

# If this will be a sub-block in a hierarchical design, uniquify with block
# unique names to avoid name collisions when integrating the design at the top
# level
#set_app_var uniquify_naming_style ${rm_project_top}_%s_%d
#uniquify -force

#define_name_rules vhdl -case_insensitive
#change_names -rules vhdl -hierarchy -verbose > \
  ../reports/synthesis/${rm_project_top}.change_names

# ------------------------------------------------------------------------------
# Write out design data for digital verification and place and route
# ------------------------------------------------------------------------------

set_app_var vhdlout_higher_designs_first true
set_app_var vhdlout_no_tri true

write -format ddc -hierarchy -output ../data/${rm_project_top}.synthesis.ddc
write -f verilog  -hierarchy -output ../data/${rm_project_top}.synthesis.v

# ------------------------------------------------------------------------------
# Write out design data for digital verification and place and route
# ------------------------------------------------------------------------------

# Write SDF backannotation data from DCT placement for static timing analysis
write_sdf ../data/${rm_project_top}.synthesis.sdf

# Do not write out net RC info into SDC
set_app_var write_sdc_output_lumped_net_capacitance false
set_app_var write_sdc_output_net_resistance false

# Write out SDC version 1.7 to omit set_voltage for backwards compatibility
# write_sdc -version 1.7 -nosplit ../data/${rm_project_top}.synthesis.sdc
write_sdc -nosplit ../data/${rm_project_top}.synthesis.sdc
# If SAIF is used, write out SAIF name mapping file for PrimeTime-PX
saif_map -type ptpx -write_map ../reports/synthesis/${rm_project_top}_SAIF.namemap

# ------------------------------------------------------------------------------
# Write reports
# ------------------------------------------------------------------------------
source ../scripts/reports.tcl

exit

# ------------------------------------------------------------------------------
# End of File
# ------------------------------------------------------------------------------

