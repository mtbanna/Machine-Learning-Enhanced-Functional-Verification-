import a_test_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class reset_assertion_and_deassertion_sequence extends master_sequence;
`uvm_object_param_utils(reset_assertion_and_deassertion_sequence)
master_sequence_item my_item;

function new(string name="reset_assertion_and_deassertion_sequence");
	super.new(name);
endfunction


virtual function automatic void randomize_item(ref master_sequence_item item);
	item.HBUSREQ=1;
endfunction



endclass