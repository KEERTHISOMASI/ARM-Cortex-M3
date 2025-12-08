`ifndef APB_SLAVE_ENV_SV
`define APB_SLAVE_ENV_SV

class apb_slave_env extends uvm_env;
  `uvm_component_utils(apb_slave_env)

  apb_slave_agent      agent;
  apb_slave_scoreboard scb;

  function new(string name = "apb_slave_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = apb_slave_agent::type_id::create("agent", this);
    scb   = apb_slave_scoreboard::type_id::create("scb", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    // connect agent monitor port to scoreboard
    agent.monitor.mon_ap.connect(scb.sb_ap);
  endfunction

endclass

`endif

