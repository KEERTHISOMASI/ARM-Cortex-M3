// ---------------------------------------------------------
// Concurrent SRAM Access Arbitration Test (DMA vs SPI)
// ---------------------------------------------------------
// Test intent:
// - After system reset
// - Target the same SRAM address from two AHB masters:
//     * DMA master
//     * SPI master
// - Issue write transactions concurrently using fork–join
//
// Purpose:
// - Validate correct AHB interconnect arbitration when multiple
//   masters access the same SRAM location simultaneously
// - Ensure no bus deadlock, data corruption, or protocol violation
//   occurs under concurrent access
// - Observe final memory contents to confirm deterministic and
//   well-defined arbitration behavior
// ---------------------------------------------------------


class ahb_sram_concurrent_access_test extends iot_test_base;
  `uvm_component_utils(ahb_sram_concurrent_access_test)

  ahb_sram_single_write_seq dma_wr_seq;
  ahb_sram_single_write_seq spi_wr_seq;

  logic [31:0] test_addr;

  function new(string name = "ahb_sram_concurrent_access_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);

    // -----------------------------------------
    // Wait for reset deassertion
    // -----------------------------------------
    //    wait (tb_top.sys_reset_n == 1);

    // Target SRAM0 base address
    test_addr = SRAM_BASE[0];

    `uvm_info("TEST", "Starting concurrent SRAM access arbitration test", UVM_LOW)

    // -----------------------------------------
    // Create sequences
    // -----------------------------------------
    dma_wr_seq = ahb_sram_single_write_seq::type_id::create("dma_wr_seq");
    spi_wr_seq = ahb_sram_single_write_seq::type_id::create("spi_wr_seq");

    dma_wr_seq.wr_addr = test_addr;
    dma_wr_seq.wr_data = 32'hAAAA_AAAA;

    spi_wr_seq.wr_addr = test_addr;
    spi_wr_seq.wr_data = 32'h5555_5555;

    // -----------------------------------------
    // Concurrent execution (KEY)
    // -----------------------------------------
    fork
      begin
        `uvm_info("TEST", "DMA master write started", UVM_MEDIUM)
        dma_wr_seq.start(env.master_agent_dma.sequencer);
        `uvm_info("TEST", "DMA master write completed", UVM_MEDIUM)
      end

      begin
        `uvm_info("TEST", "SPI master write started", UVM_MEDIUM)
        spi_wr_seq.start(env.master_agent_spi.sequencer);
        `uvm_info("TEST", "SPI master write completed", UVM_MEDIUM)
      end
    join

    `uvm_info("TEST", "Concurrent SRAM access arbitration test completed", UVM_LOW)
    #1000ns;
    phase.drop_objection(this);
  endtask
endclass

