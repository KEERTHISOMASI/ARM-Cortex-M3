/*`ifndef APB_SLAVE_DRIVER_SV
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

    // 1. Initial Reset / Idle State
    vif.prdata  <= '0;
    vif.pslverr <= 0;
    vif.pready  <= 1; 

    forever begin
      @(posedge vif.pclk);

      // Handle Reset: If reset is active, clear outputs and restart loop
      if (vif.presetn === 1'b0) begin
        vif.prdata <= 32'h0;
        continue; 
      end

      // 2. APB State Decoding
      if (vif.psel) begin
        offset = vif.paddr[11:0];
        idx = offset >> 2;

        if (!vif.pwrite) begin
          // --- READ CASE (Setup Phase) ---
          // Sample the address and provide data immediately
          if (idx < model.regs.size())
            vif.prdata <= model.regs[idx];
          else
            vif.prdata <= 32'h0;
        end 
        else if (vif.penable) begin
          // --- WRITE CASE (Access Phase only) ---
          // This ensures we only "take" pwdata when penable is high
          bit [1:0] byte_ofs = offset[1:0];
          bit [31:0] mask         = pstrb_to_mask(vif.pstrb, byte_ofs);
          bit [31:0] shifted_data = (vif.pwdata << (byte_ofs * 8));

          bit [31:0] old = model.regs[idx];
          model.regs[idx] = (old & ~mask) | (shifted_data & mask);
          
          vif.prdata <= 32'h0; // Keep prdata clean during writes
        end
      end 
      else begin
        // --- IDLE CASE ---
        // Clear prdata when not selected
        vif.prdata <= 32'h0;
      end
    end
endtask
endclass

`endif*/
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

  function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(virtual apb_slave_if.slave_mp)::get(this,"","vif",vif))
      `uvm_fatal("APB_SLV", "No virtual interface")
  endfunction


  virtual task run_phase(uvm_phase phase);
    logic [11:0] offset;
    int          idx;

    // Slave-driven defaults
    vif.prdata  <= '0;
    vif.pready  <= 1'b1;
    vif.pslverr <= 1'b0;
    vif.pwdata <= '0;

    forever begin
      @(posedge vif.pclk);
        if (!vif.psel) begin
        vif.prdata  <= '0;
        vif.pslverr <= 1'b0;
	vif.pwdata = '0;
      end

      //--------------------------------------
      // SETUP PHASE
      //--------------------------------------
      if (vif.psel && !vif.penable) begin
        offset = vif.paddr[11:0];
        idx    = offset >> 2;

        // READ PREPARE
        if (!vif.pwrite) begin
vif.pwdata = '0;

          if (idx < model.regs.size())
            vif.prdata <= model.regs[idx];
          else
            vif.prdata <= 32'h0;
        end
      end

      //--------------------------------------
      // ACCESS PHASE
      //--------------------------------------
      if (vif.psel && vif.penable) begin
        if (vif.pwrite) begin
          // WRITE happens here
          bit [1:0] byte_ofs;
          bit [31:0] mask;

          byte_ofs = vif.paddr[1:0];
          mask = pstrb_to_mask(vif.pstrb, byte_ofs);

          model.regs[idx] =
            (model.regs[idx] & ~mask) |
            ((vif.pwdata << (byte_ofs*8)) & mask);
        end
      end

      //--------------------------------------
      // When idle, clear slave outputs only
      //--------------------------------------
        end
  endtask

  function automatic bit [31:0] pstrb_to_mask(
    bit [3:0] pstrb,
    bit [1:0] byte_offset
  );
    bit [31:0] base_mask;
    base_mask = {
      (pstrb[3] ? 8'hFF : 8'h00),
      (pstrb[2] ? 8'hFF : 8'h00),
      (pstrb[1] ? 8'hFF : 8'h00),
      (pstrb[0] ? 8'hFF : 8'h00)
    };
    return base_mask << (byte_offset * 8);
  endfunction

endclass

`endif

