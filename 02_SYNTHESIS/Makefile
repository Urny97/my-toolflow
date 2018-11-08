# -----------------------------------------------------------------------------
# Abstract: GNU Makefile for reference implementation scripts
# -----------------------------------------------------------------------------
#
# Notes:
# Ensure appropriate EDA tools are on search path before using make targets
# Refer to supplied documentation for required EDA tools and versions
#
# -----------------------------------------------------------------------------

.PHONY: clean synthesis

default: synthesis

#####################################
# CLEAN                             #
#####################################
clean:
	@echo "Cleaning implementation build directory ....."
	@/bin/rm -rf work
	@/bin/rm -rf logs
	@/bin/rm -rf data
	@/bin/rm -rf lec
	@/bin/rm -rf reports
	#@/bin/rm -rf reports/dft/*
	#@/bin/rm -rf reports/lec/*
	#@/bin/rm -rf reports/*/* # Catch any remaining reports

#####################################
# FRONT                             #
#####################################

synthesis: clean
	@mkdir -p work
	@mkdir -p logs  
	@mkdir -p reports  
	@mkdir -p reports/dft  
	@mkdir -p reports/lec  
	@mkdir -p reports/synthesis
	@mkdir -p data
	cd work; design_vision-xg -64bit -f ../scripts/synthesis.tcl | tee ../logs/$@.log
