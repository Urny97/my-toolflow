
#------------------------------------------------------------------------------
# Purpose :  Synthesis Script - VHDL
#
# ------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------
# Add System RTL search path
# ----------------------------------------------------------------------------------

# path for vhdl files
# Only files to be synthesized should be in the verilog directory!!!

#set proj_vhdl    ../../99_SRC/my_src_hdl
#set proj_vhdl    ../../99_SRC/my_src_hdl_opt
set proj_vhdl    ../../99_SRC/src_hdl_32_bit
#set proj_vhdl    ../../99_SRC/src_hdl_32_bit_opt
set search_path [ concat $search_path $proj_vhdl ]



# add you memory path here
# set syn_mem_lib     ../../..
# set search_path [ concat $search_path $syn_mem_lib ]

# -----------------------------------------------------------------------------------
# RTL for ZscaleTop
# -----------------------------------------------------------------------------------

# Selection of all the files/modules that should be synthesized
#set vhdl_files [ list \
				        		AddRoundKey.vhd \
		                        AES128.vhd \
		                        SubBytes.vhd \
		                        bytesub.vhd \
		                        Control_FSM.vhd \
		                        Keyscheduler.vhd \
		                        mixcolumn.vhd \
		                        shiftrow.vhd \
    				]			

#set vhdl_files [ list \
				        		AddRoundKey.vhd \
		                        AES128.vhd \
		                        SubBytes.vhd \
		                        Control_FSM.vhd \
		                        Keyscheduler.vhd \
		                        mixcolumn.vhd \
		                        shiftrow.vhd \
		                        AES_Sbox_Canright.vhd \
		                        GF_INV_4.vhd \
		                        GF_INV_8.vhd \
		                        GF_MULS_2.vhd \
		                        GF_MULS_4.vhd \
		                        GF_MULS_SCL_2.vhd \
		                        GF_SCLW_2.vhd \
		                        GF_SCLW2_2.vhd \
		                        GF_SQ_2.vhd \
		                        GF_SQ_SCL_4.vhd \
    				]

set vhdl_files [ list \
				        		AES128.v \
				        		AddRoundKey32.v \
		                        subbytes32.v \
		                        bytesub.vhd \
		                        Keyscheduler.vhd \
		                        mixcolumn32.vhd \
		                        shiftrow.vhd \
		                        b128to32.v \
		                        b32to128_2.v \
    				] 				                        

#set vhdl_files [ list \
				        		AES128.v \
				        		AddRoundKey32.v \
		                        subbytes32.v \
		                        Keyscheduler.vhd \
		                        mixcolumn32.vhd \
		                        shiftrow.vhd \
		                        b128to32.v \
		                        b32to128_2.v \
		                        AES_Sbox_Canright.vhd \
		                        GF_INV_4.vhd \
		                        GF_INV_8.vhd \
		                        GF_MULS_2.vhd \
		                        GF_MULS_4.vhd \
		                        GF_MULS_SCL_2.vhd \
		                        GF_SCLW_2.vhd \
		                        GF_SCLW2_2.vhd \
		                        GF_SQ_2.vhd \
		                        GF_SQ_SCL_4.vhd \
    				] 

set vhdl_image [ concat $vhdl_files]
# ------------------------------------------------------------------------------
# End of File
# ------------------------------------------------------------------------------