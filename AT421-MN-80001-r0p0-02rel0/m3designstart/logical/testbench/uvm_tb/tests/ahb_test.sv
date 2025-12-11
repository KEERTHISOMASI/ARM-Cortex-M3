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
      
      
      env.slave_agent.driver.add_range(32'hA000_0000, 32'hA000_FFFF); 

        env.slave_agent.driver.add_range(32'h0004_0000, 32'h1FFF_FFFF); 

        env.slave_agent.driver.add_range(32'h2002_0000, 32'h3FFF_FFFF); 

        env.slave_agent.driver.add_range(32'h4001_0000, 32'h9FFF_FFFF); 

        env.slave_agent.driver.add_range(32'hA001_0000, 32'hDFFF_FFFF); 

        env.slave_agent.driver.add_range(32'hE001_0000, 32'hFFFF_FFFF);
      
    end else begin
      `uvm_error("TEST", "Slave Driver handle is null!")
    end
endfunction
  task run_phase(uvm_phase phase);
   //ahb_incr4_burst_seq master_seq;
 ahb_single_write_seq master_seq;
    //ahb_single_read_seq master_seq;
    //ahb_write_read_seq master_seq;
    //ahb_wrap4_burst_seq master_seq;
    phase.raise_objection(this);

    // 1. Fork the Slave Sequence (Runs infinitely in background)

    // 2. Start the Master Sequence (The actual test scenario)
    //master_seq = ahb_incr4_burst_seq::type_id::create("master_seq");
    master_seq = ahb_single_write_seq::type_id::create("master_seq");
    //master_seq = ahb_single_read_seq::type_id::create("master_seq");
   // master_seq = ahb_write_read_seq::type_id::create("master_seq");
    // master_seq = ahb_wrap4_burst_seq::type_id::create("master_seq");
    master_seq.start(env.master_agent.sequencer);
    
    // Allow a little time for final response to complete
    #100;
    phase.drop_objection(this);
  endtask

endclass



`endif