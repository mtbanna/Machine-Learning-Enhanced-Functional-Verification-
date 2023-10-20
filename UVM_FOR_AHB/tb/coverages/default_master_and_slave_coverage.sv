import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"// add a parameter named "training" if it's 1, you write a csv file, else you won't, add something to terminate test on 100% cvg

class default_master_and_slave_coverage extends coverage;
	`uvm_component_utils(default_master_and_slave_coverage);

	covergroup different_requests_addresses;
		coverpoint this.my_item.M_HADDR[0]{
			bins low_values[90]={[0:99]};
			bins mid_values[90]={[100:150]};
			bins high_values[90]={[300:400]};
		}
	endgroup

	function new( string name , uvm_component parent);
		super.new(name,parent);
		different_requests_addresses=new();
	endfunction

	virtual function void write(check_item t);
		my_item.M_HADDR=t.M_HADDR;
		different_requests_addresses.sample();
		print_current_test_coverage();
		coverage_changed(t);
	endfunction

endclass