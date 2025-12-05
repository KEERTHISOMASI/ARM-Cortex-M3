`ifndef AHB_SEQUENCES_SV
`define AHB_SEQUENCES_SV


// ---------------------------------------------------------
// Base Sequence
// ---------------------------------------------------------
class ahb_base_seq extends uvm_sequence #(ahb_seq_item);
  `uvm_object_utils(ahb_base_seq)

  function new(string name = "ahb_base_seq");
    super.new(name);
  endfunction
endclass

// ---------------------------------------------------------
// Single Write Sequence
// ---------------------------------------------------------
class ahb_single_write_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_single_write_seq)

  rand logic [31:0] addr;
  rand logic [31:0] data;
  rand logic [2:0]  size = 3'b010;  // Default to 32-bit to match item constraints
  rand logic [2:0]  burst = 3'b000; // Default to Single

  constraint c_addr_align { addr[1:0] == 2'b00; }
  constraint c_defaults   { size == 3'b010; burst == 3'b000; }

  function new(string name = "ahb_single_write_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    
    `uvm_info("SEQ", $sformatf("Starting Write to Addr: 0x%0h Data: 0x%0h", addr, data), UVM_LOW)

    req = ahb_seq_item::type_id::create("req");
    
    start_item(req);
    if (!req.randomize() with {
      addr  == local::addr;
      data  == local::data;
      write == 1;           // Force Write
      trans == 2'b10;       // NONSEQ
      size  == local::size;
      burst == local::burst;
    }) begin
      `uvm_error("SEQ", "Randomization failed in ahb_single_write_seq")
    end
    finish_item(req);
  endtask
endclass

// ---------------------------------------------------------
// Single Read Sequence
// ---------------------------------------------------------
class ahb_single_read_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_single_read_seq)

  rand logic [31:0] addr;
  rand logic [2:0]  size = 3'b010;  // Default to 32-bit
  rand logic [2:0]  burst = 3'b000; // Default to Single

  constraint c_addr_align { addr[1:0] == 2'b00; }
  constraint c_defaults   { size == 3'b010; burst == 3'b000; }

  function new(string name = "ahb_single_read_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    `uvm_info("SEQ", $sformatf("Starting Read from Addr: 0x%0h", addr), UVM_LOW)

    req = ahb_seq_item::type_id::create("req");
    
    start_item(req);
    if (!req.randomize() with {
      addr  == local::addr;
      write == 0;           // Force Read
      trans == 2'b10;       // NONSEQ
      size  == local::size;
      burst == local::burst;
    }) begin
      `uvm_error("SEQ", "Randomization failed in ahb_single_read_seq")
    end
    finish_item(req);
  endtask
endclass

// ---------------------------------------------------------
// Combined Sequence (Write followed by Read)
// ---------------------------------------------------------
class ahb_write_read_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_write_read_seq)

  function new(string name = "ahb_write_read_seq");
    super.new(name);
  endfunction

  task body();
    ahb_single_write_seq write_seq;
    ahb_single_read_seq  read_seq;
    
    logic [31:0] target_addr;
    logic [31:0] target_data;

    // 1. Generate local values using $urandom for unsigned safety
    target_addr = $urandom & 32'hFFFFFFFC; 
    target_data = $urandom;

    `uvm_info("SEQ", "------------------------------------------", UVM_LOW)
    `uvm_info("SEQ", $sformatf("Executing Write-Read Sequence. Addr=0x%h", target_addr), UVM_LOW)

    // 2. Execute Write Sequence
    write_seq = ahb_single_write_seq::type_id::create("write_seq");
    if(!write_seq.randomize() with {
      addr == target_addr;
      data == target_data;
    }) begin
      `uvm_fatal("SEQ", "Randomization failed for write_seq") // Fatal to stop execution
    end
    
    write_seq.start(m_sequencer);

    // 3. Execute Read Sequence (same address)
    read_seq = ahb_single_read_seq::type_id::create("read_seq");
    if(!read_seq.randomize() with {
      addr == target_addr;
    }) begin
      `uvm_fatal("SEQ", "Randomization failed for read_seq")
    end

    read_seq.start(m_sequencer);

    `uvm_info("SEQ", "------------------------------------------", UVM_LOW)
  endtask
endclass


`endif