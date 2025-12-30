// Test Name  : ahb_write_read_test
// Description:
// This test verifies write followed by read functionality.
// The master writes data to a slave address and then reads back
// from the same address.
// The test checks correct write completion, data storage,
// and read-back data consistency with HRESP = OKAY.
class ahb_wr_rd_test extends iot_test_base;
  `uvm_component_utils(ahb_wr_rd_test)

  //iot_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  


  task run_phase(uvm_phase phase);
    ahb_write_read_seq master_seq;
    phase.raise_objection(this);


    // 2. Start the Master Sequence (The actual test scenario)
    master_seq = ahb_write_read_seq::type_id::create("master_seq");
    master_seq.start(env.master_agent_spi.sequencer);

    // Allow a little time for final response to complete
    #100;
    phase.drop_objection(this);
  endtask

endclass
