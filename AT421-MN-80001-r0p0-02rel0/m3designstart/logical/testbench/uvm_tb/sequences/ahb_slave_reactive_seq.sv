`ifndef AHB_SLAVE_REACTIVE_SEQ_SV
`define AHB_SLAVE_REACTIVE_SEQ_SV

class ahb_slave_reactive_seq extends ahb_base_seq;
  `uvm_object_utils(ahb_slave_reactive_seq)

  function new(string name = "ahb_slave_reactive_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info("SLV_SEQ", "Starting Reactive Slave Sequence (Forever Loop) - No Errors", UVM_LOW)

    forever begin
      // 1. Create the request item
      req = ahb_seq_item::type_id::create("req");

      // 2. Wait for Driver request (Handshake Start)
      start_item(req);

      // 3. Randomize the response configuration (Only delays/wait states)
      if (!req.randomize()) begin
        `uvm_error("SEQ", "Randomization failed for slave response item")
      end

      // 4. Force OKAY Response (Removed 2% Error Logic)
      req.resp = 0;  // Always OKAY

      // 5. Send item to Driver (Handshake Finish)
      finish_item(req);
    end
  endtask

endclass

`endif

