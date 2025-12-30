// ---------------------------------------------------------
// SRAM Address Boundary Test Sequence
// ---------------------------------------------------------
// Test intent:
// - For each SRAM bank (SRAM0–SRAM3):
//   * Write a known data pattern to the first address of the bank
//   * Write a different data pattern to the last valid word address
//   * Read back both addresses
// - Data correctness is checked in the scoreboard
//
// Address coverage:
// - Base address  : SRAM_BASE[bank]
// - Last word     : SRAM_BASE[bank] + SRAM_BANK_SIZE - ADDR_STRIDE
//
// Implementation details:
// - Uses word-aligned (32-bit) accesses
// - Issues SINGLE, NONSEQ AHB transactions
// - Performs explicit write followed by read at boundary addresses
//
// Purpose:
// - Validate correct address decoding at SRAM boundaries
// - Detect off-by-one errors in bank size handling
// - Ensure no address aliasing across adjacent SRAM banks
// ---------------------------------------------------------

`ifndef AHB_SRAM_ADDR_BOUNDARY_TEST_SV
`define AHB_SRAM_ADDR_BOUNDARY_TEST_SV

class ahb_sram_addr_boundary_test extends iot_test_base;
  `uvm_component_utils(ahb_sram_addr_boundary_test)

  ahb_sram_addr_boundary_seq boundary_seq;

  function new(string name = "ahb_sram_addr_boundary_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // Wait for reset deassertion

    boundary_seq = ahb_sram_addr_boundary_seq::type_id::create("boundary_seq");

    `uvm_info("TEST", "Starting SRAM address boundary test sequence", UVM_LOW)

    boundary_seq.start(env.master_agent_dma.sequencer);

    `uvm_info("TEST", "Completed SRAM address boundary test sequence", UVM_LOW)
    #1000ns;

    phase.drop_objection(this);
  endtask

endclass

`endif

