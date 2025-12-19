`ifndef AHB_SLAVE_DRIVER_SV
`define AHB_SLAVE_DRIVER_SV


class ahb_slave_driver extends uvm_driver #(ahb_seq_item);
  `uvm_component_utils(ahb_slave_driver)

  virtual ahb_if.SLAVE vif;

  // Memory Model
  logic [31:0] memory [int];
  
  // Pipeline State
  typedef struct {
    bit          valid;
    logic [31:0] addr;
    bit          write;
    int          wait_cycles;    
    bit          error_resp;     
    bit          error_cycle_1_done; 
  } slave_pipeline_t;

  slave_pipeline_t stage;

  // Configuration
  typedef struct {
    logic [31:0] min;
    logic [31:0] max;
  } range_t;
  range_t allowed_ranges[$];
  
 // int wait_state_chance = 20;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    stage.valid = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Logic to determine if this is slave 0 or 1
	if (get_name() == "slave_agent_exp0")
	begin
	if(!uvm_config_db#(virtual ahb_if.SLAVE)::get(this,"","vif_0" , vif)) 
    		`uvm_fatal("NOVIF","Virtual interface slave agent 0 not set ")
	end
	else                         
	begin
	if(!uvm_config_db#(virtual ahb_if.SLAVE)::get(this,"","vif_1", vif)) 
    		`uvm_fatal("NOVIF","Virtual interface slave agent 1 not set ")
	end
     endfunction
  function bit is_addr_valid(logic [31:0] addr);
    if (allowed_ranges.size() == 0) return 1; 
    foreach (allowed_ranges[i]) begin
      if (addr >= allowed_ranges[i].min && addr <= allowed_ranges[i].max)
        return 1;
    end
    return 0;
  endfunction

  function void add_range(logic [31:0] min, logic [31:0] max);
    range_t r;
    r.min = min;
    r.max = max;
    allowed_ranges.push_back(r);
  endfunction

  task run_phase(uvm_phase phase);
    // Local Sampling Variables
    logic [31:0] s_haddr;
    logic        s_hwrite;
    logic [1:0]  s_htrans;
    logic        s_hsel;
    logic        s_hready;

    // Reset State
    vif.HREADYOUT <= 1'b1;
    vif.HRESP     <= 1'b0;
    vif.HRDATA    <= 32'b0;
    stage.valid    = 0;

    forever begin
      @(posedge vif.hclk);
      
      // 1. SAMPLE INPUTS (Capture T-1 values)
      s_haddr  = vif.HADDR;
      s_hwrite = vif.HWRITE;
      s_htrans = vif.HTRANS;
      s_hsel   = vif.HSEL;
      s_hready = vif.HREADYMUX; 

      if (!vif.hresetn) begin
        vif.HREADYOUT <= 1'b1;
        vif.HRESP     <= 1'b0;
        stage.valid   <= 0;
        continue;
      end

      // 2. PIPELINE UPDATE LOGIC
      // If the bus was Ready, the previous Data Phase is DONE.
      // We must Commit its Write, and then Load the New Address.
      if (s_hready) begin
          
          // A. Commit Previous Write (if valid and no error)
          if (stage.valid && stage.write && !stage.error_resp) begin
             memory[stage.addr] = vif.HWDATA;
             `uvm_info("SLV_DRV", $sformatf("Write 0x%h = 0x%h", stage.addr, vif.HWDATA), UVM_HIGH)
          end
          // If previous was Error Cycle 2, it ends now naturally.

          // B. Load New Address (Sampled Address Phase)
          if (s_hsel && (s_htrans == 2'b10 || s_htrans == 2'b11)) begin
             stage.valid = 1;
             stage.addr  = s_haddr;
             stage.write = s_hwrite;
             stage.error_cycle_1_done = 0;

             // Determine Response Type immediately
             if (!is_addr_valid(s_haddr)) begin
                stage.error_resp = 1;
                stage.wait_cycles = 0;
             end 
             else begin
                stage.error_resp = 0;
               /* if ($urandom_range(0, 99) < wait_state_chance)
                   stage.wait_cycles = $urandom_range(1, 3);
                else*/
                   stage.wait_cycles = 0;
             end
          end
          else begin
             stage.valid = 0; // IDLE or BUSY
          end
      end
      // Else (s_hready == 0): Master holds previous Address. 
      // We keep 'stage' as is (extending Wait State or Error Cycle 1).

      // 3. DATA PHASE EXECUTION (Drive Outputs for CURRENT Stage)
      if (stage.valid) begin
        
        // --- A. Wait States ---
        if (stage.wait_cycles > 0) begin
           vif.HREADYOUT <= 1'b0; 
           vif.HRESP     <= 1'b0; // Protocol: OKAY during wait
           stage.wait_cycles--;
           
           // Keep Read Data stable
           if (!stage.write && !stage.error_resp) begin
             if (memory.exists(stage.addr)) vif.HRDATA <= memory[stage.addr];
             else vif.HRDATA <= 32'hDEAD_BEEF;
           end
        end
        // --- B. Error Response (2 Cycles) ---
        else if (stage.error_resp) begin
             if (!stage.error_cycle_1_done) begin
               // Cycle 1: HRESP=ERROR, HREADY=0
               vif.HREADYOUT <= 1'b0;
               vif.HRESP     <= 1'b1;
               stage.error_cycle_1_done = 1;
               `uvm_info("SLV_DRV", $sformatf("ERROR Start (Cycle 1) Addr=0x%h", stage.addr), UVM_HIGH)
             end 
             else begin
               // Cycle 2: HRESP=ERROR, HREADY=1
               vif.HREADYOUT <= 1'b1;
               vif.HRESP     <= 1'b1;
               // We don't clear stage.valid here; it clears in step 2 (Load New) next clock
               `uvm_info("SLV_DRV", $sformatf("ERROR End (Cycle 2) Addr=0x%h", stage.addr), UVM_HIGH)
             end
        end
        // --- C. Normal OKAY Transfer ---
        else begin
             vif.HREADYOUT <= 1'b1;
             vif.HRESP     <= 1'b0;
             
             // Drive Read Data
             if (!stage.write) begin
                if (memory.exists(stage.addr)) vif.HRDATA <= memory[stage.addr];
                else vif.HRDATA <= 32'hDEAD_BEEF;
                `uvm_info("SLV_DRV", $sformatf("Read 0x%h = 0x%h", stage.addr, vif.HRDATA), UVM_HIGH)
             end
        end
      end
      else begin
        // IDLE State
        vif.HREADYOUT <= 1'b1;
        vif.HRESP     <= 1'b0;
      end
      
    end
  endtask

endclass

`endif
