# Reuse the design and tech setup from synthesis
source ../../02_SYNTHESIS/scripts/design_config.tcl
source ../../02_SYNTHESIS/scripts/design_tech.tcl


# Link primetime to the correct standard cells
set search_path $stdcell_search_path
set target_library $stdcell_library(db,$typ_corner_pvt)
set link_path "* $target_library"

# Show where to look for the activity files of the program
# This should match the vcd_dump_dir variable in the 03_VERIFICATION makefile!!!!!
set vcd_dump_dir "/tmp/arne-vcd"

set power_enable_analysis "true"
set precision full

# This line produces an error if no design was active, you can ignore the error
# It simply here as a safety measure
remove_design -all

# Load the synthesized design
read_ddc ../../02_SYNTHESIS/data/$rm_project_top.synthesis.ddc


