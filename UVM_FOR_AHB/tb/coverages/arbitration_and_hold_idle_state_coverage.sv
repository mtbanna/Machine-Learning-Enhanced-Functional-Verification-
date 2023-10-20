import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"// add a parameter named "training" if it's 1, you write a csv file, else you won't, add something to terminate test on 100% cvg

class arbitration_and_hold_idle_state_coverage extends coverage;
	`uvm_component_utils(arbitration_and_hold_idle_state_coverage);

	covergroup arbitration;            
		coverpoint my_item.M_HGRANT[0]{
		option.at_least = 5;        //at least 5 times to be considered covered (if it's hit 4 times cov% =0 )              
		bins first_master={1};
		}
		coverpoint my_item.M_HGRANT[1]{
		option.at_least = 5;                      
		bins first_master={1};
		}
	endgroup

	function new( string name , uvm_component parent);
		super.new(name,parent);
		arbitration=new();
	endfunction

	virtual function void write(check_item t);
		my_item.M_HGRANT=t.M_HGRANT;
		arbitration.sample();
		print_current_test_coverage();
		coverage_changed(t);
	endfunction
	//needs current and previous signals for the 2 masters to identify sequence for machine learning 

endclass