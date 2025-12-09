`ifndef CMD_TRANSACTION_SV
`define CMD_TRANSACTION_SV

class cmd_transaction extends uvm_sequence_item;

  `uvm_object_utils(cmd_transaction)

  rand bit [31:0] addr;
  rand bit [31:0] data;
  rand bit        is_write;
  rand int        master_id;

  function new(string name = "cmd_transaction");
    super.new(name);
  endfunction

endclass

`endif
