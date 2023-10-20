# Create Library 
quit -sim
if [file exists work] {
    vdel -all
}
vlib work

# Compile RTL and testbench files:

vlog {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/src/amba_ahb_m2s3.v}
vlog -sv {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/ahb_parameters.sv} 
vlog -sv {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/base_test_components/master_components/master_interface.sv} 
vlog -sv {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/base_test_components/slave_components/slave_interface.sv} 
vlog -sv {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/base_test_components/a_test_package.sv} 
vlog -sv {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/sequences/sequences_package.sv} 
vlog -sv {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/scoreboards/scoreboards_package.sv} 
vlog -sv {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/coverages/coverages_package.sv} 
vlog -sv {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/tests/tests_package.sv} 
vlog -sv {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/uvm_sanity_top.sv}    

# Run simulation:

vsim -voptargs=+acc uvm_sanity_top
run -all

#Coverage Reports:
#coverage save {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/Questa_Files/UCDB Files/FULL_MACHINE_LEARNING/locked_write_single_master_single_slave.ucdb} 
#vcover report -html -htmldir {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/HTML Coverage Reports/FULL_MACHINE_LEARNING/locked_write_single_master_single_slave} {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/Questa_Files/UCDB Files/FULL_MACHINE_LEARNING/locked_write_single_master_single_slave.ucdb} 

# "vcover merge -help" to merge coverage reports








#_________________________________________________________________________________________________________________________________________________________________________________

#DPI TRIAL
#vlog -dpiheader dpiheader.h sanity_test.sv main.c //write full path name     {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/main.c}
# vlib work && vlog '-timescale' '1ns/1ns' '-sv2k9' design.sv testbench.sv  && ccomp -dpi my_dpi.cc -o my_dpi.so && vsim -c -do "vsim -sv_lib my_dpi +access+r; run -all; exit" 

#
#if { } { }  >> if statement
#puts{}   >> print statement.
#vlog {../src/amba_ahb_m2s3.v}
#vlog -sv +acc rtl/amba_ahb_m2s3.v tb/test_example.v
#vlib work
#vmap work 
#vlog -work work -vopt -stats=none {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/src/amba_ahb_m2s3.v}
#vlog -work work -vopt -stats=none {C:/Users/Dell/Documents/Bachelor Thesis/UVM_FOR_AHB/tb/test_example.v}

#onbreak {resume}



# compile and link C source files
#sccom -g {C:/questasim64_10.7c/examples/main.c}
#sccom -link

# open debugging windows
#quietly view *



