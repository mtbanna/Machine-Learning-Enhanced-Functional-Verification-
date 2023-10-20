import a_test_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class slave_agent extends uvm_agent;
`uvm_component_utils(slave_agent)

slave_monitor my_monitor;
virtual slave_interface my_slave_interface;
uvm_analysis_imp#(slave_sequence_item, slave_agent) from_monitor_import;
slave_sequence_item slave_item;


function new (string name="slave_agent", uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	my_monitor= slave_monitor::type_id::create("my_monitor",this);

	if(!uvm_config_db#(virtual slave_interface)::get(this,"","slave_interface",my_slave_interface))
		`uvm_fatal("Slave_Agent","isn't able to get its slave interface")
	uvm_config_db#(virtual slave_interface)::set(this, "*", "my_slave_interface", my_slave_interface);   // "*" stands for all objects, while ".*" stands for an object named*

	from_monitor_import=new("from_monitor_import",this);
endfunction

virtual function void write (slave_sequence_item slave_item);
	this.slave_item=slave_item;
endfunction

task run_phase(uvm_phase phase);
	forever begin
		@(posedge my_slave_interface.clock)
			required_reply();
	end
endtask

virtual task required_reply();     //make it a pure virtual one if needed. This function is for setting slave's outputs not inputs (coming from bus)
	my_slave_interface.HREADY<=1;
	if(my_slave_interface.HWRITE==0 && my_slave_interface.HSEL==1)
	my_slave_interface.HRDATA=my_slave_interface.HADDR;          // specific reply. Don't change, as coverage/scoreboard is set for it.
endtask

function void connect_phase(uvm_phase phase);
	my_monitor.to_agent_port.connect(from_monitor_import);
endfunction

endclass