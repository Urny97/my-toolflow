#------------------------------------------------------------------------------
# Purpose : Synthesis Script - Tech library setup
#
# ------------------------------------------------------------------------------

puts "Technology setup file"

# Usage:
# This script creates Tcl arrays to describe technology constants.
# These are keyed around 'extract corner' and 'pvt corner'. However,
# the key could be any required naming or combination of design variables.

# For example:
# 1) "$tluplus_file(key)" could use 'extract' as the key name:
#    setting e.g. "$tluplus_file(typical)" or "$tluplus_file(typical)" etc.
# 2) "$stdcell_library(key)" could use 'libtype,transistor_temperature_voltage' as the
#    key name: setting e.g. "$stdcell_library(db,ff_1p98v_m40c)"
#

# They key can be any required name, such as "$stdcell_library(best)", but
# building up a key name from other independent variable will give consistent
# naming.
# The following variables are used in this flow to set key names:

# Variable:     Description:                     Examples:
#
# $transistor   Transistor n+p process corner    ss, tt, ff
# $voltage      Primary voltage                  1p62v, 1p80v, 1p98v
# $temperature  Operating temperature            m40c, 25c, 125c
# $extraction   RC parasitic extraction corner   typical
# $mode         Run-time mode of design          unconstrained, functional, scanshift

# These allow simpler iteration around scenarios for multi-scenario flows.

# A technology setting may not require a per corner key
# E.g. "$stdcell_search_path" may not change between corners.
# If this did need to change between corners, it could be replaced with
# different verisions, such as "$stdcell_search_path(ss_1p62v_m40c)",
# "$stdcell_search_path(ff_1p98v_m40c)" etc, but all script references must be
# updated to accept data in array from e.g. "$stdcell_search_path($pvt)"

# Important: for variables that include lists, ordering within lists may be
# important. Ensure list ordering is consistent between differently keyed lists
# in the same array.

#####################################################################################
# 1. Main design performance targets for different supply voltages
#####################################################################################

switch $supplyVoltage {
    1.1 {
    	puts "Setting technology for 1.1V supply"
    	# -----------------------------------------------------------------------------
		# Default corners:
		# -----------------------------------------------------------------------------

		# The default corner names are 'keys' defining the min/max PVT used throughout
		# implementation. These can be changed if matching libraries/pvt corners are
		# available


		set slow_corner_pvt ss_1p1v;
		set typ_corner_pvt  tt_1p1v;
		set fast_corner_pvt ff_1p1v;

		# Equivalent default RC extraction corners 'keys' are also used

		# set slow_corner_extraction typical
		# set typ_corner_extraction  typical
		# set fast_corner_extraction typical

		# -----------------------------------------------------------------------------
		# Clock timing (set in design_config)
		# -----------------------------------------------------------------------------

		#set clock_period            $clock_period       ;# Target clock period for the system clock
		#set clock_period_jitter     $clock_period_jitter;# Cycle jitter (rise-to-rise) +/- N ns
				                                        ;# of the whole cycle
		#set clock_dutycycle_jitter [expr $clock_period * 0.05 ]
				                                        ;# Duty cycle distortion as a percentage of the whole
				                                        ;# cycle - +/- N%. Affects the falling edge
				                                        ;# of the clock
				                                        ;# Adjusts clock source falling edge timing
		#set swclock_dutycycle_jitter [expr $swclock_period * 0.05 ]
				                                        ;# Adjusts clock source falling edge
				                                        ;# timing

		#set setup_margin            0.50               ;# in ns. Setup margin
		#set hold_margin             0.50               ;# in ns. Hold margin
		#set clock_uncertainty       0.250               ;# in ns. Pre-CTS clock skew estimate

		# -----------------------------------------------------------------------------
		# Pre-CTS clock skew and latency estimates
		# -----------------------------------------------------------------------------

		#set pre_cts_clock_skew_estimate    0.150
		#set pre_cts_clock_latency_estimate 0

		#####################################################################################
		# 2. Design environment
		#####################################################################################

		# -----------------------------------------------------------------------------
		# Input driving cell models
		# -----------------------------------------------------------------------------

		set driving_cell            BUFX4;						# The driving cell for all inputs
		set driving_from_pin        A;							# Input of the driving cell
		set driving_pin             Y;							# The output pin of the driving cell

		set clock_driving_cell      CLKBUF3;					# The driving cell for clock ports
		set clock_driving_from_pin  A;							# The input pin of the clock driving cell
		set clock_driving_pin       Y;							# The output pin of the clock driving cell
		
		# Current version of the freepdk does not contain a clock gating cell
		# This cell could be added if required
		# set icg_name				clock_gating_cell;			# Name of ICG cell

		# -----------------------------------------------------------------------------
		# Output loading models
		# -----------------------------------------------------------------------------

		set output_load             0.150;						# Capacitive load placed on all outputs

		# -----------------------------------------------------------------------------
		# Max capacitance
		# -----------------------------------------------------------------------------

		# Keyed from "$transistor_$voltage_$temperature"

		# This is used to set the upper limits for tables during timing model creation
		# These values have based on the largest max_capacitance in target library
		# Smaller values may be preferable for increased accuracy over a smaller range

		set max_capacitance(ss_1p1v) 10;
		set max_capacitance(tt_1p1v) 10;
		set max_capacitance(ff_1p1v) 10;

		# -----------------------------------------------------------------------------
		# Transition time targets
		# -----------------------------------------------------------------------------

		# Keyed from "$transistor_$voltage_$temperature"

		# Only max_transition($slow_corner_pvt) is required during implementation
		# Others are used in analysis steps such as sta and model creation

		set max_transition(ss_1p1v) 4.000;
		set max_transition(tt_1p1v) 4.000;
		set max_transition(ff_1p1v) 4.000;

		# Clock transition requirement
		set max_clock_transition(ss_1p1v) [expr $max_transition(ss_1p1v)/2.0 ];
		set max_clock_transition(tt_1p1v) [expr $max_transition(tt_1p1v)/2.0 ];
		set max_clock_transition(ff_1p1v) [expr $max_transition(ff_1p1v)/2.0 ];

		

		#####################################################################################
		# 3. Design libraries
		#####################################################################################

		# -----------------------------------------------------------------------------------
		# Path to libraries
		# -----------------------------------------------------------------------------------

		if {[info exists sh_launch_dir] == 0} {
		  set sh_launch_dir "."
		}

		set libs                  "../../99_SRC/technology/NCSU-FreePDK45-1.4/FreePDK45"

		# -----------------------------------------------------------------------------
		# Techfile and metal stack extract models (not used for now)
		# -----------------------------------------------------------------------------

		# set tech_file             ${libs}/ncsu_basekit/techfile/FreePDK45.tf
		# set tf2itf_map_file       ${libs}/osu_soc/lib/files/gds2_encounter.map

		# Keyed from '$extraction'

		# set tluplus_file(typical) ${libs}/arm/tsmc/ce018fg/arm_tech/r5p1/synopsys_tluplus/6lm/typical.tluplus

		# -----------------------------------------------------------------------------
		# Library search path and Milkyway locations
		# -----------------------------------------------------------------------------

		set stdcell_search_path [ list \
								  ${libs}/osu_soc/lib/files/ \
								   ]

		# set stdcell_mw_library  [ list ${libs}/arm/tsmc/ce018fg/sc7_base_rvt/r9p0-01eac0/milkyway/6lm/sc7_ce018fg_base_rvt ]

		# -----------------------------------------------------------------------------
		# NLDM .db filenames
		# -----------------------------------------------------------------------------

		# Keyed from "db,$transistor_$voltage_$temperature"

		# Order within lists must be consistent between corners to allow min/max
		# relationship linking.
		
		# Since the freePDK does not come with corner characterizations for the standardcells
		# the same .db is used for every corner, this might lead to some warnings
		# If time allows it is possible to recharacterize the standardcells at other supply voltages.

		# Standard Cells
		set stdcell_library(db,ss_1p1v) [ list \
												gscl45nm.db \
				                                ]

		set stdcell_library(db,tt_1p1v) [ list \
				                                gscl45nm.db \
				                                ]

		set stdcell_library(db,ff_1p1v)  [ list \
				                                gscl45nm.db \
				                                ]

		# -----------------------------------------------------------------------------
		# Operating conditions
		# -----------------------------------------------------------------------------
		# Only typical operating condition available at this point
		
		# Keyed from "$transistor_$voltage_$temperature"
		set operating_condition_name(ss_1p1v) 				typical
		set target_library_name(ss_1p1v) 					[ list \
															gscl45nm \
				                                			]

		set operating_condition_name(tt_1p1v)				typical
		set target_library_name(tt_1p1v) 					[ list \
				                                			gscl45nm \
				                                			]

		set operating_condition_name(ff_1p1v)				typical
		set target_library_name(ff_1p1v) 					[ list \
				                                			gscl45nm \
				                                			]
    }
    X.XX {
    
    	# Copy past the setup from the 1.1V supply setting and adapt where necessary
    	# to tailer to your new voltage setting
    }
    default {
    
    	# This condition should never be reached.
    	# If it is reached however it means a none existing voltage was specified in the design_config file
    	puts "Unsupported voltage configuration, please make sure the specified supply_voltage in the design_config file is also defined in the design_tech file"
    	exit
        
    }
}

# End of File
