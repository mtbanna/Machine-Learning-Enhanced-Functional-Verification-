import uvm_pkg::*;
import a_test_package::*;
`include "uvm_macros.svh"

class master_sequence_item extends uvm_sequence_item; 
bit   HBUSREQ;  
bit [31:0] HADDR;
bit [1:0]  HTRANS;
bit [2:0]  HSIZE;
bit [2:0]  HBURST;
bit [3:0]  HPROT;
bit        HLOCK;
bit        HWRITE;
bit [31:0] HWDATA;

bit        HGRANT;
bit [31:0] HRDATA;
bit [ 1:0] HRESP;
bit        HREADY;


`uvm_object_utils(master_sequence_item)

function new (string name="master_sequence_item");
	super.new(name);
endfunction

endclass 