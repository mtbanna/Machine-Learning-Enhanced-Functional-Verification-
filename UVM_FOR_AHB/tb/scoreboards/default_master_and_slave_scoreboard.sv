import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

class default_master_and_slave_scoreboard extends scoreboard;
`uvm_component_utils(default_master_and_slave_scoreboard)

function new(string name = "default_master_and_slave_scoreboard",uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void write (check_item my_check_item);
	`uvm_info("SCOREBOARD",$sformatf("SCOREBOARD: M_HWDATA[0]:%0d, M_HWDATA[1]:%0d, S_HWRITE[0]:%0d", my_check_item.M_HWDATA[0],my_check_item.M_HWDATA[1], my_check_item.S_HWDATA), UVM_LOW);

	if (my_check_item.M_HWDATA[0]==my_check_item.S_HWDATA &&
		my_check_item.M_HWRITE[0]==my_check_item.S_HWRITE &&
			my_check_item.M_HBURST[0]==my_check_item.S_HBURST &&
				my_check_item.M_HADDR[0]==my_check_item.S_HADDR &&
				my_check_item.S_HSEL[0]==1)
					to_coverage_port.write(my_check_item);
	else if(machine_learning_enhancement==2)
		write_csv_file(my_check_item);
	else if(machine_learning_enhancement==3 && full_machine_learning==1)
		to_sequence_terminate_test_port.write(2'b10);
endfunction

endclass