
`include "../sequences/ahb_sequences.sv"
`include "../sequences/ahb_slave_reactive_seq.sv"
`include "iot_test_base.sv"

class ahb_wr_rd_test extends iot_test_base;
  `uvm_component_utils(ahb_wr_rd_test)

  function new(string name = "ahb_wr_rd_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    ahb_slave_reactive_seq slave_seq;
   // ahb_incr4_burst_seq master_seq;
    //ahb_single_write_seq   master_seq;
    //ahb_single_read_seq master_seq;
    ahb_write_read_seq master_seq;
    //ahb_wrap4_burst_seq master_seq;
    phase.raise_objection(this);

    // 1. Fork the Slave Sequence (Runs infinitely in background)
    slave_seq  = ahb_slave_reactive_seq::type_id::create("slave_seq");
    // 2. Start the Master Sequence (The actual test scenario)
   // master_seq = ahb_incr4_burst_seq::type_id::create("master_seq");
    //master_seq = ahb_single_write_seq::type_id::create("master_seq");
    //master_seq = ahb_single_read_seq::type_id::create("master_seq");
     master_seq = ahb_write_read_seq::type_id::create("master_seq");
    // master_seq = ahb_wrap4_burst_seq::type_id::create("master_seq");
    //

    fork
      slave_seq.start(env.slave_agent_exp1.sequencer);
    join_none

    master_seq.start(env.master_agent_spi.sequencer);

    // Allow a little time for final response to complete
    #100;
    phase.drop_objection(this);
  endtask

endclass



