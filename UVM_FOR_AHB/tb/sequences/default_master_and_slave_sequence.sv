import a_test_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class default_master_and_slave_sequence extends master_sequence;
`uvm_object_param_utils(default_master_and_slave_sequence)
master_sequence_item my_item;

function new(string name="default_master_and_slave_sequence");
	super.new(name);
endfunction

virtual function automatic void randomize_item(ref master_sequence_item item);
	item.HBUSREQ=0;
	item.HWDATA=$urandom_range(0,1000);
	item.HWRITE=$urandom_range(0,1);
	item.HBURST=$urandom_range(0,7);
	item.HADDR=$urandom_range(0,399);
endfunction



endclass