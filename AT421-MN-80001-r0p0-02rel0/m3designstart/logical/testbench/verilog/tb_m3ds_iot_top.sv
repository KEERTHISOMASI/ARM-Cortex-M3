
`timescale 1ns / 1ps
`include "apb_slave_bfm.sv"
`include "sram_bfm.sv"
`include "AHB_BFM/ahb_bfm.sv"

module tb_m3ds_iot_top;

  // ------------------------------------------------------------
  // DEFAULT CLOCKS
  // ------------------------------------------------------------
  // CPU/SRAM/AHB : 100 MHz → 10ns period
  // APB/Timers   : 50 MHz → 20ns period
  // TPIU Trace   : 80 MHz → 12.5ns period
  // ------------------------------------------------------------

  // CPU clocks
  logic CPU0FCLK = 0;
  logic CPU0HCLK = 0;

  // AHB Matrix
  logic MTXHCLK = 0;

  // SRAMs
  logic SRAM0HCLK = 0;
  logic SRAM1HCLK = 0;
  logic SRAM2HCLK = 0;
  logic SRAM3HCLK = 0;

  // AHB-to-APB
  logic AHB2APBHCLK = 0;

  // APB clocks used by some peripherals (use AHB2APBHCLK)
  logic PCLK;
  logic PCLKG;

  // Timers
  logic TIMER0PCLK = 0;
  logic TIMER0PCLKG;
  logic TIMER1PCLK = 0;
  logic TIMER1PCLKG;

  // Trace clock
  logic TPIUTRACECLKIN = 0;

  // ------------------------------------------------------------
  // FLASH INIT FILE (user uploaded .ini)
  // ------------------------------------------------------------
  localparam string FLASH_INI = "sandbox:/mnt/data/flash_main.ini";

  // ------------------------------------------------------------
  // GENERATE CLOCKS
  // ------------------------------------------------------------
  // 100 MHz clocks (10ns)
  always #5 CPU0FCLK = ~CPU0FCLK;
  always #5 CPU0HCLK = ~CPU0HCLK;
  always #5 MTXHCLK = ~MTXHCLK;
  always #5 SRAM0HCLK = ~SRAM0HCLK;
  always #5 SRAM1HCLK = ~SRAM1HCLK;
  always #5 SRAM2HCLK = ~SRAM2HCLK;
  always #5 SRAM3HCLK = ~SRAM3HCLK;

  // 50 MHz clocks (20ns)
  always #10 AHB2APBHCLK = ~AHB2APBHCLK;
  always #10 TIMER0PCLK = ~TIMER0PCLK;
  always #10 TIMER1PCLK = ~TIMER1PCLK;

  // Drive APB clocks from AHB->APB clock
  assign PCLK = AHB2APBHCLK;
  assign PCLKG = PCLK;

  // Gated clocks follow base clocks
  assign TIMER0PCLKG = TIMER0PCLK;
  assign TIMER1PCLKG = TIMER1PCLK;

  // 80 MHz trace clock (12.5ns)
  always #6.25 TPIUTRACECLKIN = ~TPIUTRACECLKIN;

  // ------------------------------------------------------------
  // RESET GENERATION
  // ------------------------------------------------------------
  logic CPU0PORESETn = 0;
  logic CPU0SYSRESETn = 0;
  logic MTXHRESETn = 0;
  logic TIMER0PRESETn = 0;
  logic TIMER1PRESETn = 0;

  initial begin
    CPU0PORESETn = 0;
    CPU0SYSRESETn = 0;
    MTXHRESETn = 0;
    TIMER0PRESETn = 0;
    TIMER1PRESETn = 0;

    repeat (5) @(posedge CPU0FCLK);
    CPU0PORESETn = 1;
    CPU0SYSRESETn = 1;
    MTXHRESETn = 1;

    repeat (5) @(posedge TIMER0PCLK);
    TIMER0PRESETn = 1;

    repeat (5) @(posedge TIMER1PCLK);
    TIMER1PRESETn = 1;
  end

  // ------------------------------------------------------------
  // SRAM INTERFACES
  // ------------------------------------------------------------
  logic [31:0] SRAM0RDATA;
  logic [12:0] SRAM0ADDR;
  logic [ 3:0] SRAM0WREN;
  logic [31:0] SRAM0WDATA;
  logic        SRAM0CS;

  logic [31:0] SRAM1RDATA;
  logic [12:0] SRAM1ADDR;
  logic [ 3:0] SRAM1WREN;
  logic [31:0] SRAM1WDATA;
  logic        SRAM1CS;

  logic [31:0] SRAM2RDATA;
  logic [12:0] SRAM2ADDR;
  logic [ 3:0] SRAM2WREN;
  logic [31:0] SRAM2WDATA;
  logic        SRAM2CS;

  logic [31:0] SRAM3RDATA;
  logic [12:0] SRAM3ADDR;
  logic [ 3:0] SRAM3WREN;
  logic [31:0] SRAM3WDATA;
  logic        SRAM3CS;

  // ------------------------------------------------------------
  // TIMER EXTERNAL & INTERRUPTS
  // ------------------------------------------------------------
  logic        TIMER0EXTIN;
  logic        TIMER0PRIVMODEN;
  logic        TIMER1EXTIN;
  logic        TIMER1PRIVMODEN;

  logic        TIMER0TIMERINT;
  logic        TIMER1TIMERINT;

  initial begin
    TIMER0EXTIN     = 1'b0;
    TIMER0PRIVMODEN = 1'b0;
    TIMER1EXTIN     = 1'b0;
    TIMER1PRIVMODEN = 1'b0;
  end

  // ------------------------------------------------------------
  // AHB TARGET EXPANSION PORTS (FLASH, EXP0, EXP1)
  // ------------------------------------------------------------
  // Flash
  logic        TARGFLASH0HSEL;
  logic [31:0] TARGFLASH0HADDR;
  logic [ 1:0] TARGFLASH0HTRANS;
  logic        TARGFLASH0HWRITE;
  logic [ 2:0] TARGFLASH0HSIZE;
  logic [ 2:0] TARGFLASH0HBURST;
  logic [ 3:0] TARGFLASH0HPROT;
  logic [ 1:0] TARGFLASH0MEMATTR;
  logic        TARGFLASH0EXREQ;
  logic [ 3:0] TARGFLASH0HMASTER;
  logic [31:0] TARGFLASH0HWDATA;
  logic        TARGFLASH0HMASTLOCK;
  logic        TARGFLASH0HREADYMUX;
  logic        TARGFLASH0HAUSER;
  logic [ 3:0] TARGFLASH0HWUSER;
  logic [31:0] TARGFLASH0HRDATA;
  logic        TARGFLASH0HREADYOUT;
  logic        TARGFLASH0HRESP;
  logic        TARGFLASH0EXRESP;
  logic [ 2:0] TARGFLASH0HRUSER;

  // EXP0
  logic        TARGEXP0HSEL;
  logic [31:0] TARGEXP0HADDR;
  logic [ 1:0] TARGEXP0HTRANS;
  logic        TARGEXP0HWRITE;
  logic [ 2:0] TARGEXP0HSIZE;
  logic [ 2:0] TARGEXP0HBURST;
  logic [ 3:0] TARGEXP0HPROT;
  logic [ 1:0] TARGEXP0MEMATTR;
  logic        TARGEXP0EXREQ;
  logic [ 3:0] TARGEXP0HMASTER;
  logic [31:0] TARGEXP0HWDATA;
  logic        TARGEXP0HMASTLOCK;
  logic        TARGEXP0HREADYMUX;
  logic        TARGEXP0HAUSER;
  logic [ 3:0] TARGEXP0HWUSER;
  logic [31:0] TARGEXP0HRDATA;
  logic        TARGEXP0HREADYOUT;
  logic        TARGEXP0HRESP;
  logic        TARGEXP0EXRESP;
  logic [ 2:0] TARGEXP0HRUSER;

  // EXP1
  logic        TARGEXP1HSEL;
  logic [31:0] TARGEXP1HADDR;
  logic [ 1:0] TARGEXP1HTRANS;
  logic        TARGEXP1HWRITE;
  logic [ 2:0] TARGEXP1HSIZE;
  logic [ 2:0] TARGEXP1HBURST;
  logic [ 3:0] TARGEXP1HPROT;
  logic [ 1:0] TARGEXP1MEMATTR;
  logic        TARGEXP1EXREQ;
  logic [ 3:0] TARGEXP1HMASTER;
  logic [31:0] TARGEXP1HWDATA;
  logic        TARGEXP1HMASTLOCK;
  logic        TARGEXP1HREADYMUX;
  logic        TARGEXP1HAUSER;
  logic [ 3:0] TARGEXP1HWUSER;
  logic [31:0] TARGEXP1HRDATA;
  logic        TARGEXP1HREADYOUT;
  logic        TARGEXP1HRESP;
  logic        TARGEXP1EXRESP;
  logic [ 2:0] TARGEXP1HRUSER;

  // ------------------------------------------------------------
  // AHB INITIATOR EXPANSION PORTS (slaves INITEXP0/1)
  // ------------------------------------------------------------
  // Signals coming FROM Master BFM INTO DUT (DUT is Slave here)
  logic        INITEXP0HSEL;
  logic [31:0] INITEXP0HADDR;
  logic [ 1:0] INITEXP0HTRANS;
  logic        INITEXP0HWRITE;
  logic [ 2:0] INITEXP0HSIZE;
  logic [ 2:0] INITEXP0HBURST;
  logic [ 3:0] INITEXP0HPROT;
  logic [ 1:0] INITEXP0MEMATTR;
  logic        INITEXP0EXREQ;
  logic [ 3:0] INITEXP0HMASTER;
  logic [31:0] INITEXP0HWDATA;
  logic        INITEXP0HMASTLOCK;
  logic        INITEXP0HAUSER;
  logic [ 3:0] INITEXP0HWUSER;
  // Signals coming FROM DUT TO Master BFM
  logic [31:0] INITEXP0HRDATA;
  logic        INITEXP0HREADY;
  logic        INITEXP0HRESP;
  logic        INITEXP0EXRESP;
  logic [ 2:0] INITEXP0HRUSER;

  logic        INITEXP1HSEL;
  logic [31:0] INITEXP1HADDR;
  logic [ 1:0] INITEXP1HTRANS;
  logic        INITEXP1HWRITE;
  logic [ 2:0] INITEXP1HSIZE;
  logic [ 2:0] INITEXP1HBURST;
  logic [ 3:0] INITEXP1HPROT;
  logic [ 1:0] INITEXP1MEMATTR;
  logic        INITEXP1EXREQ;
  logic [ 3:0] INITEXP1HMASTER;
  logic [31:0] INITEXP1HWDATA;
  logic        INITEXP1HMASTLOCK;
  logic        INITEXP1HAUSER;
  logic [ 3:0] INITEXP1HWUSER;
  // Signals coming FROM DUT TO Master BFM
  logic [31:0] INITEXP1HRDATA;
  logic        INITEXP1HREADY;
  logic        INITEXP1HRESP;
  logic        INITEXP1EXRESP;
  logic [ 2:0] INITEXP1HRUSER;

  // ------------------------------------------------------------
  // APB TARGET EXPANSION PORTS (2..15) signals (IoT -> APB)
  // ------------------------------------------------------------
  `define APB_TARG_DECL_SIM(N) \
    logic        APBTARGEXP``N``PSEL;    \
    logic        APBTARGEXP``N``PENABLE; \
    logic [11:0] APBTARGEXP``N``PADDR;   \
    logic        APBTARGEXP``N``PWRITE;  \
    logic [31:0] APBTARGEXP``N``PWDATA;  \
    logic [3:0]  APBTARGEXP``N``PSTRB;   \
    logic [2:0]  APBTARGEXP``N``PPROT;   \
    logic [31:0] APBTARGEXP``N``PRDATA;  \
    logic        APBTARGEXP``N``PREADY;  \
    logic        APBTARGEXP``N``PSLVERR;

  `APB_TARG_DECL_SIM(2)
  `APB_TARG_DECL_SIM(3)
  `APB_TARG_DECL_SIM(4)
  `APB_TARG_DECL_SIM(5)
  `APB_TARG_DECL_SIM(6)
  `APB_TARG_DECL_SIM(7)
  `APB_TARG_DECL_SIM(8)
  `APB_TARG_DECL_SIM(9)
  `APB_TARG_DECL_SIM(10)
  `APB_TARG_DECL_SIM(11)
  `APB_TARG_DECL_SIM(12)
  `APB_TARG_DECL_SIM(13)
  `APB_TARG_DECL_SIM(14)
  `APB_TARG_DECL_SIM(15)

  // ------------------------------------------------------------
  // CPU DEBUG / TRACE / STATUS / CONFIG (tie-offs)
  // ------------------------------------------------------------
  logic         CPU0EDBGRQ;
  logic         CPU0DBGRESTART;
  logic         CPU0DBGRESTARTED;

  logic [ 31:0] CPU0HTMDHADDR;
  logic [  1:0] CPU0HTMDHTRANS;
  logic [  2:0] CPU0HTMDHSIZE;
  logic [  2:0] CPU0HTMDHBURST;
  logic [  3:0] CPU0HTMDHPROT;
  logic [ 31:0] CPU0HTMDHWDATA;
  logic         CPU0HTMDHWRITE;
  logic [ 31:0] CPU0HTMDHRDATA;
  logic         CPU0HTMDHREADY;
  logic [  1:0] CPU0HTMDHRESP;

  logic [ 47:0] CPU0TSVALUEB;
  logic [  8:0] CPU0ETMINTNUM;
  logic [  2:0] CPU0ETMINTSTAT;

  logic         CPU0HALTED;
  logic         CPU0MPUDISABLE;
  logic         CPU0SLEEPING;
  logic         CPU0SLEEPDEEP;
  logic         CPU0SLEEPHOLDREQn;
  logic         CPU0SLEEPHOLDACKn;
  logic         CPU0WAKEUP;
  logic         CPU0WICENACK;
  logic [ 66:0] CPU0WICSENSE;
  logic         CPU0WICENREQ;
  logic         CPU0SYSRESETREQ;
  logic         CPU0LOCKUP;
  logic         CPU0CDBGPWRUPREQ;
  logic         CPU0CDBGPWRUPACK;
  logic [  3:0] CPU0BRCHSTAT;

  logic [  3:1] MTXREMAP;
  logic         CPU0RXEV;
  logic         CPU0TXEV;

  logic [239:0] CPU0INTISR;
  logic         CPU0INTNMI;
  logic [  7:0] CPU0CURRPRI;
  logic [ 31:0] CPU0AUXFAULT;

  logic         APBQACTIVE;
  logic         TIMER0PCLKQACTIVE;
  logic         TIMER1PCLKQACTIVE;

  logic         CPU0DBGEN;
  logic         CPU0NIDEN;
  logic         CPU0FIXMASTERTYPE;
  logic         CPU0ISOLATEn;
  logic         CPU0RETAINn;

  logic         DFTSCANMODE;
  logic         DFTCGEN;
  logic         DFTSE;

  logic         CPU0BIGEND;

  logic         nTRST;
  logic         SWDITMS;
  logic         SWCLKTCK;
  logic         TDI;
  logic         TDO;
  logic         nTDOEN;
  logic         SWDO;
  logic         SWDOEN;
  logic         JTAGNSW;
  logic         SWV;
  logic         TRACECLK;
  logic [  3:0] TRACEDATA;
  logic         TRCENA;

  logic         CPU0GATEHCLK;

  // ------------------------------------------------------------
  // Tie-offs / default values for control / debug inputs
  // ------------------------------------------------------------
  initial begin
    CPU0EDBGRQ        = 1'b0;
    CPU0DBGRESTART    = 1'b0;
    CPU0TSVALUEB      = '0;

    CPU0MPUDISABLE    = 1'b0;
    CPU0SLEEPHOLDREQn = 1'b1;
    CPU0WICENREQ      = 1'b0;
    CPU0CDBGPWRUPACK  = 1'b1;
    MTXREMAP          = 3'b000;

    CPU0RXEV          = 1'b0;
    CPU0INTNMI        = 1'b0;
    CPU0AUXFAULT      = '0;

    CPU0DBGEN         = 1'b1;
    CPU0NIDEN         = 1'b1;
    CPU0FIXMASTERTYPE = 1'b0;
    CPU0ISOLATEn      = 1'b1;
    CPU0RETAINn       = 1'b1;

    DFTSCANMODE       = 1'b0;
    DFTCGEN           = 1'b0;
    DFTSE             = 1'b0;

    nTRST             = 1'b1;
    SWDITMS           = 1'b0;
    SWCLKTCK          = 1'b0;
    TDI               = 1'b0;
  end

  // ------------------------------------------------------------
  // Instantiate IoT Top (ALL PORTS CONNECTED)
  // ------------------------------------------------------------
  m3ds_iot_top dut (
      // Clocks / resets
      .CPU0FCLK      (CPU0FCLK),
      .CPU0HCLK      (CPU0HCLK),
      .TPIUTRACECLKIN(TPIUTRACECLKIN),
      .CPU0PORESETn  (CPU0PORESETn),
      .CPU0SYSRESETn (CPU0SYSRESETn),
      .CPU0STCLK     (1'b1),
      .CPU0STCALIB   (26'h0),

      .SRAM0HCLK(SRAM0HCLK),
      .SRAM1HCLK(SRAM1HCLK),
      .SRAM2HCLK(SRAM2HCLK),
      .SRAM3HCLK(SRAM3HCLK),

      .MTXHCLK   (MTXHCLK),
      .MTXHRESETn(MTXHRESETn),

      .AHB2APBHCLK(AHB2APBHCLK),

      .TIMER0PCLK   (TIMER0PCLK),
      .TIMER0PCLKG  (TIMER0PCLKG),
      .TIMER0PRESETn(TIMER0PRESETn),
      .TIMER1PCLK   (TIMER1PCLK),
      .TIMER1PCLKG  (TIMER1PCLKG),
      .TIMER1PRESETn(TIMER1PRESETn),

      // AHB2SRAM0 (Connected to SRAM Signals -> BFM)
      .SRAM0RDATA(SRAM0RDATA),
      .SRAM0ADDR (SRAM0ADDR),
      .SRAM0WREN (SRAM0WREN),
      .SRAM0WDATA(SRAM0WDATA),
      .SRAM0CS   (SRAM0CS),

      // AHB2SRAM1
      .SRAM1RDATA(SRAM1RDATA),
      .SRAM1ADDR (SRAM1ADDR),
      .SRAM1WREN (SRAM1WREN),
      .SRAM1WDATA(SRAM1WDATA),
      .SRAM1CS   (SRAM1CS),

      // AHB2SRAM2
      .SRAM2RDATA(SRAM2RDATA),
      .SRAM2ADDR (SRAM2ADDR),
      .SRAM2WREN (SRAM2WREN),
      .SRAM2WDATA(SRAM2WDATA),
      .SRAM2CS   (SRAM2CS),

      // AHB2SRAM3
      .SRAM3RDATA(SRAM3RDATA),
      .SRAM3ADDR (SRAM3ADDR),
      .SRAM3WREN (SRAM3WREN),
      .SRAM3WDATA(SRAM3WDATA),
      .SRAM3CS   (SRAM3CS),

      // Timer external signals
      .TIMER0EXTIN    (TIMER0EXTIN),
      .TIMER0PRIVMODEN(TIMER0PRIVMODEN),
      .TIMER1EXTIN    (TIMER1EXTIN),
      .TIMER1PRIVMODEN(TIMER1PRIVMODEN),

      .TIMER0TIMERINT(TIMER0TIMERINT),
      .TIMER1TIMERINT(TIMER1TIMERINT),

      // AHB Target FLASH0  <--- connect to flash model ports
      .TARGFLASH0HSEL     (TARGFLASH0HSEL),
      .TARGFLASH0HADDR    (TARGFLASH0HADDR),
      .TARGFLASH0HTRANS   (TARGFLASH0HTRANS),
      .TARGFLASH0HWRITE   (TARGFLASH0HWRITE),
      .TARGFLASH0HSIZE    (TARGFLASH0HSIZE),
      .TARGFLASH0HBURST   (TARGFLASH0HBURST),
      .TARGFLASH0HPROT    (TARGFLASH0HPROT),
      .TARGFLASH0MEMATTR  (TARGFLASH0MEMATTR),
      .TARGFLASH0EXREQ    (TARGFLASH0EXREQ),
      .TARGFLASH0HMASTER  (TARGFLASH0HMASTER),
      .TARGFLASH0HWDATA   (TARGFLASH0HWDATA),
      .TARGFLASH0HMASTLOCK(TARGFLASH0HMASTLOCK),
      .TARGFLASH0HREADYMUX(TARGFLASH0HREADYMUX),
      .TARGFLASH0HAUSER   (TARGFLASH0HAUSER),
      .TARGFLASH0HWUSER   (TARGFLASH0HWUSER),
      .TARGFLASH0HRDATA   (TARGFLASH0HRDATA),
      .TARGFLASH0HREADYOUT(TARGFLASH0HREADYOUT),
      .TARGFLASH0HRESP    (TARGFLASH0HRESP),
      .TARGFLASH0EXRESP   (TARGFLASH0EXRESP),
      .TARGFLASH0HRUSER   (TARGFLASH0HRUSER),

      // AHB Target EXP0 (Connected to AHB Slave BFM)
      .TARGEXP0HSEL     (TARGEXP0HSEL),
      .TARGEXP0HADDR    (TARGEXP0HADDR),
      .TARGEXP0HTRANS   (TARGEXP0HTRANS),
      .TARGEXP0HWRITE   (TARGEXP0HWRITE),
      .TARGEXP0HSIZE    (TARGEXP0HSIZE),
      .TARGEXP0HBURST   (TARGEXP0HBURST),
      .TARGEXP0HPROT    (TARGEXP0HPROT),
      .TARGEXP0MEMATTR  (TARGEXP0MEMATTR),
      .TARGEXP0EXREQ    (TARGEXP0EXREQ),
      .TARGEXP0HMASTER  (TARGEXP0HMASTER),
      .TARGEXP0HWDATA   (TARGEXP0HWDATA),
      .TARGEXP0HMASTLOCK(TARGEXP0HMASTLOCK),
      .TARGEXP0HREADYMUX(TARGEXP0HREADYMUX),
      .TARGEXP0HAUSER   (TARGEXP0HAUSER),
      .TARGEXP0HWUSER   (TARGEXP0HWUSER),
      .TARGEXP0HRDATA   (TARGEXP0HRDATA),     // Driven by BFM
      .TARGEXP0HREADYOUT(TARGEXP0HREADYOUT),  // Driven by BFM
      .TARGEXP0HRESP    (TARGEXP0HRESP),      // Driven by BFM
      .TARGEXP0EXRESP   (TARGEXP0EXRESP),     // BFM doesn't drive (tied 0)
      .TARGEXP0HRUSER   (TARGEXP0HRUSER),     // BFM doesn't drive (tied 0)

      // AHB Target EXP1 (Connected to AHB Slave BFM)
      .TARGEXP1HSEL     (TARGEXP1HSEL),
      .TARGEXP1HADDR    (TARGEXP1HADDR),
      .TARGEXP1HTRANS   (TARGEXP1HTRANS),
      .TARGEXP1HWRITE   (TARGEXP1HWRITE),
      .TARGEXP1HSIZE    (TARGEXP1HSIZE),
      .TARGEXP1HBURST   (TARGEXP1HBURST),
      .TARGEXP1HPROT    (TARGEXP1HPROT),
      .TARGEXP1MEMATTR  (TARGEXP1MEMATTR),
      .TARGEXP1EXREQ    (TARGEXP1EXREQ),
      .TARGEXP1HMASTER  (TARGEXP1HMASTER),
      .TARGEXP1HWDATA   (TARGEXP1HWDATA),
      .TARGEXP1HMASTLOCK(TARGEXP1HMASTLOCK),
      .TARGEXP1HREADYMUX(TARGEXP1HREADYMUX),
      .TARGEXP1HAUSER   (TARGEXP1HAUSER),
      .TARGEXP1HWUSER   (TARGEXP1HWUSER),
      .TARGEXP1HRDATA   (TARGEXP1HRDATA),     // Driven by BFM
      .TARGEXP1HREADYOUT(TARGEXP1HREADYOUT),  // Driven by BFM
      .TARGEXP1HRESP    (TARGEXP1HRESP),      // Driven by BFM
      .TARGEXP1EXRESP   (TARGEXP1EXRESP),     // Tied 0
      .TARGEXP1HRUSER   (TARGEXP1HRUSER),     // Tied 0

      // AHB Initiator Expansion 0 (DUT is Slave, BFM is Master)
      .INITEXP0HSEL     (INITEXP0HSEL),       // In (from BFM)
      .INITEXP0HADDR    (INITEXP0HADDR),      // In
      .INITEXP0HTRANS   (INITEXP0HTRANS),     // In
      .INITEXP0HWRITE   (INITEXP0HWRITE),     // In
      .INITEXP0HSIZE    (INITEXP0HSIZE),      // In
      .INITEXP0HBURST   (INITEXP0HBURST),     // In
      .INITEXP0HPROT    (INITEXP0HPROT),      // In
      .INITEXP0MEMATTR  (INITEXP0MEMATTR),    // In (Tie)
      .INITEXP0EXREQ    (INITEXP0EXREQ),      // In (Tie)
      .INITEXP0HMASTER  (INITEXP0HMASTER),    // In (Tie)
      .INITEXP0HWDATA   (INITEXP0HWDATA),     // In
      .INITEXP0HMASTLOCK(INITEXP0HMASTLOCK),  // In (Tie)
      .INITEXP0HAUSER   (INITEXP0HAUSER),     // In (Tie)
      .INITEXP0HWUSER   (INITEXP0HWUSER),     // In (Tie)
      .INITEXP0HRDATA   (INITEXP0HRDATA),     // Out (to BFM)
      .INITEXP0HREADY   (INITEXP0HREADY),     // Out (to BFM)
      .INITEXP0HRESP    (INITEXP0HRESP),      // Out (to BFM)
      .INITEXP0EXRESP   (INITEXP0EXRESP),     // Out
      .INITEXP0HRUSER   (INITEXP0HRUSER),     // Out

      // AHB Initiator Expansion 1 (DUT is Slave, BFM is Master)
      .INITEXP1HSEL     (INITEXP1HSEL),
      .INITEXP1HADDR    (INITEXP1HADDR),
      .INITEXP1HTRANS   (INITEXP1HTRANS),
      .INITEXP1HWRITE   (INITEXP1HWRITE),
      .INITEXP1HSIZE    (INITEXP1HSIZE),
      .INITEXP1HBURST   (INITEXP1HBURST),
      .INITEXP1HPROT    (INITEXP1HPROT),
      .INITEXP1MEMATTR  (INITEXP1MEMATTR),
      .INITEXP1EXREQ    (INITEXP1EXREQ),
      .INITEXP1HMASTER  (INITEXP1HMASTER),
      .INITEXP1HWDATA   (INITEXP1HWDATA),
      .INITEXP1HMASTLOCK(INITEXP1HMASTLOCK),
      .INITEXP1HAUSER   (INITEXP1HAUSER),
      .INITEXP1HWUSER   (INITEXP1HWUSER),
      .INITEXP1HRDATA   (INITEXP1HRDATA),
      .INITEXP1HREADY   (INITEXP1HREADY),
      .INITEXP1HRESP    (INITEXP1HRESP),
      .INITEXP1EXRESP   (INITEXP1EXRESP),
      .INITEXP1HRUSER   (INITEXP1HRUSER),

      // APB Target Expansion 2..15
      .APBTARGEXP2PSEL   (APBTARGEXP2PSEL),
      .APBTARGEXP2PENABLE(APBTARGEXP2PENABLE),
      .APBTARGEXP2PADDR  (APBTARGEXP2PADDR),
      .APBTARGEXP2PWRITE (APBTARGEXP2PWRITE),
      .APBTARGEXP2PWDATA (APBTARGEXP2PWDATA),
      .APBTARGEXP2PRDATA (APBTARGEXP2PRDATA),
      .APBTARGEXP2PREADY (APBTARGEXP2PREADY),
      .APBTARGEXP2PSLVERR(APBTARGEXP2PSLVERR),
      .APBTARGEXP2PSTRB  (APBTARGEXP2PSTRB),
      .APBTARGEXP2PPROT  (APBTARGEXP2PPROT),

      .APBTARGEXP3PSEL   (APBTARGEXP3PSEL),
      .APBTARGEXP3PENABLE(APBTARGEXP3PENABLE),
      .APBTARGEXP3PADDR  (APBTARGEXP3PADDR),
      .APBTARGEXP3PWRITE (APBTARGEXP3PWRITE),
      .APBTARGEXP3PWDATA (APBTARGEXP3PWDATA),
      .APBTARGEXP3PRDATA (32'h0),
      .APBTARGEXP3PREADY (1'b1),
      .APBTARGEXP3PSLVERR(1'b0),
      .APBTARGEXP3PSTRB  (APBTARGEXP3PSTRB),
      .APBTARGEXP3PPROT  (APBTARGEXP3PPROT),

      .APBTARGEXP4PSEL   (APBTARGEXP4PSEL),
      .APBTARGEXP4PENABLE(APBTARGEXP4PENABLE),
      .APBTARGEXP4PADDR  (APBTARGEXP4PADDR),
      .APBTARGEXP4PWRITE (APBTARGEXP4PWRITE),
      .APBTARGEXP4PWDATA (APBTARGEXP4PWDATA),
      .APBTARGEXP4PRDATA (APBTARGEXP4PRDATA),
      .APBTARGEXP4PREADY (APBTARGEXP4PREADY),
      .APBTARGEXP4PSLVERR(APBTARGEXP4PSLVERR),
      .APBTARGEXP4PSTRB  (APBTARGEXP4PSTRB),
      .APBTARGEXP4PPROT  (APBTARGEXP4PPROT),

      .APBTARGEXP5PSEL   (APBTARGEXP5PSEL),
      .APBTARGEXP5PENABLE(APBTARGEXP5PENABLE),
      .APBTARGEXP5PADDR  (APBTARGEXP5PADDR),
      .APBTARGEXP5PWRITE (APBTARGEXP5PWRITE),
      .APBTARGEXP5PWDATA (APBTARGEXP5PWDATA),
      .APBTARGEXP5PRDATA (APBTARGEXP5PRDATA),
      .APBTARGEXP5PREADY (APBTARGEXP5PREADY),
      .APBTARGEXP5PSLVERR(APBTARGEXP5PSLVERR),
      .APBTARGEXP5PSTRB  (APBTARGEXP5PSTRB),
      .APBTARGEXP5PPROT  (APBTARGEXP5PPROT),

      .APBTARGEXP6PSEL   (APBTARGEXP6PSEL),
      .APBTARGEXP6PENABLE(APBTARGEXP6PENABLE),
      .APBTARGEXP6PADDR  (APBTARGEXP6PADDR),
      .APBTARGEXP6PWRITE (APBTARGEXP6PWRITE),
      .APBTARGEXP6PWDATA (APBTARGEXP6PWDATA),
      .APBTARGEXP6PRDATA (APBTARGEXP6PRDATA),
      .APBTARGEXP6PREADY (APBTARGEXP6PREADY),
      .APBTARGEXP6PSLVERR(APBTARGEXP6PSLVERR),
      .APBTARGEXP6PSTRB  (APBTARGEXP6PSTRB),
      .APBTARGEXP6PPROT  (APBTARGEXP6PPROT),

      .APBTARGEXP7PSEL   (APBTARGEXP7PSEL),
      .APBTARGEXP7PENABLE(APBTARGEXP7PENABLE),
      .APBTARGEXP7PADDR  (APBTARGEXP7PADDR),
      .APBTARGEXP7PWRITE (APBTARGEXP7PWRITE),
      .APBTARGEXP7PWDATA (APBTARGEXP7PWDATA),
      .APBTARGEXP7PRDATA (APBTARGEXP7PRDATA),
      .APBTARGEXP7PREADY (APBTARGEXP7PREADY),
      .APBTARGEXP7PSLVERR(APBTARGEXP7PSLVERR),
      .APBTARGEXP7PSTRB  (APBTARGEXP7PSTRB),
      .APBTARGEXP7PPROT  (APBTARGEXP7PPROT),

      .APBTARGEXP8PSEL   (APBTARGEXP8PSEL),
      .APBTARGEXP8PENABLE(APBTARGEXP8PENABLE),
      .APBTARGEXP8PADDR  (APBTARGEXP8PADDR),
      .APBTARGEXP8PWRITE (APBTARGEXP8PWRITE),
      .APBTARGEXP8PWDATA (APBTARGEXP8PWDATA),
      .APBTARGEXP8PRDATA (APBTARGEXP8PRDATA),
      .APBTARGEXP8PREADY (APBTARGEXP8PREADY),
      .APBTARGEXP8PSLVERR(APBTARGEXP8PSLVERR),
      .APBTARGEXP8PSTRB  (APBTARGEXP8PSTRB),
      .APBTARGEXP8PPROT  (APBTARGEXP8PPROT),

      // APB9,10 used by flash config
      .APBTARGEXP9PSEL   (APBTARGEXP9PSEL),
      .APBTARGEXP9PENABLE(APBTARGEXP9PENABLE),
      .APBTARGEXP9PADDR  (APBTARGEXP9PADDR),
      .APBTARGEXP9PWRITE (APBTARGEXP9PWRITE),
      .APBTARGEXP9PWDATA (APBTARGEXP9PWDATA),
      .APBTARGEXP9PRDATA (32'h0),
      .APBTARGEXP9PREADY (1'b1),
      .APBTARGEXP9PSLVERR(1'b0),
      .APBTARGEXP9PSTRB  (APBTARGEXP9PSTRB),
      .APBTARGEXP9PPROT  (APBTARGEXP9PPROT),

      .APBTARGEXP10PSEL   (APBTARGEXP10PSEL),
      .APBTARGEXP10PENABLE(APBTARGEXP10PENABLE),
      .APBTARGEXP10PADDR  (APBTARGEXP10PADDR),
      .APBTARGEXP10PWRITE (APBTARGEXP10PWRITE),
      .APBTARGEXP10PWDATA (APBTARGEXP10PWDATA),
      .APBTARGEXP10PRDATA (32'h0),
      .APBTARGEXP10PREADY (1'b1),
      .APBTARGEXP10PSLVERR(1'b0),
      .APBTARGEXP10PSTRB  (APBTARGEXP10PSTRB),
      .APBTARGEXP10PPROT  (APBTARGEXP10PPROT),

      // APB[11..15]
      .APBTARGEXP11PSEL   (APBTARGEXP11PSEL),
      .APBTARGEXP11PENABLE(APBTARGEXP11PENABLE),
      .APBTARGEXP11PADDR  (APBTARGEXP11PADDR),
      .APBTARGEXP11PWRITE (APBTARGEXP11PWRITE),
      .APBTARGEXP11PWDATA (APBTARGEXP11PWDATA),
      .APBTARGEXP11PRDATA (APBTARGEXP11PRDATA),
      .APBTARGEXP11PREADY (APBTARGEXP11PREADY),
      .APBTARGEXP11PSLVERR(APBTARGEXP11PSLVERR),
      .APBTARGEXP11PSTRB  (APBTARGEXP11PSTRB),
      .APBTARGEXP11PPROT  (APBTARGEXP11PPROT),

      .APBTARGEXP12PSEL   (APBTARGEXP12PSEL),
      .APBTARGEXP12PENABLE(APBTARGEXP12PENABLE),
      .APBTARGEXP12PADDR  (APBTARGEXP12PADDR),
      .APBTARGEXP12PWRITE (APBTARGEXP12PWRITE),
      .APBTARGEXP12PWDATA (APBTARGEXP12PWDATA),
      .APBTARGEXP12PRDATA (APBTARGEXP12PRDATA),
      .APBTARGEXP12PREADY (APBTARGEXP12PREADY),
      .APBTARGEXP12PSLVERR(APBTARGEXP12PSLVERR),
      .APBTARGEXP12PSTRB  (APBTARGEXP12PSTRB),
      .APBTARGEXP12PPROT  (APBTARGEXP12PPROT),

      .APBTARGEXP13PSEL   (APBTARGEXP13PSEL),
      .APBTARGEXP13PENABLE(APBTARGEXP13PENABLE),
      .APBTARGEXP13PADDR  (APBTARGEXP13PADDR),
      .APBTARGEXP13PWRITE (APBTARGEXP13PWRITE),
      .APBTARGEXP13PWDATA (APBTARGEXP13PWDATA),
      .APBTARGEXP13PRDATA (APBTARGEXP13PRDATA),
      .APBTARGEXP13PREADY (APBTARGEXP13PREADY),
      .APBTARGEXP13PSLVERR(APBTARGEXP13PSLVERR),
      .APBTARGEXP13PSTRB  (APBTARGEXP13PSTRB),
      .APBTARGEXP13PPROT  (APBTARGEXP13PPROT),

      .APBTARGEXP14PSEL   (APBTARGEXP14PSEL),
      .APBTARGEXP14PENABLE(APBTARGEXP14PENABLE),
      .APBTARGEXP14PADDR  (APBTARGEXP14PADDR),
      .APBTARGEXP14PWRITE (APBTARGEXP14PWRITE),
      .APBTARGEXP14PWDATA (APBTARGEXP14PWDATA),
      .APBTARGEXP14PRDATA (APBTARGEXP14PRDATA),
      .APBTARGEXP14PREADY (APBTARGEXP14PREADY),
      .APBTARGEXP14PSLVERR(APBTARGEXP14PSLVERR),
      .APBTARGEXP14PSTRB  (APBTARGEXP14PSTRB),
      .APBTARGEXP14PPROT  (APBTARGEXP14PPROT),

      .APBTARGEXP15PSEL   (APBTARGEXP15PSEL),
      .APBTARGEXP15PENABLE(APBTARGEXP15PENABLE),
      .APBTARGEXP15PADDR  (APBTARGEXP15PADDR),
      .APBTARGEXP15PWRITE (APBTARGEXP15PWRITE),
      .APBTARGEXP15PWDATA (APBTARGEXP15PWDATA),
      .APBTARGEXP15PRDATA (APBTARGEXP15PRDATA),
      .APBTARGEXP15PREADY (APBTARGEXP15PREADY),
      .APBTARGEXP15PSLVERR(APBTARGEXP15PSLVERR),
      .APBTARGEXP15PSTRB  (APBTARGEXP15PSTRB),
      .APBTARGEXP15PPROT  (APBTARGEXP15PPROT),

      // CPU debug
      .CPU0EDBGRQ      (CPU0EDBGRQ),
      .CPU0DBGRESTART  (CPU0DBGRESTART),
      .CPU0DBGRESTARTED(CPU0DBGRESTARTED),
      .CPU0HTMDHADDR   (CPU0HTMDHADDR),
      .CPU0HTMDHTRANS  (CPU0HTMDHTRANS),
      .CPU0HTMDHSIZE   (CPU0HTMDHSIZE),
      .CPU0HTMDHBURST  (CPU0HTMDHBURST),
      .CPU0HTMDHPROT   (CPU0HTMDHPROT),
      .CPU0HTMDHWDATA  (CPU0HTMDHWDATA),
      .CPU0HTMDHWRITE  (CPU0HTMDHWRITE),
      .CPU0HTMDHRDATA  (CPU0HTMDHRDATA),
      .CPU0HTMDHREADY  (CPU0HTMDHREADY),
      .CPU0HTMDHRESP   (CPU0HTMDHRESP),

      // CPU trace ext
      .CPU0TSVALUEB  (CPU0TSVALUEB),
      .CPU0ETMINTNUM (CPU0ETMINTNUM),
      .CPU0ETMINTSTAT(CPU0ETMINTSTAT),

      // CPU control / status / config
      .CPU0HALTED       (CPU0HALTED),
      .CPU0MPUDISABLE   (CPU0MPUDISABLE),
      .CPU0SLEEPING     (CPU0SLEEPING),
      .CPU0SLEEPDEEP    (CPU0SLEEPDEEP),
      .CPU0SLEEPHOLDREQn(CPU0SLEEPHOLDREQn),
      .CPU0SLEEPHOLDACKn(CPU0SLEEPHOLDACKn),
      .CPU0WAKEUP       (CPU0WAKEUP),
      .CPU0WICENACK     (CPU0WICENACK),
      .CPU0WICSENSE     (CPU0WICSENSE),
      .CPU0WICENREQ     (CPU0WICENREQ),
      .CPU0SYSRESETREQ  (CPU0SYSRESETREQ),
      .CPU0LOCKUP       (CPU0LOCKUP),
      .CPU0CDBGPWRUPREQ (CPU0CDBGPWRUPREQ),
      .CPU0CDBGPWRUPACK (CPU0CDBGPWRUPACK),
      .CPU0BRCHSTAT     (CPU0BRCHSTAT),

      // CSS config
      .MTXREMAP(MTXREMAP),

      // Events
      .CPU0RXEV(CPU0RXEV),
      .CPU0TXEV(CPU0TXEV),

      // Interrupts from system
      .CPU0INTISR  (CPU0INTISR),
      .CPU0INTNMI  (CPU0INTNMI),
      .CPU0CURRPRI (CPU0CURRPRI),
      .CPU0AUXFAULT(CPU0AUXFAULT),

      // PMU interface
      .APBQACTIVE       (APBQACTIVE),
      .TIMER0PCLKQACTIVE(TIMER0PCLKQACTIVE),
      .TIMER1PCLKQACTIVE(TIMER1PCLKQACTIVE),

      // Secure debug control
      .CPU0DBGEN        (CPU0DBGEN),
      .CPU0NIDEN        (CPU0NIDEN),
      .CPU0FIXMASTERTYPE(CPU0FIXMASTERTYPE),
      .CPU0ISOLATEn     (CPU0ISOLATEn),
      .CPU0RETAINn      (CPU0RETAINn),

      // Test control
      .DFTSCANMODE(DFTSCANMODE),
      .DFTCGEN    (DFTCGEN),
      .DFTSE      (DFTSE),

      // Status
      .CPU0BIGEND(CPU0BIGEND),

      // Debug & Trace (JTAG/SWD/TPIU)
      .nTRST    (nTRST),
      .SWDITMS  (SWDITMS),
      .SWCLKTCK (SWCLKTCK),
      .TDI      (TDI),
      .TDO      (TDO),
      .nTDOEN   (nTDOEN),
      .SWDO     (SWDO),
      .SWDOEN   (SWDOEN),
      .JTAGNSW  (JTAGNSW),
      .SWV      (SWV),
      .TRACECLK (TRACECLK),
      .TRACEDATA(TRACEDATA),
      .TRCENA   (TRCENA),

      // Clock gating ctrl
      .CPU0GATEHCLK(CPU0GATEHCLK)
  );

  // ------------------------------------------------------------
  // Instantiate flash model (unchanged)
  // ------------------------------------------------------------
  m3ds_simple_flash u_m3ds_simple_flash (
      .hclk   (MTXHCLK),
      .hresetn(MTXHRESETn),

      .hsel_i     (TARGFLASH0HSEL),
      .haddr_i    (TARGFLASH0HADDR),
      .htrans_i   (TARGFLASH0HTRANS),
      .hwrite_i   (TARGFLASH0HWRITE),
      .hsize_i    (TARGFLASH0HSIZE),
      .hburst_i   (TARGFLASH0HBURST),
      .hprot_i    (TARGFLASH0HPROT),
      .memattr_i  (TARGFLASH0MEMATTR),
      .exreq_i    (TARGFLASH0EXREQ),
      .hmaster_i  (TARGFLASH0HMASTER),
      .hwdata_i   (TARGFLASH0HWDATA),
      .hmastlock_i(TARGFLASH0HMASTLOCK),
      .hreadymux_i(TARGFLASH0HREADYMUX),
      .hauser_i   (TARGFLASH0HAUSER),
      .hwuser_i   (TARGFLASH0HWUSER),

      .hrdata_o   (TARGFLASH0HRDATA),
      .hreadyout_o(TARGFLASH0HREADYOUT),
      .hresp_o    (TARGFLASH0HRESP),
      .exresp_o   (TARGFLASH0EXRESP),
      .hruser_o   (TARGFLASH0HRUSER),

      .flash_err_o(CPU0INTISR[32]),
      .flash_int_o(CPU0INTISR[33]),

      .pclk (PCLK),
      .pclkg(PCLKG),

      .apbtargexp3psel_i   (APBTARGEXP3PSEL),
      .apbtargexp3penable_i(APBTARGEXP3PENABLE),
      .apbtargexp3paddr_i  (APBTARGEXP3PADDR),
      .apbtargexp3pwrite_i (APBTARGEXP3PWRITE),
      .apbtargexp3pwdata_i (APBTARGEXP3PWDATA),
      .apbtargexp3pstrb_i  (APBTARGEXP3PSTRB),
      .apbtargexp3pprot_i  (APBTARGEXP3PPROT),

      .apbtargexp9psel_i   (APBTARGEXP9PSEL),
      .apbtargexp9penable_i(APBTARGEXP9PENABLE),
      .apbtargexp9paddr_i  (APBTARGEXP9PADDR),
      .apbtargexp9pwrite_i (APBTARGEXP9PWRITE),
      .apbtargexp9pwdata_i (APBTARGEXP9PWDATA),
      .apbtargexp9pstrb_i  (APBTARGEXP9PSTRB),
      .apbtargexp9pprot_i  (APBTARGEXP9PPROT),

      .apbtargexp10psel_i   (APBTARGEXP10PSEL),
      .apbtargexp10penable_i(APBTARGEXP10PENABLE),
      .apbtargexp10paddr_i  (APBTARGEXP10PADDR),
      .apbtargexp10pwrite_i (APBTARGEXP10PWRITE),
      .apbtargexp10pwdata_i (APBTARGEXP10PWDATA),
      .apbtargexp10pstrb_i  (APBTARGEXP10PSTRB),
      .apbtargexp10pprot_i  (APBTARGEXP10PPROT)
  );

  // ========================================================================
  // SRAM BFM INTEGRATION
  // ========================================================================

  // 1. Instantiate Interfaces
  sram_if sram0_if (SRAM0HCLK);
  sram_if sram1_if (SRAM1HCLK);
  sram_if sram2_if (SRAM2HCLK);
  sram_if sram3_if (SRAM3HCLK);

  // 2. Connect Interfaces to DUT Signals
  // SRAM0
  assign sram0_if.CS    = SRAM0CS;
  assign sram0_if.ADDR  = SRAM0ADDR;
  assign sram0_if.WREN  = SRAM0WREN;
  assign sram0_if.WDATA = SRAM0WDATA;
  assign SRAM0RDATA     = sram0_if.RDATA;

  // SRAM1
  assign sram1_if.CS    = SRAM1CS;
  assign sram1_if.ADDR  = SRAM1ADDR;
  assign sram1_if.WREN  = SRAM1WREN;
  assign sram1_if.WDATA = SRAM1WDATA;
  assign SRAM1RDATA     = sram1_if.RDATA;

  // SRAM2
  assign sram2_if.CS    = SRAM2CS;
  assign sram2_if.ADDR  = SRAM2ADDR;
  assign sram2_if.WREN  = SRAM2WREN;
  assign sram2_if.WDATA = SRAM2WDATA;
  assign SRAM2RDATA     = sram2_if.RDATA;

  // SRAM3
  assign sram3_if.CS    = SRAM3CS;
  assign sram3_if.ADDR  = SRAM3ADDR;
  assign sram3_if.WREN  = SRAM3WREN;
  assign sram3_if.WDATA = SRAM3WDATA;
  assign SRAM3RDATA     = sram3_if.RDATA;

  // 3. Declare Agents
  sram_slave_agent sram0_agent;
  sram_slave_agent sram1_agent;
  sram_slave_agent sram2_agent;
  sram_slave_agent sram3_agent;


  // ========================================================================
  // AHB SLAVE BFM INTEGRATION (Target Expansion Ports 0 & 1)
  // ========================================================================

  // 1. Instantiate Interfaces
  ahb_if ahb_exp0_if (
      MTXHCLK,
      MTXHRESETn
  );
  ahb_if ahb_exp1_if (
      MTXHCLK,
      MTXHRESETn
  );

  // 2. Connect Interfaces to DUT Signals
  // Note: DUT drives "HREADYMUX" (system ready) to Slave Input "HREADY".
  //       Slave Drives "HREADYOUT" back to DUT.

  // EXP0 Connections
  assign ahb_exp0_if.HSEL   = TARGEXP0HSEL;
  assign ahb_exp0_if.HADDR  = TARGEXP0HADDR;
  assign ahb_exp0_if.HWRITE = TARGEXP0HWRITE;
  assign ahb_exp0_if.HTRANS = TARGEXP0HTRANS;
  assign ahb_exp0_if.HSIZE  = TARGEXP0HSIZE;
  assign ahb_exp0_if.HBURST = TARGEXP0HBURST;
  assign ahb_exp0_if.HPROT  = TARGEXP0HPROT;
  assign ahb_exp0_if.HWDATA = TARGEXP0HWDATA;
  assign ahb_exp0_if.HREADY = TARGEXP0HREADYMUX;  // Input to Slave

  assign TARGEXP0HREADYOUT  = ahb_exp0_if.HREADYOUT;  // Output from Slave
  assign TARGEXP0HRDATA     = ahb_exp0_if.HRDATA;
  assign TARGEXP0HRESP      = ahb_exp0_if.HRESP;

  // Tie-off unsupported DUT sideband inputs for EXP0 (BFM doesn't drive these)
  assign TARGEXP0EXRESP     = 1'b0;
  assign TARGEXP0HRUSER     = 3'b000;

  // EXP1 Connections
  assign ahb_exp1_if.HSEL   = TARGEXP1HSEL;
  assign ahb_exp1_if.HADDR  = TARGEXP1HADDR;
  assign ahb_exp1_if.HWRITE = TARGEXP1HWRITE;
  assign ahb_exp1_if.HTRANS = TARGEXP1HTRANS;
  assign ahb_exp1_if.HSIZE  = TARGEXP1HSIZE;
  assign ahb_exp1_if.HBURST = TARGEXP1HBURST;
  assign ahb_exp1_if.HPROT  = TARGEXP1HPROT;
  assign ahb_exp1_if.HWDATA = TARGEXP1HWDATA;
  assign ahb_exp1_if.HREADY = TARGEXP1HREADYMUX;  // Input to Slave

  assign TARGEXP1HREADYOUT  = ahb_exp1_if.HREADYOUT;  // Output from Slave
  assign TARGEXP1HRDATA     = ahb_exp1_if.HRDATA;
  assign TARGEXP1HRESP      = ahb_exp1_if.HRESP;

  // Tie-off unsupported DUT sideband inputs for EXP1
  assign TARGEXP1EXRESP     = 1'b0;
  assign TARGEXP1HRUSER     = 3'b000;

  // 3. Declare Agents
  ahb_slave_agent ahb_slave_exp0;
  ahb_slave_agent ahb_slave_exp1;


  // ========================================================================
  // AHB MASTER BFM INTEGRATION (Initiator Expansion Ports 0 & 1)
  // ========================================================================

  // 1. Instantiate Interfaces (Mode: MASTER)
  ahb_if ahb_init0_if (
      MTXHCLK,
      MTXHRESETn
  );
  ahb_if ahb_init1_if (
      MTXHCLK,
      MTXHRESETn
  );

  // 2. Connect Interfaces to DUT Signals
  // Note: DUT is the SLAVE here. BFM is the MASTER.

  // INITEXP0 (BFM Drives Addr/Ctrl, DUT Drives Ready/Data)
  assign INITEXP0HADDR       = ahb_init0_if.HADDR;
  assign INITEXP0HWRITE      = ahb_init0_if.HWRITE;
  assign INITEXP0HTRANS      = ahb_init0_if.HTRANS;
  assign INITEXP0HSIZE       = ahb_init0_if.HSIZE;
  assign INITEXP0HBURST      = ahb_init0_if.HBURST;
  assign INITEXP0HPROT       = ahb_init0_if.HPROT;
  assign INITEXP0HWDATA      = ahb_init0_if.HWDATA;
  // BFM Master doesn't drive HSEL directly in this point-to-point (or tie high if always selected)
  assign INITEXP0HSEL        = 1'b1;
  // DUT tie-offs for signals BFM doesn't support
  assign INITEXP0MEMATTR     = 2'b00;
  assign INITEXP0EXREQ       = 1'b0;
  assign INITEXP0HMASTER     = 4'b0000;
  assign INITEXP0HMASTLOCK   = 1'b0;
  assign INITEXP0HAUSER      = 1'b0;
  assign INITEXP0HWUSER      = 4'b0000;

  // Inputs to BFM Master from DUT
  assign ahb_init0_if.HREADY = INITEXP0HREADY;
  assign ahb_init0_if.HRDATA = INITEXP0HRDATA;
  assign ahb_init0_if.HRESP  = INITEXP0HRESP;

  // INITEXP1
  assign INITEXP1HADDR       = ahb_init1_if.HADDR;
  assign INITEXP1HWRITE      = ahb_init1_if.HWRITE;
  assign INITEXP1HTRANS      = ahb_init1_if.HTRANS;
  assign INITEXP1HSIZE       = ahb_init1_if.HSIZE;
  assign INITEXP1HBURST      = ahb_init1_if.HBURST;
  assign INITEXP1HPROT       = ahb_init1_if.HPROT;
  assign INITEXP1HWDATA      = ahb_init1_if.HWDATA;
  assign INITEXP1HSEL        = 1'b1;

  assign INITEXP1MEMATTR     = 2'b00;
  assign INITEXP1EXREQ       = 1'b0;
  assign INITEXP1HMASTER     = 4'b0000;
  assign INITEXP1HMASTLOCK   = 1'b0;
  assign INITEXP1HAUSER      = 1'b0;
  assign INITEXP1HWUSER      = 4'b0000;

  assign ahb_init1_if.HREADY = INITEXP1HREADY;
  assign ahb_init1_if.HRDATA = INITEXP1HRDATA;
  assign ahb_init1_if.HRESP  = INITEXP1HRESP;

  // 3. Declare Agents
  ahb_master_agent ahb_master_init0;
  ahb_master_agent ahb_master_init1;


  // ========================================================================
  // APB SLAVE BFMs (Existing Integration)
  // ========================================================================
  apb_if apb2 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb4 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb5 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb6 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb7 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb8 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb11 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb12 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb13 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb14 (
      PCLK,
      CPU0PORESETn
  );
  apb_if apb15 (
      PCLK,
      CPU0PORESETn
  );

  apb_slave_agent slave2;
  apb_slave_agent slave4;
  apb_slave_agent slave5;
  apb_slave_agent slave6;
  apb_slave_agent slave7;
  apb_slave_agent slave8;
  apb_slave_agent slave11;
  apb_slave_agent slave12;
  apb_slave_agent slave13;
  apb_slave_agent slave14;
  apb_slave_agent slave15;

  assign apb2.PSEL    = APBTARGEXP2PSEL;
  assign apb2.PENABLE = APBTARGEXP2PENABLE;
  assign apb2.PWRITE  = APBTARGEXP2PWRITE;
  assign apb2.PADDR   = {APBTARGEXP2PADDR, 2'b00};
  assign apb2.PWDATA  = APBTARGEXP2PWDATA;
  assign apb2.PSTRB   = APBTARGEXP2PSTRB;
  assign apb2.PPROT   = APBTARGEXP2PPROT;
  assign APBTARGEXP2PRDATA  = apb2.PRDATA;
  assign APBTARGEXP2PREADY  = apb2.PREADY;
  assign APBTARGEXP2PSLVERR = apb2.PSLVERR;

  assign apb4.PSEL    = APBTARGEXP4PSEL;
  assign apb4.PENABLE = APBTARGEXP4PENABLE;
  assign apb4.PWRITE  = APBTARGEXP4PWRITE;
  assign apb4.PADDR   = {APBTARGEXP4PADDR, 2'b00};
  assign apb4.PWDATA  = APBTARGEXP4PWDATA;
  assign apb4.PSTRB   = APBTARGEXP4PSTRB;
  assign apb4.PPROT   = APBTARGEXP4PPROT;
  assign APBTARGEXP4PRDATA  = apb4.PRDATA;
  assign APBTARGEXP4PREADY  = apb4.PREADY;
  assign APBTARGEXP4PSLVERR = apb4.PSLVERR;

  assign apb5.PSEL    = APBTARGEXP5PSEL;
  assign apb5.PENABLE = APBTARGEXP5PENABLE;
  assign apb5.PWRITE  = APBTARGEXP5PWRITE;
  assign apb5.PADDR   = {APBTARGEXP5PADDR, 2'b00};
  assign apb5.PWDATA  = APBTARGEXP5PWDATA;
  assign apb5.PSTRB   = APBTARGEXP5PSTRB;
  assign apb5.PPROT   = APBTARGEXP5PPROT;
  assign APBTARGEXP5PRDATA  = apb5.PRDATA;
  assign APBTARGEXP5PREADY  = apb5.PREADY;
  assign APBTARGEXP5PSLVERR = apb5.PSLVERR;

  assign apb6.PSEL    = APBTARGEXP6PSEL;
  assign apb6.PENABLE = APBTARGEXP6PENABLE;
  assign apb6.PWRITE  = APBTARGEXP6PWRITE;
  assign apb6.PADDR   = {APBTARGEXP6PADDR, 2'b00};
  assign apb6.PWDATA  = APBTARGEXP6PWDATA;
  assign apb6.PSTRB   = APBTARGEXP6PSTRB;
  assign apb6.PPROT   = APBTARGEXP6PPROT;
  assign APBTARGEXP6PRDATA  = apb6.PRDATA;
  assign APBTARGEXP6PREADY  = apb6.PREADY;
  assign APBTARGEXP6PSLVERR = apb6.PSLVERR;

  assign apb7.PSEL    = APBTARGEXP7PSEL;
  assign apb7.PENABLE = APBTARGEXP7PENABLE;
  assign apb7.PWRITE  = APBTARGEXP7PWRITE;
  assign apb7.PADDR   = {APBTARGEXP7PADDR, 2'b00};
  assign apb7.PWDATA  = APBTARGEXP7PWDATA;
  assign apb7.PSTRB   = APBTARGEXP7PSTRB;
  assign apb7.PPROT   = APBTARGEXP7PPROT;
  assign APBTARGEXP7PRDATA  = apb7.PRDATA;
  assign APBTARGEXP7PREADY  = apb7.PREADY;
  assign APBTARGEXP7PSLVERR = apb7.PSLVERR;

  assign apb8.PSEL    = APBTARGEXP8PSEL;
  assign apb8.PENABLE = APBTARGEXP8PENABLE;
  assign apb8.PWRITE  = APBTARGEXP8PWRITE;
  assign apb8.PADDR   = {APBTARGEXP8PADDR, 2'b00};
  assign apb8.PWDATA  = APBTARGEXP8PWDATA;
  assign apb8.PSTRB   = APBTARGEXP8PSTRB;
  assign apb8.PPROT   = APBTARGEXP8PPROT;
  assign APBTARGEXP8PRDATA  = apb8.PRDATA;
  assign APBTARGEXP8PREADY  = apb8.PREADY;
  assign APBTARGEXP8PSLVERR = apb8.PSLVERR;

  assign apb11.PSEL    = APBTARGEXP11PSEL;
  assign apb11.PENABLE = APBTARGEXP11PENABLE;
  assign apb11.PWRITE  = APBTARGEXP11PWRITE;
  assign apb11.PADDR   = {APBTARGEXP11PADDR, 2'b00};
  assign apb11.PWDATA  = APBTARGEXP11PWDATA;
  assign apb11.PSTRB   = APBTARGEXP11PSTRB;
  assign apb11.PPROT   = APBTARGEXP11PPROT;
  assign APBTARGEXP11PRDATA  = apb11.PRDATA;
  assign APBTARGEXP11PREADY  = apb11.PREADY;
  assign APBTARGEXP11PSLVERR = apb11.PSLVERR;

  assign apb12.PSEL    = APBTARGEXP12PSEL;
  assign apb12.PENABLE = APBTARGEXP12PENABLE;
  assign apb12.PWRITE  = APBTARGEXP12PWRITE;
  assign apb12.PADDR   = {APBTARGEXP12PADDR, 2'b00};
  assign apb12.PWDATA  = APBTARGEXP12PWDATA;
  assign apb12.PSTRB   = APBTARGEXP12PSTRB;
  assign apb12.PPROT   = APBTARGEXP12PPROT;
  assign APBTARGEXP12PRDATA  = apb12.PRDATA;
  assign APBTARGEXP12PREADY  = apb12.PREADY;
  assign APBTARGEXP12PSLVERR = apb12.PSLVERR;

  assign apb13.PSEL    = APBTARGEXP13PSEL;
  assign apb13.PENABLE = APBTARGEXP13PENABLE;
  assign apb13.PWRITE  = APBTARGEXP13PWRITE;
  assign apb13.PADDR   = {APBTARGEXP13PADDR, 2'b00};
  assign apb13.PWDATA  = APBTARGEXP13PWDATA;
  assign apb13.PSTRB   = APBTARGEXP13PSTRB;
  assign apb13.PPROT   = APBTARGEXP13PPROT;
  assign APBTARGEXP13PRDATA  = apb13.PRDATA;
  assign APBTARGEXP13PREADY  = apb13.PREADY;
  assign APBTARGEXP13PSLVERR = apb13.PSLVERR;

  assign apb14.PSEL    = APBTARGEXP14PSEL;
  assign apb14.PENABLE = APBTARGEXP14PENABLE;
  assign apb14.PWRITE  = APBTARGEXP14PWRITE;
  assign apb14.PADDR   = {APBTARGEXP14PADDR, 2'b00};
  assign apb14.PWDATA  = APBTARGEXP14PWDATA;
  assign apb14.PSTRB   = APBTARGEXP14PSTRB;
  assign apb14.PPROT   = APBTARGEXP14PPROT;
  assign APBTARGEXP14PRDATA  = apb14.PRDATA;
  assign APBTARGEXP14PREADY  = apb14.PREADY;
  assign APBTARGEXP14PSLVERR = apb14.PSLVERR;

  assign apb15.PSEL    = APBTARGEXP15PSEL;
  assign apb15.PENABLE = APBTARGEXP15PENABLE;
  assign apb15.PWRITE  = APBTARGEXP15PWRITE;
  assign apb15.PADDR   = {APBTARGEXP15PADDR, 2'b00};
  assign apb15.PWDATA  = APBTARGEXP15PWDATA;
  assign apb15.PSTRB   = APBTARGEXP15PSTRB;
  assign apb15.PPROT   = APBTARGEXP15PPROT;
  assign APBTARGEXP15PRDATA  = apb15.PRDATA;
  assign APBTARGEXP15PREADY  = apb15.PREADY;
  assign APBTARGEXP15PSLVERR = apb15.PSLVERR;

  // ------------------------------------------------------------
  // INITIALIZATION AND STARTUP
  // ------------------------------------------------------------
  initial begin
    // --- SRAM Agents ---
    sram0_agent = new(sram0_if);
    sram0_agent.set_range(13'h0000, 13'h1FFF);  // Dummy range, covering common depth
    sram0_agent.start();

    sram1_agent = new(sram1_if);
    sram1_agent.set_range(13'h0000, 13'h1FFF);
    sram1_agent.start();

    sram2_agent = new(sram2_if);
    sram2_agent.set_range(13'h0000, 13'h1FFF);
    sram2_agent.start();

    sram3_agent = new(sram3_if);
    sram3_agent.set_range(13'h0000, 13'h1FFF);
    sram3_agent.start();
    $display("SRAM Agents Started.");

    // --- AHB Slave Agents (Target Expansions) ---
    ahb_slave_exp0 = new(ahb_exp0_if);
    ahb_slave_exp0.set_address_range(32'h6000_0000, 32'h6FFF_FFFF);  // Dummy EXP0 Range
    ahb_slave_exp0.run();

    ahb_slave_exp1 = new(ahb_exp1_if);
    ahb_slave_exp1.set_address_range(32'h7000_0000, 32'h7FFF_FFFF);  // Dummy EXP1 Range
    ahb_slave_exp1.run();
    $display("AHB Slave Agents (EXP0/1) Started.");

    // --- AHB Master Agents (Initiator Expansions) ---
    // Note: Master agents do not need address ranges set (they generate addresses).
    ahb_master_init0 = new(ahb_init0_if);
    ahb_master_init0.run();

    ahb_master_init1 = new(ahb_init1_if);
    ahb_master_init1.run();
    $display("AHB Master Agents (INIT0/1) Started.");

    // --- APB Agents ---
    slave2  = new(apb2);
    slave4  = new(apb4);
    slave5  = new(apb5);
    slave6  = new(apb6);
    slave7  = new(apb7);
    slave8  = new(apb8);
    slave11 = new(apb11);
    slave12 = new(apb12);
    slave13 = new(apb13);
    slave14 = new(apb14);
    slave15 = new(apb15);

    slave2.start();
    slave4.start();
    slave5.start();
    slave6.start();
    slave7.start();
    slave8.start();
    slave11.start();
    slave12.start();
    slave13.start();
    slave14.start();
    slave15.start();

    // Set APB Ranges
    slave2.drv.set_range(32'h4000_2000, 32'h4000_2FFF);
    slave4.drv.set_range(32'h4000_4000, 32'h4000_4FFF);
    slave5.drv.set_range(32'h4000_5000, 32'h4000_5FFF);
    slave6.drv.set_range(32'h4000_6000, 32'h4000_6FFF);
    slave7.drv.set_range(32'h4000_7000, 32'h4000_7FFF);
    slave8.drv.set_range(32'h4000_8000, 32'h4000_8FFF);
    slave11.drv.set_range(32'h4000_B000, 32'h4000_BFFF);
    slave12.drv.set_range(32'h4000_C000, 32'h4000_CFFF);
    slave13.drv.set_range(32'h4000_D000, 32'h4000_DFFF);
    slave14.drv.set_range(32'h4000_E000, 32'h4000_EFFF);
    slave15.drv.set_range(32'h4000_F000, 32'h4000_FFFF);

    $display("APB slave BFMs for indices 2,4-8,11-15 started.");
  end

  // ------------------------------------------------------------
  // SIMPLE SIMULATION
  // ------------------------------------------------------------
  initial begin
    $display("=== IoT Subsystem Simulation With APB, AHB, SRAM BFMs Started ===");
    // let simulation run for some time to observe bus activity
    #200000;
    $display("=== IoT Subsystem Simulation Completed ===");
    $finish;
  end

  initial begin
    $dumpfile("iot_full_bfms.vcd");
    $dumpvars(0, tb_m3ds_iot_top);
  end

endmodule
