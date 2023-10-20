import a_test_package::*;
import uvm_pkg::*;
import ahb_parameters::*;
`include "uvm_macros.svh"

class reset_assertion_and_deassertion_scoreboard extends scoreboard;
`uvm_component_utils(reset_assertion_and_deassertion_scoreboard)
bit reset_on_clock_edge, reset_on_previous_clock_edge, test_failed;

function new(string name = "reset_assertion_and_deassertion_scoreboard",uvm_component parent=null);
	super.new(name,parent);
endfunction

virtual function void write (check_item my_check_item);
	`uvm_info("SCOREBOARD",$sformatf("SCOREBOARD: grant0:%0b, hreset:%0b",my_check_item.M_HGRANT[0], my_master_interface.HRESET), UVM_LOW);
	if(test_failed==1)
		`uvm_info("Scoreboard","Reset wasn't asynchrounsly sampled, so our directed test won't continue, as it will show false results", UVM_LOW)
	else begin
		if(my_master_interface.HRESET==0 && my_check_item.M_HGRANT[0]==1) begin
			`uvm_error("Scoreboard", "Reset isn't asserted asynchrounsly")
			test_wont_continue(my_check_item);
		end
		else if (reset_on_clock_edge==1 && reset_on_previous_clock_edge==1 &&my_check_item.M_HGRANT[0]==1)
			to_coverage_port.write(my_check_item);
		else if (my_master_interface.HRESET==0 && my_check_item.M_HGRANT[0]==0)
			to_coverage_port.write(my_check_item); //using interface's clock to indicate clock at any time (not on +ve edge)

		reset_on_previous_clock_edge=reset_on_clock_edge;
	end
endfunction

virtual task run_phase(uvm_phase phase);
	@(posedge my_master_interface.clock)
		reset_on_clock_edge=my_master_interface.HRESET;
endtask

virtual function void test_wont_continue(check_item my_check_item);//we are using this function, and not just using fatal error, as this test tests 2 features
	my_check_item.end_test=1;                    // so we wanna collect coverage for the other feature instead of sabotaging the test
	test_failed=1;                               // this is a directed test, so we can use whatever way we want to test.
	to_coverage_port.write(my_check_item);       // all objects used in that test are special for the test, and aren't following
endfunction// the universal convention.

endclass


