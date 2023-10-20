import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

class bus_request_coverage extends coverage;
`uvm_component_utils(bus_request_coverage);

covergroup master_grant;
	coverpoint this.my_grant{
		bins grant_values[]={[1:1000]};
	}
endgroup

function new( string name , uvm_component parent);
	super.new(name,parent);
	master_grant=new();
endfunction

virtual function void write(check_item t);
	my_grant =my_grant+1;
	master_grant.sample();
	print_current_test_coverage();
	coverage_changed(t);
endfunction

virtual function void write_csv_file(check_item item); //overridden here because we want to print data due to previous request (we could create previous check items array and use it)
	file_handle=$fopen(to_python_csv_file_location_training,"a");
	if (file_handle!==0)
		uvm_report_info("", "File was opened successfully", UVM_MEDIUM);
	else
		uvm_report_fatal("", "File wasn't opened");
	$sformat(file_text,"%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
	     1,              //sending one to bus_request space, instead of handling getting previous check_item, as that '1' comes from there
		item.M_HADDR[0],
		item.M_HTRANS[0],
		item.M_HSIZE[0],
		item.M_HBURST[0],
		item.M_HPROT[0],
		item.M_HLOCK[0],
		item.M_HWRITE[0],
		item.M_HWDATA[0],
		1);   //coverage bit
	$fdisplay(file_handle,file_text);
	$fclose(file_handle);
endfunction


endclass