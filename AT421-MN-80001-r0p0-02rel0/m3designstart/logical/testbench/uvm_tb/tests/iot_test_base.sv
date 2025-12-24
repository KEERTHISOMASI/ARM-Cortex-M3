//IoT Base Test class

`ifndef IOT_TEST_BASE_SV
`define IOT_TEST_BASE_SV

//Include path of Environment
`include "../env/iot_env.sv"

class iot_test_base extends uvm_test;
  `uvm_component_utils(iot_test_base)

  iot_env env;

  function new(string name = "iot_test_base", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = iot_env::type_id::create("env", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();

    //Configure Slave ranges
    //env.slave_agent_exp0.driver.add_range(32'h0000_0000, 32'h0000_0001);
    env.slave_agent_exp0.driver.add_range(32'hA000_0000, 32'hA000_FFFF);
    //env.slave_agent_exp1.driver.add_range(32'h0000_0000, 32'h0000_0001);
    env.slave_agent_exp1.driver.add_range(32'h0004_0000, 32'h1FFF_FFFF);
    env.slave_agent_exp1.driver.add_range(32'h2002_0000, 32'h3FFF_FFFF);
    env.slave_agent_exp1.driver.add_range(32'h4001_0000, 32'h9FFF_FFFF);
    env.slave_agent_exp1.driver.add_range(32'hA001_0000, 32'hDFFF_FFFF);
    env.slave_agent_exp1.driver.add_range(32'hE001_0000, 32'hFFFF_FFFF);
  endfunction
endclass
`endif
