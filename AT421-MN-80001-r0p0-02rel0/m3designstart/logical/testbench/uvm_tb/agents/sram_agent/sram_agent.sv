
`include "sram_agent_config.sv"
`include "sram_driver.sv"
`include "sram_monitor.sv"

// ----------------------------------------------------------------
// 6. AGENT
// ----------------------------------------------------------------
class sram_agent extends uvm_agent;
  `uvm_component_utils(sram_agent)

  sram_agent_config                  m_cfg;
  sram_driver                        drv;
  sram_monitor                       mon;

  // Analysis port to promote Monitor's output to the Env
  uvm_analysis_port #(sram_seq_item) ap;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    ap = new("ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Get Config
    if (!uvm_config_db#(sram_agent_config)::get(this, "", "sram_cfg", m_cfg))
      `uvm_fatal("AGENT", "No sram_cfg found")
    uvm_config_db#(sram_agent_config)::set(this, "*", "sram_cfg", m_cfg);
    mon = sram_monitor::type_id::create("mon", this);

    if (m_cfg.active) begin
      drv = sram_driver::type_id::create("drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    mon.ap.connect(this.ap);  // Promote monitor port to agent boundary

    // Share the config (and the memory model)
    mon.m_cfg = m_cfg;
    if (m_cfg.active) begin
      drv.m_cfg = m_cfg;
    end
  endfunction
endclass


