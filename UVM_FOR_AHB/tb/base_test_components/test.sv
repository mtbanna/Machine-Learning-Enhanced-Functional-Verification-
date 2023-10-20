import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"
class test extends uvm_test;

`uvm_component_utils(test)
master_sequence my_master_sequence;
environment my_environment;
virtual master_interface my_master_interface[number_of_masters];
virtual slave_interface my_slave_interface[number_of_slaves];
uvm_analysis_imp#(bit[1:0], test) from_coverage_or_scorboard_terminate_test_port;// terminates tests & changes read file during ML if wanted
int number_of_consecutive_items_without_coverage_hit;


function new (string name="test", uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
	my_environment=environment::type_id::create("my_environment",this);
	from_coverage_or_scorboard_terminate_test_port=new("from_coverage_or_scorboard_terminate_test_port",this);
	this.get_interfaces();
	this.set_interfaces();
	my_master_sequence= master_sequence::type_id::create("my_sequence",this);
	this.my_environment.set_report_verbosity_level_hier(verbosity);
endfunction

virtual task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	my_master_interface[0].HRESET=0;
	#1;
	my_master_interface[0].HRESET=1;
	#1;
	my_master_sequence.start(this.my_environment.my_master_agent[0].my_sequencer,null) ;
	#1;
	phase.drop_objection(this);
endtask

virtual function void get_interfaces();
	for (int i = 0; i < number_of_masters; i++) begin
		if(!uvm_config_db#(virtual master_interface)::get(this,"",$sformatf("my_master_interface_%0d",i), my_master_interface[i]))
			`uvm_fatal("Test",$sformatf("couldn't get the master%0d interface",i));
	end
	for (int i = 0; i < number_of_slaves; i++) begin
		if(!uvm_config_db#(virtual slave_interface)::get(this,"",$sformatf("my_slave_interface_%0d",i), my_slave_interface[i]))
			`uvm_fatal("Test",$sformatf("couldn't get the slave%0d interface",i));
	end
endfunction

virtual function void set_interfaces();
	uvm_config_db#(virtual master_interface)::set(this,"my_environment","master_interface",my_master_interface[0]);//to give the environment the clock (change it to clock only not the whole interface)
	uvm_config_db#(virtual master_interface)::set(this,"my_environment.my_scoreboard","master_interface",my_master_interface[0]); //to give the scoreboard the clock (change it to clock only not the whole interface)

	for (int i = 0; i < number_of_masters; i++)
		uvm_config_db#(virtual master_interface)::set(this,$sformatf("my_environment.my_master_agent[%0d]",i), "master_interface", my_master_interface[i]);

	for (int i = 0; i < number_of_slaves; i++)
		uvm_config_db#(virtual slave_interface)::set(this,$sformatf("my_environment.my_slave_agent[%0d]",i),"slave_interface", my_slave_interface[i]);
endfunction

virtual function void write(bit[1:0] t);
	my_master_sequence.terminate_test=t[0];         // master_sequence is ran on agent #1

	if(machine_learning_enhancement==3 && full_machine_learning==1) begin
		if(t[1]==1)
			number_of_consecutive_items_without_coverage_hit=number_of_consecutive_items_without_coverage_hit+1;
		else
			number_of_consecutive_items_without_coverage_hit=0;

		if(number_of_consecutive_items_without_coverage_hit==max_number_of_consecutive_items_without_coverage_hit_to_change_file) begin
			my_master_sequence.change_reading_file=1;
			number_of_consecutive_items_without_coverage_hit=0;
		end
		else
			my_master_sequence.change_reading_file=0;
	end

endfunction

virtual function void connect_phase(uvm_phase phase);
	my_environment.my_coverage.to_sequence_terminate_test_port.connect(from_coverage_or_scorboard_terminate_test_port);
	my_environment.my_scoreboard.to_sequence_terminate_test_port.connect(from_coverage_or_scorboard_terminate_test_port);
endfunction

endclass