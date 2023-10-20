module sanity_test;
	bit clock;

	localparam NUM_MST=2
		, NUM_SLV=3;
	//---------------------------------------------------------------------------
	localparam  P_HSEL0_START=32'h0,P_HSEL0_SIZE=32'h400;               //specifies which slave to select depending on address coming from master.
	localparam  P_HSEL1_START=32'h400,P_HSEL1_SIZE=32'h400;
	localparam  P_HSEL2_START=32'h800,P_HSEL2_SIZE=32'h400;
	//---------------------------------------------------------------------------
	localparam CLK_PERIOD_HALF=5;
	bit         HCLK   = 1'b0; //always #(CLK_PERIOD_HALF) HCLK=~HCLK;        //remove one of HCLK and clock
	bit         HRESETn= 1'b0; initial #1 HRESETn=1'b1;
	//---------------------------------------------------------------------------
	bit [NUM_MST-1:0] M_HBUSREQ ;                   //remove these signals (coming from interfaces already)
	bit [NUM_MST-1:0] M_HGRANT  ;
	bit [31:0]        M_HADDR  [0:NUM_MST-1];
	bit [ 3:0]        M_HPROT  [0:NUM_MST-1];
	bit               M_HLOCK  [0:NUM_MST-1];
	bit [ 1:0]        M_HTRANS [0:NUM_MST-1];
	bit               M_HWRITE [0:NUM_MST-1];
	bit [ 2:0]        M_HSIZE  [0:NUM_MST-1];
	bit [ 2:0]        M_HBURST [0:NUM_MST-1];
	bit [31:0]        M_HWDATA [0:NUM_MST-1];
	bit [31:0]        M_HRDATA  ;
	bit [ 1:0]        M_HRESP   ;
	bit               M_HREADY  ;
	//---------------------------------------------------------------------------
	bit [31:0]        S_HADDR    ;
	bit [ 3:0]        S_HPROT    ;
	bit [ 1:0]        S_HTRANS   ;
	bit               S_HWRITE   ;
	bit [ 2:0]        S_HSIZE    ;
	bit [ 2:0]        S_HBURST   ;
	bit [31:0]        S_HWDATA   ;
	bit [31:0]        S_HRDATA [0:NUM_SLV-1];
	bit [ 1:0]        S_HRESP  [0:NUM_SLV-1];
	bit               S_HREADY   ;
	bit [NUM_SLV-1:0] S_HREADYout;
	bit [15:0]        S_HSPLIT   [0:NUM_SLV-1];
	bit [NUM_SLV-1:0] S_HSEL     ;
	bit [ 3:0]        S_HMASTER  ;
	bit               S_HMASTLOCK;
	//---------------------------------------------------------------------------

	amba_ahb_m2s3 #(.P_NUMM(NUM_MST) // num of masters
		,.P_NUMS(NUM_SLV) // num of slaves
		,.P_HSEL0_START(P_HSEL0_START),.P_HSEL0_SIZE(P_HSEL0_SIZE)
		,.P_HSEL1_START(P_HSEL1_START),.P_HSEL1_SIZE(P_HSEL1_SIZE)
		,.P_HSEL2_START(P_HSEL2_START),.P_HSEL2_SIZE(P_HSEL2_SIZE)
	)
	u_amba_ahb  (
		.HRESETn      (HRESETn     )
		, .HCLK         (HCLK        )
		, .M0_HBUSREQ  (M_HBUSREQ [0])
		, .M0_HGRANT   (M_HGRANT  [0])
		, .M0_HADDR    (M_HADDR   [0])
		, .M0_HTRANS   (M_HTRANS  [0])
		, .M0_HSIZE    (M_HSIZE   [0])
		, .M0_HBURST   (M_HBURST  [0])
		, .M0_HPROT    (M_HPROT   [0])
		, .M0_HLOCK    (M_HLOCK   [0])
		, .M0_HWRITE   (M_HWRITE  [0])
		, .M0_HWDATA   (M_HWDATA  [0])
		, .M1_HBUSREQ  (M_HBUSREQ [1])
		, .M1_HGRANT   (M_HGRANT  [1])
		, .M1_HADDR    (M_HADDR   [1])
		, .M1_HTRANS   (M_HTRANS  [1])
		, .M1_HSIZE    (M_HSIZE   [1])
		, .M1_HBURST   (M_HBURST  [1])
		, .M1_HPROT    (M_HPROT   [1])
		, .M1_HLOCK    (M_HLOCK   [1])
		, .M1_HWRITE   (M_HWRITE  [1])
		, .M1_HWDATA   (M_HWDATA  [1])
		, .M_HRDATA    (M_HRDATA     )
		, .M_HRESP     (M_HRESP      )
		, .M_HREADY    (M_HREADY     )
		, .S_HADDR     (S_HADDR      )
		, .S_HWRITE    (S_HWRITE     )
		, .S_HTRANS    (S_HTRANS     )
		, .S_HSIZE     (S_HSIZE      )
		, .S_HBURST    (S_HBURST     )
		, .S_HWDATA    (S_HWDATA     )
		, .S_HPROT     (S_HPROT      )
		, .S_HREADY    (S_HREADY     )
		, .S_HMASTER   (S_HMASTER    )
		, .S_HMASTLOCK (S_HMASTLOCK  )
		, .S0_HSEL     (S_HSEL     [0])
		, .S0_HREADY   (S_HREADYout[0])
		, .S0_HRESP    (S_HRESP    [0])
		, .S0_HRDATA   (S_HRDATA   [0])
		, .S0_HSPLIT   (S_HSPLIT   [0])
		, .S1_HSEL     (S_HSEL     [1])
		, .S1_HREADY   (S_HREADYout[1])
		, .S1_HRESP    (S_HRESP    [1])
		, .S1_HRDATA   (S_HRDATA   [1])
		, .S1_HSPLIT   (S_HSPLIT   [1])
		, .S2_HSEL     (S_HSEL     [2])
		, .S2_HREADY   (S_HREADYout[2])
		, .S2_HRESP    (S_HRESP    [2])
		, .S2_HRDATA   (S_HRDATA   [2])
		, .S2_HSPLIT   (S_HSPLIT   [2])
		, .REMAP       (1'b0          )
	);

	/*initial begin
	uvm_config_db#(virtual master_interface)::set(null,"uvm_test_top","my_master_interface_1",my_master_interface_1);
	run_test("test");
	end*/

	initial begin
		forever begin @ (posedge HCLK);
			$display("K______________________________");
			$display("M_HBUSREQ [0]: %0d", M_HBUSREQ [0]);
			$display("Grant0: %b ", M_HGRANT[0]);
			$display("ADDRESS:%0d , DATA: %0d, WRITE?:%0d, S_HSEL: %b , S_HMASTLOCK: %0b  ",S_HADDR,S_HWDATA,S_HWRITE,S_HSEL, S_HMASTLOCK);
			$display("M_HADDR0: %0d",M_HADDR[0]);
			/*
			$display("reset:%0b",HRESETn);
			$display("This is M_HRDATA %0d",M_HRDATA);
			$display("This is M_HRESP %0d",M_HRESP);
			$display("This is M_HREADY %0d",M_HREADY);
			$display("This is S_HADDR %0d",S_HADDR);
			$display("This is S_HWRITE %0d",S_HWRITE);
			$display("This is S_HTRANS %0d",S_HTRANS);
			$display("This is S_HSIZE %0d",S_HSIZE);
			$display("This is S_HBURST %0d",S_HBURST);
			$display("This is S_HWDATA %0d",S_HWDATA);
			$display("This is S_HPROT %0d",S_HPROT);
			$display("This is S_HREADY %0d",S_HREADY);
			$display("This is S_HMASTER %0d",S_HMASTER);
			$display("This is S_HMASTLOCK %0d",S_HMASTLOCK);
			$display("This is 0_HSEL %0d",S_HSEL[0]);
			$display("This is 1_HSEL %0d",S_HSEL[1]);
			$display("This is 2_HSEL %0d",S_HSEL[2]);
			$display("___________________________________________________________________");
			end*/
		end
	end

	initial begin
		wait(HRESETn==1'b0);
		wait(HRESETn==1'b1);


		@ (posedge HCLK);begin
			M_HBUSREQ [0] <= 1;
			S_HREADYout[0]<=1;
			M_HADDR[0]<=32'h000;
			M_HWDATA[0]<=7;
			M_HWRITE[0]<=1;
			M_HBURST[0]<=3'b010;
			M_HSIZE[0]<=3'b000;
			M_HTRANS[0]<=2'b10;
			M_HLOCK[0]<=1;
		end
		@ (posedge HCLK);begin
			M_HBUSREQ[0]<=0;
		end
		@ (posedge HCLK);begin
			S_HREADYout[0]<=1;
		end
		@ (posedge HCLK);begin
		end

		#30;
		$finish;
	end

	initial begin
		clock=1'b0;
		forever#CLK_PERIOD_HALF
			begin
				clock=~clock;
				HCLK=~HCLK;
			end
	end
endmodule

/* read
@ (posedge HCLK);begin
M_HBUSREQ [0] <= 1;
S_HREADYout[0]<=1;
M_HADDR[0]<=32'h001;
M_HWDATA[0]<=7;
M_HWRITE[0]<=0;
S_HRDATA[0]<=S_HADDR+5;

end
@ (posedge HCLK);begin
S_HRDATA[0]<=S_HADDR+5;
end
@ (posedge HCLK);begin
M_HADDR[0]<=32'h301;
S_HRDATA[0]<=S_HADDR+5;

end
@ (posedge HCLK); begin
S_HRDATA[0]<=S_HADDR+5;

end
#80;
$finish;
*/
/*
The Manager (master) sets HPROT to 0b0011 to correspond to a Non-cacheable, Non-bufferable, privileged, data
access. If you don't wanna consider memory management system
*/

/* Busrequest
You must turn off bus request after you recieve grant or ready or both (check that).
wait(HRESETn==1'b0);
wait(HRESETn==1'b1);
M_HBUSREQ [0] = 0;
M_HBUSREQ [1] = 0;

@ (posedge HCLK);
M_HBUSREQ [0] <= 1;
@ (posedge HCLK);
M_HBUSREQ [0] <= 0;
@ (posedge HCLK);
M_HBUSREQ [1] <= 1;
@ (posedge HCLK);
M_HBUSREQ [1] <= 0;
@ (posedge HCLK);
M_HBUSREQ [1] <= 0;*/

/* BUS REQUEST EXAMPLE

initial begin
wait(HRESETn==1'b0);
wait(HRESETn==1'b1);
M_HBUSREQ [0] = 0;
M_HBUSREQ [1] = 0;

@ (posedge HCLK);
M_HBUSREQ [0] <= 1;
@ (posedge HCLK);
M_HBUSREQ [0] <= 0;
@ (posedge HCLK);
M_HBUSREQ [1] <= 1;
@ (posedge HCLK);
M_HBUSREQ [1] <= 0;
@ (posedge HCLK);
M_HBUSREQ [1] <= 0;

#100;
$finish;
end
*/


/* WRITE EXAMPLES

initial begin
wait(HRESETn==1'b0);
wait(HRESETn==1'b1);

@ (posedge HCLK);
$display("test2");
M_HBUSREQ [0] <= 1;                //bus request
M_HLOCK   [0] <= 0;                // locks the bus to the master, until the master releases the bus.

@ (posedge HCLK);


//if ((M_HGRANT[0]!==1'b1)||(M_HREADY!==1'b1)) begin
$display("Grant: %0d, Ready: ,%0d ", M_HGRANT[0],M_HREADY);
//	M_HBUSREQ[0] <= 1'b0;
M_HLOCK  [0] <= 0;
M_HADDR  [0] <= 32'h401;
M_HPROT  [0] <= 0;   //`HPROT_DATA
M_HTRANS [0] <= 2'b10;   //`HTRANS_NONSEQ;
M_HBURST [0] <= 3'b000;  //`HBURST_SINGLE;
M_HWRITE [0] <= 1'b1;    //`HWRITE_WRITE;
M_HSIZE  [0]= 3'b000; //`SIZE_BYTE
//end
//@ (posedge HCLK);
//while (M_HREADY!==1) @ (posedge HCLK);
M_HWDATA [0] <=5;
M_HTRANS[0] <= 2'b00;
$display("ana fi elakher");
#100;
$finish;
end



@ (posedge HCLK);begin
M_HBUSREQ [0] <= 1;  //Ready_out must be '1' and the master having the grant must let busreq=0 for another master to take it. It takes 2 cycles to give grant
S_HREADYout[1]<=1;   // think when to let slave set and release the ready signal (maybe normally 1 and 0 during processing. Check amba documenatation)
S_HREADYout[0]<=1;
//S_HREADYout[2]<=1;  // When grant is 1, it doesn't change when as hready is low, it only does when busreq changes. So in a nutshell, change grant with busreq only
M_HADDR[0]<=32'h401;  // and keep hready always high, unless you want to extend transfers (advanced tests). Keep unused slave's hready high, specially hready[0]
M_HWDATA[0]<=7;       // "default slave" as if it's not high in the initial cycle, bus doesn't work
M_HWRITE[0]<=1;       // After aquiring grant with a cycle, the address is decoded to the slave, then after another cycle the data is decoded there. When a master
M_HWRITE[1]<=1;       // already has a grant, they appear on the same cycle they were driven in.
end
@ (posedge HCLK);begin
M_HBUSREQ [0] <= 0;
S_HREADYout[0]<=0;
end
#20
@ (posedge HCLK);begin
M_HWDATA[0]<=9;
M_HWDATA[1]<=5;
M_HADDR[1]<=32'h301;
S_HREADYout[1]<=0;
end
#20
@ (posedge HCLK); begin
M_HBUSREQ [1] <= 1;
end

@ (posedge HCLK); begin
S_HREADYout[1]<=1;
end
@ (posedge HCLK); begin
M_HWDATA[1]<=4;
end
#40
@ (posedge HCLK); begin
M_HWDATA[1]<=30;
M_HADDR[1]<=32'h801;
end
#80;
$finish;


*/


