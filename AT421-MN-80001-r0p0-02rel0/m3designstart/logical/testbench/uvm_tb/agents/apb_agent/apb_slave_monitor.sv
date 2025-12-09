`ifndef APB_SLAVE_MONITOR_SV
`define APB_SLAVE_MONITOR_SV

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
      @(posedge vif.cb.pclk);

      if (vif.cb.psel && vif.cb.penable && vif.cb.pready) begin
        apb_slave_seq_item tr = new();

        // Report the 12-bit offset (peripheral internal address)
        tr.addr  = vif.cb.paddr[11:0];
        tr.pstrb = vif.cb.pstrb;
        tr.pprot = vif.cb.pprot;

        if (vif.cb.pwrite) begin
          tr.rw   = WRITE;
          tr.data = vif.cb.pwdata;
        end else begin
          tr.rw   = READ;
          tr.data = vif.cb.prdata;
        end

        mon_ap.write(tr);
      end
    end
  endtask

endclass

`endif

