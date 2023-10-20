import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

virtual class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_analysis_port#(check_item) to_coverage_port;
	uvm_analysis_imp#(check_item, scoreboard) from_environment_import;
	virtual master_interface my_master_interface;//Check kind of interface, or how to pass clock to here
	check_item previous_check_items[4];    //each element corrosponds to reply in the #th cycle. ex: [0] is for the reply in the exact previous cycle
	int file_handle;
	string file_text;
	uvm_analysis_port #(bit[1:0]) to_sequence_terminate_test_port;

	function new(string name = "scoreboard",uvm_component parent=null);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		for (int i=0; i<4; i++)
			previous_check_items[i]=check_item::type_id::create($sformatf("previous_check_items[%0d]",i),this);

		if(!uvm_config_db#(virtual master_interface)::get(this,"","master_interface", my_master_interface))
			`uvm_fatal("Scoreboard","couldn't get the master interface");

		to_coverage_port=new("to_coverage_port",this);
		to_sequence_terminate_test_port=new("to_sequence_terminate_test_port",this);
		from_environment_import=new("from_environment_import",this);
	endfunction

	pure virtual function void write (check_item my_check_item);
	virtual function void set_previous_check_item (check_item new_item , check_item old_item);
		old_item.M_HBUSREQ=new_item.M_HBUSREQ;
		old_item.M_HADDR=new_item.M_HADDR;
		old_item.M_HTRANS=new_item.M_HTRANS;
		old_item.M_HSIZE=new_item.M_HSIZE;
		old_item.M_HBURST=new_item.M_HBURST;
		old_item.M_HPROT=new_item.M_HPROT;
		old_item.M_HLOCK=new_item.M_HLOCK;
		old_item.M_HWRITE=new_item.M_HWRITE;
		old_item.M_HWDATA=new_item.M_HWDATA;
		old_item.M_HGRANT=new_item.M_HGRANT;
		old_item.M_HRDATA=new_item.M_HRDATA;
		old_item.M_HRESP=new_item.M_HRESP;
		old_item.M_HREADY=new_item.M_HREADY;
		old_item.S_HADDR=new_item.S_HADDR;
		old_item.S_HWRITE=new_item.S_HWRITE;
		old_item.S_HTRANS=new_item.S_HTRANS;
		old_item.S_HSIZE=new_item.S_HSIZE;
		old_item.S_HBURST=new_item.S_HBURST;
		old_item.S_HWDATA=new_item.S_HWDATA;
		old_item.S_HPROT=new_item.S_HPROT;
		old_item.S_HREADY=new_item.S_HREADY;
		old_item.S_HMASTER=new_item.S_HMASTER;
		old_item.S_HMASTLOCK=new_item.S_HMASTLOCK;
		old_item.S_HSEL=new_item.S_HSEL;
		old_item.SS_HREADY=new_item.SS_HREADY;
		old_item.S_HRESP=new_item.S_HRESP;
		old_item.S_HRDATA=new_item.S_HRDATA;
		old_item.S_HSPLIT=new_item.S_HSPLIT;
	endfunction

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
			0);             // for coverage bit
		$fdisplay(file_handle,file_text);
		$fclose(file_handle);
	endfunction

endclass

