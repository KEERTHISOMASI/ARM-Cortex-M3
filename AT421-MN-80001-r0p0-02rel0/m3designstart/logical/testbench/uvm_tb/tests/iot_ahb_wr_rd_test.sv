// Test Intention:
// 1. To perform write and read any one particular AHB Slave.
// 2. Verify whether the same written data is being read immediately.

`ifndef IOT_AHB_WR_RD_TEST
`define IOT_AHB_WR_RD_TEST
//Include the sequence required
`include "../sequences/ahb_sequences.sv"
class iot_ahb_wr_rd_test extends iot_test_base;
    `uvm_component_utils(iot_ahb_wr_rd_test)

    function new(string name = "iot_test_base", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    task run_phase(uvm_phase phase);
        //ahb_write_read_seq seq;
        ahb_incr4_burst_seq seq;
	phase.raise_objection(this);

        seq = ahb_incr4_burst_seq::type_id::create("seq");
        seq.start(env.master_agent_dma.sequencer);
        #100;

        phase.drop_objection(this);
    endtask
endclass
`endif
