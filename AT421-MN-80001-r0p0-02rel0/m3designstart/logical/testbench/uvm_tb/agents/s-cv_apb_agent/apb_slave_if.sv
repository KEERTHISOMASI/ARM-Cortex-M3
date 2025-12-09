`ifndef APB_SLAVE_IF_SV
`define APB_SLAVE_IF_SV

interface apb_slave_if (
    input logic pclk,
    input logic presetn
);

  logic        psel;
  logic        penable;
  logic        pwrite;
  logic        pready;
  logic        pslverr;
  logic [31:0] paddr;
  logic [31:0] pwdata;
  logic [31:0] prdata;
  logic [2:0]  pprot;    // Secure/Privileged/Data access
  logic [3:0] pstrb;   // NEW — APB write strobes
  
  clocking cb @(posedge pclk);
    input  psel;
    input  penable;
    input  pwrite;
    input  paddr;
    input  pwdata;
    input  pprot;
    input  presetn;
    input  pstrb;
    output pready;
    output prdata;
    output pslverr;
  endclocking

  modport slave_mp (clocking cb);

endinterface : apb_slave_if

`endif

