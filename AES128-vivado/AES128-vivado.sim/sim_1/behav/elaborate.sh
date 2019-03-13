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
ExecStep $xv_path/bin/xelab -wto f8a4f9f7f41a49e684f0b4c641be48c2 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot AES128_tb_behav xil_defaultlib.AES128_tb -log elaborate.log
