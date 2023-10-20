import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
import sequences_package::*;
import scoreboards_package::*;
import coverages_package::*;

`include "uvm_macros.svh"
class bus_request_test extends test;
`uvm_component_utils(bus_request_test)

function new (string name="bus_request_test", uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
set_type_override_by_type(master_sequence::get_type(),bus_request_sequence::get_type());
set_type_override_by_type(scoreboard::get_type(),bus_request_scoreboard::get_type());
set_type_override_by_type(coverage::get_type(),bus_request_coverage::get_type());
super.build_phase(phase);
endfunction

endclass