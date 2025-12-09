`ifndef APB_SLAVE_SCOREBOARD_SV
`define APB_SLAVE_SCOREBOARD_SV

class apb_slave_scoreboard extends uvm_component;
  `uvm_component_utils(apb_slave_scoreboard)

  uvm_analysis_imp#(apb_slave_seq_item, apb_slave_scoreboard) sb_ap;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    sb_ap = new("sb_ap",this);
  endfunction

  virtual function void write(apb_slave_seq_item tr);
    `uvm_info("SCOREBOARD",$sformatf("SLAVE observed: %s", tr.sprint()),UVM_LOW)
  endfunction
endclass

`endif

