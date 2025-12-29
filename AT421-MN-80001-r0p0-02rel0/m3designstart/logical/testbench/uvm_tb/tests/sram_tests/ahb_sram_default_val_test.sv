// ---------------------------------------------------------
// SRAM Default Value Test (Test-Level Control)
// ---------------------------------------------------------
// Test intent:
// - After reset
// - Trigger a sequence that reads the entire SRAM address space
// - All reads are issued through the DMA AHB master
// - No checking is done inside the test or sequence
// - Scoreboard verifies that all locations return default values
//
// Purpose:
// - Validate SRAM reset initialization
// - Ensure correct AHB-to-SRAM connectivity
// - Confirm no spurious writes before reset release
//
// ---------------------------------------------------------

`ifndef AHB_SRAM_DEFAULT_VAL_TEST_SV
`define AHB_SRAM_DEFAULT_VAL_TEST_SV

class ahb_sram_default_val_test extends iot_test_base;
  `uvm_component_utils(ahb_sram_default_val_test)

  ahb_sram_default_val_seq sram_seq;

  function new(string name = "ahb_sram_default_val_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // Wait for reset deassertion (VERY IMPORTANT)
    wait (tb_top.sys_reset_n == 1);

    sram_seq = ahb_sram_default_val_seq::type_id::create("sram_seq");

    `uvm_info("TEST", "Starting SRAM default value sequence on DMA master", UVM_LOW)

    sram_seq.start(env.master_agent_dma.sequencer);

    `uvm_info("TEST", "SRAM default value sequence completed", UVM_LOW)
    #1000ns;

    phase.drop_objection(this);
  endtask
endclass
