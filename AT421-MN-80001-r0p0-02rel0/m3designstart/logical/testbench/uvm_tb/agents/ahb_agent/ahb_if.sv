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
  logic        HREADYMUX;

  logic        HREADY;
  //assign HREADY = HREADYOUT;

  modport MASTER(
      input hclk, hresetn, HREADY, HRESP, HRDATA,
      output HSEL, HADDR, HWRITE, HTRANS, HSIZE, HBURST, HPROT, HWDATA
  );

  modport SLAVE(
      input hclk, hresetn, HSEL, HADDR, HWRITE, HTRANS, HSIZE, HBURST, HPROT, HWDATA, HREADYMUX,
      output HREADYOUT, HRESP, HRDATA
  );
endinterface
