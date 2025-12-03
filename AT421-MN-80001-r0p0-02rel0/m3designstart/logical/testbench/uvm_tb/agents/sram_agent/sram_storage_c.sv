import uvm_pkg::*;
`include "uvm_macros.svh"
// ----------------------------------------------------------------

// 2. MEMORY STORAGE (The "Brain")
// ----------------------------------------------------------------

class sram_storage_c extends uvm_object;
  `uvm_object_utils(sram_storage_c)

  protected bit [31:0] mem_array [int]; // Associative array
  bit [31:0] default_val = '0;

  function new(string name = "sram_storage_c");
    super.new(name);
  endfunction

  function void write(input int addr, input logic [31:0] wdata, input logic [3:0] wren);
    bit [31:0] current_data = mem_array.exists(addr) ? mem_array[addr] : default_val;
    
    if (wren[0]) current_data[7:0]   = wdata[7:0];
    if (wren[1]) current_data[15:8]  = wdata[15:8];
    if (wren[2]) current_data[23:16] = wdata[23:16];
    if (wren[3]) current_data[31:24] = wdata[31:24];

    mem_array[addr] = current_data;
  endfunction

  function bit [31:0] read(input int addr);
    return mem_array.exists(addr) ? mem_array[addr] : default_val;
  endfunction
  
  // For Backdoor access from Test
  function void poke(int addr, bit [31:0] data);
    mem_array[addr] = data;
  endfunction
endclass


