`ifndef APB_SLAVE_SEQ_LIB_SV
`define APB_SLAVE_SEQ_LIB_SV

class dummy_slave_seq extends uvm_sequence#(apb_slave_seq_item);
  `uvm_object_utils(dummy_slave_seq)
  function new(string name="dummy_slave_seq"); super.new(name); endfunction
  virtual task body(); endtask
endclass

`endif

