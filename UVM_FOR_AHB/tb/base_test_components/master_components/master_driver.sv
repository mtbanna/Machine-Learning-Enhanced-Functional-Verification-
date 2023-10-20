import uvm_pkg::*;
import a_test_package::*;
`include "uvm_macros.svh"

class master_driver extends uvm_driver #(master_sequence_item);//parametrized to enable passing child classes of master_sequence_item

`uvm_component_utils(master_driver)
master_sequence_item my_item;
virtual master_interface my_master_interface;

function new (string name="master_driver", uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void build_phase(uvm_phase phase);
	if(!uvm_config_db#(virtual master_interface)::get(this,"","my_master_interface", my_master_interface))
		`uvm_fatal("Driver","couldn't get its master interface")
endfunction

virtual task  run_phase(uvm_phase phase);
	forever begin  @(posedge this.my_master_interface.clock)
		seq_item_port.get_next_item(my_item);
		set_master_interface();
		print();
		seq_item_port.item_done();
	end
endtask

virtual function void set_master_interface();
	this.my_master_interface.HBUSREQ<=my_item.HBUSREQ;
	this.my_master_interface.HADDR<=my_item.HADDR;
	this.my_master_interface.HTRANS<=my_item.HTRANS;
	this.my_master_interface.HSIZE<=my_item.HSIZE;
	this.my_master_interface.HBURST<=my_item.HBURST;
	this.my_master_interface.HPROT<=my_item.HPROT;
	this.my_master_interface.HLOCK<=my_item.HLOCK;
	this.my_master_interface.HWRITE<=my_item.HWRITE;
	this.my_master_interface.HWDATA<=my_item.HWDATA;
endfunction

virtual function void print();
	`uvm_info("Driver",$sformatf("BUS_REQUEST: %0d",my_master_interface.HBUSREQ),UVM_MEDIUM);
endfunction

endclass