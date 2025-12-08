`ifndef APB_SLAVE_CFG_SV
`define APB_SLAVE_CFG_SV

class apb_slave_cfg extends uvm_object;
  `uvm_object_utils(apb_slave_cfg)

  // NOTE: For your current requirement we do not need base_addr mapping inside UVC.
  // This class is retained for possible future extension. Test will drive config if needed.
  rand bit [31:0] base_addr = 32'h0;
  rand int unsigned size = 4096;

  function new(string name="apb_slave_cfg");
    super.new(name);
  endfunction

endclass

`endif

