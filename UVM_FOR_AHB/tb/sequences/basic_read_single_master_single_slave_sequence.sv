import a_test_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class basic_read_single_master_single_slave_sequence extends master_sequence;
`uvm_object_param_utils(basic_read_single_master_single_slave_sequence)
master_sequence_item my_item;

function new(string name="basic_read_single_master_single_slave_sequence");
	super.new(name);
endfunction


virtual function automatic void randomize_item(ref master_sequence_item item);
	item.HWRITE=$urandom_range(0,1);
	item.HBUSREQ=$urandom_range(0,1);
	item.HADDR=$urandom_range(0,399);
	item.HWDATA=$urandom_range(0,5000);
    //rest of signals (burst,size..etc) are default
endfunction



endclass