//=========================================================
// File: sram_sequences.sv
// Description: All SRAM-related AHB sequences
//=========================================================

`ifndef SRAM_SEQUENCES_SV
`define SRAM_SEQUENCES_SV

// ---------------------------------------------------------
// Imports
// ---------------------------------------------------------

`include "sram_params_pkg.sv"
import sram_params_pkg::*;  // <-- COMMON SRAM PARAMETERS

/*
// ---------------------------------------------------------
// AHB Base Sequence (COMMON for SRAM tests)
// ---------------------------------------------------------
class ahb_base_seq extends uvm_sequence #(ahb_seq_item);
  `uvm_object_utils(ahb_base_seq)

  function new(string name = "ahb_base_seq");
    super.new(name);
  endfunction
endclass
*/

// ---------------------------------------------------------
// Single Read Sequence
// ---------------------------------------------------------
class ahb_sram_single_read_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_sram_single_read_seq)

  logic [31:0] rd_addr;

  function new(string name = "ahb_sram_single_read_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    req = ahb_seq_item::type_id::create("rd_req");

    start_item(req);
    if (!req.randomize() with {
          addr == rd_addr;
          write == 0;
          burst == 3'b000;
          trans == 2'b10;
          size == 3'b010;
        })
      `uvm_error("AHB_RD", "Randomization failed");
    finish_item(req);
  endtask
endclass


// ---------------------------------------------------------
// Single Write Sequence
// ---------------------------------------------------------
class ahb_sram_single_write_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_sram_single_write_seq)

  logic [31:0] wr_addr;
  logic [31:0] wr_data;

  function new(string name = "ahb_sram_single_write_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;

    req = ahb_seq_item::type_id::create("wr_req");

    start_item(req);
    if (!req.randomize() with {
          addr == wr_addr;
          data == wr_data;
          write == 1;
          burst == 3'b000;
          trans == 2'b10;
          size == 3'b010;
        })
      `uvm_error("AHB_WR", "Randomization failed");
    finish_item(req);
  endtask
endclass


// ---------------------------------------------------------
// SRAM Address Boundary Test Sequence
// ---------------------------------------------------------
class ahb_sram_addr_boundary_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_sram_addr_boundary_seq)

  function new(string name = "ahb_sram_addr_boundary_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    logic [31:0] base_addr;
    logic [31:0] last_word_addr;

    `uvm_info("SRAM_BOUNDARY", "Starting SRAM Address Boundary Test", UVM_LOW)

    for (int bank = 0; bank < 4; bank++) begin
      base_addr      = SRAM_BASE[bank];
      last_word_addr = SRAM_BASE[bank] + SRAM_BANK_SIZE - ADDR_STRIDE;

      // WRITE base
      req            = ahb_seq_item::type_id::create($sformatf("wr_base_b%0d", bank));
      start_item(req);
      req.randomize() with {
        addr == base_addr;
        data == 32'hAAAA_AAAA;
        write == 1;
        burst == 3'b000;
        trans == 2'b10;
        size == 3'b010;
      };
      finish_item(req);

      // WRITE last word
      req = ahb_seq_item::type_id::create($sformatf("wr_last_b%0d", bank));
      start_item(req);
      req.randomize() with {
        addr == last_word_addr;
        data == 32'h5555_5555;
        write == 1;
        burst == 3'b000;
        trans == 2'b10;
        size == 3'b010;
      };
      finish_item(req);

      // READ base
      req = ahb_seq_item::type_id::create($sformatf("rd_base_b%0d", bank));
      start_item(req);
      req.randomize() with {
        addr == base_addr;
        write == 0;
        burst == 3'b000;
        trans == 2'b10;
        size == 3'b010;
      };
      finish_item(req);

      // READ last word
      req = ahb_seq_item::type_id::create($sformatf("rd_last_b%0d", bank));
      start_item(req);
      req.randomize() with {
        addr == last_word_addr;
        write == 0;
        burst == 3'b000;
        trans == 2'b10;
        size == 3'b010;
      };
      finish_item(req);
    end

    `uvm_info("SRAM_BOUNDARY", "Completed SRAM Address Boundary Test", UVM_LOW)
  endtask
endclass


// ---------------------------------------------------------
// SRAM Default Value Test Sequence
// ---------------------------------------------------------
class ahb_sram_default_val_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_sram_default_val_seq)

  function new(string name = "ahb_sram_default_val_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    logic [31:0] curr_addr;

    `uvm_info("SRAM_SEQ", "Starting SRAM Default Value Test", UVM_LOW)

    for (int bank = 0; bank < 4; bank++) begin
      curr_addr = SRAM_BASE[bank];

      while (curr_addr < SRAM_BASE[bank] + SRAM_BANK_SIZE) begin
        req = ahb_seq_item::type_id::create("rd_default");
        start_item(req);
        req.randomize() with {
          addr == curr_addr;
          write == 0;
          burst == 3'b000;
          trans == 2'b10;
          size == 3'b010;
        };
        finish_item(req);

        curr_addr += ADDR_STRIDE;
      end
    end

    `uvm_info("SRAM_SEQ", "Completed SRAM Default Value Test", UVM_LOW)
  endtask
endclass


// ---------------------------------------------------------
// SRAM Write Enable (WREN) Test Sequence
// ---------------------------------------------------------
class ahb_sram_wren_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_sram_wren_seq)

  logic [31:0] test_addr;

  function new(string name = "ahb_sram_wren_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    logic [31:0] addr;

    `uvm_info("SRAM_WREN_SEQ", "Starting SRAM WREN Test", UVM_LOW)

    // BYTE writes
    for (int byte_lane = 0; byte_lane < 4; byte_lane++) begin
      addr = test_addr + byte_lane;
      write_word(test_addr, 32'hFFFF_FFFF);

      req = ahb_seq_item::type_id::create("wr_byte");
      start_item(req);
      req.randomize() with {
        addr == addr;
        data == 32'h0;
        write == 1;
        size == 3'b000;
        burst == 3'b000;
        trans == 2'b10;
      };
      finish_item(req);

      read_word(test_addr);
    end

    // HALFWORD writes
    for (int half = 0; half < 2; half++) begin
      addr = test_addr + (half * 2);
      write_word(test_addr, 32'hFFFF_FFFF);

      req = ahb_seq_item::type_id::create("wr_half");
      start_item(req);
      req.randomize() with {
        addr == addr;
        data == 32'h0;
        write == 1;
        size == 3'b001;
        burst == 3'b000;
        trans == 2'b10;
      };
      finish_item(req);

      read_word(test_addr);
    end

    // WORD write
    write_word(test_addr, 32'hFFFF_FFFF);
    req = ahb_seq_item::type_id::create("wr_word");
    start_item(req);
    req.randomize() with {addr == test_addr;
                          data == 32'h0;
                          write == 1;
                          size == 3'b010;
                          burst == 3'b000;
                          trans == 2'b10;};
    finish_item(req);

    read_word(test_addr);

    `uvm_info("SRAM_WREN_SEQ", "Completed SRAM WREN Test", UVM_LOW)
  endtask

  // Helper tasks
  task write_word(logic [31:0] addr, logic [31:0] data);
    ahb_sram_single_write_seq wr_seq;
    wr_seq = ahb_sram_single_write_seq::type_id::create("wr_seq");
    wr_seq.wr_addr = addr;
    wr_seq.wr_data = data;
    wr_seq.start(m_sequencer);
  endtask

  task read_word(logic [31:0] addr);
    ahb_sram_single_read_seq rd_seq;
    rd_seq = ahb_sram_single_read_seq::type_id::create("rd_seq");
    rd_seq.rd_addr = addr;
    rd_seq.start(m_sequencer);
  endtask

endclass

`endif  // SRAM_SEQUENCES_SV

