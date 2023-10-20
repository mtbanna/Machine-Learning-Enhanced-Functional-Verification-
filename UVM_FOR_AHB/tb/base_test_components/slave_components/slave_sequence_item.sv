import uvm_pkg::*;
import a_test_package::*;
`include "uvm_macros.svh"

class slave_sequence_item extends uvm_sequence_item;
`uvm_object_utils(slave_sequence_item)

bit [31:0] HADDR;       //Universal 
bit        HWRITE;
bit [ 1:0] HTRANS;
bit [ 2:0] HSIZE;
bit [ 2:0] HBURST;
bit [31:0] HWDATA;
bit [ 3:0] HPROT;
bit        S_HREADY;
bit [3:0]  HMASTER;
bit        HMASTLOCK;

bit        HSEL;         //Exclusive
bit        HREADY;
bit [ 1:0] HRESP;
bit [31:0] HRDATA;
bit [15:0] HSPLIT;

function new (string name="slave_sequence_item");
	super.new(name);
endfunction
endclass