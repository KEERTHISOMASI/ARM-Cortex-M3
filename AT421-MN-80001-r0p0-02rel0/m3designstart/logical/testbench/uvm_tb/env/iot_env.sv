`ifndef IOT_ENV_SV
`define IOT_ENV_SV

//IoT Env

//AHB Master and Slave agents include file paths
`include "../agents/ahb_agent/ahb_master_agent.sv"
`include "../agents/ahb_agent/ahb_slave_agent.sv"
`include "../agents/apb_agent/apb_slave_agent.sv"
`include "../agents/sram_agent/sram_agent.sv"
class iot_env extends uvm_env;
  `uvm_component_utils(iot_env)

  //AHB Master agents
  ahb_master_agent  master_agent_spi;
  ahb_master_agent  master_agent_dma;

  //AHB Slave agents
  ahb_slave_agent   slave_agent_exp0;
  ahb_slave_agent   slave_agent_exp1;

  //APB Slave Agents
  apb_slave_agent   APB              [2:15];

  // --- SRAM INTEGRATION ---
  sram_agent        sram             [   4];  // 4 SRAM Agents
  sram_agent_config sram_cfg         [   4];  // 4 Config Objects (Mandatory!)
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
      APB[i] = apb_slave_agent::type_id::create($sformatf("APB_%0d", i), this);
    end
    foreach (sram[i]) begin
      sram_cfg[i] = sram_agent_config::type_id::create($sformatf("sram_cfg_%0d", i));
      if (!uvm_config_db#(virtual sram_if)::get(
              this, "", $sformatf("sram_vif_%0d", i), sram_cfg[i].vif
          )) begin
        `uvm_fatal("ENV", $sformatf("Could not get sram_vif_%0d from config DB", i))
      end

      uvm_config_db#(sram_agent_config)::set(this, $sformatf("sram_%0d", i), "sram_cfg",
                                             sram_cfg[i]);
      sram[i] = sram_agent::type_id::create($sformatf("sram_%0d", i), this);
    end
  endfunction

endclass

`endif
