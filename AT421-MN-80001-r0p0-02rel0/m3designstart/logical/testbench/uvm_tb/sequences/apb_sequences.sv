`ifndef APB_SEQUENCES_SV
`define APB_SEQUENCES_SV 


// ---------------------------------------------------------
//  Write Followed by Read 
// ---------------------------------------------------------
class apb_wr_rd_seq extends ahb_base_seq;
  `uvm_object_utils(apb_wr_rd_seq)

  function new(string name = "apb_wr_rd_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
    // Task-local variable to sync address between Write and Read
    logic [31:0] target_addr = 32'h40008000; //watchdog as a slave peripheral
    logic [31:0] target_data = 32'h12345678;

    `uvm_info("SEQ", "--- Starting Write-Read Sequence ---", UVM_LOW)

    // 1. Write
    req = ahb_seq_item::type_id::create("req_wr");
    start_item(req);
    if (!req.randomize() with {
          addr == target_addr;
          data == target_data;
          write == 1;
          burst == 3'b000;  // SINGLE
          trans == 2'b10;  // NONSEQ
          //size   == 3'b010;
        })
      `uvm_error("SEQ", "Randomization failed");
    finish_item(req);

    // 2. Read
    req = ahb_seq_item::type_id::create("req_rd");
    start_item(req);
    if (!req.randomize() with {
          addr == target_addr;  // Same address
          write == 0;
          burst == 3'b000;  // SINGLE
          trans == 2'b10;  // NONSEQ
          // size   == 3'b010;
        })
      `uvm_error("SEQ", "Randomization failed");
    finish_item(req);

    `uvm_info("SEQ", "--- Finished APB Write-Read Sequence ---", UVM_LOW)
  endtask
endclass


class apb_strb_seq extends ahb_base_seq;
  `uvm_object_utils(apb_strb_seq)
   function new(string name = "apb_strb_seq");
    super.new(name);
  endfunction

  task body();
    ahb_seq_item req;
     logic [31:0] target_addr = 32'h40008003; //watchdog as a slave peripheral
    logic [31:0] target_data = 32'h12345678;
    //1.write
    req = ahb_seq_item::type_id::create("req");
    // Disable the conflicting constraint in the item
    //req.c_default_ctrl.constraint_mode(0);

    start_item(req);

      // To get pstrb = 4'b1100 (Upper Half-word)
       if (!req.randomize() with {
	  addr == target_addr;
          data == target_data;  
          write  == 1;
          //size  == 3'b001; // 16-bit
         })
        `uvm_error("SEQ", "Randomization failed");

    finish_item(req);
          
    // 2. Read
    req = ahb_seq_item::type_id::create("req_rd");
    start_item(req);
    if (!req.randomize() with {
          addr == target_addr;  // Same address
          write == 0;
          burst == 3'b000;  // SINGLE
          trans == 2'b10;  // NONSEQ
          //size   == 3'b001;
        })
      `uvm_error("SEQ", "Randomization failed");
    finish_item(req);

     `uvm_info("SEQ", "--- APB strobe Sequence ---", UVM_LOW)
  endtask
endclass

`endif
