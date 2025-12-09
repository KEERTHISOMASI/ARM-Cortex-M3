`ifndef APB_SLAVE_MONITOR_SV
`define APB_SLAVE_MONITOR_SV

`include "apb_slave_seq_item.sv"
`include "apb_slave_vif.sv"

class apb_slave_monitor extends uvm_monitor;
  `uvm_component_utils(apb_slave_monitor)

  uvm_analysis_port#(apb_slave_seq_item) mon_ap;
  apb_slave_vif vif;

  function new(string name="apb_slave_monitor", uvm_component parent=null);
    super.new(name,parent);
    mon_ap = new("mon_ap",this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    if (!uvm_config_db#(apb_slave_vif)::get(this, "", "apb_slave_vif", vif))
      `uvm_fatal("MON","vif not set")
  endfunction

  virtual task run_phase(uvm_phase phase);
    apb_slave_seq_item tr;

    forever begin
      @(posedge vif.cb.pclk);
      wait(vif.cb.psel && vif.cb.penable && vif.cb.pready);

      tr = apb_slave_seq_item::type_id::create("tr");
      tr.addr  = vif.cb.paddr;
      tr.pprot = vif.cb.pprot;

      if (vif.cb.pwrite) begin
        tr.rw   = WRITE;
        tr.pstrb = vif.cb.pstrb;
        tr.data = vif.cb.pwdata;
      end else begin
        tr.rw   = READ;
        tr.data = vif.cb.prdata;
      end

      mon_ap.write(tr);
    end
  endtask
endclass

`endif

