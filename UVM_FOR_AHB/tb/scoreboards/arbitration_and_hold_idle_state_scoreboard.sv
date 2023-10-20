import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

class arbitration_and_hold_idle_state_scoreboard extends scoreboard;
`uvm_component_utils(arbitration_and_hold_idle_state_scoreboard)
int previous_master_with_grant, number_of_idle_states;

function new(string name = "arbitration_and_hold_idle_state_scoreboard",uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void write (check_item my_check_item);
	`uvm_info("SCOREBOARD",$sformatf("SCOREBOARD: req0:%0b, grant0:%0b",previous_check_items[0].M_HBUSREQ[0], my_check_item.M_HGRANT[0]), UVM_LOW);
	`uvm_info("SCOREBOARD",$sformatf("SCOREBOARD: req1:%0b, grant1:%0b",previous_check_items[0].M_HBUSREQ[1], my_check_item.M_HGRANT[1]), UVM_LOW);


	if ((previous_master_with_grant==1 && previous_check_items[0].M_HBUSREQ[0] ==1 && my_check_item.M_HGRANT[0]==1) ||
		(previous_master_with_grant==0 && previous_check_items[0].M_HBUSREQ[1] ==1 && my_check_item.M_HGRANT[1]==1)) //we only accept stimulus when the grant changes
	to_coverage_port.write(my_check_item);


	if(my_check_item.M_HGRANT[0]==1 && previous_master_with_grant==0)
		number_of_idle_states=number_of_idle_states+1;
	else if (my_check_item.M_HGRANT[1]==1 && previous_master_with_grant==1)
		number_of_idle_states=number_of_idle_states+1;
    else 
    			number_of_idle_states=0;
    		if(number_of_idle_states==5)
    			`uvm_error("Scoreboard","Bus doesn't terminate grant on idle state; the master holds the HBUSREQ signal without doing any functionality for 5 cycles")

		if(my_check_item.M_HGRANT[0]==1)
			previous_master_with_grant=0;
	else if(my_check_item.M_HGRANT[1]==1)
		previous_master_with_grant=1;

	set_previous_check_item(my_check_item,previous_check_items[0]);

endfunction

endclass