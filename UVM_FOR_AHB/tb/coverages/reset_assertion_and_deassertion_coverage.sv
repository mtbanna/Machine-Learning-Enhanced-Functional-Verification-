import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"// add a parameter named "training" if it's 1, you write a csv file, else you won't, add something to terminate test on 100% cvg

class reset_assertion_and_deassertion_coverage extends coverage;
	`uvm_component_utils(reset_assertion_and_deassertion_coverage);
//option.at_least applies to individual bins. You have specified 10 bins, each needing to get hit 10 times. That means you need a minimum of 100 samples before it would be possible to get 100% coverage.
	covergroup grant_due_to_reset;
		 option.per_instance = 1;
		coverpoint my_item.M_HGRANT[0]{
		option.at_least = 2;
			bins zero={0}; 
			bins one={1}; 
		}
	endgroup

	function new( string name , uvm_component parent);
		super.new(name,parent);
		grant_due_to_reset=new();
	endfunction

	virtual function void write(check_item t);
	    if(t.end_test==0) begin
		my_item.M_HGRANT=t.M_HGRANT;
		grant_due_to_reset.sample();
		print_current_test_coverage();
		coverage_changed(t);
	end
	else
		to_sequence_terminate_test_port.write(1);
	endfunction
	
endclass