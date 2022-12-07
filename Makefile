#------------------------------------------------------------------------------
#  quartus_design_space_explorer_template
#  Makefile for iterative compilation for Intel / Altera Quartus
#  published as part of https://github.com/pConst/basic_verilog
#  Konstantin Pavlov, pavlovconst@gmail.com
#------------------------------------------------------------------------------
#
#
# INFO ------------------------------------------------------------------------
#
# - This is a top-level Makefile
# - It makes a bunch of Quartus project copies which differ only one variable
# - Then it compiles all projects in parallel and collects FMAX data
#
# - Please define var sweep range below
# - Separate quartus project will be created and compiled for every var value
#
# - This makefile is "make -j"-friendly
#


VAR_START = 5
VAR_STOP = 64
VAR = $(shell seq $(VAR_START) ${VAR_STOP})

JOBS = $(addprefix job,${VAR})


.PHONY: all report clean


all: fmax
	echo '$@ success'

${JOBS}: job%:
	mkdir -p ./$*; \
	cp ./base/* ./$*; \
	echo "\`define WIDTH $*" > ./$*/define.vh; \
	$(MAKE) -C ./$* stap

fmax: ${JOBS}
	echo '# FMAX summary report for iterative compilation' > fmax.csv; \
	echo 'var, clk1, clk2' >> fmax.csv; \
	v=$(VAR_START);	while [ "$$v" -le $(VAR_STOP) ]; do \
		echo $$v | xargs echo -n >> fmax.csv; \
		echo -n ', ' >> fmax.csv; \
		cat ./$$v/OUTPUT/test.sta.rpt | \
		grep -A3 '; Fmax       ; Restricted Fmax ; Clock Name ; Note ;' | \
		tail -n1 | gawk {'print $$5'} | xargs echo -n >> fmax.csv; \
		echo -n ', ' >> fmax.csv; \
		cat ./$$v/OUTPUT/test.sta.rpt | \
		grep -A2 '; Fmax       ; Restricted Fmax ; Clock Name ; Note ;' | \
		tail -n1 | gawk {'print $$5'} | xargs echo -n >> fmax.csv; \
		echo >> fmax.csv; \
		v=$$((v+1)); \
	done

report: fmax.csv
	cat fmax.csv

clean:
	v=$(VAR_START);	while [ "$$v" -le $(VAR_STOP) ]; do \
		rm -rfv $$v; \
		rm -rfv fmax.csv; \
		v=$$((v+1)); \
	done

