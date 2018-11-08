
# Should be passed as an argument to the power.tcl file
# Let me know if you would find out how ;)
test_program = helloworld


.PHONY: clean synthesis

default: power

#####################################
# CLEAN                             #
#####################################
clean:
	@echo "Cleaning implementation build directory ....."
	@/bin/rm -rf work/*
	@/bin/rm -rf logs/*
	@/bin/rm -rf data/*
	@/bin/rm -rf lec/*

	@/bin/rm -rf reports/* # Catch any remaining reports

#####################################
# FRONT                             #
#####################################

power: clean
	@mkdir -p work
	@mkdir -p logs  
	@mkdir -p reports
	@mkdir -p data
	cd work; primetime -file ../scripts/power.tcl -output_log_file ../logs/$@.log
