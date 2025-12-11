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
        addr   == 32'h0000000C;     // Set your Address
        data   == 32'hAABBCCDD;// Set your Data
        
        // --- Protocol Rules ---
        write  == 1;           // Write
       // size   == 3'b010;      // Word
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
// 5. 4-Beat Incrementing Burst Sequence (INCR4)
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
//WRAP4
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

`endif