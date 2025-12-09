`ifndef APB_SLAVE_ENV_SV
`define APB_SLAVE_ENV_SV

`include "apb_slave_agent.sv"
`include "apb_slave_scoreboard.sv"

class apb_slave_env extends uvm_env;
  `uvm_component_utils(apb_slave_env)

  apb_slave_agent agent;
  apb_slave_scoreboard scoreboard;

  function new(string name, uvm_component parent=null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    agent      = apb_slave_agent::type_id::create("agent", this);
    scoreboard = apb_slave_scoreboard::type_id::create("scoreboard", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    agent.monitor.mon_ap.connect(scoreboard.sb_ap);
  endfunction

endclass

`endif

