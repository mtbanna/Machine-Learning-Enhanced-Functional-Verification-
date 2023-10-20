module master_assertions_properties;

property reset_is_off;
   @(posedge my_master_interface.clock) 
   my_master_interface.HRESET!=0;
endproperty

//Check the port map, and try to link it to our environment, and check cover option


endmodule 