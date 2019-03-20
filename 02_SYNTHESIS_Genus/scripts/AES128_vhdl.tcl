
#------------------------------------------------------------------------------
# Purpose :  Synthesis Script - VHDL
#
# ------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------
# Add System RTL search path
# ----------------------------------------------------------------------------------

# path for vhdl files
# Only files to be synthesized should be in the verilog directory!!!
set proj_vhdl    ../../99_SRC/my_src_hdl
set search_path [ concat $search_path $proj_vhdl ]



# add you memory path here
# set syn_mem_lib     ../../..
# set search_path [ concat $search_path $syn_mem_lib ]

# -----------------------------------------------------------------------------------
# RTL for ZscaleTop
# -----------------------------------------------------------------------------------

# Selection of all the files/modules that should be synthesized
set vhdl_files [ list \
				        AddRoundKey.vhd \
		                        AES128.vhd \
		                        bytesub.vhd \
		                        Control_FSM.vhd \
		                        Keyscheduler.vhd \
		                        mixcolumn.vhd \
		                        shiftrow.vhd \
		                        SubBytes.vhd \
    				]			

set vhdl_image [ concat $vhdl_files]
# ------------------------------------------------------------------------------
# End of File
# ------------------------------------------------------------------------------
