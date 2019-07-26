#=======================================================================
# Makefile for HDL simulation with VCS
#-----------------------------------------------------------------------


default: all

base_dir = $(abspath ..)
#src_dir = $(abspath ../99_SRC/my_src_hdl)
#src_dir = $(abspath ../99_SRC/my_src_hdl_opt)
src_dir = $(abspath ../99_SRC/src_hdl_32_bit)
test_dir = $(abspath ../99_SRC/test_benches)
test_bench = AES128_tb

verilog = TRUE
vhdl = TRUE

# Direct this path to a directory that has "unlimited" disk space
# Typically this would be a temp dir on the machine you are using
# This should match the vcd_dump_dir variable defined in the setup.tcl in the 04_POWER section!!!!!
vcd_dump_dir = /tmp/arne-vcd

# define the simulator
simulator = vcs
# define simulator options
simulator_flags = -full64 -timescale=1ns/10ps -debug_acc+all -debug_region+cell+encrypt
# define additional directives that are used to set options in the test_bench at compile time
# Using DUMP_VCD allows to based power estimations on actual signal activity => more accurate simulations
# However VCD files consume a lot of diskspace and should therefore only be made on the local volume1 of the machine you are using.
compiler_directives =


#mem_gen = $(base_dir)/vsim/vlsi_mem_gen
sim_dir = .

name:
	echo $(vcd_dump_dir)

all: analyze elaborate sim

debug: analyze elaborate dve

analyze:
ifeq ($(verilog), TRUE)
	echo $(src_dir)/*.v > verilog_file_list
	#echo $(test_dir)/*.v >> verilog_file_list
	vlogan -full64 `cat verilog_file_list`
endif
ifeq ($(vhdl), TRUE)
	echo $(src_dir)/*.vhd > vhdl_file_list
	echo $(test_dir)/*vhd >> vhdl_file_list
	vhdlan -smart_order -full64 `cat vhdl_file_list`
endif

elaborate:
	$(simulator) $(test_bench) $(simulator_flags) $(compiler_directives)


#compile: clean
#	echo $(src_dir)/*.v > verilog_file_list
#	echo $(no_synth_dir)/*.v >> verilog_file_list
#	echo $(test_dir)/$(test_bench).v >> verilog_file_list

#	$(simulator) verilog_file_list $(simulator_flags) $(compiler_directives)

# Run the simulation file
sim:
	./simv

# Start the simulator gui
dve:
	./simv -gui




#------------------------------------------------------------
# Clean up

clean:
	rm -rf simv* csrc *.key DVE* *.h *.a *.daidir verilog_file_list *.vcd *.vpd vhdl_file_list 64/

.PHONY: default all all-gui analyse elaborate dve clean
