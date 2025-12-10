
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
    mon = sram_monitor::type_id::create("mon", this);

    if (m_cfg.active) begin
      drv = sram_driver::type_id::create("drv", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Hook up monitor's analysis port to agent's
    mon.ap.connect(this.ap);

    // Pass shared config + vif down from agent to children
    mon.m_cfg = m_cfg;
    mon.vif   = m_cfg.vif;

    if (m_cfg.active && drv != null) begin
      drv.m_cfg = m_cfg;
      drv.vif   = m_cfg.vif;
    end
  endfunction
endclass


