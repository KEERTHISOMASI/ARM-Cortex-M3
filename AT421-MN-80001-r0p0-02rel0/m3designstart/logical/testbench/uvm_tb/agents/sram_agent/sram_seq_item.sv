import uvm_pkg::*;
`include "uvm_macros.svh"

// ----------------------------------------------------------------
// 1. SEQUENCE ITEM
// ----------------------------------------------------------------
class sram_seq_item extends uvm_sequence_item;
  `uvm_object_utils(sram_seq_item)

  rand bit [12:0] addr;
  rand bit [31:0] data;
  rand bit [3:0]  wren;
  bit             is_write; // 1 = Write, 0 = Read

  function new(string name = "sram_seq_item");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("Type=%s Addr=%0h Data=%0h WREN=%b", 
      (is_write ? "WRITE" : "READ"), addr, data, wren);
  endfunction
endclass

