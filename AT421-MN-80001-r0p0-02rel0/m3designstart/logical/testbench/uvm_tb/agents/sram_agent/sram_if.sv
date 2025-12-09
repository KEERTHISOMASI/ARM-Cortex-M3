interface sram_if (
    input logic CLK
);
  logic        CS;
  logic [12:0] ADDR;
  logic [ 3:0] WREN;
  logic [31:0] WDATA;
  logic [31:0] RDATA;

  // Modport for the DUT (Controller)
  modport DUT(input CLK, RDATA, output CS, ADDR, WREN, WDATA);

  // Modport for the Testbench (Slave Agent)
  modport TB(input CLK, CS, ADDR, WREN, WDATA, output RDATA);
endinterface

