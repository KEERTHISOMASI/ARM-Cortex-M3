`ifndef APB_SLAVE_AGENT_SV
`define APB_SLAVE_AGENT_SV

class apb_slave_agent extends uvm_agent;
  `uvm_component_utils(apb_slave_agent)

  apb_slave_driver  driver;
  apb_slave_monitor monitor;

<<<<<<< HEAD
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    monitor = apb_slave_monitor::type_id::create("monitor", this);
    driver  = apb_slave_driver::type_id::create("driver", this);
=======
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    monitor = apb_slave_monitor::type_id::create("monitor", this);
    driver  = apb_slave_driver ::type_id::create("driver",  this);
>>>>>>> main
  endfunction

endclass

`endif

