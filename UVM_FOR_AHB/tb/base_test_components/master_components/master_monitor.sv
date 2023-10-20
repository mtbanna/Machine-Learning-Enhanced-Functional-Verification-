import a_test_package::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

class master_monitor extends uvm_monitor ;
`uvm_component_utils(master_monitor)

virtual master_interface my_master_interface;
master_sequence_item my_item;
uvm_analysis_port #(master_sequence_item) to_agent_port;

function new(string name = "master_monitor",uvm_component parent=null);
	super.new(name , parent);
endfunction

function void build_phase(uvm_phase phase);
	my_item = master_sequence_item::type_id::create("my_item",this);
	to_agent_port=new ("to_agent_port",this);
	if(!uvm_config_db#(virtual master_interface)::get(this, "", "my_master_interface", my_master_interface))
		`uvm_fatal("Master_Monitor","couldn't get it's interface")
endfunction

virtual task run_phase(uvm_phase phase);
	uvm_report_info(".",$sformatf("T=%0t [Master Monitor] is starting ..... " , $time ));
	forever begin
		@(posedge my_master_interface.clock)
		set_item();
		print();
		to_agent_port.write(my_item);
	end
endtask

virtual function void set_item();                      // blocking which give us the current input and output of the master interface with bus
	my_item.HBUSREQ=my_master_interface.HBUSREQ;
	my_item.HADDR=my_master_interface.HADDR;
	my_item.HTRANS=my_master_interface.HTRANS;
	my_item.HSIZE=my_master_interface.HSIZE;
	my_item.HBURST=my_master_interface.HBURST;
	my_item.HPROT=my_master_interface.HPROT;
	my_item.HLOCK=my_master_interface.HLOCK;
	my_item.HWRITE=my_master_interface.HWRITE;
	my_item.HWDATA=my_master_interface.HWDATA;
	my_item.HGRANT=my_master_interface.HGRANT;
	my_item.HRDATA=my_master_interface.HRDATA;
	my_item.HRESP=my_master_interface.HRESP;
	my_item.HREADY=my_master_interface.HREADY;
endfunction

virtual function void print();
	//`uvm_info("MASTER Monitor", $sformatf("Universal Signal HREADY: %0d",my_master_interface.HREADY),UVM_MEDIUM);
	//`uvm_info("MASTER Monitor", $sformatf("req:%0b, grant:%0b",my_master_interface.HBUSREQ,my_master_interface.HGRANT), UVM_MEDIUM);
endfunction
endclass