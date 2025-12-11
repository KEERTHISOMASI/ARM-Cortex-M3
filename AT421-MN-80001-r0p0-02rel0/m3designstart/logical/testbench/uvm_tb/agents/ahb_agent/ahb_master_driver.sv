`ifndef AHB_MASTER_DRIVER_SV
`define AHB_MASTER_DRIVER_SV

class ahb_master_driver extends uvm_driver #(ahb_seq_item);
  `uvm_component_utils(ahb_master_driver)

  virtual ahb_if.MASTER vif;

  // ------------------------------------------------------------------------
  // Internal Structures
  // ------------------------------------------------------------------------
  typedef struct {
    bit          valid;
    logic [31:0] data;
    bit          write;
  } pipeline_reg_t;

  pipeline_reg_t pipe_stage;

  // Holding Registers for Request
  local bit          req_pending;
  local logic [31:0] req_addr;
  local logic [31:0] req_data;
  local bit          req_write;
  local logic [2:0]  req_burst;
  local logic [2:0]  req_size;
  local logic [1:0]  req_trans; // Captures HTRANS directly from Sequence

  event addr_phase_accepted;
  //int beats;

   

  // ------------------------------------------------------------------------
  // Constructor & Build Phase
  // ------------------------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    this.req_pending = 0;
    this.pipe_stage.valid = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual ahb_if.MASTER)::get(this, "", "vif", vif))
      `uvm_fatal("NOVIF", "Virtual interface not set")
  endfunction

  // ------------------------------------------------------------------------
  // Run Phase
  // ------------------------------------------------------------------------
  task run_phase(uvm_phase phase);
    fork
      handle_reset();
      get_and_drive();   
      pipeline_engine(); 
    join
  endtask

  // ------------------------------------------------------------------------
  // Thread 1: Sequencer Fetching
  // ------------------------------------------------------------------------
  task get_and_drive();
    wait(vif.hresetn);
    forever begin
      seq_item_port.get_next_item(req);
      
      req_addr    = req.addr;
      req_data    = req.data;
      req_write   = req.write;
      req_burst   = req.burst;
      req_size    = req.size;
      req_trans  = req.trans;
      `uvm_info("HTRANS", $sformatf("---1---GOT DATA FROM SEQ--------------REQ.ADDR=%0d---------------", req.addr), UVM_MEDIUM) 
      req_pending = 1;

      @(addr_phase_accepted);
      
      req_pending = 0;
      seq_item_port.item_done();
    end
  endtask

  // ------------------------------------------------------------------------
  // Thread 2: Pipeline Engine
  // ------------------------------------------------------------------------
  task pipeline_engine();
    const logic [1:0] HTRANS_IDLE   = 2'b00;
    const logic [1:0] HTRANS_BUSY   = 2'b01;
    const logic [1:0] HTRANS_NONSEQ = 2'b10;
    const logic [1:0] HTRANS_SEQ    = 2'b11;

    forever begin
      @(posedge vif.hclk);
      
      if (!vif.hresetn) continue;

      // ====================================================================
      // PRIORITY 1: ERROR RECOVERY (Protocol Mandate) [cite: 2324, 2328]
      // ====================================================================
      // Even if sequence wants NONSEQ, we MUST drive IDLE if ERROR occurs.
      if (vif.HRESP && !vif.HREADY) begin
          vif.HTRANS <= HTRANS_IDLE;
          pipe_stage.valid <= 0;
          // Note: We do NOT set 'addr_phase_accepted'. The sequence holds.
      end
      
      // ====================================================================
      // PRIORITY 2: NORMAL OPERATION (HREADY HIGH)
      // ====================================================================
       if (vif.HREADY) begin
        
        // --- A. DATA PHASE (Previous Transaction) ---
        if (pipe_stage.valid) begin
           if (pipe_stage.write) vif.HWDATA <= pipe_stage.data;
           else                  vif.HWDATA <= 'hx ; 
        end else begin
        //  `uvm_info("HTRANS","PIPE_VALID0",UVM_MEDIUM)
           vif.HWDATA <= 'hxx;
        end

        // --- B. ADDRESS PHASE (Current Transaction) ---
        if (req_pending) begin
         // `uvm_info("HTRANS","REQ_PENDING1",UVM_MEDIUM)
      //   #5;
      //@(posedge vif.hclk); 
           
           // DIRECT DRIVE: Blindly follow the Sequence
           vif.HTRANS <= req_trans;
           vif.HBURST <= req_burst;
           vif.HADDR  <= req_addr;
           vif.HWRITE <= req_write;
           vif.HSIZE  <= req_size;

    `uvm_info("DRV", $sformatf("2---DROVE: Addr=0x%h ", vif.HADDR), UVM_LOW)
           // execute a Data Phase in the next cycle.
         
           if (req_trans[1]) begin
             `uvm_info("trans0","htrans[1]==1",UVM_MEDIUM)
               pipe_stage.valid <= 1;
               pipe_stage.data  <= req_data;
               pipe_stage.write <= req_write;
             `uvm_info("trans0",$sformatf("----------3 driving data req_data=%0d",req_data),UVM_MEDIUM)
           end else begin
            
               pipe_stage.valid <= 0; // It was IDLE or BUSY
           end

           // Handshake
           -> addr_phase_accepted;
//	   req_pending<=0;
        end
        else begin
                @(posedge vif.hclk); 
		`uvm_info("reqpend",$sformatf("--req_addr=%0h req_data=%0d",req_addr,req_data),UVM_MEDIUM)
           // No item from sequence? Default to IDLE.
           vif.HTRANS <= HTRANS_IDLE;
           vif.HADDR  <= 'h0000_0000;
           vif.HWRITE <= 0;
           pipe_stage.valid <= 0;
        end
      end 
      
      // ====================================================================
      // PRIORITY 3: WAIT STATE
      // ====================================================================
      else begin
         // Stall: Do not change signals.
      end
    end
  endtask

  // ------------------------------------------------------------------------
  // Thread 3: Reset Handling
  // ------------------------------------------------------------------------
  task handle_reset();
    wait(!vif.hresetn);
    vif.HADDR        <= 0;
    vif.HWDATA       <= 0;
    vif.HWRITE       <= 0;
    vif.HTRANS       <= 0;
    vif.HSIZE        <= 0;
    vif.HBURST       <= 0;
    pipe_stage.valid <= 0;
    req_pending      <= 0;
  endtask

endclass

`endif
