`timescale 1ns/1ps
 
interface sram_if(input logic CLK);
  logic        CS;
  logic [12:0] ADDR;
  logic [3:0]  WREN;
  logic [31:0] WDATA;
  logic [31:0] RDATA;
endinterface
 
// ------------------------------------------------------------------------
// sram_slave_driver - run() guarded by `running` flag, with start()/stop()
// ------------------------------------------------------------------------
class sram_slave_driver;
 
  virtual sram_if vif;
 
  localparam int ADDR_WIDTH = 13;
  localparam int MEM_DEPTH  = (1 << ADDR_WIDTH);
 
  logic [31:0] mem [0:MEM_DEPTH-1];
  // pipeline registers for read latency handled inside run()
  // lifecycle control
  bit running;
 
  // NEW: Configurable local address range (defaults: full range)
  logic [ADDR_WIDTH-1:0] min_addr;
  logic [ADDR_WIDTH-1:0] max_addr;
 
  function new(virtual sram_if vif);
    this.vif = vif;
    for (int i = 0; i < MEM_DEPTH; i = i + 1) mem[i] = 32'hx;
    running = 0;
 
    // NEW: default range = full memory
    min_addr = '0;
    max_addr = MEM_DEPTH-1;
  endfunction
 
  // NEW: configuration function (similar to AHB set_range)
  function void set_range(logic [ADDR_WIDTH-1:0] min,
                          logic [ADDR_WIDTH-1:0] max);
    min_addr = min;
    max_addr = max;
 
    `ifdef SIM_VERBOSE
      $display("[%0t] %m: SRAM addr range set: [%0h .. %0h]",
               $time, min_addr, max_addr);
    `endif
  endfunction
 
  // UPDATED: now checks configured range instead of just MEM_DEPTH
  function bit is_valid_addr(logic [ADDR_WIDTH-1:0] addr);
    // addr is already 13 bits, so addr < MEM_DEPTH is always true;
    // we only need to enforce [min_addr .. max_addr]
    return (addr >= min_addr && addr <= max_addr);
  endfunction
 
  // start run() in background
  task start();
    if (!running) begin
      running = 1;
      fork
        run();
      join_none
    end
  endtask
 
  // ask run() to stop (it will stop at next loop iteration)
  task stop();
    running = 0;
  endtask
 
  // main worker - exits when running becomes 0
  task run();
    // pipeline regs for 1-cycle read latency
    bit prev_cs;
    logic [ADDR_WIDTH-1:0] prev_addr;
 
    // initialize output + pipeline regs
    vif.RDATA = 32'h0;
    prev_cs   = 1'b0;
    prev_addr = '0;
 
    // main loop
    while (running) begin
      @(posedge vif.CLK);
 
      // --- 1) perform writes immediately using current inputs ---
      if (vif.CS) begin
        if (!is_valid_addr(vif.ADDR)) begin
          `ifdef SIM_VERBOSE
            $display("[%0t] %m: Write to invalid addr %0h (range [%0h..%0h]) ignored",
                     $time, vif.ADDR, min_addr, max_addr);
          `endif
        end else begin
          if (vif.WREN[0]) mem[vif.ADDR][7:0]   = vif.WDATA[7:0];
          if (vif.WREN[1]) mem[vif.ADDR][15:8]  = vif.WDATA[15:8];
          if (vif.WREN[2]) mem[vif.ADDR][23:16] = vif.WDATA[23:16];
          if (vif.WREN[3]) mem[vif.ADDR][31:24] = vif.WDATA[31:24];
        end
      end
 
      // --- 2) drive RDATA from the previous-cycle address (one-cycle latency) ---
      if (prev_cs && is_valid_addr(prev_addr))
        vif.RDATA = mem[prev_addr];
      else
        vif.RDATA = 32'h0;
 
      // --- 3) update pipeline registers for next cycle ---
      prev_cs   = vif.CS;
      prev_addr = vif.ADDR;
    end // while running
  endtask
  // Backdoor helpers (immediate)
  // NOTE: These still use the full MEM_DEPTH range, intentionally.
  task write_mem(input logic [ADDR_WIDTH-1:0] addr, input logic [31:0] data);
    if (addr >= min_addr && addr <= max_addr) $display("[%0t] %m: write_mem: Address %h out of bounds.", $time, addr);
    else mem[addr] = data;
  endtask
 
  task read_mem(input logic [ADDR_WIDTH-1:0] addr, output logic [31:0] data);
    if (addr >= min_addr && addr <= max_addr) begin
      $display("[%0t] %m: read_mem: Address %h out of bounds.", $time, addr);
      data = 32'hx;
    end else data = mem[addr];
  endtask
 
endclass
 
 
// ------------------------------------------------------------------------
// sram_slave_monitor - start()/stop() + run()
// ------------------------------------------------------------------------
class sram_slave_monitor;
 
  virtual sram_if vif;
  bit running;
 
  function new(virtual sram_if vif);
    this.vif = vif;
    running = 0;
  endfunction
 
  task start();
    if (!running) begin
      running = 1;
      fork run(); join_none
    end
  endtask
 
  task stop();
    running = 0;
  endtask
 
  task run();
    while (running) begin
      @(posedge vif.CLK);
      // small delta so monitor sees value driver has driven for this cycle
      #1;
      if (vif.CS) begin
        if (vif.WREN != 4'b0)
          $display("[%0t] [SRAM SLAVE MON] WRITE Addr=%0h WDATA=%0h WSTRB=%b",
                   $time, vif.ADDR, vif.WDATA, vif.WREN);
        else
          begin
			@(posedge vif.CLK);  
          $display("[%0t] [SRAM SLAVE MON] READ  Addr=%0h RDATA=%0h",
                   $time, vif.ADDR, vif.RDATA);
          end
      end
    end
  endtask
 
endclass
 
 
// ------------------------------------------------------------------------
// sram_slave_agent - composes driver + monitor; provides start()/stop()
// ------------------------------------------------------------------------
class sram_slave_agent;
 
  virtual sram_if vif;
  sram_slave_driver drv;
  sram_slave_monitor mon;
 
  function new(virtual sram_if vif);
    this.vif = vif;
    drv = new(vif);
    mon = new(vif);
  endfunction
 
  // NEW: easy way to configure range from TB
  function void set_range(logic [12:0] min, logic [12:0] max);
    drv.set_range(min, max);
  endfunction
 
  task start();
    drv.start();
    mon.start();
  endtask
 
  task stop();
    drv.stop();
    mon.stop();
  endtask
 
endclass