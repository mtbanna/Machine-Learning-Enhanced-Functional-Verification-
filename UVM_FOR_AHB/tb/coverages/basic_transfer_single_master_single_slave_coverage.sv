import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"// add a parameter named "training" if it's 1, you write a csv file, else you won't, add something to terminate test on 100% cvg

class basic_transfer_single_master_single_slave_coverage extends coverage;
	`uvm_component_utils(basic_transfer_single_master_single_slave_coverage);

	covergroup written_all_addresses;                           
		coverpoint this.my_item.M_HADDR[0]{                    
			bins write_low_values[]={[0:100]};
			bins write_mid_values[]={[101:300]};
			bins write_high_values[]={[301:399]};
		}
	endgroup

	function new( string name , uvm_component parent);
		super.new(name,parent);
		written_all_addresses=new();
	endfunction




	virtual function void write(check_item t);
        my_item.M_HADDR=t.M_HADDR;	
		written_all_addresses.sample();
		print_current_test_coverage();
		coverage_changed(t);
	endfunction

endclass