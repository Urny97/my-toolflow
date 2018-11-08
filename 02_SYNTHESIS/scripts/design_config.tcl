# ------------------------------------------------------------------------------
# General design configuration file
#
# Thomas Vandenabeele
#
# 10/11/2017
# ------------------------------------------------------------------------------


# Top level module that has to be synthesized
# This is also the prefix that some of the scripts should carry
set rm_project_top			AES128;

# Supply voltage to be used for synthesis. STDLIBS of this voltage must be avialable
set supplyVoltage			1.1;

# Set number of cores of your machine
# to check execute command lscpu
set_host_options -max_cores 4


# ------------------------------------------------------------------------------
# Clock and Reset Definitions 
# (top level, only used ports that are not connected to a constant)
# ------------------------------------------------------------------------------        
set clock_ports               	[list clock ]
set reset_ports               	[list reset]
set output_ports		[list data_out \
				      done]
set input_ports			[list data_in \
				      ce \
				      key ]

# -----------------------------------------------------------------------------
# Clock timing
# -----------------------------------------------------------------------------

set clock_period				20;									# Target clock period for the system clock
set clock_period_jitter			0.05;									# Cycle jitter (rise-to-rise) +/- N ns
                                                						# of the whole cycle
set clock_dutycycle_jitter		[expr $clock_period * 0.05 ];
                                                						# Duty cycle distortion as a percentage of the whole
                                                						# cycle - +/- N%. Affects the falling edge
                                                						# of the clock
                                                						# Adjusts clock source falling edge timing

set setup_margin            	[expr $clock_period * 0.05 ];			# in ns. Setup margin
set hold_margin             	[expr $clock_period * 0.05 ];			# in ns. Hold margin
set clock_uncertainty       	[expr $clock_period * 0.05 ];			# in ns. Pre-CTS clock skew estimate

# -----------------------------------------------------------------------------
# Pre-CTS clock skew and latency estimates
# -----------------------------------------------------------------------------
set pre_cts_clock_skew_estimate    0.05
set pre_cts_clock_latency_estimate 0.05


# -----------------------------------------------------------------------------
# Synthesis technology independent options
# -----------------------------------------------------------------------------
set max_fanout 					8;				# Maximum fanout threshold

set report_default_significant_digits 6;

# ------------------------------------------------------------------------------
# End of File
# ------------------------------------------------------------------------------
