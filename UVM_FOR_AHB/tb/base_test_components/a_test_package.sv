package a_test_package; // a package including a full single test components
     `include "master_components/master_sequence_item.sv"
     `include "slave_components/slave_sequence_item.sv"
     `include "master_components/master_sequence.sv"
     `include "master_components/master_driver.sv"
     `include "master_components/master_monitor.sv"
     `include "slave_components/slave_monitor.sv"
     `include "master_components/master_agent.sv"
     `include "slave_components/slave_agent.sv"
     `include "check_item.sv"
     `include "scoreboard.sv"
     `include "coverage.sv"
     `include "environment.sv"
     `include "test.sv"
endpackage 