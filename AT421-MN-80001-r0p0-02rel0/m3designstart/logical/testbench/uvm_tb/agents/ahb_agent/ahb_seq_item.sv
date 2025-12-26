`ifndef AHB_SEQ_ITEM_SV
`define AHB_SEQ_ITEM_SV 

import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_seq_item extends uvm_sequence_item;

  // Request Fields (Master -> Slave)
  rand logic        [31:0] addr;
  rand logic        [31:0] data;
  rand bit                 write;
  rand logic        [ 2:0] size;
  rand logic        [ 2:0] burst;
  rand logic        [ 1:0] trans;

  // Response Fields (Slave -> Master)
  logic                    resp;  // 0=OKAY, 1=ERROR
  rand int unsigned        delay;  // Number of HREADY=0 cycles to insert

  `uvm_object_utils_begin(ahb_seq_item)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_int(write, UVM_ALL_ON)
    `uvm_field_int(resp, UVM_ALL_ON)
    `uvm_field_int(delay, UVM_ALL_ON)
    `uvm_field_int(burst, UVM_ALL_ON)
    `uvm_field_int(trans, UVM_ALL_ON)

  `uvm_object_utils_end

  function new(string name = "ahb_seq_item");
    super.new(name);
  endfunction


  // Default Constraints
  constraint c_default_ctrl {size == 3'b010;}

endclass

`endif
