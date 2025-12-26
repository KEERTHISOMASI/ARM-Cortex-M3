
`ifndef SRAM_PARAMS_SV
`define SRAM_PARAMS_SV

// ---------------------------------------------------------
// SRAM Address Map Parameters
// ---------------------------------------------------------

parameter logic [31:0] SRAM_BASE_ADDR = 32'h2000_0000;

parameter int SRAM_TOTAL_SIZE = 32'h20000;  // 128 KB
parameter int SRAM_BANK_SIZE = 32'h8000;  // 32 KB
parameter int ADDR_STRIDE = 4;  // 32-bit word

// 4 SRAM banks
parameter logic [31:0] SRAM_BASE[4] = '{
    32'h2000_0000,  // SRAM0
    32'h2000_8000,  // SRAM1
    32'h2001_0000,  // SRAM2
    32'h2001_8000  // SRAM3
};

`endif
