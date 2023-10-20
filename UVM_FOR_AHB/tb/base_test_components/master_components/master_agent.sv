import a_test_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class master_agent extends uvm_agent;
`uvm_component_utils(master_agent)
master_driver my_driver;
master_monitor my_monitor;
uvm_sequencer#(master_sequence_item) my_sequencer;
virtual master_interface my_master_interface;
uvm_analysis_imp#(master_sequence_item, master_agent) from_monitor_import;
master_sequence_item master_item;



function new (string name="master_agent", uvm_component parent=null);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
	my_driver= master_driver::type_id::create("my_driver",this);
	my_sequencer= new("my_sequencer",this);
	my_monitor= master_monitor::type_id::create("my_monitor",this);
	from_monitor_import=new("from_monitor_import",this);

	if(!uvm_config_db#(virtual master_interface)::get(this,"","master_interface",my_master_interface))
		`uvm_fatal("Master_Agent","isn't able to get its master interface")

	uvm_config_db#(virtual master_interface)::set(this, "*", "my_master_interface", my_master_interface);   // "*" stands for all objects, while ".*" stands for an object named*

endfunction

virtual function void write (master_sequence_item master_item); 
	this.master_item=master_item;                             
endfunction

function void connect_phase(uvm_phase phase);
			my_driver.seq_item_port.connect(my_sequencer.seq_item_export);
			my_monitor.to_agent_port.connect(from_monitor_import);
endfunction

endclass