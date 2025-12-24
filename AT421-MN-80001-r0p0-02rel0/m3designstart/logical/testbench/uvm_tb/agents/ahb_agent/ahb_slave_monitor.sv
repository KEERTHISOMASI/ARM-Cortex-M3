`ifndef AHB_SLAVE_MONITOR_SV
`define AHB_SLAVE_MONITOR_SV 

class ahb_slave_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_slave_monitor)

  virtual ahb_if.SLAVE vif;
  uvm_analysis_port #(ahb_seq_item) item_collected_port;

  ahb_seq_item pending_trans;  // Holds the Address Phase info

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb_if.SLAVE)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", {"Virtual interface must be set for: ", get_full_name(), ".vif"})
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.hclk);
      if (!vif.hresetn) begin
        pending_trans = null;
      end else if (vif.HREADYMUX) begin  // Pipeline advances

        // --- 1. DATA PHASE (Complete previous transaction) ---
        if (pending_trans != null) begin
          // Capture Data
          if (pending_trans.write) pending_trans.data = vif.HWDATA;
          else pending_trans.data = vif.HRDATA;

          // Capture actual response seen on bus
          pending_trans.resp = vif.HRESP;

          // Send to Scoreboard
          item_collected_port.write(pending_trans);
          pending_trans = null;
        end

        // --- 2. ADDRESS PHASE (Detect new transaction) ---
        // Sample only if valid transfer (NONSEQ or SEQ)
        if (vif.HSEL && (vif.HTRANS == 2'b10 || vif.HTRANS == 2'b11)) begin
          pending_trans = ahb_seq_item::type_id::create("mon_item");

          // Map Interface signals to your seq_item fields
          pending_trans.addr = vif.HADDR;
          pending_trans.write = vif.HWRITE;
          pending_trans.trans = vif.HTRANS;
          pending_trans.size = vif.HSIZE;
          pending_trans.burst = vif.HBURST;
          // Note: 'delay' is not easily captured here as it's a duration, 
          // usually monitors capture "what happened" rather than configuration knobs.
        end
      end
    end
  endtask
endclass
`endif

