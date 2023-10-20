import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"// add a parameter named "training" if it's 1, you write a csv file, else you won't, add something to terminate test on 100% cvg

class locked_write_single_master_single_slave_coverage extends coverage;
	`uvm_component_utils(locked_write_single_master_single_slave_coverage);

	covergroup written_all_cases;                  //we are assuming that for certain addresses and data, locked transfers must be covered. To inc. complexity
		option.per_instance = 1;
		addresses:coverpoint this.my_item.S_HADDR{
		    type_option.weight = 2;
			bins address_range_one[10]={[0:40]};
			bins address_range_two[10]={[70:85]};
			bins address_range_three[10]={[200:350]};
		}
		data:coverpoint this.my_item.S_HWDATA{
			bins data_range_one[10]={[1000:1040]};
			bins data_range_two[10]={[4800:4850]};
		}
		cross addresses,data{
		ignore_bins max = binsof(data.data_range_two);
		}

	endgroup

	function new( string name , uvm_component parent);
		super.new(name,parent);
		written_all_cases=new();
	endfunction




	virtual function void write(check_item t);
		my_item.S_HADDR=t.S_HADDR;
		my_item.S_HWDATA=t.S_HWDATA;
		//my_item.S_HMASTLOCK=t.S_HMASTLOCK; no need,as scoreboard only sends locked writes
		written_all_cases.sample();
		print_current_test_coverage();
		coverage_changed(t);
	endfunction

endclass