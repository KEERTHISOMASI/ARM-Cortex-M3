// Test Name  : ahb_single_read_test
// Description:
// This test verifies a basic single AHB read transaction.
// The AHB master initiates a NONSEQ SINGLE read to a valid slave address.
// The test checks correct address decoding, data return,
// HREADY handshake, and HRESP = OKAY.
class ahb_single_read_test extends uvm_test;
  `uvm_component_utils(ahb_single_read_test)

  ahb_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ahb_env::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    ahb_single_read_seq master_seq;
    phase.raise_objection(this);


    // 2. Start the Master Sequence (The actual test scenario)
    master_seq = ahb_single_read_seq::type_id::create("master_seq");
    master_seq.start(env.master_agent.sequencer);

    // Allow a little time for final response to complete
    #100;
    phase.drop_objection(this);
  endtask

endclass
