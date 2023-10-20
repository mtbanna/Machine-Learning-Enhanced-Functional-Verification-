import uvm_pkg::*;
import a_test_package::*;
import ahb_parameters::*;
import sequences_package::*;
import scoreboards_package::*;
import coverages_package::*;
import tests_package::*;
`include "../tb/base_test_components/master_components/master_interface.sv"
`include "../tb/base_test_components/slave_components/slave_interface.sv"
`timescale 1ns/1ns


module uvm_sanity_top;

bit clock;

genvar masters,slaves;
generate
	for (masters= 0; masters < number_of_masters; masters++) begin: master
		master_interface my_master_interface(clock);
	end
	for (slaves= 0; slaves < number_of_slaves; slaves++) begin: slave
		slave_interface my_slave_interface(clock);
	end
//connecting universal signals of masters and slaves
	for (masters=1; masters < number_of_masters; masters++)
		always_comb begin
			master[masters].my_master_interface.HRDATA=master[0].my_master_interface.HRDATA;
			master[masters].my_master_interface.HRESP=master[0].my_master_interface.HRESP;
			master[masters].my_master_interface.HREADY= master[0].my_master_interface.HREADY;
		end

	for (slaves = 1; slaves < number_of_slaves; slaves++)
		always_comb begin
			slave[slaves].my_slave_interface.HADDR= slave[0].my_slave_interface.HADDR;
			slave[slaves].my_slave_interface.HWRITE= slave[0].my_slave_interface.HWRITE;
			slave[slaves].my_slave_interface.HTRANS= slave[0].my_slave_interface.HTRANS;
			slave[slaves].my_slave_interface.HSIZE= slave[0].my_slave_interface.HSIZE;
			slave[slaves].my_slave_interface.HBURST= slave[0].my_slave_interface.HBURST;
			slave[slaves].my_slave_interface.HWDATA= slave[0].my_slave_interface.HWDATA;
			slave[slaves].my_slave_interface.HPROT= slave[0].my_slave_interface.HPROT;
			slave[slaves].my_slave_interface.S_HREADY= slave[0].my_slave_interface.S_HREADY;
			slave[slaves].my_slave_interface.HMASTER= slave[0].my_slave_interface.HMASTER;
			slave[slaves].my_slave_interface.HMASTLOCK= slave[0].my_slave_interface.HMASTLOCK;
		end
		
	for (masters = 0; masters < number_of_masters; masters++)
		initial
			uvm_config_db#(virtual master_interface)::set(null,"uvm_test_top",$sformatf("my_master_interface_%0d",masters),master[masters].my_master_interface);

	for (slaves = 0; slaves < number_of_slaves; slaves++)
		initial
			uvm_config_db#(virtual slave_interface)::set(null,"uvm_test_top",$sformatf("my_slave_interface_%0d",slaves),slave[slaves].my_slave_interface);

endgenerate

amba_ahb_m2s3 #(.P_NUMM(number_of_masters)
	,.P_NUMS(number_of_slaves)
	,.P_HSEL0_START(P_HSEL0_START),.P_HSEL0_SIZE(P_HSEL0_SIZE)
	,.P_HSEL1_START(P_HSEL1_START),.P_HSEL1_SIZE(P_HSEL1_SIZE)
	,.P_HSEL2_START(P_HSEL2_START),.P_HSEL2_SIZE(P_HSEL2_SIZE)
)
u_amba_ahb  (
	.HRESETn       (master[0].my_master_interface.HRESET )
	, .HCLK        (clock)
	, .M0_HBUSREQ  (master[0].my_master_interface.HBUSREQ)
	, .M0_HGRANT   (master[0].my_master_interface.HGRANT)
	, .M0_HADDR    (master[0].my_master_interface.HADDR)
	, .M0_HTRANS   (master[0].my_master_interface.HTRANS)
	, .M0_HSIZE    (master[0].my_master_interface.HSIZE)
	, .M0_HBURST   (master[0].my_master_interface.HBURST)
	, .M0_HPROT    (master[0].my_master_interface.HPROT)
	, .M0_HLOCK    (master[0].my_master_interface.HLOCK)
	, .M0_HWRITE   (master[0].my_master_interface.HWRITE)
	, .M0_HWDATA   (master[0].my_master_interface.HWDATA)
	, .M1_HBUSREQ  (master[1].my_master_interface.HBUSREQ)
	, .M1_HGRANT   (master[1].my_master_interface.HGRANT)
	, .M1_HADDR    (master[1].my_master_interface.HADDR)
	, .M1_HTRANS   (master[1].my_master_interface.HTRANS)
	, .M1_HSIZE    (master[1].my_master_interface.HSIZE)
	, .M1_HBURST   (master[1].my_master_interface.HBURST)
	, .M1_HPROT    (master[1].my_master_interface.HPROT)
	, .M1_HLOCK    (master[1].my_master_interface.HLOCK)
	, .M1_HWRITE   (master[1].my_master_interface.HWRITE)
	, .M1_HWDATA   (master[1].my_master_interface.HWDATA)
	, .M_HRDATA    (master[0].my_master_interface.HRDATA)
	, .M_HRESP     (master[0].my_master_interface.HRESP)
	, .M_HREADY    (master[0].my_master_interface.HREADY)
	, .S_HADDR     (slave[0].my_slave_interface.HADDR)
	, .S_HWRITE    (slave[0].my_slave_interface.HWRITE)
	, .S_HTRANS    (slave[0].my_slave_interface.HTRANS)         //default slave/master is assigned the universal signals in the uvm test, while the rest take values from here.
	, .S_HSIZE     (slave[0].my_slave_interface.HSIZE)          // so don't include them in the tests.
	, .S_HBURST    (slave[0].my_slave_interface.HBURST)
	, .S_HWDATA    (slave[0].my_slave_interface.HWDATA)
	, .S_HPROT     (slave[0].my_slave_interface.HPROT)
	, .S_HREADY    (slave[0].my_slave_interface.S_HREADY)
	, .S_HMASTER   (slave[0].my_slave_interface.HMASTER)
	, .S_HMASTLOCK (slave[0].my_slave_interface.HMASTLOCK)
	, .S0_HSEL     (slave[0].my_slave_interface.HSEL)
	, .S0_HREADY   (slave[0].my_slave_interface.HREADY)
	, .S0_HRESP    (slave[0].my_slave_interface.HRESP)
	, .S0_HRDATA   (slave[0].my_slave_interface.HRDATA)
	, .S0_HSPLIT   (slave[0].my_slave_interface.HSPLIT)
	, .S1_HSEL     (slave[1].my_slave_interface.HSEL)
	, .S1_HREADY   (slave[1].my_slave_interface.HREADY)
	, .S1_HRESP    (slave[1].my_slave_interface.HRESP)
	, .S1_HRDATA   (slave[1].my_slave_interface.HRDATA)
	, .S1_HSPLIT   (slave[1].my_slave_interface.HSPLIT)
	, .S2_HSEL     (slave[2].my_slave_interface.HSEL)
	, .S2_HREADY   (slave[2].my_slave_interface.HREADY)
	, .S2_HRESP    (slave[2].my_slave_interface.HRESP)
	, .S2_HRDATA   (slave[2].my_slave_interface.HRDATA)
	, .S2_HSPLIT   (slave[2].my_slave_interface.HSPLIT)
	, .REMAP       (1'b0)   //related to HSEL0, HSEL1, HSEL2 (their order)
);

initial begin
	$timeformat(-9,1,"ns");
	run_test(test_name);
end

initial begin // clock generator
	clock=1'b0;
	forever#CLK_PERIOD_HALF
		begin
			clock=~clock;
		end
end

endmodule