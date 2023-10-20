import uvm_pkg::*;
import a_test_package::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

class check_item extends uvm_sequence_item;  
                              //Master Signals
bit        M_HBUSREQ [number_of_masters];         //out
bit [31:0] M_HADDR[number_of_masters];
bit [1:0]  M_HTRANS[number_of_masters];
bit [2:0]  M_HSIZE[number_of_masters];
bit [2:0]  M_HBURST[number_of_masters];
bit [3:0]  M_HPROT[number_of_masters];
bit        M_HLOCK[number_of_masters];
bit        M_HWRITE[number_of_masters];
bit [31:0] M_HWDATA[number_of_masters];

bit        M_HGRANT[number_of_masters];         //in
bit [31:0] M_HRDATA;
bit [ 1:0] M_HRESP;
bit        M_HREADY;
                             // Slave signals
bit [31:0] S_HADDR;          // in
bit        S_HWRITE;
bit [ 1:0] S_HTRANS;
bit [ 2:0] S_HSIZE;
bit [ 2:0] S_HBURST;
bit [31:0] S_HWDATA;
bit [ 3:0] S_HPROT;
bit        S_HREADY;
bit [3:0]  S_HMASTER;
bit        S_HMASTLOCK;
bit        S_HSEL[number_of_slaves];

bit        SS_HREADY[number_of_slaves];        //out
bit [ 1:0] S_HRESP[number_of_slaves];
bit [31:0] S_HRDATA[number_of_slaves];
bit [15:0] S_HSPLIT[number_of_slaves];

bit end_test;   // a bit used for verification purposes only


`uvm_object_utils(check_item)
/*`uvm_object_utils_begin(check_item)        requires to set a field macro for every unpacked type. ex: for every element in M_HBUSREQ
`uvm_field_int(M_HBUSREQ,UVM_DEFAULT)
`uvm_field_int(M_HADDR,UVM_DEFAULT)
`uvm_field_int(M_HTRANS,UVM_DEFAULT)
`uvm_field_int(M_HSIZE,UVM_DEFAULT)
`uvm_field_int(M_HBURST,UVM_DEFAULT)
`uvm_field_int(M_HPROT,UVM_DEFAULT)
`uvm_field_int(M_HLOCK,UVM_DEFAULT)
`uvm_field_int(M_HWRITE,UVM_DEFAULT)
`uvm_field_int(M_HWDATA,UVM_DEFAULT)
`uvm_field_int(M_HGRANT,UVM_DEFAULT)
`uvm_field_int(M_HRDATA,UVM_DEFAULT)
`uvm_field_int(M_HRESP,UVM_DEFAULT)
`uvm_field_int(M_HREADY,UVM_DEFAULT)
`uvm_field_int(S_HADDR,UVM_DEFAULT)
`uvm_field_int(S_HWRITE,UVM_DEFAULT)
`uvm_field_int(S_HTRANS,UVM_DEFAULT)
`uvm_field_int(S_HSIZE,UVM_DEFAULT)
`uvm_field_int(S_HBURST,UVM_DEFAULT)
`uvm_field_int(S_HWDATA,UVM_DEFAULT)
`uvm_field_int(S_HPROT,UVM_DEFAULT)
`uvm_field_int(S_HREADY,UVM_DEFAULT)
`uvm_field_int(S_HMASTER,UVM_DEFAULT)
`uvm_field_int(S_HMASTLOCK,UVM_DEFAULT)
`uvm_field_int(S_HSEL,UVM_DEFAULT)
`uvm_field_int(SS_HREADY,UVM_DEFAULT)
`uvm_field_int(S_HRESP,UVM_DEFAULT)
`uvm_field_int(S_HRDATA,UVM_DEFAULT)
`uvm_field_int(S_HSPLIT,UVM_DEFAULT)
`uvm_object_utils_end*/

function new (string name="check_item");
	super.new(name);
endfunction

endclass



