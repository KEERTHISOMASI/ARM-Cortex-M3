`ifndef AHB_SEQ_ITEM_SV
`define AHB_SEQ_ITEM_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_seq_item extends uvm_sequence_item;

  // Request Fields (Master -> Slave)
  rand logic [31:0] addr;
  rand logic [31:0] data;
  rand bit          write;
  rand logic [2:0]  size;
  rand logic [2:0]  burst;
  rand logic [1:0]  trans;

  // Response Fields (Slave -> Master)
  logic        resp;      // 0=OKAY, 1=ERROR

  `uvm_object_utils_begin(ahb_seq_item)
    `uvm_field_int(addr,  UVM_ALL_ON)
    `uvm_field_int(data,  UVM_ALL_ON)
    `uvm_field_int(write, UVM_ALL_ON)
    `uvm_field_int(resp,  UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "ahb_seq_item");
    super.new(name);
  endfunction
// -------------------------------------------------------
  // Address Map Constraint
  // -------------------------------------------------------
  constraint c_valid_mem_map {
    addr inside {
      [32'hA000_0000 : 32'hA000_FFFF], // exp0 range
      [32'h0004_0000 : 32'h1FFF_FFFF], // exp1 range start
      [32'h2002_0000 : 32'h3FFF_FFFF],
      [32'h4001_0000 : 32'h9FFF_FFFF],
      [32'hA001_0000 : 32'hDFFF_FFFF],
      [32'hE001_0000 : 32'hFFFF_FFFF]
    };
  }
  constraint c_addr_aligned { addr[1:0] == 0; }
  
  // Default Constraints
  constraint c_default_ctrl {
    size == 3'b010; 
    trans == 2'b10; 
    burst == 3'b000; 
  }

  // Response Constraints (Keep delays reasonable by default)

endclass

`endif
