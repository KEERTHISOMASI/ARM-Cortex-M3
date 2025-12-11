`ifndef APB_SLAVE_DRIVER_SV
`define APB_SLAVE_DRIVER_SV
`include "apb_slave_vif.sv"
`include "apb_slave_model.sv"
class apb_slave_driver extends uvm_component;
  `uvm_component_utils(apb_slave_driver)

virtual apb_slave_if.slave_mp vif;
apb_slave_model model;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    model = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    pidcid_t ids;
    if (!uvm_config_db#(virtual apb_slave_if.slave_mp)::get(this,"","vif",vif))
      	    `uvm_fatal("DRV","No VIF provided")

    if (uvm_config_db#(pidcid_t)::get(this,"","pidcid",ids))
      model.set_ids(ids);
  endfunction

  function automatic bit [31:0] pstrb_to_mask(bit [3:0] pstrb, bit [1:0] byte_offset);
    bit [31:0] base_mask = {
      (pstrb[3] ? 8'hFF : 8'h00),
      (pstrb[2] ? 8'hFF : 8'h00),
      (pstrb[1] ? 8'hFF : 8'h00),
      (pstrb[0] ? 8'hFF : 8'h00)
    };
    return base_mask << (byte_offset * 8);
  endfunction

  virtual task run_phase(uvm_phase phase);
	logic [11:0] offset;
	int idx;
    // Default outputs
    vif.prdata  <= '0;
    vif.pslverr <= 0;
    vif.pready  <= 1;   // <<<<<< ALWAYS READY (matches your RTL)

    forever begin
      @(posedge vif.pclk);

      if (!vif.psel)
        continue;

      // APB protocol: PSEL=1 in SETUP, PSEL=1 & PENABLE=1 in ACCESS
      if (vif.penable == 0)
        continue;

      offset = vif.paddr[11:0];

      // RTL requirement: ANY offset in 0..FFF is valid. No error.
      vif.pslverr <= 0;

      idx = offset >> 2;

      if (idx >= model.regs.size()) begin
        vif.prdata <= 32'h0;
      end
      else begin
        if (vif.pwrite) begin
          bit [1:0] byte_ofs = offset[1:0];
          bit [31:0] mask         = pstrb_to_mask(vif.pstrb, byte_ofs);
          bit [31:0] shifted_data = (vif.pwdata << (byte_ofs * 8));

          bit [31:0] old = model.regs[idx];
          model.regs[idx] = (old & ~mask) | (shifted_data & mask);
          vif.prdata   <= 0;
        end
        else begin
          // Read
          vif.prdata <= model.regs[idx];
        end
      end

      // PREADY is already 1 — no toggling required
    end
  endtask

endclass

`endif

