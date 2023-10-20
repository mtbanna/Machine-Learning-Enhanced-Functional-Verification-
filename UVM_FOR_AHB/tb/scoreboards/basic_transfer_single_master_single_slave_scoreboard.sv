import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

class basic_transfer_single_master_single_slave_scoreboard extends scoreboard;
`uvm_component_utils(basic_transfer_single_master_single_slave_scoreboard)
int last_master_with_grant=0;

function new(string name = "basic_transfer_single_master_single_slave_scoreboard",uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void write (check_item my_check_item);
	`uvm_info("SCOREBOARD",$sformatf("SCOREBOARD: Master:%0d, Slave:%0d",my_check_item.M_HADDR[0], my_check_item.S_HADDR), UVM_LOW);
	`uvm_info("SCOREBOARD",$sformatf("SCOREBOARD: Master:%0d, Slave:%0d",my_check_item.M_HWDATA[0], my_check_item.S_HWDATA), UVM_LOW);

	if (my_check_item.M_HADDR[0]==my_check_item.S_HADDR &&
		my_check_item.M_HWDATA[0]==my_check_item.S_HWDATA &&
		my_check_item.M_HGRANT[0]==1 && my_check_item.M_HWRITE[0]==1 && my_check_item.M_HBUSREQ[0]==1)
	to_coverage_port.write(my_check_item);
	else if(machine_learning_enhancement==2)
		write_csv_file(my_check_item);


	if(last_master_with_grant!=0 &&
		(previous_check_items[0].M_HGRANT[0]==0 && my_check_item.M_HGRANT[0]==1) &&
		my_check_item.M_HADDR[0]!=previous_check_items[0].M_HADDR[0]
		&& my_check_item.M_HWRITE[0]==1)
	assert (my_check_item.S_HADDR!=my_check_item.M_HADDR[0]) else `uvm_fatal("Scoreboard","bus samples write address earlier than expected")

	if(last_master_with_grant!=0 &&                  // we are using master #1 only
		(((previous_check_items[0].M_HGRANT[0]==0 && my_check_item.M_HGRANT[0]==1) &&(my_check_item.M_HRDATA[0]!=previous_check_items[0].M_HRDATA[0]))||
			((previous_check_items[1].M_HGRANT[0]==0 && previous_check_items[0].M_HGRANT[0]==1 && my_check_item.M_HGRANT[0]==1)&&(my_check_item.M_HRDATA[0]!=previous_check_items[1].M_HRDATA[0]))) &&
		my_check_item.M_HWRITE[0]==1)

	assert (my_check_item.S_HWDATA!=my_check_item.M_HWDATA[0]) else `uvm_fatal("Scoreboard","bus samples write data earlier than expected")

// When a master gains grant (before it must be with another ), the address is sampled in the next cycle, while data is
// sampled after 2 cycles. We don't want to hold the master address/data for some cycles, as we don't
// care about exactly mimicing a master (it waits for ready/response signal from slave...etc). At the end our cover
//condition meets the requirments. However, we could add this condition in a seperate test.
	set_previous_check_item(previous_check_items[0],previous_check_items[1]);
	set_previous_check_item(my_check_item,previous_check_items[0]);
	if(my_check_item.M_HGRANT[0]==1)
		last_master_with_grant=0;
	else if(my_check_item.M_HGRANT[1]==1)
		last_master_with_grant=1;
	else if(my_check_item.M_HGRANT[2]==1)
		last_master_with_grant=2;
endfunction

endclass