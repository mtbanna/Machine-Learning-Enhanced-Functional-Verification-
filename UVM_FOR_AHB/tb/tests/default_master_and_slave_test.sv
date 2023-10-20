import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
import sequences_package::*;
import scoreboards_package::*;
import coverages_package::*;

`include "uvm_macros.svh"
class default_master_and_slave_test extends test;
`uvm_component_utils(default_master_and_slave_test)
master_sequence another_master_sequence;

function new (string name="default_master_and_slave_test", uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
	set_type_override_by_type(master_sequence::get_type(),default_master_and_slave_sequence::get_type());
	set_type_override_by_type(scoreboard::get_type(),default_master_and_slave_scoreboard::get_type());
	set_type_override_by_type(coverage::get_type(),default_master_and_slave_coverage::get_type());
	another_master_sequence=default_master_and_slave_sequence::type_id::create("another_master_sequence",this);
	another_master_sequence.add_to_local_seed(1);
	super.build_phase(phase);
endfunction

virtual task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	my_master_interface[0].HRESET=0;
	#1;
	my_master_interface[0].HRESET=1;
	#1;
	fork
		my_master_sequence.start(this.my_environment.my_master_agent[0].my_sequencer,null);
		//another_master_sequence.start(this.my_environment.my_master_agent[1].my_sequencer,null); //will cause problems when reading from python
		//as it will read from the same file the other sequence reads from, so comment it.
	join_any
	disable fork;
	#1;
	phase.drop_objection(this);
endtask

endclass