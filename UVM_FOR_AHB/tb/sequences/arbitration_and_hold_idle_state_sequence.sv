import a_test_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class arbitration_and_hold_idle_state_sequence extends master_sequence;
`uvm_object_param_utils(arbitration_and_hold_idle_state_sequence)
master_sequence_item my_item;
int hold_idle_state=0;

function new(string name="arbitration_and_hold_idle_state_sequence");
	super.new(name);
endfunction


virtual function automatic void randomize_item(ref master_sequence_item item);
	if(hold_idle_state<=10)
		item.HBUSREQ=1;		
	else
		item.HBUSREQ=$urandom_range(0,1);

	hold_idle_state=hold_idle_state+1;

endfunction

endclass