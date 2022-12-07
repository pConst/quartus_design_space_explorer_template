
quartus_design_space_explorer_template
-------------------------------------

published as part of https://github.com/pConst/basic_verilog
Konstantin Pavlov, pavlovconst@gmail.com


This project shows how to make iterative compilation for Intel / Altera Quartus FPGA

The idea is similar to the dse.exe utility, that is being shipped with Altera /
Intel Quartus suite

We create a bunch of generated Quartus project copies which differ only one variable
All projects get compiled in parallel collecting FMAX data

This particular test shows FMAX advantage of using 'fast_counter.sv' module

Launch compilation using "make -j". And be careful with large j's there ;)

