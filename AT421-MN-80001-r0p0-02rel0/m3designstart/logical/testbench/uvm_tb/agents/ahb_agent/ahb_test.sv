`ifndef AHB_TEST_SV
`define AHB_TEST_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_wr_rd_test extends uvm_test;
  `uvm_component_utils(ahb_wr_rd_test)

  ahb_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ahb_env::type_id::create("env", this);
  endfunction

function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology(); // Optional: Print structure
    
    // 1. Access the Slave Driver through the hierarchy
    // Path: env -> slave_agent -> driver
    if (env.slave_agent.driver != null) begin
      
      // 2. Call the function
      `uvm_info("TEST", "Configuring Slave Address Ranges", UVM_LOW)
      
      // Range 1: 0x0000_0000 to 0x0000_FFFF
      env.slave_agent.driver.add_range(32'h0000_0000, 32'h0000_FFFF);
      
      // Range 2: 0xEC00_0000 to 0xECFF_FFFF (Where your test writes)
      env.slave_agent.driver.add_range(32'hEC00_0000, 32'hECFF_FFFF);
      
    end else begin
      `uvm_error("TEST", "Slave Driver handle is null!")
    end
endfunction
  task run_phase(uvm_phase phase);
    ahb_write_read_seq master_seq;
    
    phase.raise_objection(this);

    // 1. Fork the Slave Sequence (Runs infinitely in background)

    // 2. Start the Master Sequence (The actual test scenario)
    master_seq = ahb_write_read_seq::type_id::create("master_seq");
    master_seq.start(env.master_agent.sequencer);
    
    // Allow a little time for final response to complete
    #100;
    phase.drop_objection(this);
  endtask

endclass

`endif