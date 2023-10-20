import a_test_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class bus_request_sequence extends master_sequence;
`uvm_object_param_utils(bus_request_sequence)


function new(string name="bus_request_sequence");
	super.new(name);
endfunction


virtual function automatic void randomize_item(ref master_sequence_item item);
	item.HBUSREQ=$urandom_range(0,1);
endfunction



endclass