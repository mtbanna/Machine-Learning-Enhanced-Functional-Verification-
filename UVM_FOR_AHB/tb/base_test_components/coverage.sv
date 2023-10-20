import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

virtual class coverage extends uvm_subscriber #(check_item);
	`uvm_component_utils(coverage);
	check_item my_item;
	int my_grant;
	real previous_coverage_percentage;
	int file_handle;
	string file_text;
	uvm_analysis_port #(bit[1:0]) to_sequence_terminate_test_port;

	function new( string name , uvm_component parent);
		super.new( name , parent );
		to_sequence_terminate_test_port=new("to_sequence_terminate_test_port",this);
		my_item=check_item::type_id::create("my_item",this);
	endfunction

	virtual function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("TEST IS DONE", $sformatf("Final Coverage = %0f%% ",$get_coverage()), UVM_NONE)
	endfunction

	virtual function void print_current_test_coverage();
		`uvm_info("COVERAGE",$sformatf("An item sampled, Coverage = %0f%%",$get_coverage()), UVM_MEDIUM);
	endfunction

	pure virtual function void write(check_item t);

	virtual function void write_csv_file(check_item item);
		file_handle=$fopen(to_python_csv_file_location_training,"a");
		if (file_handle!==0)
			uvm_report_info("", "File was opened successfully", UVM_MEDIUM);
		else
			uvm_report_fatal("", "File wasn't opened");
		$sformat(file_text,"%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d",
			item.M_HBUSREQ[0],
			item.M_HADDR[0],
			item.M_HTRANS[0],
			item.M_HSIZE[0],
			item.M_HBURST[0],
			item.M_HPROT[0],
			item.M_HLOCK[0],
			item.M_HWRITE[0],
			item.M_HWDATA[0],
			1);          //this bit is for coverage hit
		$fdisplay(file_handle,file_text);
		$fclose(file_handle);
	endfunction

	virtual function void coverage_changed (check_item t);
		if(previous_coverage_percentage!=$get_coverage() && machine_learning_enhancement==2)
			write_csv_file(t);
		if(previous_coverage_percentage==$get_coverage() && machine_learning_enhancement==3 && full_machine_learning==1)
			to_sequence_terminate_test_port.write(2'b10);
		else if(previous_coverage_percentage!=$get_coverage() && machine_learning_enhancement==3 && full_machine_learning==1)
			to_sequence_terminate_test_port.write(2'b00);

		if(previous_coverage_percentage!=$get_coverage()) begin
			if($get_coverage>=25 &&$get_coverage<=30 )begin
				`uvm_info("Coverage",$sformatf("Coverage: coverage percentage:%0f at time:%t",$get_coverage, $realtime()), UVM_NONE);
			end
			else if($get_coverage>=50 &&$get_coverage<=55 ) begin
				`uvm_info("Coverage",$sformatf("Coverage: coverage percentage:%0f at time:%t",$get_coverage, $realtime()), UVM_NONE);
			end
			else if($get_coverage>=75 &&$get_coverage<=80 )begin
				`uvm_info("Coverage",$sformatf("Coverage: coverage percentage:%0f at time:%t",$get_coverage, $realtime()), UVM_NONE);
			end
			else if($get_coverage>=95 &&$get_coverage<=100 ) begin
				`uvm_info("Coverage",$sformatf("Coverage: coverage percentage:%0f at time:%t",$get_coverage, $realtime()), UVM_NONE);
				if($get_coverage==100)
					to_sequence_terminate_test_port.write(2'b01);
			end
		end
		previous_coverage_percentage=$get_coverage();
	endfunction

endclass