`ifndef AHB_SLAVE_AGENT_SV
`define AHB_SLAVE_AGENT_SV 


// Ensure these are included in your package or file list
`include "ahb_seq_item.sv"
`include "ahb_slave_driver.sv"
`include "ahb_slave_monitor.sv"

// Typedef for the sequencer (Standard UVM practice for simple sequencers)
typedef uvm_sequencer#(ahb_seq_item) ahb_slave_sequencer;

class ahb_slave_agent extends uvm_agent;
  `uvm_component_utils(ahb_slave_agent)

  // -------------------------------------------------------
  // Component Handles
  // -------------------------------------------------------
  ahb_slave_driver                  driver;
  ahb_slave_monitor                 monitor;
  ahb_slave_sequencer               sequencer;

  // -------------------------------------------------------
  // Analysis Port
  // -------------------------------------------------------
  // Output port to send monitored transactions to Scoreboard/Coverage
  uvm_analysis_port #(ahb_seq_item) item_collected_port;

  // -------------------------------------------------------
  // Constructor
  // -------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  // -------------------------------------------------------
  // Build Phase
  // -------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // 1. Always build the Monitor (Active or Passive)
    monitor = ahb_slave_monitor::type_id::create("monitor", this);

    // 2. Build Driver & Sequencer only if Active
    if (get_is_active() == UVM_ACTIVE) begin
      driver    = ahb_slave_driver::type_id::create("driver", this);
      sequencer = ahb_slave_sequencer::type_id::create("sequencer", this);
    end
  endfunction

  // -------------------------------------------------------
  // Connect Phase
  // -------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // 1. Connect Monitor internal port to Agent external port
    monitor.item_collected_port.connect(item_collected_port);

    // 2. Connect Driver to Sequencer (Only if Active)
    if (get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

`endif

