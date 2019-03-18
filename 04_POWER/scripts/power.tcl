# Setup the design, technology and tool
source ../scripts/setup.tcl

# Read in the program argument
# Does not work...
# set program [lindex $argv 0]
# puts $program

# Select the program to get a power estimate of
# .vcd file of this program must exist in the 03_VERIFICATION dir
set program AES

current_design $rm_project_top
link

# Averaged power estimate
set power_analysis_mode "averaged" 
read_vcd /tmp/arne-vcd/dump.vcd -strip_path TB_AES/UUT 
report_switching_activity -list_not_annotated > ../reports/$program.non_annotated.txt
report_power -hierarchy > ../reports/$program.averaged.txt

# Time based power estimate
# Depending on the program this could take a while...
set power_analysis_mode "time_based"
read_vcd /tmp/arne-vcd/dump.vcd -strip_path TB_AES/UUT
report_power -hierarchy > ../reports/$program.time_based.txt

exit

