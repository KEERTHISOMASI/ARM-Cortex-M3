`include "../../../../m3designstart_iot/logical/m3ds_iot_top/verilog/m3ds_iot_top.v"
`include "../../../../m3designstart/logical/m3ds_user_partition/verilog/m3ds_simple_flash.v"
module dut_wrapper (
    // Clocking
    input  wire         fclk,            // Main Free running clock
    
    // Resets (Active Low)
    input  wire         cpu0_po_reset_n, // Power on reset
    input  wire         sys_reset_n,     // System reset
    input  wire         cpu0_sys_reset_n,// CPU System reset

    // ----------------------------------------------------------------
    // Connections typically driven by Top Level Logic or Tie-offs
    // ----------------------------------------------------------------
    input  wire         cpu0_stclk,
    input  wire [25:0]  cpu0_stcalib,
    input  wire         cpu0_bigend,
    input  wire         cpu0_dbgen,
    input  wire         cpu0_niden,
    input  wire         cpu0_fixmastertype,
    input  wire         cpu0_isolaten,
    input  wire         cpu0_retainn,
    input  wire         cpu0_mpudisable,
    input  wire         cpu0_sleepholdreqn,
    input  wire         cpu0_rxev,
    input  wire         cpu0_edbgrq,
    input  wire         cpu0_dbgrestart,
    input  wire [31:0]  cpu0_auxfault,
    input  wire         cpu0_wicenreq,
    input  wire         cpu0_cdbgpwrupreq,
    input  wire         cpu0_sysresetreq, // Usually an output, but listed as input in instantiation
    input  wire         cpu0_lockup,      // Usually an output, listed as input in instantiation
    input  wire         wdog_reset_req,
    input  wire [3:1]   mtx_remap,
    
    // Interrupts (Input Vector)
    input  wire [239:0] cpu0_intisr,
    input  wire         cpu0_intnmi,

    // ----------------------------------------------------------------
    // SRAM Interfaces (Exposed for external SRAM models)
    // ----------------------------------------------------------------
    // SRAM0
    input  wire [31:0]  sram0_rdata,
    output wire [12:0]  sram0_addr,
    output wire [3:0]   sram0_wren,
    output wire [31:0]  sram0_wdata,
    output wire         sram0_cs,
    // SRAM1
    input  wire [31:0]  sram1_rdata,
    output wire [12:0]  sram1_addr,
    output wire [3:0]   sram1_wren,
    output wire [31:0]  sram1_wdata,
    output wire         sram1_cs,
    // SRAM2
    input  wire [31:0]  sram2_rdata,
    output wire [12:0]  sram2_addr,
    output wire [3:0]   sram2_wren,
    output wire [31:0]  sram2_wdata,
    output wire         sram2_cs,
    // SRAM3
    input  wire [31:0]  sram3_rdata,
    output wire [12:0]  sram3_addr,
    output wire [3:0]   sram3_wren,
    output wire [31:0]  sram3_wdata,
    output wire         sram3_cs,

    // ----------------------------------------------------------------
    // Expansion Ports (AHB & APB)
    // ----------------------------------------------------------------
    // Target Expansion 0
    output wire         targexp0hsel,
    output wire [31:0]  targexp0haddr,
    output wire [1:0]   targexp0htrans,
    output wire         targexp0hwrite,
    output wire [2:0]   targexp0hsize,
    output wire [2:0]   targexp0hburst,
    output wire [3:0]   targexp0hprot,
    output wire [1:0]   targexp0memattr,
    output wire         targexp0exreq,
    output wire [3:0]   targexp0hmaster,
    output wire [31:0]  targexp0hwdata,
    output wire         targexp0hmastlock,
    output wire         targexp0hreadymux,
    output wire         targexp0hauser,
    output wire [3:0]   targexp0hwuser,
    input  wire [31:0]  targexp0hrdata,
    input  wire         targexp0hreadyout,
    input  wire         targexp0hresp,
    input  wire         targexp0exresp,
    input  wire [2:0]   targexp0hruser,

    // Target Expansion 1
    output wire         targexp1hsel,
    output wire [31:0]  targexp1haddr,
    output wire [1:0]   targexp1htrans,
    output wire         targexp1hwrite,
    output wire [2:0]   targexp1hsize,
    output wire [2:0]   targexp1hburst,
    output wire [3:0]   targexp1hprot,
    output wire [1:0]   targexp1memattr,
    output wire         targexp1exreq,
    output wire [3:0]   targexp1hmaster,
    output wire [31:0]  targexp1hwdata,
    output wire         targexp1hmastlock,
    output wire         targexp1hreadymux,
    output wire         targexp1hauser,
    output wire [3:0]   targexp1hwuser,
    input  wire [31:0]  targexp1hrdata,
    input  wire         targexp1hreadyout,
    input  wire         targexp1hresp,
    input  wire         targexp1exresp,
    input  wire [2:0]   targexp1hruser,

    // Init Expansion 0 (Slave Inputs)
    input  wire         initexp0hsel,
    input  wire [31:0]  initexp0haddr,
    input  wire [1:0]   initexp0htrans,
    input  wire         initexp0hwrite,
    input  wire [2:0]   initexp0hsize,
    input  wire [2:0]   initexp0hburst,
    input  wire [3:0]   initexp0hprot,
    input  wire [1:0]   initexp0memattr,
    input  wire         initexp0exreq,
    input  wire [3:0]   initexp0hmaster,
    input  wire         initexp0hauser,
    input  wire [3:0]   initexp0hwuser,
    output wire         initexp0exresp,
    output wire [2:0]   initexp0hruser,
    input  wire         initexp0hmastlock,
    output wire [31:0]  initexp0hrdata,
    output wire         initexp0hready,
    output wire         initexp0hresp,
    input  wire [31:0]  initexp0hwdata,

    // Init Expansion 1 (Slave Inputs)
    input  wire         initexp1hsel,
    input  wire [31:0]  initexp1haddr,
    input  wire [1:0]   initexp1htrans,
    input  wire         initexp1hwrite,
    input  wire [2:0]   initexp1hsize,
    input  wire [2:0]   initexp1hburst,
    input  wire [31:0]  initexp1hwdata,
    input  wire [3:0]   initexp1hprot,
    input  wire [1:0]   initexp1memattr,
    input  wire         initexp1exreq,
    input  wire [3:0]   initexp1hmaster,
    input  wire         initexp1hauser,
    input  wire [3:0]   initexp1hwuser,
    output wire         initexp1exresp,
    output wire [2:0]   initexp1hruser,
    input  wire         initexp1hmastlock,
    output wire [31:0]  initexp1hrdata,
    output wire         initexp1hready,
    output wire         initexp1hresp,

    // ----------------------------------------------------------------
    // APB Expansions [2:15]
    // Note: 3, 9, 10 were Flash, now exposed.
    // ----------------------------------------------------------------
    
    // APB 2
    output wire         apbtargexp2psel,
    output wire         apbtargexp2penable,
    output wire [11:0]  apbtargexp2paddr,
    output wire         apbtargexp2pwrite,
    output wire [31:0]  apbtargexp2pwdata,
    input  wire [31:0]  apbtargexp2prdata,
    input  wire         apbtargexp2pready,
    input  wire         apbtargexp2pslverr,
    output wire [3:0]   apbtargexp2pstrb,
    output wire [2:0]   apbtargexp2pprot,

    // APB 3
    output wire         apbtargexp3psel,
    output wire         apbtargexp3penable,
    output wire [11:0]  apbtargexp3paddr,
    output wire         apbtargexp3pwrite,
    output wire [31:0]  apbtargexp3pwdata,
    input  wire [31:0]  apbtargexp3prdata,
    input  wire         apbtargexp3pready,
    input  wire         apbtargexp3pslverr,
    output wire [3:0]   apbtargexp3pstrb,
    output wire [2:0]   apbtargexp3pprot,

    // APB 4
    output wire         apbtargexp4psel,
    output wire         apbtargexp4penable,
    output wire [11:0]  apbtargexp4paddr,
    output wire         apbtargexp4pwrite,
    output wire [31:0]  apbtargexp4pwdata,
    input  wire [31:0]  apbtargexp4prdata,
    input  wire         apbtargexp4pready,
    input  wire         apbtargexp4pslverr,
    output wire [3:0]   apbtargexp4pstrb,
    output wire [2:0]   apbtargexp4pprot,

    // APB 5
    output wire         apbtargexp5psel,
    output wire         apbtargexp5penable,
    output wire [11:0]  apbtargexp5paddr,
    output wire         apbtargexp5pwrite,
    output wire [31:0]  apbtargexp5pwdata,
    input  wire [31:0]  apbtargexp5prdata,
    input  wire         apbtargexp5pready,
    input  wire         apbtargexp5pslverr,
    output wire [3:0]   apbtargexp5pstrb,
    output wire [2:0]   apbtargexp5pprot,

    // APB 6
    output wire         apbtargexp6psel,
    output wire         apbtargexp6penable,
    output wire [11:0]  apbtargexp6paddr,
    output wire         apbtargexp6pwrite,
    output wire [31:0]  apbtargexp6pwdata,
    input  wire [31:0]  apbtargexp6prdata,
    input  wire         apbtargexp6pready,
    input  wire         apbtargexp6pslverr,
    output wire [3:0]   apbtargexp6pstrb,
    output wire [2:0]   apbtargexp6pprot,

    // APB 7
    output wire         apbtargexp7psel,
    output wire         apbtargexp7penable,
    output wire [11:0]  apbtargexp7paddr,
    output wire         apbtargexp7pwrite,
    output wire [31:0]  apbtargexp7pwdata,
    input  wire [31:0]  apbtargexp7prdata,
    input  wire         apbtargexp7pready,
    input  wire         apbtargexp7pslverr,
    output wire [3:0]   apbtargexp7pstrb,
    output wire [2:0]   apbtargexp7pprot,

    // APB 8
    output wire         apbtargexp8psel,
    output wire         apbtargexp8penable,
    output wire [11:0]  apbtargexp8paddr,
    output wire         apbtargexp8pwrite,
    output wire [31:0]  apbtargexp8pwdata,
    input  wire [31:0]  apbtargexp8prdata,
    input  wire         apbtargexp8pready,
    input  wire         apbtargexp8pslverr,
    output wire [3:0]   apbtargexp8pstrb,
    output wire [2:0]   apbtargexp8pprot,

    // APB 9
    output wire         apbtargexp9psel,
    output wire         apbtargexp9penable,
    output wire [11:0]  apbtargexp9paddr,
    output wire         apbtargexp9pwrite,
    output wire [31:0]  apbtargexp9pwdata,
    input  wire [31:0]  apbtargexp9prdata,
    input  wire         apbtargexp9pready,
    input  wire         apbtargexp9pslverr,
    output wire [3:0]   apbtargexp9pstrb,
    output wire [2:0]   apbtargexp9pprot,

    // APB 10
    output wire         apbtargexp10psel,
    output wire         apbtargexp10penable,
    output wire [11:0]  apbtargexp10paddr,
    output wire         apbtargexp10pwrite,
    output wire [31:0]  apbtargexp10pwdata,
    input  wire [31:0]  apbtargexp10prdata,
    input  wire         apbtargexp10pready,
    input  wire         apbtargexp10pslverr,
    output wire [3:0]   apbtargexp10pstrb,
    output wire [2:0]   apbtargexp10pprot,

    // APB 11
    output wire         apbtargexp11psel,
    output wire         apbtargexp11penable,
    output wire [11:0]  apbtargexp11paddr,
    output wire         apbtargexp11pwrite,
    output wire [31:0]  apbtargexp11pwdata,
    input  wire [31:0]  apbtargexp11prdata,
    input  wire         apbtargexp11pready,
    input  wire         apbtargexp11pslverr,
    output wire [3:0]   apbtargexp11pstrb,
    output wire [2:0]   apbtargexp11pprot,

    // APB 12
    output wire         apbtargexp12psel,
    output wire         apbtargexp12penable,
    output wire [11:0]  apbtargexp12paddr,
    output wire         apbtargexp12pwrite,
    output wire [31:0]  apbtargexp12pwdata,
    input  wire [31:0]  apbtargexp12prdata,
    input  wire         apbtargexp12pready,
    input  wire         apbtargexp12pslverr,
    output wire [3:0]   apbtargexp12pstrb,
    output wire [2:0]   apbtargexp12pprot,

    // APB 13
    output wire         apbtargexp13psel,
    output wire         apbtargexp13penable,
    output wire [11:0]  apbtargexp13paddr,
    output wire         apbtargexp13pwrite,
    output wire [31:0]  apbtargexp13pwdata,
    input  wire [31:0]  apbtargexp13prdata,
    input  wire         apbtargexp13pready,
    input  wire         apbtargexp13pslverr,
    output wire [3:0]   apbtargexp13pstrb,
    output wire [2:0]   apbtargexp13pprot,

    // APB 14
    output wire         apbtargexp14psel,
    output wire         apbtargexp14penable,
    output wire [11:0]  apbtargexp14paddr,
    output wire         apbtargexp14pwrite,
    output wire [31:0]  apbtargexp14pwdata,
    input  wire [31:0]  apbtargexp14prdata,
    input  wire         apbtargexp14pready,
    input  wire         apbtargexp14pslverr,
    output wire [3:0]   apbtargexp14pstrb,
    output wire [2:0]   apbtargexp14pprot,
    
    // APB 15
    output wire         apbtargexp15psel,
    output wire         apbtargexp15penable,
    output wire [11:0]  apbtargexp15paddr,
    output wire         apbtargexp15pwrite,
    output wire [31:0]  apbtargexp15pwdata,
    input  wire [31:0]  apbtargexp15prdata,
    input  wire         apbtargexp15pready,
    input  wire         apbtargexp15pslverr,
    output wire [3:0]   apbtargexp15pstrb,
    output wire [2:0]   apbtargexp15pprot,

    // ----------------------------------------------------------------
    // Debug & Trace
    // ----------------------------------------------------------------
    input  wire         nTRST,
    input  wire         SWCLKTCK,
    input  wire         SWDITMS,
    input  wire         TDI,
    output wire         TDO,
    output wire         nTDOEN,
    output wire         SWDO,
    output wire         SWDOEN,
    output wire         JTAGNSW,
    output wire         SWV,
    output wire         TRACECLK,
    output wire [3:0]   TRACEDATA,
    output wire         trcena,
    output wire [47:0]  cpu0tsvalueb, // Timestamp

    // ----------------------------------------------------------------
    // Outputs from IoT Top
    // ----------------------------------------------------------------
    output wire         cpu0halted,
    output wire         cpu0wakeup,
    output wire         cpu0wicenack,
    output wire [66:0]  cpu0wicsense,
    output wire         cpu0cdbgpwrupack,
    
    // ----------------------------------------------------------------
    // Outputs from Flash Module (For interrupts)
    // ----------------------------------------------------------------
    output wire         flash_err_o,
    output wire         flash_int_o,
    
    // DFT
    input  wire         dftscanmode,
    input  wire         dftcgen,
    input  wire         dftse
);

  // ----------------------------------------------------------------
  // Internal Connections (The "Glue")
  // ----------------------------------------------------------------

  // AHB Flash Connection (IoT Master -> Flash Slave)
  // This connection is KEPT active per standard design, only APB is removed.
  wire         targflash0hsel;
  wire [31:0]  targflash0haddr;
  wire [1:0]   targflash0htrans;
  wire         targflash0hwrite;
  wire [2:0]   targflash0hsize;
  wire [31:0]  targflash0hwdata;
  wire [2:0]   targflash0hburst;
  wire [3:0]   targflash0hprot;
  wire [1:0]   targflash0memattr;
  wire         targflash0exreq;
  wire [3:0]   targflash0hmaster;
  wire         targflash0hmastlock;
  wire         targflash0hauser;
  wire [3:0]   targflash0hwuser;
  wire         targflash0hreadymux;
  wire         targflash0hreadyout;
  wire [31:0]  targflash0hrdata;
  wire         targflash0hresp;
  wire         targflash0exresp;
  wire [2:0]   targflash0hruser;

  // Clock Distribution (mimicking user partition logic)
  wire SRAMFHCLK      = fclk;
  wire SRAM0HCLK      = fclk;
  wire SRAM1HCLK      = fclk;
  wire SRAM2HCLK      = fclk;
  wire SRAM3HCLK      = fclk;
  wire MTXHCLK        = fclk;
  wire AHB2APBHCLK    = fclk;
  wire TIMER0PCLK     = fclk;
  wire TIMER0PCLKG    = fclk;
  wire TIMER1PCLK     = fclk;
  wire TIMER1PCLKG    = fclk;
  wire CPU0FCLK       = fclk;
  wire CPU0HCLK       = fclk;
  wire TPIUTRACECLKIN = fclk;
  wire PCLK           = fclk;
  wire PCLKG          = fclk;

  // Reset Distribution
  wire MTXHRESETn     = sys_reset_n;
  wire SRAMHRESETn    = sys_reset_n;
  wire TIMER0PRESETn  = sys_reset_n;
  wire TIMER1PRESETn  = sys_reset_n;


  // ----------------------------------------------------------------
  // Instance: m3ds_iot_top
  // ----------------------------------------------------------------
  m3ds_iot_top u_iot_top (
    .CPU0FCLK               (CPU0FCLK),
    .CPU0HCLK               (CPU0HCLK),
    .TPIUTRACECLKIN         (TPIUTRACECLKIN),
    .CPU0PORESETn           (cpu0_po_reset_n),
    .CPU0SYSRESETn          (cpu0_sys_reset_n),
    .CPU0STCLK              (cpu0_stclk),
    .CPU0STCALIB            (cpu0_stcalib),
    .SRAM0HCLK              (SRAM0HCLK),
    .SRAM1HCLK              (SRAM1HCLK),
    .SRAM2HCLK              (SRAM2HCLK),
    .SRAM3HCLK              (SRAM3HCLK),
    .MTXHCLK                (MTXHCLK),
    .MTXHRESETn             (MTXHRESETn),
    .AHB2APBHCLK            (AHB2APBHCLK),
    .TIMER0PCLK             (TIMER0PCLK),
    .TIMER0PCLKG            (TIMER0PCLKG),
    .TIMER0PRESETn          (TIMER0PRESETn),
    .TIMER1PCLK             (TIMER1PCLK),
    .TIMER1PCLKG            (TIMER1PCLKG),
    .TIMER1PRESETn          (TIMER1PRESETn),

    // SRAM Interfaces (Connected to ports)
    .SRAM0RDATA             (sram0_rdata),
    .SRAM0ADDR              (sram0_addr),
    .SRAM0WREN              (sram0_wren),
    .SRAM0WDATA             (sram0_wdata),
    .SRAM0CS                (sram0_cs),
    .SRAM1RDATA             (sram1_rdata),
    .SRAM1ADDR              (sram1_addr),
    .SRAM1WREN              (sram1_wren),
    .SRAM1WDATA             (sram1_wdata),
    .SRAM1CS                (sram1_cs),
    .SRAM2RDATA             (sram2_rdata),
    .SRAM2ADDR              (sram2_addr),
    .SRAM2WREN              (sram2_wren),
    .SRAM2WDATA             (sram2_wdata),
    .SRAM2CS                (sram2_cs),
    .SRAM3RDATA             (sram3_rdata),
    .SRAM3ADDR              (sram3_addr),
    .SRAM3WREN              (sram3_wren),
    .SRAM3WDATA             (sram3_wdata),
    .SRAM3CS                (sram3_cs),

    .TIMER0EXTIN            (1'b0), 
    .TIMER0PRIVMODEN        (1'b0),
    .TIMER1EXTIN            (1'b0),
    .TIMER1PRIVMODEN        (1'b0),
    .TIMER0TIMERINT         (),
    .TIMER1TIMERINT         (),

    // Internal Flash AHB Connection
    .TARGFLASH0HSEL         (targflash0hsel),
    .TARGFLASH0HADDR        (targflash0haddr),
    .TARGFLASH0HTRANS       (targflash0htrans),
    .TARGFLASH0HWRITE       (targflash0hwrite),
    .TARGFLASH0HSIZE        (targflash0hsize),
    .TARGFLASH0HBURST       (targflash0hburst),
    .TARGFLASH0HPROT        (targflash0hprot),
    .TARGFLASH0MEMATTR      (targflash0memattr),
    .TARGFLASH0EXREQ        (targflash0exreq),
    .TARGFLASH0HMASTER      (targflash0hmaster),
    .TARGFLASH0HWDATA       (targflash0hwdata),
    .TARGFLASH0HMASTLOCK    (targflash0hmastlock),
    .TARGFLASH0HREADYMUX    (targflash0hreadymux),
    .TARGFLASH0HAUSER       (targflash0hauser),
    .TARGFLASH0HWUSER       (targflash0hwuser),
    .TARGFLASH0HRDATA       (targflash0hrdata),
    .TARGFLASH0HREADYOUT    (targflash0hreadyout),
    .TARGFLASH0HRESP        (targflash0hresp),
    .TARGFLASH0EXRESP       (targflash0exresp),
    .TARGFLASH0HRUSER       (targflash0hruser),

    // External Expansion Ports
    .TARGEXP0HSEL           (targexp0hsel),
    .TARGEXP0HADDR          (targexp0haddr),
    .TARGEXP0HTRANS         (targexp0htrans),
    .TARGEXP0HWRITE         (targexp0hwrite),
    .TARGEXP0HSIZE          (targexp0hsize),
    .TARGEXP0HBURST         (targexp0hburst),
    .TARGEXP0HPROT          (targexp0hprot),
    .TARGEXP0MEMATTR        (targexp0memattr),
    .TARGEXP0EXREQ          (targexp0exreq),
    .TARGEXP0HMASTER        (targexp0hmaster),
    .TARGEXP0HWDATA         (targexp0hwdata),
    .TARGEXP0HMASTLOCK      (targexp0hmastlock),
    .TARGEXP0HREADYMUX      (targexp0hreadymux),
    .TARGEXP0HAUSER         (targexp0hauser),
    .TARGEXP0HWUSER         (targexp0hwuser),
    .TARGEXP0HRDATA         (targexp0hrdata),
    .TARGEXP0HREADYOUT      (targexp0hreadyout),
    .TARGEXP0HRESP          (targexp0hresp),
    .TARGEXP0EXRESP         (targexp0exresp),
    .TARGEXP0HRUSER         (targexp0hruser),

    .TARGEXP1HSEL           (targexp1hsel),
    .TARGEXP1HADDR          (targexp1haddr),
    .TARGEXP1HTRANS         (targexp1htrans),
    .TARGEXP1HWRITE         (targexp1hwrite),
    .TARGEXP1HSIZE          (targexp1hsize),
    .TARGEXP1HBURST         (targexp1hburst),
    .TARGEXP1HPROT          (targexp1hprot),
    .TARGEXP1MEMATTR        (targexp1memattr),
    .TARGEXP1EXREQ          (targexp1exreq),
    .TARGEXP1HMASTER        (targexp1hmaster),
    .TARGEXP1HWDATA         (targexp1hwdata),
    .TARGEXP1HMASTLOCK      (targexp1hmastlock),
    .TARGEXP1HREADYMUX      (targexp1hreadymux),
    .TARGEXP1HAUSER         (targexp1hauser),
    .TARGEXP1HWUSER         (targexp1hwuser),
    .TARGEXP1HRDATA         (targexp1hrdata),
    .TARGEXP1HREADYOUT      (targexp1hreadyout),
    .TARGEXP1HRESP          (targexp1hresp),
    .TARGEXP1EXRESP         (targexp1exresp),
    .TARGEXP1HRUSER         (targexp1hruser),

    .INITEXP0HSEL           (initexp0hsel),
    .INITEXP0HADDR          (initexp0haddr),
    .INITEXP0HTRANS         (initexp0htrans),
    .INITEXP0HWRITE         (initexp0hwrite),
    .INITEXP0HSIZE          (initexp0hsize),
    .INITEXP0HBURST         (initexp0hburst),
    .INITEXP0HPROT          (initexp0hprot),
    .INITEXP0MEMATTR        (initexp0memattr),
    .INITEXP0EXREQ          (initexp0exreq),
    .INITEXP0HMASTER        (initexp0hmaster),
    .INITEXP0HWDATA         (initexp0hwdata),
    .INITEXP0HMASTLOCK      (initexp0hmastlock),
    .INITEXP0HAUSER         (initexp0hauser),
    .INITEXP0HWUSER         (initexp0hwuser),
    .INITEXP0HRDATA         (initexp0hrdata),
    .INITEXP0HREADY         (initexp0hready),
    .INITEXP0HRESP          (initexp0hresp),
    .INITEXP0EXRESP         (initexp0exresp),
    .INITEXP0HRUSER         (initexp0hruser),

    .INITEXP1HSEL           (initexp1hsel),
    .INITEXP1HADDR          (initexp1haddr),
    .INITEXP1HTRANS         (initexp1htrans),
    .INITEXP1HWRITE         (initexp1hwrite),
    .INITEXP1HSIZE          (initexp1hsize),
    .INITEXP1HBURST         (initexp1hburst),
    .INITEXP1HPROT          (initexp1hprot),
    .INITEXP1MEMATTR        (initexp1memattr),
    .INITEXP1EXREQ          (initexp1exreq),
    .INITEXP1HMASTER        (initexp1hmaster),
    .INITEXP1HWDATA         (initexp1hwdata),
    .INITEXP1HMASTLOCK      (initexp1hmastlock),
    .INITEXP1HAUSER         (initexp1hauser),
    .INITEXP1HWUSER         (initexp1hwuser),
    .INITEXP1HRDATA         (initexp1hrdata),
    .INITEXP1HREADY         (initexp1hready),
    .INITEXP1HRESP          (initexp1hresp),
    .INITEXP1EXRESP         (initexp1exresp),
    .INITEXP1HRUSER         (initexp1hruser),

    // APB Connections [2-15]
    // 3, 9, 10 are now exposed and NOT connected to Flash instance below
    .APBTARGEXP2PSEL        (apbtargexp2psel),
    .APBTARGEXP2PENABLE     (apbtargexp2penable),
    .APBTARGEXP2PADDR       (apbtargexp2paddr),
    .APBTARGEXP2PWRITE      (apbtargexp2pwrite),
    .APBTARGEXP2PWDATA      (apbtargexp2pwdata),
    .APBTARGEXP2PRDATA      (apbtargexp2prdata),
    .APBTARGEXP2PREADY      (apbtargexp2pready),
    .APBTARGEXP2PSLVERR     (apbtargexp2pslverr),
    .APBTARGEXP2PSTRB       (apbtargexp2pstrb),
    .APBTARGEXP2PPROT       (apbtargexp2pprot),

    .APBTARGEXP3PSEL        (apbtargexp3psel),
    .APBTARGEXP3PENABLE     (apbtargexp3penable),
    .APBTARGEXP3PADDR       (apbtargexp3paddr),
    .APBTARGEXP3PWRITE      (apbtargexp3pwrite),
    .APBTARGEXP3PWDATA      (apbtargexp3pwdata),
    .APBTARGEXP3PRDATA      (apbtargexp3prdata),
    .APBTARGEXP3PREADY      (apbtargexp3pready),
    .APBTARGEXP3PSLVERR     (apbtargexp3pslverr),
    .APBTARGEXP3PSTRB       (apbtargexp3pstrb),
    .APBTARGEXP3PPROT       (apbtargexp3pprot),

    .APBTARGEXP4PSEL        (apbtargexp4psel),
    .APBTARGEXP4PENABLE     (apbtargexp4penable),
    .APBTARGEXP4PADDR       (apbtargexp4paddr),
    .APBTARGEXP4PWRITE      (apbtargexp4pwrite),
    .APBTARGEXP4PWDATA      (apbtargexp4pwdata),
    .APBTARGEXP4PRDATA      (apbtargexp4prdata),
    .APBTARGEXP4PREADY      (apbtargexp4pready),
    .APBTARGEXP4PSLVERR     (apbtargexp4pslverr),
    .APBTARGEXP4PSTRB       (apbtargexp4pstrb),
    .APBTARGEXP4PPROT       (apbtargexp4pprot),

    .APBTARGEXP5PSEL        (apbtargexp5psel),
    .APBTARGEXP5PENABLE     (apbtargexp5penable),
    .APBTARGEXP5PADDR       (apbtargexp5paddr),
    .APBTARGEXP5PWRITE      (apbtargexp5pwrite),
    .APBTARGEXP5PWDATA      (apbtargexp5pwdata),
    .APBTARGEXP5PRDATA      (apbtargexp5prdata),
    .APBTARGEXP5PREADY      (apbtargexp5pready),
    .APBTARGEXP5PSLVERR     (apbtargexp5pslverr),
    .APBTARGEXP5PSTRB       (apbtargexp5pstrb),
    .APBTARGEXP5PPROT       (apbtargexp5pprot),

    .APBTARGEXP6PSEL        (apbtargexp6psel),
    .APBTARGEXP6PENABLE     (apbtargexp6penable),
    .APBTARGEXP6PADDR       (apbtargexp6paddr),
    .APBTARGEXP6PWRITE      (apbtargexp6pwrite),
    .APBTARGEXP6PWDATA      (apbtargexp6pwdata),
    .APBTARGEXP6PRDATA      (apbtargexp6prdata),
    .APBTARGEXP6PREADY      (apbtargexp6pready),
    .APBTARGEXP6PSLVERR     (apbtargexp6pslverr),
    .APBTARGEXP6PSTRB       (apbtargexp6pstrb),
    .APBTARGEXP6PPROT       (apbtargexp6pprot),

    .APBTARGEXP7PSEL        (apbtargexp7psel),
    .APBTARGEXP7PENABLE     (apbtargexp7penable),
    .APBTARGEXP7PADDR       (apbtargexp7paddr),
    .APBTARGEXP7PWRITE      (apbtargexp7pwrite),
    .APBTARGEXP7PWDATA      (apbtargexp7pwdata),
    .APBTARGEXP7PRDATA      (apbtargexp7prdata),
    .APBTARGEXP7PREADY      (apbtargexp7pready),
    .APBTARGEXP7PSLVERR     (apbtargexp7pslverr),
    .APBTARGEXP7PSTRB       (apbtargexp7pstrb),
    .APBTARGEXP7PPROT       (apbtargexp7pprot),

    .APBTARGEXP8PSEL        (apbtargexp8psel),
    .APBTARGEXP8PENABLE     (apbtargexp8penable),
    .APBTARGEXP8PADDR       (apbtargexp8paddr),
    .APBTARGEXP8PWRITE      (apbtargexp8pwrite),
    .APBTARGEXP8PWDATA      (apbtargexp8pwdata),
    .APBTARGEXP8PRDATA      (apbtargexp8prdata),
    .APBTARGEXP8PREADY      (apbtargexp8pready),
    .APBTARGEXP8PSLVERR     (apbtargexp8pslverr),
    .APBTARGEXP8PSTRB       (apbtargexp8pstrb),
    .APBTARGEXP8PPROT       (apbtargexp8pprot),

    .APBTARGEXP9PSEL        (apbtargexp9psel),
    .APBTARGEXP9PENABLE     (apbtargexp9penable),
    .APBTARGEXP9PADDR       (apbtargexp9paddr),
    .APBTARGEXP9PWRITE      (apbtargexp9pwrite),
    .APBTARGEXP9PWDATA      (apbtargexp9pwdata),
    .APBTARGEXP9PRDATA      (apbtargexp9prdata),
    .APBTARGEXP9PREADY      (apbtargexp9pready),
    .APBTARGEXP9PSLVERR     (apbtargexp9pslverr),
    .APBTARGEXP9PSTRB       (apbtargexp9pstrb),
    .APBTARGEXP9PPROT       (apbtargexp9pprot),

    .APBTARGEXP10PSEL       (apbtargexp10psel),
    .APBTARGEXP10PENABLE    (apbtargexp10penable),
    .APBTARGEXP10PADDR      (apbtargexp10paddr),
    .APBTARGEXP10PWRITE     (apbtargexp10pwrite),
    .APBTARGEXP10PWDATA     (apbtargexp10pwdata),
    .APBTARGEXP10PRDATA     (apbtargexp10prdata),
    .APBTARGEXP10PREADY     (apbtargexp10pready),
    .APBTARGEXP10PSLVERR    (apbtargexp10pslverr),
    .APBTARGEXP10PSTRB      (apbtargexp10pstrb),
    .APBTARGEXP10PPROT      (apbtargexp10pprot),

    .APBTARGEXP11PSEL       (apbtargexp11psel),
    .APBTARGEXP11PENABLE    (apbtargexp11penable),
    .APBTARGEXP11PADDR      (apbtargexp11paddr),
    .APBTARGEXP11PWRITE     (apbtargexp11pwrite),
    .APBTARGEXP11PWDATA     (apbtargexp11pwdata),
    .APBTARGEXP11PRDATA     (apbtargexp11prdata),
    .APBTARGEXP11PREADY     (apbtargexp11pready),
    .APBTARGEXP11PSLVERR    (apbtargexp11pslverr),
    .APBTARGEXP11PSTRB      (apbtargexp11pstrb),
    .APBTARGEXP11PPROT      (apbtargexp11pprot),

    .APBTARGEXP12PSEL       (apbtargexp12psel),
    .APBTARGEXP12PENABLE    (apbtargexp12penable),
    .APBTARGEXP12PADDR      (apbtargexp12paddr),
    .APBTARGEXP12PWRITE     (apbtargexp12pwrite),
    .APBTARGEXP12PWDATA     (apbtargexp12pwdata),
    .APBTARGEXP12PRDATA     (apbtargexp12prdata),
    .APBTARGEXP12PREADY     (apbtargexp12pready),
    .APBTARGEXP12PSLVERR    (apbtargexp12pslverr),
    .APBTARGEXP12PSTRB      (apbtargexp12pstrb),
    .APBTARGEXP12PPROT      (apbtargexp12pprot),

    .APBTARGEXP13PSEL       (apbtargexp13psel),
    .APBTARGEXP13PENABLE    (apbtargexp13penable),
    .APBTARGEXP13PADDR      (apbtargexp13paddr),
    .APBTARGEXP13PWRITE     (apbtargexp13pwrite),
    .APBTARGEXP13PWDATA     (apbtargexp13pwdata),
    .APBTARGEXP13PRDATA     (apbtargexp13prdata),
    .APBTARGEXP13PREADY     (apbtargexp13pready),
    .APBTARGEXP13PSLVERR    (apbtargexp13pslverr),
    .APBTARGEXP13PSTRB      (apbtargexp13pstrb),
    .APBTARGEXP13PPROT      (apbtargexp13pprot),

    .APBTARGEXP14PSEL       (apbtargexp14psel),
    .APBTARGEXP14PENABLE    (apbtargexp14penable),
    .APBTARGEXP14PADDR      (apbtargexp14paddr),
    .APBTARGEXP14PWRITE     (apbtargexp14pwrite),
    .APBTARGEXP14PWDATA     (apbtargexp14pwdata),
    .APBTARGEXP14PRDATA     (apbtargexp14prdata),
    .APBTARGEXP14PREADY     (apbtargexp14pready),
    .APBTARGEXP14PSLVERR    (apbtargexp14pslverr),
    .APBTARGEXP14PSTRB      (apbtargexp14pstrb),
    .APBTARGEXP14PPROT      (apbtargexp14pprot),

    .APBTARGEXP15PSEL       (apbtargexp15psel),
    .APBTARGEXP15PENABLE    (apbtargexp15penable),
    .APBTARGEXP15PADDR      (apbtargexp15paddr),
    .APBTARGEXP15PWRITE     (apbtargexp15pwrite),
    .APBTARGEXP15PWDATA     (apbtargexp15pwdata),
    .APBTARGEXP15PRDATA     (apbtargexp15prdata),
    .APBTARGEXP15PREADY     (apbtargexp15pready),
    .APBTARGEXP15PSLVERR    (apbtargexp15pslverr),
    .APBTARGEXP15PSTRB      (apbtargexp15pstrb),
    .APBTARGEXP15PPROT      (apbtargexp15pprot),

    .CPU0EDBGRQ             (cpu0_edbgrq),
    .CPU0DBGRESTART         (cpu0_dbgrestart),
    .CPU0DBGRESTARTED       (), 
    .CPU0HTMDHADDR          (),
    .CPU0HTMDHTRANS         (),
    .CPU0HTMDHSIZE          (),
    .CPU0HTMDHBURST         (),
    .CPU0HTMDHPROT          (),
    .CPU0HTMDHWDATA         (),
    .CPU0HTMDHWRITE         (),
    .CPU0HTMDHRDATA         (),
    .CPU0HTMDHREADY         (),
    .CPU0HTMDHRESP          (),
    .CPU0TSVALUEB           (cpu0tsvalueb),
    .CPU0ETMINTNUM          (),
    .CPU0ETMINTSTAT         (),
    .CPU0HALTED             (cpu0halted),
    .CPU0MPUDISABLE         (cpu0_mpudisable),
    .CPU0SLEEPING           (),
    .CPU0SLEEPDEEP          (),
    .CPU0SLEEPHOLDREQn      (cpu0_sleepholdreqn),
    .CPU0SLEEPHOLDACKn      (),
    .CPU0WAKEUP             (cpu0wakeup),
    .CPU0WICENACK           (cpu0wicenack),
    .CPU0WICSENSE           (cpu0wicsense),
    .CPU0WICENREQ           (cpu0_wicenreq),
    .CPU0SYSRESETREQ        (cpu0_sysresetreq),
    .CPU0LOCKUP             (cpu0_lockup),
    .CPU0CDBGPWRUPREQ       (cpu0_cdbgpwrupreq),
    .CPU0CDBGPWRUPACK       (cpu0cdbgpwrupack),
    .CPU0BRCHSTAT           (),
    .MTXREMAP               (mtx_remap),
    .CPU0RXEV               (cpu0_rxev),
    .CPU0TXEV               (),
    .CPU0INTISR             (cpu0_intisr),
    .CPU0INTNMI             (cpu0_intnmi),
    .CPU0CURRPRI            (),
    .CPU0AUXFAULT           (cpu0_auxfault),
    .APBQACTIVE             (),
    .TIMER0PCLKQACTIVE      (),
    .TIMER1PCLKQACTIVE      (),
    .CPU0DBGEN              (cpu0_dbgen),
    .CPU0NIDEN              (cpu0_niden),
    .CPU0FIXMASTERTYPE      (cpu0_fixmastertype),
    .CPU0ISOLATEn           (cpu0_isolaten),
    .CPU0RETAINn            (cpu0_retainn),
    .DFTSCANMODE            (dftscanmode),
    .DFTCGEN                (dftcgen),
    .DFTSE                  (dftse),
    .CPU0GATEHCLK           (),
    .nTRST                  (nTRST),
    .SWCLKTCK               (SWCLKTCK),
    .SWDITMS                (SWDITMS),
    .TDI                    (TDI),
    .TDO                    (TDO),
    .nTDOEN                 (nTDOEN),
    .SWDO                   (SWDO),
    .SWDOEN                 (SWDOEN),
    .JTAGNSW                (JTAGNSW),
    .SWV                    (SWV),
    .TRACECLK               (TRACECLK),
    .TRACEDATA              (TRACEDATA),
    .TRCENA                 (trcena),
    .CPU0BIGEND             (cpu0_bigend)
  );

  // ----------------------------------------------------------------
  // Instance: m3ds_simple_flash
  // ----------------------------------------------------------------
  m3ds_simple_flash u_m3ds_simple_flash (
    .hclk                   (SRAMFHCLK),
    .hresetn                (MTXHRESETn),
    
    // AHB Connection (Slave of IoT Top - Remains connected)
    .hsel_i                 (targflash0hsel),
    .haddr_i                (targflash0haddr),
    .htrans_i               (targflash0htrans),
    .hwrite_i               (targflash0hwrite),
    .hsize_i                (targflash0hsize),
    .hburst_i               (targflash0hburst),
    .hprot_i                (targflash0hprot),
    .memattr_i              (targflash0memattr),
    .exreq_i                (targflash0exreq),
    .hmaster_i              (targflash0hmaster),
    .hwdata_i               (targflash0hwdata),
    .hmastlock_i            (targflash0hmastlock),
    .hreadymux_i            (targflash0hreadymux),
    .hauser_i               (targflash0hauser),
    .hwuser_i               (targflash0hwuser),
    .hrdata_o               (targflash0hrdata),
    .hreadyout_o            (targflash0hreadyout),
    .hresp_o                (targflash0hresp),
    .exresp_o               (targflash0exresp),
    .hruser_o               (targflash0hruser),
    
    // Flash Interrupts (Exposed to wrapper outputs)
    .flash_err_o            (flash_err_o),
    .flash_int_o            (flash_int_o),

    .pclk                   (PCLK),
    .pclkg                  (PCLKG),
    
    // APB Connections
    // These are TIED OFF (0) as per request to remove connection to IoT
    .apbtargexp3psel_i      (1'b0),
    .apbtargexp3penable_i   (1'b0),
    .apbtargexp3paddr_i     (12'b0),
    .apbtargexp3pwrite_i    (1'b0),
    .apbtargexp3pwdata_i    (32'b0),
    .apbtargexp3prdata_o    (), // Unused Output
    .apbtargexp3pready_o    (), // Unused Output
    .apbtargexp3pslverr_o   (), // Unused Output
    .apbtargexp3pstrb_i     (4'b0),
    .apbtargexp3pprot_i     (3'b0),

    .apbtargexp9psel_i      (1'b0),
    .apbtargexp9penable_i   (1'b0),
    .apbtargexp9paddr_i     (12'b0),
    .apbtargexp9pwrite_i    (1'b0),
    .apbtargexp9pwdata_i    (32'b0),
    .apbtargexp9prdata_o    (), // Unused Output
    .apbtargexp9pready_o    (), // Unused Output
    .apbtargexp9pslverr_o   (), // Unused Output
    .apbtargexp9pstrb_i     (4'b0),
    .apbtargexp9pprot_i     (3'b0),

    .apbtargexp10psel_i     (1'b0),
    .apbtargexp10penable_i  (1'b0),
    .apbtargexp10paddr_i    (12'b0),
    .apbtargexp10pwrite_i   (1'b0),
    .apbtargexp10pwdata_i   (32'b0),
    .apbtargexp10prdata_o   (), // Unused Output
    .apbtargexp10pready_o   (), // Unused Output
    .apbtargexp10pslverr_o  (), // Unused Output
    .apbtargexp10pstrb_i    (4'b0),
    .apbtargexp10pprot_i    (3'b0)
  );

endmodule

