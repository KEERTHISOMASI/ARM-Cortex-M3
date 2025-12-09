`ifndef APB_SLAVE_IF_SV
`define APB_SLAVE_IF_SV

interface apb_slave_if(
    input logic pclk,
    input logic presetn
);

  logic        psel;
  logic        penable;
  logic        pwrite;
  logic [11:0] paddr;    // 12-bit Address (peripheral internal offset)
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic        pready;
  logic        pslverr;
  logic [3:0]  pstrb;
  logic [2:0]  pprot;

  clocking cb @(posedge pclk);
    input  psel;
    input  penable;
    input  pwrite;
    input  paddr;
    input  pwdata;
    input  pstrb;
    input  pprot;

    output prdata;
    output pslverr;
    output pready;
  endclocking

  modport slave_mp(clocking cb);

endinterface
`endif

