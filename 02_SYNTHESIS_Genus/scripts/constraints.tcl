# -----------------------------------------------------------------------------------
# Define Cycle Percentage Expressions
# -----------------------------------------------------------------------------------

set cycle90    [expr 0.90 * ${clock_period}]
set cycle80    [expr 0.80 * ${clock_period}]
set cycle70    [expr 0.70 * ${clock_period}]
set cycle60    [expr 0.60 * ${clock_period}]
set cycle50    [expr 0.50 * ${clock_period}]
set cycle40    [expr 0.40 * ${clock_period}]
set cycle30    [expr 0.30 * ${clock_period}]
set cycle20    [expr 0.20 * ${clock_period}]
set cycle10    [expr 0.10 * ${clock_period}]



# -----------------------------------------------------------------------------------
# Resets
# -----------------------------------------------------------------------------------

set_input_delay	-clock VCLK -max $cycle50 $reset_ports 

puts "Constrained Resets"


# ------------------------------------------------------------------------------
# Define Signal Constraints
# ------------------------------------------------------------------------------

set_output_delay -clock VCLK  -max $cycle50 $output_ports
set_input_delay -clock VCLK  -max $cycle50 $input_ports
