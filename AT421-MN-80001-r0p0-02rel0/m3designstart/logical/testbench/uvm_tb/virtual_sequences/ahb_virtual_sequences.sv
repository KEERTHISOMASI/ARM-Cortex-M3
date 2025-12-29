// ---------------------------------------------------------
// Virtual Sequence: Reset During Active AHB Transfer
// ---------------------------------------------------------
class ahb_reset_during_active_vseq extends uvm_sequence;
  `uvm_object_utils(ahb_reset_during_active_vseq)

  ahb_virtual_sequencer vseqr;

  // NORMAL AHB sequence (already written by you)
  ahb_incr4_write_seq incr4_seq;

  function new(string name = "ahb_reset_during_active_vseq");
    super.new(name);
  endfunction

  task body();

    // Get virtual sequencer
    if (!$cast(vseqr, p_sequencer)) begin
      `uvm_fatal("VSEQ", "Failed to cast p_sequencer to ahb_virtual_sequencer")
    end

    `uvm_info("VSEQ",
      "Starting reset-during-active-AHB-transfer virtual sequence",
      UVM_LOW)

    // Create normal sequence
    incr4_seq = ahb_incr4_write_seq::type_id::create("incr4_seq");

    fork
      // -------------------------------------------------
      // Thread 1: AHB traffic (NORMAL sequence)
      // -------------------------------------------------
      begin
        incr4_seq.start(vseqr.dma_seqr);
      end

      // -------------------------------------------------
      // Thread 2: Reset control
      // -------------------------------------------------
      begin
        // Wait for address phase to launch
        @(posedge vseqr.ahb_vif.HCLK);

        `uvm_info("VSEQ", "Asserting HRESETn LOW", UVM_MEDIUM)
        vseqr.ahb_vif.HRESETn <= 1'b0;

        // Hold reset for 4 cycles
        repeat (4) @(posedge vseqr.ahb_vif.HCLK);

        `uvm_info("VSEQ", "Deasserting HRESETn HIGH", UVM_MEDIUM)
        vseqr.ahb_vif.HRESETn <= 1'b1;
      end
    join

    `uvm_info("VSEQ",
      "Completed reset-during-active-AHB-transfer sequence",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Virtual Sequence: Reset During AHB Idle
// ---------------------------------------------------------
class ahb_reset_during_idle_vseq extends uvm_sequence;
  `uvm_object_utils(ahb_reset_during_idle_vseq)

  ahb_virtual_sequencer vseqr;

  function new(string name = "ahb_reset_during_idle_vseq");
    super.new(name);
  endfunction

  task body();

    // Cast virtual sequencer
    if (!$cast(vseqr, p_sequencer)) begin
      `uvm_fatal("VSEQ", "Failed to cast p_sequencer to ahb_virtual_sequencer")
    end

    `uvm_info("VSEQ",
      "Starting reset-during-idle virtual sequence",
      UVM_LOW)

    // -------------------------------------------------
    // Ensure bus is idle (no sequences started)
    // -------------------------------------------------
    repeat (2) @(posedge vseqr.ahb_vif.HCLK);

    // -------------------------------------------------
    // Assert reset while bus is idle
    // -------------------------------------------------
    `uvm_info("VSEQ", "Asserting HRESETn LOW during IDLE", UVM_MEDIUM)
    vseqr.ahb_vif.HRESETn <= 1'b0;

    // Hold reset for 4 cycles
    repeat (4) @(posedge vseqr.ahb_vif.HCLK);

    // -------------------------------------------------
    // Deassert reset
    // -------------------------------------------------
    `uvm_info("VSEQ", "Deasserting HRESETn HIGH", UVM_MEDIUM)
    vseqr.ahb_vif.HRESETn <= 1'b1;

    // Allow bus to stabilize
    repeat (2) @(posedge vseqr.ahb_vif.HCLK);

    `uvm_info("VSEQ",
      "Completed reset-during-idle virtual sequence",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Virtual Sequence: Reset During Arbitration
// ---------------------------------------------------------
class ahb_reset_during_arbitration_vseq extends uvm_sequence;
  `uvm_object_utils(ahb_reset_during_arbitration_vseq)

  ahb_virtual_sequencer vseqr;

  // NORMAL sequences for both masters
  ahb_incr4_write_seq dma_seq;
  ahb_incr4_write_seq spi_seq;

  function new(string name = "ahb_reset_during_arbitration_vseq");
    super.new(name);
  endfunction

  task body();

    // Cast virtual sequencer
    if (!$cast(vseqr, p_sequencer)) begin
      `uvm_fatal("VSEQ", "Failed to cast p_sequencer to ahb_virtual_sequencer")
    end

    `uvm_info("VSEQ",
      "Starting reset-during-arbitration virtual sequence",
      UVM_LOW)

    // Create normal sequences
    dma_seq = ahb_incr4_write_seq::type_id::create("dma_seq");
    spi_seq = ahb_incr4_write_seq::type_id::create("spi_seq");

    fork
      // -------------------------------------------------
      // Thread 1: DMA master requests bus
      // -------------------------------------------------
      begin
        dma_seq.start(vseqr.dma_seqr);
      end

      // -------------------------------------------------
      // Thread 2: SPI master requests bus
      // -------------------------------------------------
      begin
        spi_seq.start(vseqr.spi_seqr);
      end

      // -------------------------------------------------
      // Thread 3: Reset during arbitration
      // -------------------------------------------------
      begin
        // Wait until arbitration is active
        @(posedge vseqr.ahb_vif.HCLK);

        `uvm_info("VSEQ", "Asserting HRESETn LOW during arbitration", UVM_MEDIUM)
        vseqr.ahb_vif.HRESETn <= 1'b0;

        // Hold reset for 4 cycles
        repeat (4) @(posedge vseqr.ahb_vif.HCLK);

        `uvm_info("VSEQ", "Deasserting HRESETn HIGH", UVM_MEDIUM)
        vseqr.ahb_vif.HRESETn <= 1'b1;
      end
    join

    `uvm_info("VSEQ",
      "Completed reset-during-arbitration virtual sequence",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Concurrent Access Virtual Sequence
// Master 0 & Master 1 → Same Slave
// Uses single_beat_nonseq_seq
// ---------------------------------------------------------
class ahb_concurrent_same_slave_vseq extends uvm_sequence;
  `uvm_object_utils(ahb_concurrent_same_slave_vseq)

  ahb_virtual_sequencer vseqr;

  function new(string name = "ahb_concurrent_same_slave_vseq");
    super.new(name);
  endfunction

  task body();
    single_beat_nonseq_seq m0_seq;
    single_beat_nonseq_seq m1_seq;

    // Get virtual sequencer
    if (!$cast(vseqr, p_sequencer)) begin
      `uvm_fatal("VSEQ", "Failed to cast p_sequencer to ahb_virtual_sequencer")
    end

    `uvm_info("VSEQ",
      "Starting concurrent access: Master0 & Master1 → same slave",
      UVM_LOW)

    // Create sequences
    m0_seq = single_beat_nonseq_seq::type_id::create("m0_seq");
    m1_seq = single_beat_nonseq_seq::type_id::create("m1_seq");

    // -------------------------------------------------
    // Start both master sequences concurrently
    // -------------------------------------------------
    fork
      begin
        m0_seq.start(vseqr.m0_seqr);
      end
      begin
        m1_seq.start(vseqr.m1_seqr);
      end
    join

    `uvm_info("VSEQ",
      "Concurrent access virtual sequence completed",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Concurrent Different Slave Access Virtual Sequence
// Master 0 -> Slave A
// Master 1 -> Slave B
// ---------------------------------------------------------
class ahb_concurrent_diff_slave_vseq extends uvm_sequence;
  `uvm_object_utils(ahb_concurrent_diff_slave_vseq)

  ahb_virtual_sequencer vseqr;

  function new(string name = "ahb_concurrent_diff_slave_vseq");
    super.new(name);
  endfunction

  task body();
    single_beat_nonseq_seq m0_seq;
    single_beat_nonseq_seq m1_seq;

    // Example addresses for DIFFERENT slaves
    // (Update later based on final address map)
    logic [31:0] slaveA_addr = 32'h4001_0000; // Slave A
    logic [31:0] slaveB_addr = 32'h4002_0000; // Slave B

    // Get virtual sequencer
    if (!$cast(vseqr, p_sequencer)) begin
      `uvm_fatal("VSEQ", "Failed to cast p_sequencer to ahb_virtual_sequencer")
    end

    `uvm_info("VSEQ",
      "Starting concurrent access: Master0->SlaveA, Master1->SlaveB",
      UVM_LOW)

    // Create sequences
    m0_seq = single_beat_nonseq_seq::type_id::create("m0_seq");
    m1_seq = single_beat_nonseq_seq::type_id::create("m1_seq");

    // Set different target addresses
    m0_seq.addr = slaveA_addr;
    m1_seq.addr = slaveB_addr;

    // -------------------------------------------------
    // Start both master sequences concurrently
    // -------------------------------------------------
    fork
      begin
        m0_seq.start(vseqr.m0_seqr);
      end
      begin
        m1_seq.start(vseqr.m1_seqr);
      end
    join

    `uvm_info("VSEQ",
      "Concurrent different-slave access completed",
      UVM_LOW)

  endtask
endclass