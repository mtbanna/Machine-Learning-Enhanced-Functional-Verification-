
interface slave_interface(input bit clock);

bit [31:0] HADDR;            //slave's inputs  (coming from bus) 
bit        HWRITE;  
bit [ 1:0] HTRANS;  
bit [ 2:0] HSIZE;   
bit [ 2:0] HBURST;  
bit [31:0] HWDATA;  
bit [ 3:0] HPROT;   
bit        S_HREADY;          // assign S_HREADY = M_HREADY from rtl's code
bit [3:0]  HMASTER; 
bit        HMASTLOCK;
bit        HSEL;              // HSEL is exclusive for every slave, while the rest inputs are general.

                              //slave's outputs (you give it)
bit        HREADY; 
bit [ 1:0] HRESP;  
bit [31:0] HRDATA; 
bit [15:0] HSPLIT;

endinterface