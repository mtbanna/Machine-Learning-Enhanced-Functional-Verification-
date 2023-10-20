import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
import sequences_package::*;
import scoreboards_package::*;
import coverages_package::*;

`include "uvm_macros.svh"
class reset_assertion_and_deassertion_test extends test;
`uvm_component_utils(reset_assertion_and_deassertion_test)

function new (string name="reset_assertion_and_deassertion_test", uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
	set_type_override_by_type(master_sequence::get_type(),reset_assertion_and_deassertion_sequence::get_type());
	set_type_override_by_type(scoreboard::get_type(),reset_assertion_and_deassertion_scoreboard::get_type());
	set_type_override_by_type(coverage::get_type(),reset_assertion_and_deassertion_coverage::get_type());
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
		begin
			#43;
			my_master_interface[0].HRESET=0;
            #40;
		end
	join_any
	disable fork;
		#1;
		phase.drop_objection(this);
		endtask

			endclass