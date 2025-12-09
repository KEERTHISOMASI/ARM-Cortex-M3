// ----------------------------------------------------------------
// 3. AGENT CONFIG
// ----------------------------------------------------------------
class sram_agent_config extends uvm_object;
  `uvm_object_utils(sram_agent_config)

  virtual sram_if vif;
  sram_storage_c mem_model;  // Shared memory handle
  bit active = 1;  // Active = Driver + Monitor, Passive = Monitor only

  function new(string name = "sram_agent_config");
    super.new(name);
    bit active = 1;
    mem_model = sram_storage_c::type_id::create("mem_model");
  endfunction
endclass


