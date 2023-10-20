import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

class bus_request_scoreboard extends scoreboard;
`uvm_component_utils(bus_request_scoreboard)

function new(string name = "bus_request_scoreboard",uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void write (check_item my_check_item);   
	`uvm_info("SCOREBOARD",$sformatf("SCOREBOARD: req:%0b, grant:%0b",previous_check_items[0].M_HBUSREQ[0], my_check_item.M_HGRANT[0]), UVM_LOW);

	if (previous_check_items[0].M_HBUSREQ[0] ==1 && my_check_item.M_HGRANT[0]==1) 
		to_coverage_port.write(my_check_item);
	else if (machine_learning_enhancement==2)
		write_csv_file(my_check_item);
	else if(machine_learning_enhancement==3 && full_machine_learning==1)
		to_sequence_terminate_test_port.write(2'b10);
	
   set_previous_check_item(my_check_item,previous_check_items[0]);
		
endfunction

virtual function void write_csv_file(check_item item);
		file_handle=$fopen(to_python_csv_file_location_training,"a");
		if (file_handle!==0)
			uvm_report_info("", "File was opened successfully", UVM_MEDIUM);
		else
			uvm_report_fatal("", "File wasn't opened");
		$sformat(file_text,"%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
			0,                  //overridden here cause setting check_item.M_HBUSREQ[0] before sending to the function causes strange errors.
			item.M_HADDR[0],
			item.M_HTRANS[0],
			item.M_HSIZE[0],
			item.M_HBURST[0],
			item.M_HPROT[0],
			item.M_HLOCK[0],
			item.M_HWRITE[0],
			item.M_HWDATA[0],
			0); // coverage bit        
		$fdisplay(file_handle,file_text);
		$fclose(file_handle);
	endfunction

endclass