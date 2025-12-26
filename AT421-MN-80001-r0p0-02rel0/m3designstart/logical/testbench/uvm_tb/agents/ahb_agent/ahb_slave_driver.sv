`ifndef AHB_SLAVE_DRIVER_SV
`define AHB_SLAVE_DRIVER_SV 

class ahb_slave_driver extends uvm_driver #(ahb_seq_item);
  `uvm_component_utils(ahb_slave_driver)

  virtual ahb_if.SLAVE vif;

  // -------------------------------------------------------
  // Internal Structures
  // -------------------------------------------------------
  // Memory Model (Sparse Array)
  logic [31:0] memory[int];

  // Pipeline State Register
  typedef struct {
    bit          valid;
    logic [31:0] addr;
    bit          write;
    logic [1:0]  trans_type;          // Store HTRANS to handle BUSY vs NONSEQ/SEQ
    int          wait_cycles;
    bit          error_resp;
    bit          error_cycle_1_done;
  } slave_pipeline_t;

  slave_pipeline_t stage;

  // Address Range Configuration
  typedef struct {
    logic [31:0] min;
    logic [31:0] max;
  } range_t;
  range_t allowed_ranges[$];

  // Randomization Knobs
  int wait_state_chance = 20;  // 20% chance to insert wait states

  // -------------------------------------------------------
  // Component Basics
  // -------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    stage.valid = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ahb_if.SLAVE)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NOVIF", "Virtual interface not set for ahb_slave_driver")
    end
  endfunction

  // -------------------------------------------------------
  // Helper Functions
  // -------------------------------------------------------
  function bit is_addr_valid(logic [31:0] addr);
    if (allowed_ranges.size() == 0) return 1;  // Allow all if no ranges set
    foreach (allowed_ranges[i]) begin
      if (addr >= allowed_ranges[i].min && addr <= allowed_ranges[i].max)
        `uvm_info("ADDR_CHECK", $sformatf(
                  "----------------------------------Address 0x%h is VALID. Found in Range[%0d]: 0x%h - 0x%h",
                  addr,
                  i,
                  allowed_ranges[i].min,
                  allowed_ranges[i].max
                  ), UVM_MEDIUM)
      return 1;
    end
    `uvm_info("ADDR_CHECK", $sformatf(
              "------------------------------------Address 0x%h is INVALID. Not found in any configured range.",
              addr
              ), UVM_MEDIUM)
    return 0;
  endfunction

  function void add_range(logic [31:0] min, logic [31:0] max);
    range_t r;
    r.min = min;
    r.max = max;
    allowed_ranges.push_back(r);
  endfunction

  // -------------------------------------------------------
  // Run Phase (Main Logic)
  // -------------------------------------------------------
  task run_phase(uvm_phase phase);
    // Local Sampling Variables
    logic       [31:0] s_haddr;
    logic              s_hwrite;
    logic       [ 1:0] s_htrans;
    logic              s_hsel;
    logic              s_hready_in;  // The HREADY input (muxed/system)

    // AHB HTRANS Encodings
    const logic [ 1:0] HTRANS_IDLE = 2'b00;
    const logic [ 1:0] HTRANS_BUSY = 2'b01;
    const logic [ 1:0] HTRANS_NONSEQ = 2'b10;
    const logic [ 1:0] HTRANS_SEQ = 2'b11;

    // Initial Reset State
    vif.HREADYOUT <= 1'b1;
    vif.HRESP     <= 1'b0;
    vif.HRDATA    <= 32'b0;
    stage.valid = 0;

    forever begin
      @(posedge vif.hclk);

      // 1. SAMPLE INPUTS
      // We sample the inputs driven by the Master
      s_haddr     = vif.HADDR;
      s_hwrite    = vif.HWRITE;
      s_htrans    = vif.HTRANS;
      s_hsel      = vif.HSEL;
      s_hready_in = vif.HREADY;

      // 2. RESET CHECK
      if (!vif.hresetn) begin
        vif.HREADYOUT <= 1'b1;
        vif.HRESP     <= 1'b0;
        stage.valid   <= 0;
        continue;
      end

      // 3. PIPELINE UPDATE LOGIC
      // We only update the pipeline state if the previous phase completed (HREADY=1)
      if (s_hready_in) begin

        // --- A. COMMIT PREVIOUS TRANSACTION (Data Phase) ---
        // If we had a valid WRITE in the pipeline, the data is now valid on HWDATA
        if (stage.valid && stage.write && !stage.error_resp) begin
          memory[stage.addr] = vif.HWDATA;
          `uvm_info("SLV_MEM", $sformatf("Write Commit: Addr=0x%h Data=0x%h", stage.addr,
                                         vif.HWDATA), UVM_HIGH)
        end

        // --- B. LOAD NEW TRANSACTION (Address Phase) ---
        if (s_hsel && (s_htrans == HTRANS_NONSEQ || s_htrans == HTRANS_SEQ)) begin
          // Valid Transfer Request
          stage.valid              = 1;
          stage.addr               = s_haddr;
          stage.write              = s_hwrite;
          stage.trans_type         = s_htrans;
          stage.error_cycle_1_done = 0;

          // Error Injection / Validation Logic
          if (!is_addr_valid(s_haddr)) begin
            stage.error_resp  = 1;
            stage.wait_cycles = 0;
          end else begin
            stage.error_resp = 0;
            // Random Wait State Insertion
            if ($urandom_range(0, 99) < wait_state_chance) stage.wait_cycles = $urandom_range(1, 3);
            else stage.wait_cycles = 0;
          end
        end else begin
          // IDLE or BUSY cycle
          // If HTRANS is BUSY, Master is putting a bubble in the pipe.
          // We must NOT commit data for this cycle next time.
          stage.valid = 0;
        end
      end
      // If s_hready_in == 0, it means WE (or another slave) are inserting wait states.
      // We hold the current 'stage' constant.

      // 4. DRIVE OUTPUTS (Execute Current Stage)
      if (stage.valid) begin

        // --- Case 1: Insert Wait States ---
        if (stage.wait_cycles > 0) begin
          vif.HREADYOUT <= 1'b0;
          vif.HRESP     <= 1'b0;  // OKAY
          stage.wait_cycles--;

          // CRITICAL: During wait states on a READ, we must keep driving the data
          // or drive unknown, but commonly we hold the intended data if ready.
          if (!stage.write && !stage.error_resp) begin
            if (memory.exists(stage.addr)) vif.HRDATA <= memory[stage.addr];
            else vif.HRDATA <= 32'hDEAD_BEEF;
          end
        end  // --- Case 2: Error Response (2-Cycle Protocol) ---
        else if (stage.error_resp) begin
          if (!stage.error_cycle_1_done) begin
            // Cycle 1: HREADY=0, HRESP=ERROR
            vif.HREADYOUT <= 1'b0;
            vif.HRESP     <= 1'b1;
            stage.error_cycle_1_done = 1;
          end else begin
            // Cycle 2: HREADY=1, HRESP=ERROR
            vif.HREADYOUT <= 1'b1;
            vif.HRESP     <= 1'b1;
            // The pipeline update logic (Step 3B) will see HREADY=1 next clock
            // and clear the stage (or load new), effectively ending the error.
          end
        end  // --- Case 3: Normal Transfer (Zero Wait or Wait Done) ---
        else begin
          vif.HREADYOUT <= 1'b1;
          vif.HRESP     <= 1'b0;  // OKAY

          // Drive Read Data
          if (!stage.write) begin
            if (memory.exists(stage.addr)) vif.HRDATA <= memory[stage.addr];
            else vif.HRDATA <= 32'hDEAD_BEEF;
          end
        end
      end else begin
        // IDLE State (Default Response)
        vif.HREADYOUT <= 1'b1;
        vif.HRESP     <= 1'b0;
        vif.HRDATA    <= 32'b0;
      end

    end  // forever
  endtask

endclass

`endif

