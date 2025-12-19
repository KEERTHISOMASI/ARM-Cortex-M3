`ifndef AHB_SLAVE_AGENT_SV
`define AHB_SLAVE_AGENT_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

//`include "ahb_slave_sequencer.sv"
`include "ahb_slave_driver.sv"
`include "ahb_slave_monitor.sv"

class ahb_slave_agent extends uvm_agent;
  `uvm_component_utils(ahb_slave_agent)

  ahb_slave_driver    driver;
  ahb_slave_monitor   monitor;
  //ahb_slave_sequencer sequencer; // Added Sequencer
  
  virtual ahb_if.SLAVE vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    monitor = ahb_slave_monitor::type_id::create("monitor", this);
    if(get_is_active() == UVM_ACTIVE) begin
      driver    = ahb_slave_driver::type_id::create("driver", this);
    end
  endfunction

endclass

`endif
