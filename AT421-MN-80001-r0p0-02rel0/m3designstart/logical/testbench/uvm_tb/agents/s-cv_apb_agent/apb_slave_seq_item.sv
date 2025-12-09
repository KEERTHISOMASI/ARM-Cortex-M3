`ifndef APB_SLAVE_SEQ_ITEM_SV
`define APB_SLAVE_SEQ_ITEM_SV

typedef enum {
  READ,
  WRITE
} apb_rw_e;

class apb_slave_seq_item extends uvm_sequence_item;
  rand bit [31:0] addr;
  rand bit [31:0] data;
  apb_rw_e        rw;
  bit      [ 2:0] pprot;
  rand bit [ 3:0] pstrb;

  `uvm_object_utils_begin(apb_slave_seq_item)
    `uvm_field_int(addr, UVM_ALL_ON)
    `uvm_field_int(data, UVM_ALL_ON)
    `uvm_field_enum(apb_rw_e, rw, UVM_ALL_ON)
    `uvm_field_int(pprot, UVM_ALL_ON)
    `uvm_field_int(pstrb, UVM_ALL_ON)
  `uvm_object_utils_end
  `uvm_object_utils(apb_slave_seq_item)

  function new(string name = "apb_slave_seq_item");
    super.new(name);
  endfunction

endclass

`endif

