class ahb_incr4_burst_test extends iot_test_base;
  `uvm_component_utils(ahb_incr_burst_test)

  ahb_env env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = ahb_env::type_id::create("env", this);
  endfunction


  task run_phase(uvm_phase phase);
   ahb_incr4_burst_seq master_seq;
 
    phase.raise_objection(this)
    //Start the Master Sequence (The actual test scenario)
    master_seq = ahb_incr4_burst_seq::type_id::create("master_seq");
    master_seq.start(env.master_agent.sequencer);
    //Time for final response to complete
    #100;
    phase.drop_objection(this);
    
  endtask

endclass
