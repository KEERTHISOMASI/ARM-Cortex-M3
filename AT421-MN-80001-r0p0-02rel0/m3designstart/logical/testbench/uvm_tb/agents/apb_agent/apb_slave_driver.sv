`ifndef APB_SLAVE_DRIVER_SV
`define APB_SLAVE_DRIVER_SV

class apb_slave_driver extends uvm_component;
  `uvm_component_utils(apb_slave_driver)

  apb_slave_vif   vif;
  apb_slave_model model;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    model = new();
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(apb_slave_vif)::get(this,"","vif",vif))
      `uvm_fatal("DRV","No VIF provided")

    pidcid_t ids;
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
    // Default outputs
    vif.cb.prdata  <= '0;
    vif.cb.pslverr <= 0;
    vif.cb.pready  <= 1;   // <<<<<< ALWAYS READY (matches your RTL)

    forever begin
      @(posedge vif.cb.pclk);

      if (!vif.cb.psel)
        continue;

      // APB protocol: PSEL=1 in SETUP, PSEL=1 & PENABLE=1 in ACCESS
      if (vif.cb.penable == 0)
        continue;

      logic [11:0] offset = vif.cb.paddr[11:0];

      // RTL requirement: ANY offset in 0..FFF is valid. No error.
      vif.cb.pslverr <= 0;

      int idx = offset >> 2;

      if (idx >= model.regs.size()) begin
        vif.cb.prdata <= 32'h0;
      end
      else begin
        if (vif.cb.pwrite) begin
          bit [1:0] byte_ofs = offset[1:0];
          bit [31:0] mask         = pstrb_to_mask(vif.cb.pstrb, byte_ofs);
          bit [31:0] shifted_data = (vif.cb.pwdata << (byte_ofs * 8));

          bit [31:0] old = model.regs[idx];
          model.regs[idx] = (old & ~mask) | (shifted_data & mask);
          vif.cb.prdata   <= 0;
        end
        else begin
          // Read
          vif.cb.prdata <= model.regs[idx];
        end
      end

      // PREADY is already 1 — no toggling required
    end
  endtask

endclass

`endif

