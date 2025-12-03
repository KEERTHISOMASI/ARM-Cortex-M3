interface apb_if(input logic PCLK, input logic PRESETn);

  logic        PSEL;
  logic        PENABLE;
  logic        PWRITE;
  logic [11:0] PADDR;
  logic [31:0] PWDATA;
  logic [31:0] PRDATA;
  logic  [3:0] PSTRB;     // NEW
  logic  [2:0] PPROT;     // NEW
  logic        PREADY;
  logic        PSLVERR;

endinterface

class apb_slave_driver;

  virtual apb_if vif;

  logic [31:0] mem [0:255];
  int index;

  // ============================================
  // Address Range Config (similar to AHB driver)
  // ============================================
  logic [11:0] min_addr = 12'h000;
  logic [11:0] max_addr = 12'h0FF;

  // Set address range from agent
  function void set_range(logic [11:0] lo, logic [11:0] hi);
    min_addr = lo;
    max_addr = hi;
  endfunction

  // Updated valid address check
  function bit is_valid_addr(bit [11:0] addr);
    return (addr >= min_addr && addr <= max_addr);
  endfunction
  // ============================================


  function new(virtual apb_if vif);
    this.vif = vif;
    foreach(mem[i]) mem[i] = 32'h0;
  endfunction


  task run();

    vif.PREADY  = 0;
    vif.PRDATA  = 'z;
    vif.PSLVERR = 0;

    forever begin
      @(posedge vif.PCLK);

      if (!vif.PRESETn) begin
        vif.PREADY  = 0;
        vif.PSLVERR = 0;
        vif.PRDATA  = 'z;
        continue;
      end

      if (vif.PSEL && vif.PENABLE) begin

        // INVALID ADDRESS
        if (!is_valid_addr(vif.PADDR)) begin
          vif.PREADY  = 1;
          vif.PSLVERR = 1;
          vif.PRDATA  = (!vif.PWRITE) ? 'x : 'z;
          continue;
        end

        index = vif.PADDR[9:2];

        if (vif.PWRITE) begin
          if (vif.PSTRB[0]) mem[index][7:0]   = vif.PWDATA[7:0];
          if (vif.PSTRB[1]) mem[index][15:8]  = vif.PWDATA[15:8];
          if (vif.PSTRB[2]) mem[index][23:16] = vif.PWDATA[23:16];
          if (vif.PSTRB[3]) mem[index][31:24] = vif.PWDATA[31:24];
        end
        else begin
          vif.PRDATA = mem[index];
        end

        vif.PREADY  = 1;
        vif.PSLVERR = 0;
      end

      else begin
        vif.PREADY  = 0;
        vif.PSLVERR = 0;
        vif.PRDATA  = 'z;
      end
    end
  endtask

endclass

class apb_slave_monitor;

  virtual apb_if vif;

  function new(virtual apb_if vif);
    this.vif = vif;
  endfunction

  task run();
    forever begin
      @(posedge vif.PCLK);

      if (vif.PSEL && vif.PENABLE && vif.PREADY) begin
        if (vif.PWRITE)
          $display("[SLAVE MON] WRITE Addr=%h Data=%h STRB=%h PROT=%b",
                   vif.PADDR, vif.PWDATA, vif.PSTRB, vif.PPROT);
        else
          $display("[SLAVE MON] READ  Addr=%h Data=%h PROT=%b",
                   vif.PADDR, vif.PRDATA, vif.PPROT);
      end
    end
  endtask

endclass

class apb_slave_agent;

  virtual apb_if vif;
  apb_slave_driver  drv;
  apb_slave_monitor mon;

  function new(virtual apb_if vif);
    this.vif = vif;
    drv = new(vif);
    mon = new(vif);
  endfunction

  task start();
    fork
      drv.run();
      mon.run();
    join_none
  endtask

endclass

