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

endclass
`endif
