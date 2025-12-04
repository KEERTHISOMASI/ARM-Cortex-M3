`ifndef AHB_SLAVE_MONITOR_SV
`define AHB_SLAVE_MONITOR_SV


class ahb_slave_monitor extends uvm_monitor;
  `uvm_component_utils(ahb_slave_monitor)

  virtual ahb_if.SLAVE vif;
  
  uvm_analysis_port #(ahb_seq_item) item_collected_port;

  typedef struct {
    logic [31:0] addr;
    bit          write;
    logic [2:0]  size;
    logic [2:0]  burst;
    logic [1:0]  trans;
  } pipeline_info_s;

  pipeline_info_s pipeline_q[$];

  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collected_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ahb_if.SLAVE)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "Virtual interface not set for ahb_slave_monitor")
    end
  endfunction

  task run_phase(uvm_phase phase);
    pipeline_info_s pending;
    ahb_seq_item    trans_obj;

    forever begin
      @(posedge vif.hclk);
      
      if (vif.hresetn && vif.HREADY) begin
        
        // --- 1. DATA PHASE ---
        if (pipeline_q.size() > 0) begin
          pending = pipeline_q.pop_front();
          
          trans_obj = ahb_seq_item::type_id::create("trans_obj");
          trans_obj.addr  = pending.addr;
          trans_obj.write = pending.write;
          trans_obj.size  = pending.size;
          trans_obj.burst = pending.burst;
          trans_obj.trans = pending.trans;

          if (pending.write)
            trans_obj.data = vif.HWDATA;
          else
            trans_obj.data = vif.HRDATA; 
            
          item_collected_port.write(trans_obj);
          
          `uvm_info("SLV_MON", $sformatf("%s Addr=0x%0h Data=0x%0h", 
                                         (trans_obj.write ? "WR" : "RD"), trans_obj.addr, trans_obj.data), UVM_LOW)
        end

        // --- 2. ADDRESS PHASE ---
        if (vif.HSEL && (vif.HTRANS == 2'b10 || vif.HTRANS == 2'b11)) begin
          pipeline_info_s new_item;
          new_item.addr  = vif.HADDR;
          new_item.write = vif.HWRITE;
          new_item.size  = vif.HSIZE;
          new_item.burst = vif.HBURST;
          new_item.trans = vif.HTRANS;
          pipeline_q.push_back(new_item);
        end
      end
    end
  endtask

endclass

`endif