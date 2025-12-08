`ifndef APB_SLAVE_SEQ_ITEM_SV
`define APB_SLAVE_SEQ_ITEM_SV

typedef enum {READ, WRITE} apb_rw_e;

class apb_slave_seq_item extends uvm_sequence_item;
  rand bit [11:0] addr;
  rand bit [31:0] data;
  rand apb_rw_e   rw;
  rand bit [3:0]  pstrb;
  rand bit [2:0]  pprot;

  `uvm_object_utils(apb_slave_seq_item)

  function new(string name="apb_slave_seq_item");
    super.new(name);
  endfunction
endclass

`endif

