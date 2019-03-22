set project_top AES128

set_attribute lib_search_path /tmp/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/Liberty/NLDM/

set_attribute library ./NangateOpenCellLibrary_typical.lib

set_attribute init_hdl_search_path ../../99_SRC/my_src_hdl/

read_hdl -vhdl {
	AES128.vhd \
	AddRoundKey.vhd \
	Control_FSM.vhd \
	Keyscheduler.vhd \
	SubBytes.vhd \
	bytesub.vhd \
	mixcolumn.vhd \
	shiftrow.vhd \
}
#PKG_AES128.vhd \

elaborate

set_attribute syn_map_effort high
syn_generic $project_top
syn_map $project_top

#synthesize -to_mapped

####################
## Some Reporting ##
####################
report messages -all > ../reports/$project_top.messages.rpt
report timing -encounter -worst 10 >  ../reports/$project_top.timing.rpt
report datapath -all > ../reports/$project_top.datapath.rpt
report gates -power > ../reports/$project_top.gates.rpt
report low_power_cells > ../reports/$project_top.lp_cells.rpt
report qor -levels_of_logic > ../reports/$project_top.qor.rpt
report sequential > ../reports/$project_top.sequential.rpt
# Any instance in the design can be specified
#report instance -timing -power $project_top > ../reports/$project_top.instance.rpt
#set_db $project_top .library_domain typ_0500
report area > ../reports/$project_top.area.rpt
report gates > ../reports/$project_top.gates.rpt
report power -hier >  ../reports/$project_top.power.rpt

###############################
## Write out verilog netlist ##
###############################
write_hdl > ../data/$project_top.synthesis.v
write_sdf > ../data/$project_top.synthesis.sdf

#write -mapped > AES128_synth.v

write_script > script

gui_show;