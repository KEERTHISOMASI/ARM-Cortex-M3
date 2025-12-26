`ifndef AHB_SEQUENCES_SV
`define AHB_SEQUENCES_SV

// ---------------------------------------------------------
// 1. Base Sequence
// ---------------------------------------------------------
class ahb_base_seq extends uvm_sequence #(ahb_seq_item);
  `uvm_object_utils(ahb_base_seq)

  function new(string name = "ahb_base_seq");
    super.new(name);
  endfunction
endclass

// ---------------------------------------------------------
// 2. Single Write Sequence
// ---------------------------------------------------------
class ahb_single_write_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_single_write_seq)

  function new(string name = "ahb_single_write_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    req = ahb_seq_item::type_id::create("req");

    start_item(req);
    
    // Edit values here to control the transaction
    if (!req.randomize() with {
        // --- User Controls ---
        addr   == 32'hA0000000;     // Set your Address
        data   == 32'hAABBCCDD;// Set your Data
        
        // --- Protocol Rules ---
        write  == 1;           // Write
        size   == 3'b010;      // Word
        burst  == 3'b000;      // SINGLE
        trans == 2'b10;       // NONSEQ
    }) `uvm_error("SEQ", "Randomization failed");

    finish_item(req);
    `uvm_info("SEQ", $sformatf("Single Write: Addr=0x%h Data=0x%h", req.addr, req.data), UVM_MEDIUM)
  endtask
endclass

// ---------------------------------------------------------
// 3. Single Read Sequence
// ---------------------------------------------------------
class ahb_single_read_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_single_read_seq)

  function new(string name = "ahb_single_read_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    req = ahb_seq_item::type_id::create("req");

    start_item(req);
    
    // Edit values here to control the transaction
    if (!req.randomize() with {
        // --- User Controls ---
        addr   == 32'h100;     // Set your Address
        
        // --- Protocol Rules ---
        write  == 0;           // Read
        //size   == 3'b010;      // Word
        burst  == 3'b000;      // SINGLE
        trans == 2'b10;       // NONSEQ
    }) `uvm_error("SEQ", "Randomization failed");

    finish_item(req);
    `uvm_info("SEQ", $sformatf("Single Read: Addr=0x%h", req.addr), UVM_MEDIUM)
  endtask
endclass

// ---------------------------------------------------------
// 4. Write Followed by Read (Sanity Check)
// ---------------------------------------------------------
class ahb_write_read_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_write_read_seq)

  function new(string name = "ahb_write_read_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    // Task-local variable to sync address between Write and Read
    logic [31:0] target_addr = 32'h2000; 
    logic [31:0] target_data = 32'h12345678;

    `uvm_info("SEQ", "--- Starting Write-Read Sequence ---", UVM_LOW)

    // 1. Write
    req = ahb_seq_item::type_id::create("req_wr");
    start_item(req);
    if (!req.randomize() with {
        addr   == target_addr;
        data   == target_data;
        write  == 1;
        burst  == 3'b000; // SINGLE
        trans == 2'b10;  // NONSEQ
        //size   == 3'b010;
    }) `uvm_error("SEQ", "Randomization failed");
    finish_item(req);

    // 2. Read
    req = ahb_seq_item::type_id::create("req_rd");
    start_item(req);
    if (!req.randomize() with {
        addr   == target_addr; // Same address
        write  == 0;
        burst  == 3'b000; // SINGLE
        trans == 2'b10;  // NONSEQ
       // size   == 3'b010;
    }) `uvm_error("SEQ", "Randomization failed");
    finish_item(req);
    
    `uvm_info("SEQ", "--- Finished Write-Read Sequence ---", UVM_LOW)
  endtask
endclass

// ---------------------------------------------------------
// Single Beat NONSEQ Sequence
// ---------------------------------------------------------
class single_beat_nonseq_seq extends ahb_base_seq;
  `uvm_object_utils(single_beat_nonseq_seq)

  function new(string name = "single_beat_nonseq_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    // Example address (update later if needed)
    logic [31:0] addr = 32'h4001_0000;

    req = ahb_seq_item::type_id::create("req");
    start_item(req);

    if (!req.randomize() with {
        addr  == addr;
        write == 1'b1;       // Write (can be randomized if needed)
        size  == 3'b010;     // Word
        burst == 3'b000;     // SINGLE
        trans == 2'b10;      // NONSEQ
    }) `uvm_error("SEQ", "Randomization failed");

    finish_item(req);
  endtask
endclass
//Burst Sequences
// ---------------------------------------------------------
// Undefined Length INCR Burst Sequence
// ---------------------------------------------------------
class ahb_undefined_incr_burst_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_undefined_incr_burst_seq)

  function new(string name = "ahb_undefined_incr_burst_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    // Randomize number of beats (undefined length)
    int unsigned num_beats;
    int unsigned insert_busy;

    // Start address
    logic [31:0] current_addr = 32'hA000_4000;

    // Randomize burst length and BUSY insertion
    assert(std::randomize(num_beats, insert_busy) with {
      num_beats inside {[3:10]};     // Undefined length (N beats)
      insert_busy inside {[0:1]};    // Optional BUSY allowed
    });

    `uvm_info("SEQ",
      $sformatf("Starting UNDEFINED INCR burst: Beats=%0d", num_beats),
      UVM_LOW)

    // -------------------------------------------------
    // Issue INCR burst beats
    // -------------------------------------------------
    for (int i = 0; i < num_beats; i++) begin
      req = ahb_seq_item::type_id::create($sformatf("req_beat_%0d", i));
      start_item(req);

      if (!req.randomize() with {
          addr   == current_addr;
          write  == 1;
          size   == 3'b010;     // Word
          burst  == 3'b001;     // INCR (undefined length)
          trans  == ((i == 0) ? 2'b10 : 2'b11); // NONSEQ then SEQ
      }) `uvm_error("SEQ", "Randomization failed for INCR beat");

      finish_item(req);

      `uvm_info("SEQ",
        $sformatf("INCR Beat[%0d]: Addr=0x%h HTRANS=%0d",
                  i, current_addr, req.trans),
        UVM_MEDIUM)

      // Increment address for next beat
      current_addr += 4;

      // -------------------------------------------------
      // Optional BUSY cycle insertion
      // -------------------------------------------------
      if (insert_busy && (i < num_beats-1)) begin
        req = ahb_seq_item::type_id::create("req_busy");
        start_item(req);

        if (!req.randomize() with {
            trans == 2'b01;     // BUSY
            burst == 3'b001;    // Still INCR
            addr  == current_addr; // Hold address
        }) `uvm_error("SEQ", "Randomization failed for BUSY");

        finish_item(req);

        `uvm_info("SEQ", "Inserted BUSY cycle inside INCR burst", UVM_MEDIUM)
      end
    end

    // -------------------------------------------------
    // Terminate burst with IDLE
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("req_idle_end");
    start_item(req);

    if (!req.randomize() with {
        trans == 2'b00;     // IDLE
        burst == 3'b001;    // Don't care, keep INCR
        addr  == current_addr;
    }) `uvm_error("SEQ", "Randomization failed for burst termination");

    finish_item(req);

    `uvm_info("SEQ", "Undefined INCR burst terminated with IDLE", UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// 5. Incrementing Burst Sequence (INCR4/8/16)
// ---------------------------------------------------------
class ahb_incr4_burst_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_incr4_burst_seq)

  function new(string name = "ahb_incr4_burst_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    // Task-local variable to track address increment
    logic [31:0] current_addr = 32'h0000_3000; // Start Address

    `uvm_info("SEQ", $sformatf("Starting INCR4 Burst @ 0x%h", current_addr), UVM_LOW)

    for(int i=0; i<4; i++) begin
      req = ahb_seq_item::type_id::create("req");
      start_item(req);

      if (!req.randomize() with {
          addr   == current_addr;
          write  == 1;           // Write
          burst  == 3'b011;      // INCR4 (Fixed 4-beat)
        trans == ((i == 0) ? 2'b10 : 2'b11);
        
      }) `uvm_error("SEQ", "Randomization failed");
     // req.trans = (i == 0) ? 2'b10 : 2'b11; 

      finish_item(req);
      

      // Increment Address for next beat
      current_addr += 4;
      `uvm_info("HTRANS", $sformatf("seq ----------------TRANS=%0d i=%0d currentaddr=%0h------------------", req.trans,i,current_addr), UVM_MEDIUM) 
    end
  endtask
endclass
//WRAP4/8/16
class ahb_wrap4_burst_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_wrap4_burst_seq)

  function new(string name = "ahb_wrap4_burst_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    
    // START ADDRESS: 0x38
    // Since this is WRAP4 (16-byte boundary), the block is 0x30 to 0x3F.
    // Expected Pattern: 0x38 -> 0x3C -> 0x30 (Wrap) -> 0x34
    logic [31:0] current_addr = 32'hA000_0038; 

    `uvm_info("SEQ", $sformatf("Starting WRAP4 Burst @ 0x%h", current_addr), UVM_LOW)

    for(int i=0; i<4; i++) begin
      req = ahb_seq_item::type_id::create("req");
      start_item(req);

      if (!req.randomize() with {
          addr   == current_addr;
          //data   == 32'hA0A0A0A0 + i; // Unique data
          write  == 1;                // Write
          burst  == 3'b010;           // WRAP4 (Value 2)
          size   == 3'b010;           // Word (4 bytes)
          
          // Protocol: First beat is NONSEQ(2), others SEQ(3)
          // Note: Even when wrapping (e.g. 3C->30), it is still a SEQ transfer!
          // Only the very first beat of the burst is NONSEQ.
      }) `uvm_error("SEQ", "Randomization failed");

      // Explicitly force HTRANS (just to be safe with your driver)
      req.trans = (i == 0) ? 2'b10 : 2'b11;

      finish_item(req);

      `uvm_info("SEQ", $sformatf("Sent WRAP4 Beat[%0d]: Addr=0x%h Trans=%0d", i, req.addr, req.trans), UVM_MEDIUM)

      // ----------------------------------------------------------
      // WRAP4 ADDRESS CALCULATION
      // ----------------------------------------------------------
      // Boundary for WRAP4 x 4-byte = 16 bytes.
      // Logic: If we are at the top of the 16-byte boundary, wrap down.
      // 0x30, 0x34, 0x38, 0x3C
      //                     ^-- If we are here (End of block), subtract 12.
      // ----------------------------------------------------------
      
      // Check bits [3:2] to see position in the 16-byte block
      // 00=0, 01=4, 10=8, 11=C (12)
      if (current_addr[3:2] == 2'b11) begin
          current_addr -= 12; // Wrap around (e.g., 0x3C -> 0x30)
      end else begin
          current_addr += 4;  // Increment normally
      end

    end
  endtask
endclass
// ---------------------------------------------------------
// IDLE Transfer Between Two NONSEQ Transfers
// ---------------------------------------------------------
class ahb_idle_between_nonseq_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_idle_between_nonseq_seq)

  function new(string name = "ahb_idle_between_nonseq_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    logic [31:0] addr1 = 32'hA000_0100;
    logic [31:0] addr2 = 32'hA000_0200;
    logic [31:0] data1 = 32'hAABB_CCDD;
    logic [31:0] data2 = 32'h1122_3344;

    `uvm_info("SEQ", "Starting IDLE between NONSEQ test", UVM_LOW)

    // -------------------------------------------------
    // 1. First NONSEQ SINGLE write
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("req_wr1");
    start_item(req);
    if (!req.randomize() with {
        addr   == addr1;
        data   == data1;
        write  == 1;
        burst  == 3'b000;   // SINGLE
        trans  == 2'b10;    // NONSEQ
        size   == 3'b010;   // Word
    }) `uvm_error("SEQ", "Randomization failed for first NONSEQ");
    finish_item(req);

    `uvm_info("SEQ",
      $sformatf("Issued NONSEQ write: Addr=0x%h Data=0x%h", addr1, data1),
      UVM_MEDIUM)

    // -------------------------------------------------
    // 2. IDLE transfer (explicit)
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("req_idle");
    start_item(req);
    if (!req.randomize() with {
        trans  == 2'b00;    // IDLE
        burst  == 3'b000;   // Don't care, keep SINGLE
        write  == 0;        // Don't care
        addr   == addr1;    // Hold previous (or any safe value)
        data   == data1;
    }) `uvm_error("SEQ", "Randomization failed for IDLE");
    finish_item(req);

    `uvm_info("SEQ", "Inserted IDLE transfer", UVM_MEDIUM)

    // -------------------------------------------------
    // 3. Second NONSEQ SINGLE write
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("req_wr2");
    start_item(req);
    if (!req.randomize() with {
        addr   == addr2;
        data   == data2;
        write  == 1;
        burst  == 3'b000;   // SINGLE
        trans  == 2'b10;    // NONSEQ
        size   == 3'b010;   // Word
    }) `uvm_error("SEQ", "Randomization failed for second NONSEQ");
    finish_item(req);

    `uvm_info("SEQ",
      $sformatf("Issued second NONSEQ write: Addr=0x%h Data=0x%h", addr2, data2),
      UVM_MEDIUM)

    `uvm_info("SEQ", "Completed IDLE between NONSEQ test", UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// BUSY Cycles Inserted Inside Burst Sequence
// ---------------------------------------------------------
class ahb_busy_cycles_in_burst_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_busy_cycles_in_burst_seq)

  function new(string name = "ahb_busy_cycles_in_burst_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    // Burst configuration
    int unsigned num_beats;
    int unsigned busy_cycles;

    // Start address
    logic [31:0] current_addr = 32'hA000_5000;

    // Randomize burst length and BUSY insertion
    assert(std::randomize(num_beats, busy_cycles) with {
      num_beats  inside {[4:8]};   // Total valid beats
      busy_cycles inside {[1:3]};  // BUSY cycles to insert
    });

    `uvm_info("SEQ",
      $sformatf("Starting burst with BUSY insertion: beats=%0d busy_cycles=%0d",
                num_beats, busy_cycles),
      UVM_LOW)

    // -------------------------------------------------
    // Issue burst beats with BUSY cycles inside
    // -------------------------------------------------
    for (int i = 0; i < num_beats; i++) begin

      // -------------------------------
      // Valid beat (NONSEQ / SEQ)
      // -------------------------------
      req = ahb_seq_item::type_id::create($sformatf("req_beat_%0d", i));
      start_item(req);

      if (!req.randomize() with {
          addr   == current_addr;
          write  == 1;
          size   == 3'b010;        // Word
          burst  == 3'b001;        // INCR (can be WRAP as well)
          trans  == ((i == 0) ? 2'b10 : 2'b11); // NONSEQ then SEQ
      }) `uvm_error("SEQ", "Randomization failed for burst beat");

      finish_item(req);

      `uvm_info("SEQ",
        $sformatf("Burst Beat[%0d]: Addr=0x%h HTRANS=%0d",
                  i, current_addr, req.trans),
        UVM_MEDIUM)

      // Increment address ONLY on valid beat
      current_addr += 4;

      // -------------------------------
      // Insert BUSY cycles (randomly)
      // -------------------------------
      if ((busy_cycles > 0) && (i < num_beats-1)) begin
        req = ahb_seq_item::type_id::create("req_busy");
        start_item(req);

        if (!req.randomize() with {
            trans == 2'b01;        // BUSY
            burst == 3'b001;       // Same burst
            addr  == current_addr; // Hold address stable
        }) `uvm_error("SEQ", "Randomization failed for BUSY");

        finish_item(req);

        busy_cycles--;

        `uvm_info("SEQ",
          "Inserted BUSY cycle inside burst (no address advance)",
          UVM_MEDIUM)
      end
    end

    // -------------------------------------------------
    // Terminate burst with IDLE
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("req_idle_end");
    start_item(req);

    if (!req.randomize() with {
        trans == 2'b00;    // IDLE
        burst == 3'b001;
        addr  == current_addr;
    }) `uvm_error("SEQ", "Randomization failed for burst termination");

    finish_item(req);

    `uvm_info("SEQ", "Burst terminated cleanly after BUSY cycles", UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Back-to-Back Transfers (100% Bus Utilization)
// ---------------------------------------------------------
class ahb_back_to_back_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_back_to_back_seq)

  function new(string name = "ahb_back_to_back_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    // Number of back-to-back transfers
    int unsigned num_transfers;

    // Start address
    logic [31:0] current_addr = 32'hA000_6000;

    // Randomize number of transfers
    assert(std::randomize(num_transfers) with {
      num_transfers inside {[10:30]};
    });

    `uvm_info("SEQ",
      $sformatf("Starting back-to-back transfers: count=%0d",
                num_transfers),
      UVM_LOW)

    // -------------------------------------------------
    // Continuous stream of SINGLE transfers
    // -------------------------------------------------
    for (int i = 0; i < num_transfers; i++) begin
      req = ahb_seq_item::type_id::create($sformatf("req_%0d", i));
      start_item(req);

      if (!req.randomize() with {
          addr   == current_addr;
          write  == 1;
          size   == 3'b010;     // Word
          burst  == 3'b000;     // SINGLE
          trans  == 2'b10;      // NONSEQ every cycle
      }) `uvm_error("SEQ", "Randomization failed for back-to-back transfer");

      finish_item(req);

      `uvm_info("SEQ",
        $sformatf("Back-to-back transfer[%0d]: Addr=0x%h",
                  i, current_addr),
        UVM_MEDIUM)

      // Increment address for next cycle
      current_addr += 4;
    end

    `uvm_info("SEQ",
      "Completed back-to-back transfer stream (no IDLE cycles)",
      UVM_LOW)

  endtask
endclass

// ---------------------------------------------------------
// Slave Wait State Insertion Sequence
// ---------------------------------------------------------
class ahb_slave_wait_state_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_slave_wait_state_seq)

  function new(string name = "ahb_slave_wait_state_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    // Number of transactions
    int unsigned num_txns;

    // Start address
    logic [31:0] current_addr = 32'hA000_7000;

    // Randomize number of transfers
    assert(std::randomize(num_txns) with {
      num_txns inside {[5:15]};
    });

    `uvm_info("SEQ",
      $sformatf("Starting slave wait-state test: transactions=%0d",
                num_txns),
      UVM_LOW)

    // -------------------------------------------------
    // Issue transfers (slave will insert wait states)
    // -------------------------------------------------
    for (int i = 0; i < num_txns; i++) begin
      req = ahb_seq_item::type_id::create($sformatf("req_%0d", i));
      start_item(req);

      if (!req.randomize() with {
          addr   == current_addr;
          write  == (i % 2);        // Mix read/write
          size   == 3'b010;         // Word
          burst  == 3'b000;         // SINGLE
          trans  == 2'b10;          // NONSEQ
      }) `uvm_error("SEQ", "Randomization failed for wait-state transfer");

      finish_item(req);

      `uvm_info("SEQ",
        $sformatf("Issued transfer[%0d] to Addr=0x%h (wait states expected)",
                  i, current_addr),
        UVM_MEDIUM)

      // Increment address for next transfer
      current_addr += 4;
    end

    `uvm_info("SEQ",
      "Completed slave wait-state insertion sequence",
      UVM_LOW)

  endtask
endclass

// ---------------------------------------------------------
// Illegal 1KB Boundary Crossing Burst Sequence
// ---------------------------------------------------------
class ahb_illegal_1kb_boundary_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_illegal_1kb_boundary_seq)

  function new(string name = "ahb_illegal_1kb_boundary_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    logic [31:0] addr;

    // -------------------------------------------------
    // Start just before a 1KB boundary (example address)
    // -------------------------------------------------
    addr = 32'h4000_03FC; // crosses 0x4000_0400

    `uvm_info("SEQ",
      $sformatf("Starting illegal 1KB boundary burst at addr=0x%08h", addr),
      UVM_LOW)

    // -------------------------------------------------
    // Generate INCR burst that crosses 1KB boundary
    // -------------------------------------------------
    for (int i = 0; i < 4; i++) begin
      req = ahb_seq_item::type_id::create($sformatf("req_%0d", i));
      start_item(req);

      if (!req.randomize() with {
          addr   == addr;
          write  == 1'b1;          // Write burst
          burst  == 3'b001;        // INCR
          size   == 3'b010;        // Word (4 bytes)
          trans  == (i == 0) ? 2'b10 : 2'b11; // NONSEQ then SEQ
      }) `uvm_error("SEQ", "Randomization failed");

      finish_item(req);

      `uvm_info("SEQ",
        $sformatf("Beat %0d: Addr=0x%08h HTRANS=%0d",
                  i, addr, req.trans),
        UVM_MEDIUM)

      // Increment address (will cross 1KB boundary)
      addr += 4;
    end

    `uvm_info("SEQ",
      "Illegal 1KB boundary burst issued (expect ERROR from slave)",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Zero-Delay Read-After-Write (RAW) Sequence
// ---------------------------------------------------------
class ahb_zero_delay_raw_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_zero_delay_raw_seq)

  function new(string name = "ahb_zero_delay_raw_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    logic [31:0] addr = 32'h4001_0000;  // Example valid address
    logic [31:0] data = 32'hDEAD_BEEF;  // Expected data

    `uvm_info("SEQ",
      "Starting zero-delay Write followed by Read to same address",
      UVM_LOW)

    // -------------------------------------------------
    // 1. WRITE transaction (NONSEQ)
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("wr_req");
    start_item(req);

    if (!req.randomize() with {
        addr  == addr;
        data  == data;
        write == 1'b1;        // Write
        size  == 3'b010;      // Word
        burst == 3'b000;      // SINGLE
        trans == 2'b10;       // NONSEQ
    }) `uvm_error("SEQ", "Write randomization failed");

    finish_item(req);

    `uvm_info("SEQ",
      $sformatf("WRITE issued: Addr=0x%08h Data=0x%08h", addr, data),
      UVM_MEDIUM)

    // -------------------------------------------------
    // 2. READ transaction (immediately next transfer)
    //    No IDLE, no delay
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("rd_req");
    start_item(req);

    if (!req.randomize() with {
        addr  == addr;        // Same address
        write == 1'b0;        // Read
        size  == 3'b010;      // Word
        burst == 3'b000;      // SINGLE
        trans == 2'b10;       // NONSEQ
    }) `uvm_error("SEQ", "Read randomization failed");

    finish_item(req);

    `uvm_info("SEQ",
      $sformatf("READ issued immediately after WRITE to Addr=0x%08h", addr),
      UVM_MEDIUM)

    `uvm_info("SEQ",
      "Zero-delay RAW sequence completed (scoreboard checks data)",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Address Aliasing Boundary Test Sequence
// ---------------------------------------------------------
class ahb_address_aliasing_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_address_aliasing_seq)

  function new(string name = "ahb_address_aliasing_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    // Example boundary addresses (to be updated later)
    logic [31:0] slaveA_last_addr = 32'h4001_FFFC;
    logic [31:0] slaveB_first_addr = 32'h4002_0000;

    `uvm_info("SEQ",
      "Starting address aliasing boundary test",
      UVM_LOW)

    // -------------------------------------------------
    // 1. Access last valid address of Slave A
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("req_slaveA");
    start_item(req);

    if (!req.randomize() with {
        addr  == slaveA_last_addr;
        write == 1'b1;         // Write
        size  == 3'b010;       // Word
        burst == 3'b000;       // SINGLE
        trans == 2'b10;        // NONSEQ
    }) `uvm_error("SEQ", "Randomization failed for Slave A access");

    finish_item(req);

    `uvm_info("SEQ",
      $sformatf("Accessed Slave A last address: 0x%08h", slaveA_last_addr),
      UVM_MEDIUM)

    // -------------------------------------------------
    // 2. Access first valid address of Slave B
    //    (immediately, no idle cycle)
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("req_slaveB");
    start_item(req);

    if (!req.randomize() with {
        addr  == slaveB_first_addr;
        write == 1'b0;         // Read
        size  == 3'b010;       // Word
        burst == 3'b000;       // SINGLE
        trans == 2'b10;        // NONSEQ
    }) `uvm_error("SEQ", "Randomization failed for Slave B access");

    finish_item(req);

    `uvm_info("SEQ",
      $sformatf("Accessed Slave B first address: 0x%08h", slaveB_first_addr),
      UVM_MEDIUM)

    `uvm_info("SEQ",
      "Address aliasing boundary test completed",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Address Map Coverage Sequence
// ---------------------------------------------------------
class ahb_address_map_coverage_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_address_map_coverage_seq)

  function new(string name = "ahb_address_map_coverage_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    int region;
    int num_txns = 200;   // long enough to hit all regions

    logic [31:0] addr;

    `uvm_info("SEQ",
      "Starting address map coverage sequence",
      UVM_LOW)

    for (int i = 0; i < num_txns; i++) begin
      req = ahb_seq_item::type_id::create($sformatf("req_%0d", i));

      // -------------------------------------------------
      // Randomly select address region
      // -------------------------------------------------
      assert(std::randomize(region) with {
        region inside {[0:6]};
      });

      // -------------------------------------------------
      // Address constraints per region
      // (PLACEHOLDERS — update later)
      // -------------------------------------------------
      case (region)
        0: addr = 32'h0000_1000; // FLASH
        1: addr = 32'h2000_0000; // SRAM0
        2: addr = 32'h2000_8000; // SRAM1
        3: addr = 32'h2001_0000; // SRAM2
        4: addr = 32'h2001_8000; // SRAM3
        5: addr = 32'h4003_0000; // EXP0
        6: addr = 32'h4004_0000; // EXP1 (example)
        default: addr = 32'h0000_0000;
      endcase

      start_item(req);

      if (!req.randomize() with {
          addr  == addr;
          write inside {0,1};          // Read or Write
          size  inside {3'b000, 3'b001, 3'b010}; // Byte/Half/Word
          burst inside {3'b000, 3'b001}; // SINGLE / INCR
          trans == 2'b10;              // NONSEQ
      }) `uvm_error("SEQ", "Randomization failed");

      finish_item(req);

      `uvm_info("SEQ",
        $sformatf("Txn %0d: Region=%0d Addr=0x%08h Write=%0d Burst=%0d",
                  i, region, addr, req.write, req.burst),
        UVM_LOW)
    end

    `uvm_info("SEQ",
      "Completed address map coverage sequence",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Invalid Access Sequence (ERROR handling compliant)
// ---------------------------------------------------------
class ahb_invalid_access_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_invalid_access_seq)

  function new(string name = "ahb_invalid_access_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    logic [31:0] invalid_addr = 32'h3000_0000; // unmapped hole

    `uvm_info("SEQ",
      "Issuing INVALID access; expecting 2-cycle ERROR and HTRANS->IDLE",
      UVM_LOW)

    // -------------------------------------------------
    // Issue exactly ONE invalid transfer
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("invalid_req");
    start_item(req);

    if (!req.randomize() with {
        addr  == invalid_addr;
        write == 1'b1;
        size  == 3'b010;
        burst == 3'b000;  // SINGLE
        trans == 2'b10;   // NONSEQ
    }) `uvm_error("SEQ", "Randomization failed");

    finish_item(req);

    // -------------------------------------------------
    // IMPORTANT:
    // Do NOT send another item immediately.
    // Driver must observe ERROR and drive IDLE.
    // -------------------------------------------------
    `uvm_info("SEQ",
      "Invalid transfer issued. Waiting for ERROR handling.",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Locked Transfer Sequence
// ---------------------------------------------------------
class ahb_locked_transfer_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_locked_transfer_seq)

  function new(string name = "ahb_locked_transfer_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    // Example address (can be updated later)
    logic [31:0] addr = 32'h4001_0000;

    `uvm_info("SEQ",
      "Starting LOCKED transfer sequence (HMASTLOCK asserted)",
      UVM_LOW)

    // -------------------------------------------------
    // 1. Locked NONSEQ transfer (start of lock)
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("lock_start");
    start_item(req);

    if (!req.randomize() with {
        addr      == addr;
        write     == 1'b1;
        size      == 3'b010;   // Word
        burst     == 3'b000;   // SINGLE (can be INCR also)
        trans     == 2'b10;    // NONSEQ
        mastlock  == 1'b1;     // LOCK asserted
    }) `uvm_error("SEQ", "Locked transfer randomization failed");

    finish_item(req);

    `uvm_info("SEQ",
      "Locked NONSEQ transfer issued",
      UVM_MEDIUM)

    // -------------------------------------------------
    // 2. Optional locked SEQ transfers (locked burst)
    // -------------------------------------------------
    for (int i = 0; i < 2; i++) begin
      req = ahb_seq_item::type_id::create($sformatf("lock_seq_%0d", i));
      start_item(req);

      if (!req.randomize() with {
          addr      == addr + (i+1)*4;
          write     == 1'b1;
          size      == 3'b010;
          burst     == 3'b001;   // INCR
          trans     == 2'b11;    // SEQ
          mastlock  == 1'b1;     // LOCK maintained
      }) `uvm_error("SEQ", "Locked SEQ randomization failed");

      finish_item(req);
    end

    `uvm_info("SEQ",
      "Locked sequence completed, releasing lock",
      UVM_LOW)

    // -------------------------------------------------
    // 3. Lock release + IDLE
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("lock_release");
    start_item(req);

    if (!req.randomize() with {
        trans     == 2'b00;    // IDLE
        mastlock  == 1'b0;     // LOCK released
    }) `uvm_error("SEQ", "Lock release randomization failed");

    finish_item(req);

    `uvm_info("SEQ",
      "HMASTLOCK deasserted, bus returned to IDLE",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// ERROR Response Test Sequence (2-cycle ERROR handling)
// ---------------------------------------------------------
class ahb_error_response_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_error_response_seq)

  function new(string name = "ahb_error_response_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    // Example invalid address (outside valid decode range)
    logic [31:0] invalid_addr = 32'h3000_0000;

    `uvm_info("SEQ",
      "Issuing access to invalid address (expect 2-cycle ERROR response)",
      UVM_LOW)

    // -------------------------------------------------
    // Single invalid transfer
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("error_req");
    start_item(req);

    if (!req.randomize() with {
        addr  == invalid_addr;
        write == 1'b1;        // Write (read also fine)
        size  == 3'b010;      // Word
        burst == 3'b000;      // SINGLE
        trans == 2'b10;       // NONSEQ
    }) `uvm_error("SEQ", "Randomization failed");

    finish_item(req);

    // IMPORTANT:
    // Do NOT issue another item here.
    // Master driver must detect ERROR and drive HTRANS=IDLE.
    `uvm_info("SEQ",
      "Invalid access issued; waiting for ERROR handling",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// ERROR during burst – burst termination sequence
// ---------------------------------------------------------
class ahb_error_mid_burst_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_error_mid_burst_seq)

  function new(string name = "ahb_error_mid_burst_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    logic [31:0] addr;

    // Example start address (valid region)
    addr = 32'h4001_0000;

    `uvm_info("SEQ",
      "Starting INCR burst; ERROR will occur mid-burst",
      UVM_LOW)

    // -------------------------------------------------
    // Beat 0 : NONSEQ (valid)
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("burst_beat_0");
    start_item(req);
    if (!req.randomize() with {
        addr  == addr;
        write == 1'b1;
        size  == 3'b010;
        burst == 3'b001;   // INCR
        trans == 2'b10;    // NONSEQ
    }) `uvm_error("SEQ", "Randomization failed");
    finish_item(req);

    addr += 4;

    // -------------------------------------------------
    // Beat 1 : SEQ (valid)
    // -------------------------------------------------
    req = ahb_seq_item::type_id::create("burst_beat_1");
    start_item(req);
    if (!req.randomize() with {
        addr  == addr;
        write == 1'b1;
        size  == 3'b010;
        burst == 3'b001;   // INCR
        trans == 2'b11;    // SEQ
    }) `uvm_error("SEQ", "Randomization failed");
    finish_item(req);

    addr += 4;

    // -------------------------------------------------
    // Beat 2 : SEQ → address mapped to ERROR
    // -------------------------------------------------
    // This address must be configured in the slave to ERROR
    addr = 32'h3000_0000; // example ERROR address

    req = ahb_seq_item::type_id::create("burst_error_beat");
    start_item(req);
    if (!req.randomize() with {
        addr  == addr;
        write == 1'b1;
        size  == 3'b010;
        burst == 3'b001;   // INCR
        trans == 2'b11;    // SEQ
    }) `uvm_error("SEQ", "Randomization failed");
    finish_item(req);

    // -------------------------------------------------
    // IMPORTANT:
    // Do NOT issue further SEQ beats.
    // Master driver must:
    //  - Observe ERROR
    //  - Drive HTRANS = IDLE
    // -------------------------------------------------
    `uvm_info("SEQ",
      "ERROR injected mid-burst; remaining beats cancelled",
      UVM_LOW)

  endtask
endclass
// ---------------------------------------------------------
// Illegal Transfer Type Sequence
// Unsupported HSIZE / Alignment
// ---------------------------------------------------------
class ahb_illegal_hsize_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_illegal_hsize_seq)

  function new(string name = "ahb_illegal_hsize_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    // Example address (valid region; alignment may be illegal)
    logic [31:0] addr = 32'h4001_0001; // intentionally misaligned

    `uvm_info("SEQ",
      "Issuing NONSEQ transfer with illegal HSIZE / alignment",
      UVM_LOW)

    req = ahb_seq_item::type_id::create("illegal_hsize_req");
    start_item(req);

    if (!req.randomize() with {
        addr  == addr;

        write == 1'b1;
        trans == 2'b10;        // NONSEQ
        burst == 3'b000;       // SINGLE

        // -------------------------------------------------
        // Illegal transfer sizes:
        // - size too large for slave
        // - or size causing misalignment
        // -------------------------------------------------
        size inside {
          3'b011,   // 8-byte
          3'b100,   // 16-byte
          3'b101    // 32-byte
        };
    }) `uvm_error("SEQ", "Randomization failed");

    finish_item(req);

    // IMPORTANT:
    // Do NOT send another item.
    // Master driver must observe ERROR and go to IDLE.
    `uvm_info("SEQ",
      "Illegal transfer issued; expecting ERROR response",
      UVM_LOW)

  endtask
endclass


`endif