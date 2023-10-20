import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

class environment extends uvm_env;
`uvm_component_utils(environment)
master_agent my_master_agent[number_of_masters];
scoreboard my_scoreboard;
coverage my_coverage;
slave_agent my_slave_agent[number_of_slaves];
check_item all_items;
virtual master_interface my_master_interface;
uvm_analysis_port #(check_item) to_scoreboard_port;
master_sequence_item my_previous_master_item[number_of_masters];

function new (string name="environment", uvm_component parent=null);
    super.new(name,parent);

endfunction

virtual function void build_phase(uvm_phase phase);
    for (int i = 0; i < number_of_masters; i++) begin
        my_master_agent[i] = master_agent::type_id::create($sformatf("my_master_agent[%0d]",i),this);
        my_previous_master_item[i]=master_sequence_item::type_id::create($sformatf("my_previous_master_item[%0d]",i),this);
    end
    for (int i = 0; i < number_of_slaves; i++) begin
        my_slave_agent[i]=slave_agent::type_id::create($sformatf("my_slave_agent[%0d]",i),this);
    end
    my_scoreboard=scoreboard::type_id::create("my_scoreboard",this);
    all_items=check_item::type_id::create("all_items",this);
    my_coverage=coverage::type_id::create("my_coverage",this);
    to_scoreboard_port=new("to_scoreboard_port",this);
    if(!uvm_config_db#(virtual master_interface)::get(this,"","master_interface", my_master_interface))
        `uvm_fatal("Environment","couldn't get the master interface");
endfunction

virtual function void connect_phase(uvm_phase phase);
    to_scoreboard_port.connect(my_scoreboard.from_environment_import);
    my_scoreboard.to_coverage_port.connect(my_coverage.analysis_export);
endfunction

virtual task run_phase(uvm_phase phase);
    forever begin
        @(posedge my_master_interface.clock)
            #1
            set_universal_signals();
            for (int i = 0; i < number_of_masters; i++) begin
                set_master_all_items(my_master_agent[i],i);
            end
             for (int i = 0; i < number_of_slaves; i++) begin
                set_slave_all_items(my_slave_agent[i],i);
            end
        to_scoreboard_port.write(all_items);
      /*  for (int i = 0; i < number_of_masters; i++) begin
            set_previous_master_item(my_master_agent[i], my_previous_master_item[i]); 
        end*/
    end
endtask

virtual function void set_master_all_items(master_agent master_agent, int index); // set all items of masters and slaves.
    this.all_items.M_HBUSREQ[index]=master_agent.master_item.HBUSREQ;            //Request
    this.all_items.M_HADDR[index]=master_agent.master_item.HADDR;
    this.all_items.M_HTRANS[index]=master_agent.master_item.HTRANS;
    this.all_items.M_HSIZE[index]=master_agent.master_item.HSIZE;
    this.all_items.M_HBURST[index]=master_agent.master_item.HBURST;
    this.all_items.M_HPROT[index]=master_agent.master_item.HPROT;
    this.all_items.M_HLOCK[index]=master_agent.master_item.HLOCK;
    this.all_items.M_HWRITE[index]=master_agent.master_item.HWRITE;
    this.all_items.M_HWDATA[index]=master_agent.master_item.HWDATA;

    this.all_items.M_HGRANT[index]=master_agent.master_item.HGRANT;         //Reply to previous cycle

endfunction

virtual function void set_previous_master_item (master_agent master_agent, master_sequence_item previous_master_item);
    previous_master_item.HBUSREQ=master_agent.master_item.HBUSREQ;
    previous_master_item.HADDR=master_agent.master_item.HADDR;
    previous_master_item.HTRANS=master_agent.master_item.HTRANS;
    previous_master_item.HSIZE=master_agent.master_item.HSIZE;
    previous_master_item.HBURST=master_agent.master_item.HBURST;
    previous_master_item.HPROT=master_agent.master_item.HPROT;
    previous_master_item.HLOCK=master_agent.master_item.HLOCK;
    previous_master_item.HWRITE=master_agent.master_item.HWRITE;
    previous_master_item.HWDATA=master_agent.master_item.HWDATA;
endfunction

virtual function void set_slave_all_items(slave_agent slave_agent, int index );
    this.all_items.S_HSEL[index]=slave_agent.slave_item.HSEL;
    this.all_items.SS_HREADY[index]=slave_agent.slave_item.HREADY;
    this.all_items.S_HRESP[index]=slave_agent.slave_item.HRESP;
    this.all_items.S_HRDATA[index]=slave_agent.slave_item.HRDATA;
    this.all_items.S_HSPLIT[index]=slave_agent.slave_item.HSPLIT;

endfunction

virtual function void set_universal_signals();
    this.all_items.S_HADDR=my_slave_agent[0].slave_item.HADDR;
    this.all_items.S_HWRITE=my_slave_agent[0].slave_item.HWRITE;
    this.all_items.S_HTRANS=my_slave_agent[0].slave_item.HTRANS;
    this.all_items.S_HSIZE=my_slave_agent[0].slave_item.HSIZE;
    this.all_items.S_HBURST=my_slave_agent[0].slave_item.HBURST;
    this.all_items.S_HWDATA=my_slave_agent[0].slave_item.HWDATA;
    this.all_items.S_HPROT=my_slave_agent[0].slave_item.HPROT;
    this.all_items.S_HREADY=my_slave_agent[0].slave_item.HREADY;
    this.all_items.S_HMASTER=my_slave_agent[0].slave_item.HMASTER;
    this.all_items.S_HMASTLOCK=my_slave_agent[0].slave_item.HMASTLOCK;

    this.all_items.M_HRDATA=this.my_master_agent[0].master_item.HRDATA;
    this.all_items.M_HRESP=this.my_master_agent[0].master_item.HRESP;    // always master_agent[0] because they are universal connected to interface[0] in the top module, where
    this.all_items.M_HREADY=this.my_master_agent[0].master_item.HREADY;  // the rest of the interfaces take its value.
endfunction

endclass
