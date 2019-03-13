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
echo "xvhdl -m64 --relax -prj AES128_tb_vhdl.prj"
ExecStep $xv_path/bin/xvhdl -m64 --relax -prj AES128_tb_vhdl.prj 2>&1 | tee -a compile.log
