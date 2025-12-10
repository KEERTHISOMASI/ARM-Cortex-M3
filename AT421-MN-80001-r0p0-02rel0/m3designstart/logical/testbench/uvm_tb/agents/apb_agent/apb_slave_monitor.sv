`ifndef APB_SLAVE_MONITOR_SV
`define APB_SLAVE_MONITOR_SV
`include "apb_slave_seq_item.sv"
class apb_slave_monitor extends uvm_monitor;
  `uvm_component_utils(apb_slave_monitor)

  uvm_analysis_port#(apb_slave_seq_item) mon_ap;
  apb_slave_vif vif;

  function new(string name, uvm_component parent);
    super.new(name,parent);
    mon_ap = new("mon_ap",this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(apb_slave_vif)::get(this,"","vif",vif))
      `uvm_fatal("MON","VIF not set");
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.pclk);

      if (vif.psel && vif.penable && vif.pready) begin
        apb_slave_seq_item tr = new();

        // Report the 12-bit offset (peripheral internal address)
        tr.addr  = vif.paddr[11:0];
        tr.pstrb = vif.pstrb;
        tr.pprot = vif.pprot;

        if (vif.pwrite) begin
          tr.rw   = WRITE;
          tr.data = vif.pwdata;
        end else begin
          tr.rw   = READ;
          tr.data = vif.prdata;
        end

        mon_ap.write(tr);
      end
    end
  endtask

endclass

`endif

