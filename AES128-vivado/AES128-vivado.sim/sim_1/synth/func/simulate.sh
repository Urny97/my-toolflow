#!/bin/bash -f
xv_path="/esat/micas-data/software/xilinx_vivado_2017.1/Vivado/2017.1"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim AES128_tb_func_synth -key {Post-Synthesis:sim_1:Functional:AES128_tb} -tclbatch AES128_tb.tcl -log simulate.log
