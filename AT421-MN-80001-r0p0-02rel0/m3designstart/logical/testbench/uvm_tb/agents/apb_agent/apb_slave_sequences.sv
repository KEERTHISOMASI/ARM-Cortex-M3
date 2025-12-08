`ifndef APB_SLAVE_SEQUENCES_SV
`define APB_SLAVE_SEQUENCES_SV

class apb_slave_base_sequence extends uvm_sequence;
  `uvm_object_utils(apb_slave_base_sequence)
endclass

// minimal placeholder sequences (create real sequences as needed)
class apb_slave_simple_read_seq extends uvm_sequence#(apb_slave_seq_item);
  `uvm_object_utils(apb_slave_simple_read_seq)
  virtual task body();
    apb_slave_seq_item req;
    req = apb_slave_seq_item::type_id::create("req");
    req.addr = 'h000;
    req.rw   = READ;
    start_item(req);
    finish_item(req);
  endtask
endclass

class apb_slave_simple_write_seq extends uvm_sequence#(apb_slave_seq_item);
  `uvm_object_utils(apb_slave_simple_write_seq)
  virtual task body();
    apb_slave_seq_item req;
    req = apb_slave_seq_item::type_id::create("req");
    req.addr = 'h000;
    req.rw   = WRITE;
    req.data = 32'hA5A5A5A5;
    start_item(req);
    finish_item(req);
  endtask
endclass

`endif

