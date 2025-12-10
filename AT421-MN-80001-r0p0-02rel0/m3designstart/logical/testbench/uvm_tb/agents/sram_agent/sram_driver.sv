`include "sram_seq_item.sv"

// ----------------------------------------------------------------
// 4. DRIVER (Responder)
// ----------------------------------------------------------------
class sram_driver extends uvm_driver #(sram_seq_item);
  `uvm_component_utils(sram_driver)

  virtual sram_if vif;
  sram_agent_config m_cfg;

  // Pipeline Registers
  bit        pipe_prev_cs;
  bit [12:0] pipe_prev_addr;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(sram_agent_config)::get(this, "", "sram_cfg", m_cfg))
       `uvm_fatal("DRV", "No Config Found")
    vif = m_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    // Init
    vif.RDATA      <= 'z;
    pipe_prev_cs   = 0;
    pipe_prev_addr = 0;

    forever begin
      @(posedge vif.CLK);

      // --- 1. READ RESPONSE (Based on PREV cycle) ---
      if (pipe_prev_cs) begin
        vif.RDATA <= m_cfg.mem_model.read(pipe_prev_addr);
      end else begin
        vif.RDATA <= 'z;
      end

      // --- 2. WRITE UPDATE (Based on CURRENT cycle) ---
      if (vif.CS && (|vif.WREN)) begin
        m_cfg.mem_model.write(vif.ADDR, vif.WDATA, vif.WREN);
      end

      // --- 3. PIPELINE LATCH ---
      pipe_prev_cs   = vif.CS;
      pipe_prev_addr = vif.ADDR;
    end
  endtask
endclass
