`ifndef APB_SLAVE_AGENT_SV
`define APB_SLAVE_AGENT_SV

`include "apb_slave_driver.sv"
`include "apb_slave_monitor.sv"

class apb_slave_agent extends uvm_agent;
  `uvm_component_utils(apb_slave_agent)

  apb_slave_driver  driver;
  apb_slave_monitor monitor;

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    monitor = apb_slave_monitor::type_id::create("monitor", this);
    driver  = apb_slave_driver::type_id::create("driver", this);
  endfunction

endclass

`endif

