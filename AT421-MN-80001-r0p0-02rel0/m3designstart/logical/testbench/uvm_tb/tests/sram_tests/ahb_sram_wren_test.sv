// ---------------------------------------------------------
// AHB → SRAM Write Enable (WREN) Strobe Validation Test
// ---------------------------------------------------------
// Test intent:
// - After system reset
// - Access SRAM through the AHB master interface
// - Perform write transactions using different AHB transfer sizes
//   * BYTE writes at all byte offsets (addr[1:0] = 0–3)
//   * HALFWORD writes at valid halfword-aligned addresses
//   * WORD write covering all byte lanes
// - Read back the written locations after each operation
//
// Purpose:
// - Validate AHB-to-SRAM write-enable (WREN) decode logic
// - Ensure correct generation of SRAM byte strobes for
//   BYTE, HALFWORD, and WORD accesses
// - Verify that only intended byte lanes are modified and
//   non-selected lanes retain their previous values
// - Catch decode, alignment, or data-masking bugs in the
//   AHB → SRAM glue logic
// ---------------------------------------------------------

`ifndef AHB_SRAM_WREN_TEST_SV
`define AHB_SRAM_WREN_TEST_SV

class ahb_sram_wren_test extends iot_test_base;
  `uvm_component_utils(ahb_sram_wren_test)

  ahb_sram_wren_seq wren_seq;

  function new(string name = "ahb_sram_wren_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // -------------------------------------------------
    // Wait for reset to be deasserted
    // -------------------------------------------------
    wait (tb_top.sys_reset_n == 1);

    // -------------------------------------------------
    // Create and configure sequence
    // -------------------------------------------------
    wren_seq = ahb_sram_wren_seq::type_id::create("wren_seq");

    // Use a stable SRAM address (example: SRAM0 base)
    wren_seq.test_addr = SRAM_BASE[0];

    `uvm_info("TEST", "Starting SRAM WREN test (all strobe combinations)", UVM_LOW)

    // -------------------------------------------------
    // Start sequence on DMA master sequencer
    // -------------------------------------------------
    wren_seq.start(env.master_agent_dma.sequencer);

    `uvm_info("TEST", "Completed SRAM WREN test (all strobe combinations)", UVM_LOW)
    #100ns;
    phase.drop_objection(this);
  endtask
endclass
