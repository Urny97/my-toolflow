# ------------------------------------------------------------------------------
# Define the clocks in the $rm_project_top
# ------------------------------------------------------------------------------

# Declares the clocks present in the design with period, uncertainty and
# latency information for synthesis:
#
#   Period      - Describes the frequency to be acheieved by synthesis.
#
#   Uncertainty - Describes all parameters that could influence the difference
#                 in clock timing between two related flops. Since jitter is
#                 explicitly mentioned this will include OCV, skew and margin.
#
#   Latency     - Describes the delay in the clock tree from the core clock pin
#                 to the flop clock pin; at this point it is an estimate.
#
foreach clock_name ${clock_ports} {
  create_clock -name ${clock_name} -period [expr ${clock_period} - ${clock_period_jitter}] [get_ports ${clock_name} ]
  set_clock_uncertainty -setup [expr ${setup_margin} + $pre_cts_clock_skew_estimate] [get_clocks ${clock_name} ]
  set_clock_uncertainty -hold [expr ${hold_margin} + $pre_cts_clock_skew_estimate] [get_clocks ${clock_name} ]
  set_clock_latency -source -early [expr 0.0 + $clock_dutycycle_jitter] [get_clocks ${clock_name} ]
  set_clock_latency -source -late  [expr 0.0 + $clock_dutycycle_jitter] [get_clocks ${clock_name} ]
  set_clock_latency $pre_cts_clock_latency_estimate [get_clocks ${clock_name} ]

  echo "Defined clock $clock_name"
}
#set_clock_latency -source -dynamic [expr 0.0 + $clock_dutycycle_jitter] [get_clocks ${clock_name} ]
#  set_clock_latency -source -rise -early [expr 0.0 - $clock_dutycycle_jitter] [get_clocks ${clock_name} ]
#  set_clock_latency -source -fall -late  [expr 0.0 + $clock_dutycycle_jitter] [get_clocks ${clock_name} ]

# ------------------------------------------------------------------------------
# Virtual clocks (these are handy to constrain inputs and outputs)
# ------------------------------------------------------------------------------

create_clock -name VCLK -period [expr ${clock_period} - ${clock_period_jitter}]
set_clock_uncertainty -setup [expr ${setup_margin} + $pre_cts_clock_skew_estimate] [get_clocks {VCLK} ]
set_clock_uncertainty -hold  [expr ${hold_margin} + $pre_cts_clock_skew_estimate] [get_clocks {VCLK} ]
#set_clock_latency -source -dynamic [expr 0.0 + $clock_dutycycle_jitter] [get_clocks {VCLK} ]
set_clock_latency -source -early [expr 0.0 + $clock_dutycycle_jitter] [get_clocks {VCLK} ]
set_clock_latency -source -late  [expr 0.0 + $clock_dutycycle_jitter] [get_clocks {VCLK} ]
set_clock_latency $pre_cts_clock_latency_estimate [get_clocks {VCLK} ]

echo "Defined clock VCLK"

# ------------------------------------------------------------------------------
# End of File
# ------------------------------------------------------------------------------
