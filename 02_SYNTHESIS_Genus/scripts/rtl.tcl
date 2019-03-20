set_attribute lib_search_path /tmp/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/Liberty/NLDM/

set_attribute library {NangateOpenCellLibrary_typical.lib}

read_hdl ../../99_SRC/my_src_hdl/AES128.vhd
read_hdl ../../99_SRC/my_src_hdl/AddRoundKey.vhd
read_hdl ../../99_SRC/my_src_hdl/Control_FSM.vhd
read_hdl ../../99_SRC/my_src_hdl/Keyscheduler.vhd
read_hdl ../../99_SRC/my_src_hdl/PKG_AES128.vhd
read_hdl ../../99_SRC/my_src_hdl/SubBytes.vhd
read_hdl ../../99_SRC/my_src_hdl/bytesub.vhd
read_hdl ../../99_SRC/my_src_hdl/mixcolumn.vhd
read_hdl ../../99_SRC/my_src_hdl/shiftrow.vhd

elaborate

synthesize -to_mapped

write -mapped > AES128_synth.v

write_script > script

gui_show;