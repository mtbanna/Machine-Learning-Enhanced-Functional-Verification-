interface master_interface(input bit clock); //ADD master's general signals' violations assertion (Checker) (ex: reset signal isn't triggered (set to zero, as it's active low)), 
                                             //while in scoreboard we have assertions for a certain test 
    bit HRESET;             //master's output     (you give it)
    bit HBUSREQ;
    bit [31:0] HADDR;
    bit [1:0] HTRANS;
    bit [2:0] HSIZE;
    bit [2:0] HBURST;
    bit [3:0] HPROT;
    bit  HLOCK;
    bit  HWRITE;
    bit [31:0] HWDATA;
    //master's input      (coming from bus)
    bit HGRANT;           //exclusive for every master
    bit [31:0] HRDATA;
    bit [ 1:0] HRESP;
    bit HREADY;

    modport to_master (        //for driver                    // For identifying different directions (input or output), ex: interface_x.upstream.data. This prevents some errors like
        input    HRESET,                                       // driving outputs signals
        input    HBUSREQ,
        input    HADDR,
        input    HTRANS,
        input    HSIZE,
        input    HBURST,
        input    HPROT,
        input    HLOCK,
        input    HWRITE,
        input    HWDATA,
        output   HGRANT,
        output   HRDATA,
        output   HRESP,
        output   HREADY);
    modport from_master (     //for monitor
        output    HRESET,
        output    HBUSREQ,
        output    HADDR,
        output    HTRANS,
        output    HSIZE,
        output    HBURST,
        output    HPROT,
        output    HLOCK,
        output    HWRITE,
        output    HWDATA,
        input     HGRANT,
        input   HRDATA,
        input   HRESP,
        input   HREADY);

endinterface

//cover property (@(posedge clock)HBUSREQ==1);

   /* property reset_is_off;
        // @(posedge clock)
        HRESET!=0;
    endproperty
*/