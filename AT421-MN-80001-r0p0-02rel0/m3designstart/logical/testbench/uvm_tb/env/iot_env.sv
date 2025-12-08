`ifndef IOT_ENV_SV
`define IOT_ENV_SV    

//IoT Env

//AHB Master and Slave agents include file paths
`include "../agents/ahb_agent/ahb_master_agent.sv"
`include "../agents/ahb_agent/ahb_slave_agent.sv"
`include "../agents/apb_agent/apb_slave_agent.sv"
class iot_env extends uvm_env;
    `uvm_component_utils(iot_env)

    //AHB Master agents
    ahb_master_agent master_agent_spi;
    ahb_master_agent master_agent_dma;

    //AHB Slave agents
    ahb_slave_agent  slave_agent_exp0;
    ahb_slave_agent  slave_agent_exp1;
    
    //APB Slave Agents
    apb_slave_agent APB[2:15];

    function new(string name = "iot_env", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        //AHB Master agents creation
        master_agent_spi = ahb_master_agent::type_id::create("master_agent_spi", this);
        master_agent_dma = ahb_master_agent::type_id::create("master_agent_dma", this);
        //AHB Slave agents creation
        slave_agent_exp0 = ahb_slave_agent::type_id::create("slave_agent_exp0", this);
        slave_agent_exp1 = ahb_slave_agent::type_id::create("slave_agent_exp1", this);

        foreach (APB[i]) begin
                 APB[i] = my_agent::type_id::create($sformatf("APB_%0d", i), this);
              end
        endfunction

//   function void connect_phase(uvm_phase phase);
//       super.connect_phase(phase);
//   endfunction
//
//   function void end_of_elaboration_phase(uvm_phase phase);
//       super.end_of_elaboration_phase(phase);
//   endfunction
//
//   function void start_of_simulation_phase(uvm_phase phase);
//       super.start_of_simulation_phase(phase);
//   endfunction
//
//   task run_phase(uvm_phase phase);
//       phase.raise_objection(this);
//       #100;
//       phase.drop_objection(this);
//   endtask
//
//   function void extract_phase(uvm_phase phase);
//       super.extract_phase(phase);
//   endfunction
//
//   function void check_phase(uvm_phase phase);
//       super.check_phase(phase);
//   endfunction
//
//   function void report_phase(uvm_phase phase);
//       super.report_phase(phase);
//   endfunction
//
//   function void final_phase(uvm_phase phase);
//       super.final_phase(phase);
//   endfunction
endclass

`endif
