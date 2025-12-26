// ahb_master_agent.sv
`ifndef AHB_MASTER_AGENT_SV
`define AHB_MASTER_AGENT_SV 


// Include component files
`include "ahb_seq_item.sv"
`include "ahb_master_sequencer.sv"
`include "ahb_master_driver.sv"
`include "ahb_master_monitor.sv"

class ahb_master_agent extends uvm_agent;
  `uvm_component_utils(ahb_master_agent)

  ahb_master_driver    driver;
  ahb_master_monitor   monitor;
  ahb_master_sequencer sequencer;

  virtual ahb_if.MASTER vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Get VIF
    if (!uvm_config_db#(virtual ahb_if.MASTER)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "Virtual interface not set for ahb_master_agent")
    end

    monitor = ahb_master_monitor::type_id::create("monitor", this);

    // Create Driver/Sequencer only if Active
    if (get_is_active() == UVM_ACTIVE) begin
      driver    = ahb_master_driver::type_id::create("driver", this);
      sequencer = ahb_master_sequencer::type_id::create("sequencer", this);
    end

    uvm_config_db#(virtual ahb_if.MASTER)::set(this, "driver", "vif", vif);
    uvm_config_db#(virtual ahb_if.MASTER)::set(this, "monitor", "vif", vif);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    if (get_is_active() == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction

endclass

`endif

