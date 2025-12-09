`ifndef APB_SLAVE_DRIVER_SV
`define APB_SLAVE_DRIVER_SV

`include "apb_slave_vif.sv"
`include "apb_slave_model.sv"

class apb_slave_driver extends uvm_component;
  `uvm_component_utils(apb_slave_driver)

  apb_slave_vif vif;
  apb_slave_model model;

  int ready_delay = 1;
  bit enable_pprot_check = 1;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    model = new(8);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(apb_slave_vif)::get(this, "", "apb_slave_vif", vif))
      `uvm_fatal(get_type_name(),"vif not set")
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.cb.pclk);

      wait(vif.cb.psel == 1 && vif.cb.penable == 0);
      logic [31:0] addr  = vif.cb.paddr;
      logic [2:0]  pprot = vif.cb.pprot;

      wait(vif.cb.penable == 1);

      int idx;
      bit mapped = model.addr_to_index(addr, idx);
      bit illegal = (!mapped);

      if (enable_pprot_check && mapped)
        if (!model.check_pprot(idx, pprot))
          illegal = 1;

      if (illegal) begin
        vif.cb.pslverr <= 1;
        vif.cb.prdata  <= 32'hDEAD_DEAD;
      end
      else begin
        vif.cb.pslverr <= 0;
        vif.cb.prdata  <= model.regs[idx];
      end

      repeat(ready_delay) @(posedge vif.cb.pclk);

      vif.cb.pready <= 1;
      @(posedge vif.cb.pclk);
      vif.cb.pready <= 0;

if (!illegal && vif.cb.pwrite && mapped) begin
  bit [31:0] old = model.regs[idx];
  bit [31:0] new = vif.cb.pwdata;

  bit [31:0] mask;

  mask[7:0]    =  (vif.cb.pstrb[0] ? 8'hFF : 8'h00);
  mask[15:8]   =  (vif.cb.pstrb[1] ? 8'hFF : 8'h00);
  mask[23:16]  =  (vif.cb.pstrb[2] ? 8'hFF : 8'h00);
  mask[31:24]  =  (vif.cb.pstrb[3] ? 8'hFF : 8'h00);

  model.regs[idx] = (new & mask) | (old & ~mask);
end
      

      vif.cb.pslverr <= 0;
    end
  endtask
endclass

`endif

