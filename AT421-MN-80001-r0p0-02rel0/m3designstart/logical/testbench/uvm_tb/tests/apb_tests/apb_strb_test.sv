
`include "../sequences/ahb_sequences.sv"
`include "../sequences/apb_sequences.sv"

class apb_strb_test extends iot_test_base;
  `uvm_component_utils(apb_strb_test)

  function new(string name = "apb_strb_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);

    apb_strb_seq master_seq;
    phase.raise_objection(this);

     master_seq = apb_strb_seq::type_id::create("master_seq");
     master_seq.start(env.master_agent_spi.sequencer);

    // Allow a little time for final response to complete
    #100;
    phase.drop_objection(this);
  endtask

endclass



