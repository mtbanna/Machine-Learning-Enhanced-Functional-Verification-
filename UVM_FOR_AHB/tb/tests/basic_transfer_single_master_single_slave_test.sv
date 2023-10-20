import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
import sequences_package::*;
import scoreboards_package::*;
import coverages_package::*;

`include "uvm_macros.svh"
class basic_transfer_single_master_single_slave_test extends test;
`uvm_component_utils(basic_transfer_single_master_single_slave_test)

function new (string name="basic_transfer_single_master_single_slave_test", uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
set_type_override_by_type(master_sequence::get_type(),basic_transfer_single_master_single_slave_sequence::get_type());
set_type_override_by_type(scoreboard::get_type(),basic_transfer_single_master_single_slave_scoreboard::get_type());
set_type_override_by_type(coverage::get_type(),basic_transfer_single_master_single_slave_coverage::get_type());
super.build_phase(phase);
endfunction

endclass