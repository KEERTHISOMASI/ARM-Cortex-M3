interface ahb_if (
    input logic hclk,
    input logic hresetn
);
  logic [31:0] HADDR;
  logic        HWRITE;
  logic [ 1:0] HTRANS;
  logic [ 2:0] HSIZE;
  logic [ 2:0] HBURST;
  logic [ 3:0] HPROT;
  logic [31:0] HWDATA;
  logic [31:0] HRDATA;
  logic        HREADYOUT;
  logic        HRESP;
  logic        HSEL;

  logic        HREADY;
  //assign HREADY = HREADYOUT;

  modport MASTER(
      input hclk, hresetn, HREADY, HRESP, HRDATA,
      output HADDR, HWRITE, HTRANS, HSIZE, HBURST, HPROT, HWDATA
  );

  modport SLAVE(
      input hclk, hresetn, HSEL, HADDR, HWRITE, HTRANS, HSIZE, HBURST, HPROT, HWDATA, HREADY,
      output HREADYOUT, HRESP, HRDATA
  );
endinterface

// ==========================================================
// AHB MASTER DRIVER (Direct Drive & Pipelined)
// ==========================================================
// Internal structure to pass info from Address Phase to Data Phase
typedef struct {
  bit          valid;
  logic [31:0] addr;
  logic [31:0] data;
  bit          write;
} pipeline_reg_t;

class ahb_master_driver;

  // Interface Handle
  virtual ahb_if.MASTER        vif;

  // -------------------------------------------------------
  // Synchronization primitives
  // -------------------------------------------------------
  // Signals to handshake between drive() task and run() process
  local bit                    req_pending;
  local logic           [31:0] req_addr;
  local logic           [31:0] req_data;
  local bit                    req_write;

  // Event to signal drive() that the address phase is complete (sampled)
  event                        addr_phase_accepted;

  // Pipeline Register (Stores what enters Data Phase next)
  pipeline_reg_t               pipe_stage;

  function new(virtual ahb_if.MASTER vif_in);
    this.vif = vif_in;
    this.req_pending = 0;
    this.pipe_stage.valid = 0;
  endfunction

  // ---------------------------------------------------------
  // USER API TASK: drive()
  // ---------------------------------------------------------
  // Call this task directly from your Top/Testbench.
  // It blocks only until the Address Phase is accepted by the bus logic.
  // This allows you to call it back-to-back for pipelining.
  task drive(input bit write, input logic [31:0] addr, input logic [31:0] data = 0);

    // 1. Setup the request
    req_write   = write;
    req_addr    = addr;
    req_data    = data;
    req_pending = 1;

    // 2. Wait for the background process to accept it (sample it on HCLK)
    //    This effectively waits for the previous Address Phase to finish
    //    and HREADY to be 1.
    @(addr_phase_accepted);

    // 3. Clear pending flag so we don't re-drive same packet
    req_pending = 0;

  endtask

  // ---------------------------------------------------------
  // RESET TASK
  // ---------------------------------------------------------
  task reset();
    wait (!vif.hresetn);
    // Asynchronous Reset Assertion
    vif.HADDR  <= 'X;
    vif.HWDATA <= 0;
    vif.HWRITE <= 0;
    vif.HTRANS <= 0;  // IDLE
    vif.HSIZE  <= 0;  // 8-bit default or 0
    vif.HBURST <= 0;
    pipe_stage.valid = 0;
    req_pending      = 0;

    wait (vif.hresetn);
    // Wait for edge to synchronize
    @(posedge vif.hclk);
  endtask

  // ---------------------------------------------------------
  // BACKGROUND RUN TASK (The Pipeline Engine)
  // ---------------------------------------------------------
  // This must be forked in the testbench (e.g., initial fork drv.run(); join_none)
  task run();
    forever begin
      @(posedge vif.hclk);

      // -----------------------------------------------------
      // HREADY FEEDBACK CHECK (Rule 2 & 5)
      // -----------------------------------------------------
      // If HREADY is 0, the previous slave is extending the Data Phase.
      // We MUST hold the current Address Phase and Data Phase.
      if (vif.HREADY) begin

        // ===================================================
        // 1. DATA PHASE LOGIC (for the *previous* transfer)
        // ===================================================
        if (pipe_stage.valid) begin
          if (pipe_stage.write) begin
            // Drive Write Data
            vif.HWDATA <= pipe_stage.data;
            $display("[%0t] DRIVER: Data Phase WRITE Addr=0x%h Data=0x%h", $time, pipe_stage.addr,
                     pipe_stage.data);
          end else begin
            // Sample Read Data
            vif.HWDATA <= 'X;  // Clean bus
            // Note: HRDATA is valid *now* (at this clock edge)
            $display("[%0t] DRIVER: Data Phase READ  Addr=0x%h RData=0x%h", $time, pipe_stage.addr,
                     vif.HRDATA);
          end
        end else begin
          vif.HWDATA <= 'X;
        end

        // ===================================================
        // 2. ADDRESS PHASE LOGIC (for the *new* transfer)
        // ===================================================
        if (req_pending) begin
          // User called drive(), initiate new transfer
          vif.HADDR <= req_addr;
          vif.HWRITE <= req_write;
          vif.HTRANS <= 2'b10;  // NONSEQ
          vif.HSIZE <= 3'b010;  // 32-bit Word
          vif.HBURST <= 3'b000;  // Single

          // Update Pipeline Stage for NEXT cycle's Data Phase
          pipe_stage.valid <= 1;
          pipe_stage.addr <= req_addr;
          pipe_stage.data <= req_data;
          pipe_stage.write <= req_write;

          // Signal the drive() task that we accepted the addr
          ->addr_phase_accepted;

          $display("[%0t] DRIVER: Addr Phase DRIVE Addr=0x%h Write=%0b", $time, req_addr,
                   req_write);

        end else begin
          // No user request? Drive IDLE
          vif.HTRANS <= 2'b00;  // IDLE
          vif.HADDR <= 'X;
          vif.HWRITE <= 0;

          // If IDLE, the next Data Phase is invalid
          pipe_stage.valid <= 0;
        end

      end else begin
        // HREADY is LOW: STALL
        // Do not change HTRANS, HADDR, or HWDATA.
        // The protocol requires holding these stable until HREADY=1.
        $display("[%0t] DRIVER: Stalled by HREADY=0", $time);
      end
    end
  endtask

endclass

// ==========================================================
// AHB MASTER MONITOR
// ==========================================================


class ahb_master_monitor;

  virtual ahb_if.MASTER vif;

  // Simple struct to store address phase info for the pipeline
  typedef struct {
    logic [31:0] addr;
    bit          write;
    logic [2:0]  size;
    logic [2:0]  burst;
  } pipeline_info_s;

  pipeline_info_s pipeline_q[$];  // Queue to handle pipeline delay

  function new(virtual ahb_if.MASTER vif_in);
    this.vif = vif_in;
  endfunction

  task run();
    pipeline_info_s        pending;
    logic           [31:0] sampled_data;
    string                 kind;

    forever begin
      @(posedge vif.hclk);

      // Only process phases when HREADY is HIGH
      if (vif.hresetn && vif.HREADY) begin

        // ---------------------------------------------------
        // 1. DATA PHASE (Complete the oldest pending transfer)
        // ---------------------------------------------------
        if (pipeline_q.size() > 0) begin
          pending = pipeline_q.pop_front();

          // Capture Data based on direction
          if (pending.write) sampled_data = vif.HWDATA;
          else sampled_data = vif.HRDATA;

          kind = pending.write ? "WRITE" : "READ ";

          // PRINT DIRECTLY
          $display("[%0t] [MON-MST] %s Addr=0x%08h Data=0x%08h | Size=%0d Burst=%0d", $time, kind,
                   pending.addr, sampled_data, pending.size, pending.burst);
        end

        // ---------------------------------------------------
        // 2. ADDRESS PHASE (Sample new transfer)
        // ---------------------------------------------------
        // Check for NONSEQ (2'b10) or SEQ (2'b11)
        if (vif.HTRANS == 2'b10 || vif.HTRANS == 2'b11) begin
          pipeline_info_s new_item;

          new_item.addr  = vif.HADDR;
          new_item.write = vif.HWRITE;
          new_item.size  = vif.HSIZE;
          new_item.burst = vif.HBURST;

          // Push to queue to wait for Data Phase (Next Cycle)
          pipeline_q.push_back(new_item);
        end
      end
    end
  endtask

endclass

class ahb_master_agent;

  // Components
  ahb_master_driver driver;
  ahb_master_monitor monitor;

  // Virtual Interface
  virtual ahb_if.MASTER vif;

  function new(virtual ahb_if.MASTER vif);
    this.vif = vif;
    // Instantiate components
    driver   = new(vif);
    monitor  = new(vif);
  endfunction

  // Start both driver and monitor
  task run();
    fork
      driver.run();
      monitor.run();
    join_none
  endtask

  // Helper wrapper for reset
  task reset();
    driver.reset();
  endtask

endclass

// ==========================================================
// AHB SLAVE MODEL (Verification Component / Driver)
// ==========================================================
class ahb_slave_driver;

  // Interface Handle
  virtual ahb_if.SLAVE vif;

  // Memory Model
  logic [31:0] memory[int];

  // Pipeline State
  local bit sample_valid;
  local logic [31:0] sample_addr;
  local bit sample_write;
  local bit sample_error;  // NEW: Track if this transfer is an error

  // Address Range Config (Default: Full Range)
  logic [31:0] min_addr = 32'h0000_0000;
  logic [31:0] max_addr = 32'hFFFF_FFFF;

  // Track the HREADYOUT value we drove in the PREVIOUS cycle
  local bit hready_drove_prev;

  int wait_state_chance = 20;

  function new(virtual ahb_if.SLAVE vif_in);
    this.vif = vif_in;
    this.sample_valid = 0;
    this.hready_drove_prev = 1;
  endfunction

  // Configuration function called by Agent
  function void set_range(logic [31:0] min, logic [31:0] max);
    this.min_addr = min;
    this.max_addr = max;
  endfunction

  task run();
    vif.HREADYOUT <= 1'b1;
    vif.HRESP     <= 1'b0;
    vif.HRDATA    <= 32'b0;
    hready_drove_prev = 1;

    forever begin
      @(posedge vif.hclk);

      // 1. EXECUTE LOGIC (Based on PREVIOUS HREADY)
      if (hready_drove_prev == 1'b1) begin

        // --- A. Data Phase (Complete Previous) ---
        if (sample_valid) begin
          // CHECK FOR ERROR
          if (sample_error) begin
            vif.HRESP <= 1'b1;  // Drive ERROR response
            $display("[%0t] SLAVE:  ERROR RESP  Addr=0x%h (Out of Range)", $time, sample_addr);
            // Do not write to memory or drive valid Read Data
          end else begin
            // NORMAL OPERATION
            vif.HRESP <= 1'b0;  // OKAY

            if (sample_write) begin
              memory[sample_addr] = vif.HWDATA;
              $display("[%0t] SLAVE:  WRITE EXEC Addr=0x%h Data=0x%h", $time, sample_addr,
                       vif.HWDATA);
            end else begin
              $display("[%0t] SLAVE:  READ EXEC  Addr=0x%h Data=0x%h", $time, sample_addr,
                       vif.HRDATA);
            end
          end
        end else begin
          // No valid previous transaction
          vif.HRESP <= 1'b0;
        end

        // --- B. Address Phase (Sample New) ---
        if (vif.HSEL && (vif.HTRANS == 2'b10 || vif.HTRANS == 2'b11)) begin

          // 1. Check Address Range
          if (vif.HADDR < min_addr || vif.HADDR > max_addr) begin
            sample_error <= 1;
            // We still latch address for logging, but mark it as error
            sample_addr  <= vif.HADDR;
            sample_valid <= 1;
            sample_write <= vif.HWRITE;

            $display("[%0t] SLAVE:  ADDR SAMPLED Addr=0x%h (INVALID)", $time, vif.HADDR);
          end else begin
            // 2. Valid Address
            sample_error <= 0;
            sample_addr  <= vif.HADDR;
            sample_write <= vif.HWRITE;
            sample_valid <= 1;

            // Pre-fetch Read Data
            if (!vif.HWRITE) begin
              if (memory.exists(vif.HADDR)) vif.HRDATA <= memory[vif.HADDR];
              else vif.HRDATA <= 32'hDEAD_BEEF;
            end

            $display("[%0t] SLAVE:  ADDR SAMPLED Addr=0x%h Write=%0b", $time, vif.HADDR,
                     vif.HWRITE);
          end
        end else begin
          sample_valid <= 0;
        end
      end else begin
        // Stall Cycle
        //  $display("[%0t] SLAVE:  Stall Cycle", $time);
      end

      // 2. DECIDE NEXT HREADY
      if ($urandom_range(0, 99) < wait_state_chance) begin
        vif.HREADYOUT <= 1'b0;
        hready_drove_prev = 0;
      end else begin
        vif.HREADYOUT <= 1'b1;
        hready_drove_prev = 1;
      end
    end
  endtask

endclass

// ==========================================================
// AHB SLAVE MONITOR
// ==========================================================
class ahb_slave_monitor;

  virtual ahb_if.SLAVE vif;

  // Struct to store address phase info
  typedef struct {
    logic [31:0] addr;
    bit          write;
    logic [2:0]  size;
    logic [2:0]  burst;
  } pipeline_info_s;

  pipeline_info_s pipeline_q[$];

  function new(virtual ahb_if.SLAVE vif_in);
    this.vif = vif_in;
  endfunction

  task run();
    pipeline_info_s        pending;
    logic           [31:0] sampled_data;
    string                 kind;

    forever begin
      @(posedge vif.hclk);

      // Only process phases when HREADY is HIGH
      if (vif.hresetn && vif.HREADY) begin

        // ---------------------------------------------------
        // 1. DATA PHASE (Complete the oldest pending transfer)
        // ---------------------------------------------------
        if (pipeline_q.size() > 0) begin
          pending = pipeline_q.pop_front();

          if (pending.write) sampled_data = vif.HWDATA;
          else sampled_data = vif.HRDATA;

          kind = pending.write ? "WRITE" : "READ ";

          // PRINT DIRECTLY
          $display("[%0t] [MON-SLV] %s Addr=0x%08h Data=0x%08h | Size=%0d Burst=%0d", $time, kind,
                   pending.addr, sampled_data, pending.size, pending.burst);
        end

        // ---------------------------------------------------
        // 2. ADDRESS PHASE (Sample new transfer)
        // ---------------------------------------------------
        // Must be Selected (HSEL) AND Valid Transfer (NONSEQ/SEQ)
        if (vif.HSEL && (vif.HTRANS == 2'b10 || vif.HTRANS == 2'b11)) begin
          pipeline_info_s new_item;

          new_item.addr  = vif.HADDR;
          new_item.write = vif.HWRITE;
          new_item.size  = vif.HSIZE;
          new_item.burst = vif.HBURST;

          pipeline_q.push_back(new_item);
        end
      end
    end
  endtask

endclass

// ==========================================================
// AHB SLAVE AGENT
// ==========================================================
// Wraps the Slave Responder and Slave Monitor
// Adds Configuration API
class ahb_slave_agent;

  // Components
  ahb_slave_driver driver;
  ahb_slave_monitor monitor;

  // Virtual Interface
  virtual ahb_if.SLAVE vif;

  function new(virtual ahb_if.SLAVE vif);
    this.vif = vif;
    // Instantiate components
    driver   = new(vif);
    monitor  = new(vif);
  endfunction

  // ------------------------------------------------------
  // Configuration API
  // ------------------------------------------------------
  function void set_address_range(logic [31:0] min, logic [31:0] max);
    driver.set_range(min, max);
    $display("[SLAVE AGENT] Address Range Configured: [0x%08h - 0x%08h]", min, max);
  endfunction

  // Start both slave logic and monitor
  task run();
    fork
      driver.run();
      monitor.run();
    join_none
  endtask

endclass

