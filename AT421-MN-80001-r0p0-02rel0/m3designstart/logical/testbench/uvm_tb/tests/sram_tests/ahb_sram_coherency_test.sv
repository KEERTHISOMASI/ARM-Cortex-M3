// ---------------------------------------------------------
// DMA → SPI → DMA Coherency Test (Virtual Sequence Based)
// ---------------------------------------------------------
// Test intent:
// - After reset
// - Perform a read from memory using DMA master
// - Write new data to the same memory location using SPI master
// - Read again using DMA master
// - Verify that the DMA master observes the updated data
//
// Purpose:
// - Validate AHB multi-master coherency
// - Ensure correct interconnect arbitration and data visibility
// - Catch stale-data or ordering issues across masters
// ---------------------------------------------------------

`ifndef AHB_SRAM_COHERENCY_TEST_SV
`define AHB_SRAM_COHERENCY_TEST_SV

class ahb_sram_coherency_test extends iot_test_base;
  `uvm_component_utils(ahb_sram_coherency_test)
 logic [31:0] test_addr;
 // ahb_dma_spi_dma_vseq vseq;

  function new(string name = "ahb_sram_coherency_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction


  task run_phase(uvm_phase phase);
    ahb_sram_single_read_seq  rd1;
    ahb_sram_single_write_seq wr;
    ahb_sram_single_read_seq  rd2;
test_addr=32'h2001_8004;
    phase.raise_objection(this);

    // DMA READ
    rd1 = ahb_sram_single_read_seq::type_id::create("rd1");
    rd1.rd_addr = test_addr;
    rd1.start(env.master_agent_dma.sequencer);
    #100ns;
    // SPI WRITE
    wr = ahb_sram_single_write_seq::type_id::create("wr");
    wr.wr_addr = test_addr;
    wr.wr_data = 32'hc001c0de;
    wr.start(env.master_agent_spi.sequencer);
    #100ns;
    // DMA READ again
    rd2 = ahb_sram_single_read_seq::type_id::create("rd2");
    rd2.rd_addr = test_addr;
    rd2.start(env.master_agent_dma.sequencer);
    #100ns;
    phase.drop_objection(this);
  endtask
endclass
`endif
