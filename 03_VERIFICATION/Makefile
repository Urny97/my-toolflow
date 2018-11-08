#=======================================================================
# Makefile for Verilog simulation with VCS
#-----------------------------------------------------------------------


default: all

design_name = AES
base_dir = $(abspath ..)

test_dir = $(abspath ../99_SRC/test_benches)
synth_dir = $(abspath ../02_SYNTHESIS/data)
tech_dir = $(abspath ../99_SRC/technology/NCSU-FreePDK45-1.4/FreePDK45/osu_soc/lib/files)
test_bench = tb_AES
test_program = AES

verilog = TRUE
vhdl = TRUE

# Direct this path to a directory that has "unlimited" disk space
# Typically this would be a temp dir on the machine you are using
# This should match the vcd_dump_dir variable defined in the setup.tcl in the 04_POWER section!!!!! 
#vcd_dump_dir = /tmp/vcd_dump
# define the simulator
simulator = vcs
# define simulator options
simulator_flags = -full64 -timescale=1ns/1ps -debug_all
# define additional directives that are used to set options in the test_bench at compile time
# Using DUMP_VCD allows to based power estimations on actual signal activity => more accurate simulations
# However VCD files consume a lot of diskspace and should therefore only be made on the local volume1 of the machine you are using.
compiler_directives =


#mem_gen = $(base_dir)/vsim/vlsi_mem_gen
sim_dir = .

read_files:
	find $(tech_dir) -name '*.vhd' >> vhdl_file_list
	find $(synth_dir) -name '*.vhd' >> vhdl_file_list
	find $(test_dir) -name '*.vhd' >> vhdl_file_list

	find $(tech_dir) -name '*.v' >> verilog_file_list
	find $(synth_dir) -name '*.v' >> verilog_file_list
	find $(test_dir) -name '*.v' >> verilog_file_list

all: compile run vpd2vcd

compile: clean read_files
	@mkdir -p vcd_dump

ifeq ($(verilog), TRUE)
	vlogan -full64 `cat verilog_file_list`
endif
ifeq ($(vhdl), TRUE)
	vhdlan -smart_order -full64 `cat vhdl_file_list`
endif
	
	$(simulator) $(test_bench) $(simulator_flags) $(compiler_directives) 

vpd2vcd:
	# Convert VPD (VCD+ proprietary and binary) to IEEE VCD standard +morevhdl
	vpd2vcd +includemda ./vcd_dump/dump.vpd ./vcd_dump/dump.vcd
	rm -rf ./vcd_dump/dump.vpd
	
# Run the simulation file
run: compile
	# Run simulation.
	# The ucli.cmds file generates the .vpd signal dump (including times)
	# Check TB file name and dump directory/name in ucli.cmds
	./simv -ucli -do ucli.cmds

# Start the simulator gui
dve: compile
	./simv -gui




#------------------------------------------------------------
# Clean up

clean:
	rm -rf simv* csrc *.key DVE* *.h *.a *.daidir verilog_file_list *.vcd *.vpd vhdl_file_list .vlogansetup.args AN.DB/ 64/ vcd_dump/

.PHONY: default all compile run dve clean
