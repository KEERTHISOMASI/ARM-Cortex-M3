`ifndef AHB_ENV_SV
`define AHB_ENV_SV

`include "ahb_master_agent.sv"
`include "ahb_slave_agent.sv"

class ahb_env extends uvm_env;
  `uvm_component_utils(ahb_env)

  ahb_master_agent master_agent;
  ahb_slave_agent  slave_agent;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    master_agent = ahb_master_agent::type_id::create("master_agent", this);
    slave_agent  = ahb_slave_agent::type_id::create("slave_agent", this);
  endfunction

endclass

`endif