import a_test_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class slave_monitor extends uvm_monitor ;
`uvm_component_utils(slave_monitor)

virtual slave_interface my_slave_interface;
slave_sequence_item my_item;
uvm_analysis_port #(slave_sequence_item) to_agent_port;

function new(string name = "slave_monitor",uvm_component parent=null);
	super.new(name , parent);

endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	my_item = slave_sequence_item::type_id::create("my_item",this);
	to_agent_port=new ("to_agent_port",this);
	if(!uvm_config_db#(virtual slave_interface)::get(this, "", "my_slave_interface", my_slave_interface))
		`uvm_fatal("Slave_Monitor","couldn't get it's interface")
endfunction


virtual task run_phase(uvm_phase phase);
	uvm_report_info(".",$sformatf("T=%0t [Slave Monitor] is starting ..... " , $time ));
	forever begin
		@(posedge my_slave_interface.clock)             // blocking because I want to know at this simulation cycle what is written on the signals (sampling not driving)
		my_item.HREADY=my_slave_interface.HREADY;
		my_item.HADDR=my_slave_interface.HADDR;
		my_item.HWRITE=my_slave_interface.HWRITE;
		my_item.HTRANS=my_slave_interface.HTRANS;
		my_item.HSIZE=my_slave_interface.HSIZE;
		my_item.HBURST=my_slave_interface.HBURST;
		my_item.HWDATA=my_slave_interface.HWDATA;
		my_item.HPROT=my_slave_interface.HPROT;
		my_item.S_HREADY=my_slave_interface.S_HREADY;
		my_item.HMASTER=my_slave_interface.HMASTER;
		my_item.HMASTLOCK=my_slave_interface.HMASTLOCK;
		my_item.HSEL=my_slave_interface.HSEL;
		my_item.HREADY=my_slave_interface.HREADY;
		my_item.HRESP=my_slave_interface.HRESP;
		my_item.HRDATA=my_slave_interface.HRDATA;
		my_item.HSPLIT=my_slave_interface.HSPLIT;
		to_agent_port.write(my_item);
	end
endtask

endclass