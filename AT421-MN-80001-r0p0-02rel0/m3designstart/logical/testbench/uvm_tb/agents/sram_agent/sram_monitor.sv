
import uvm_pkg::*;
`include "uvm_macros.svh"

// ----------------------------------------------------------------
// 5. MONITOR
// ----------------------------------------------------------------
class sram_monitor extends uvm_monitor;
  `uvm_component_utils(sram_monitor)

  virtual sram_if vif;
  sram_agent_config m_cfg;
  uvm_analysis_port #(sram_seq_item) ap;

  // Monitor Pipeline
  bit        mon_prev_cs;
  bit [12:0] mon_prev_addr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(sram_agent_config)::get(this, "", "sram_cfg", m_cfg))
       `uvm_fatal("MON", "No Config Found")
    vif = m_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    sram_seq_item item;
    mon_prev_cs = 0;

    forever begin
      @(posedge vif.CLK);
      #1ns; // Sampling Delay

      // A. Capture WRITE (Current Cycle)
      if (vif.CS && (|vif.WREN)) begin
        item = sram_seq_item::type_id::create("item_write");
        item.addr = vif.ADDR;
        item.data = vif.WDATA;
        item.wren = vif.WREN;
        item.is_write = 1;
        ap.write(item);
      end

      // B. Capture READ (Previous Cycle Result)
      if (mon_prev_cs) begin
        item = sram_seq_item::type_id::create("item_read");
        item.addr = mon_prev_addr;
        item.data = vif.RDATA; // Sample what Driver actually drove
        item.wren = 0;
        item.is_write = 0;
        ap.write(item);
      end

      // C. Update Pipeline
      mon_prev_cs   = vif.CS;
      mon_prev_addr = vif.ADDR;
    end
  endtask
endclass


