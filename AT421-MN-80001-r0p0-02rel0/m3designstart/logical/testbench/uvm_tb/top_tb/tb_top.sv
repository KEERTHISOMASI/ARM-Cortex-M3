`timescale 1ns / 1ps

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../../../../../m3designstart/logical/fpga_top/verilog/fpga_options_defs.v"
// Include your interface files
`include "../agents/ahb_agent/ahb_if.sv"
`include "../agents/apb_agent/apb_slave_if.sv"
`include "../agents/sram_agent/sram_if.sv"
`include "../../verilog/dut_wrapper.v"

/*`include "../../../../../m3designstart_iot/logical/models/modules/generic/p_beid_peripheral_f0_static_reg.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0/verilog/*.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/*.v"
`include "../../../../../m3designstart_iot/logical/p_beid_peripheral_f0/verilog/*.v"
`include "../../../models/generic/*.v"
`include "../../../../../m3designstart_iot/logical/models/modules/generic/*.v"
`include "../../../../../cmsdk/logical/cmsdk_ahb_slave_mux/verilog/*.v"
`include "../../../../../cmsdk/logical/cmsdk_ahb_default_slave/verilog/*.v"
`include "../../../../../cmsdk/logical/cmsdk_ahb_to_apb/verilog/*.v"
`include "../../../../../cmsdk/logical/cmsdk_ahb_to_sram/verilog/*.v"
`include "../../../../../cmsdk/logical/cmsdk_apb_subsystem/verilog/*.v"
`include "../../../../../cmsdk/logical/cmsdk_apb_slave_mux/verilog/*.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/*.v"
`include "../../../m3ds_user_partition/verilog/*.v"*/

`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0/verilog/p_beid_interconnect_f0_ahb_code_mux.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0/verilog/p_beid_interconnect_f0_ahb_to_apb.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0/verilog/p_beid_interconnect_f0_apb_slave_mux.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0/verilog/p_beid_interconnect_f0.v"

// cortexm3integration_ds_obs
`include "../../../../../m3designstart/logical/cortexm3integration_ds_obs/verilog/cortexm3ds_logic.v"
`include "../../../../../m3designstart/logical/cortexm3integration_ds_obs/verilog/CORTEXM3INTEGRATIONDS.v"

// m3designstart models/generic
`include "../../../../../m3designstart/logical/models/generic/static_reg.v"

// m3ds_user_partition
`include "../../../../../m3designstart/logical/m3ds_user_partition/verilog/m3ds_simple_flash.v"
`include "../../../../../m3designstart/logical/m3ds_user_partition/verilog/m3ds_tscnt_48.v"
`include "../../../../../m3designstart/logical/m3ds_user_partition/verilog/m3ds_user_partition.v"

// m3designstart_iot : m3ds_iot_top
`include "../../../../../m3designstart_iot/logical/m3ds_iot_top/verilog/m3ds_iot_top.v"

// m3designstart_iot : models/modules/generic
`include "../../../../../m3designstart_iot/logical/models/modules/generic/p_beid_peripheral_f0_static_reg.v"

// m3designstart_iot : p_beid_interconnect_f0_ahb_mtx
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_arbiterTARGAPB0.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_arbiterTARGEXP0.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_arbiterTARGEXP1.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_arbiterTARGFLASH0.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_arbiterTARGSRAM0.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_arbiterTARGSRAM1.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_arbiterTARGSRAM2.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_arbiterTARGSRAM3.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_decoderINITCM3DI.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_decoderINITCM3S.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_decoderINITEXP0.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_decoderINITEXP1.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_default_slave.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_input_stage.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_output_stageTARGAPB0.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_output_stageTARGEXP0.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_output_stageTARGEXP1.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_output_stageTARGFLASH0.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_output_stageTARGSRAM0.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_output_stageTARGSRAM1.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_output_stageTARGSRAM2.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx_output_stageTARGSRAM3.v"
`include "../../../../../m3designstart_iot/logical/p_beid_interconnect_f0_ahb_mtx/verilog/p_beid_interconnect_f0_ahb_mtx.v"

// p_beid_peripheral_f0
`include "../../../../../m3designstart_iot/logical/p_beid_peripheral_f0/verilog/p_beid_peripheral_f0_timer.v"
`include "../../../../../m3designstart_iot/logical/p_beid_peripheral_f0/verilog/p_beid_peripheral_f0.v"

// local models/generic (m3designstart)
`include "../../../../../m3designstart/logical/models/generic/static_reg.v"



// cmsdk : cmsdk_ahb_slave_mux
`include "../../../../../cmsdk/logical/cmsdk_ahb_slave_mux/verilog/cmsdk_ahb_slave_mux.v"

// cmsdk : cmsdk_ahb_default_slave
`include "../../../../../cmsdk/logical/cmsdk_ahb_default_slave/verilog/cmsdk_ahb_default_slave.v"

// cmsdk : cmsdk_ahb_to_apb
`include "../../../../../cmsdk/logical/cmsdk_ahb_to_apb/verilog/cmsdk_ahb_to_apb.v"

// cmsdk : cmsdk_ahb_to_sram
`include "../../../../../cmsdk/logical/cmsdk_ahb_to_sram/verilog/cmsdk_ahb_to_sram.v"

// cmsdk : cmsdk_apb_subsystem
`include "../../../../../cmsdk/logical/cmsdk_apb_subsystem/verilog/cmsdk_apb_subsystem_speed.v"
`include "../../../../../cmsdk/logical/cmsdk_apb_subsystem/verilog/cmsdk_apb_subsystem.v"
`include "../../../../../cmsdk/logical/cmsdk_apb_subsystem/verilog/cmsdk_apb_test_slave.v"
`include "../../../../../cmsdk/logical/cmsdk_apb_subsystem/verilog/cmsdk_irq_sync.v"

// cmsdk : cmsdk_apb_slave_mux
`include "../../../../../cmsdk/logical/cmsdk_apb_slave_mux/verilog/cmsdk_apb_slave_mux.v"

// smm : smm_common_fpga
`include "../../../../../smm/logical/smm_common_fpga/verilog/ahb_blockram_128.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/ahb_blockram_32.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/ahb_zbtram_32.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/ahb_zbtram_64.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/audio_pll.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/cmsdk_ahb_memory_models_defs.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/cmsdk_clock_gate.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/ddr_inout.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/ddr_out_22.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/ddr_out.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/fpga_100hz_gen.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/fpga_io_regs_ard.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/fpga_io_regs.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/fpga_pll_speed.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/fpga_pll.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/fpga_rst_sync.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/fpga_spi_ahb.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/fpga_sync_regs.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/fpga_sys_bus_mux.v"
`include "../../../../../smm/logical/smm_common_fpga/verilog/SBCon.v"


// Include the Environment and Test
//`include "iot_env.sv"
`include "../tests/iot_test_base.sv"
`include "../tests/iot_ahb_wr_rd_test.sv"


module tb_top;

  // ----------------------------------------------------------------
  // 1. Clock and Reset Generation
  // ----------------------------------------------------------------
  logic fclk;
  logic cpu0_po_reset_n;
  logic sys_reset_n;
  logic cpu0_sys_reset_n;

  // Clock Generation (100MHz)

  // ----------------------------------------------------------------
  // 2. Interface Instantiations
  // ----------------------------------------------------------------

  // SRAM Interface Array (4 Instances)
  // This creates sram_vif[0], sram_vif[1], sram_vif[2], sram_vif[3]
  sram_if sram_vif[4] (.CLK(fclk));

  // AHB Interfaces
  ahb_if targexp0_vif (
      .hclk(fclk),
      .hresetn(sys_reset_n)
  );
  ahb_if targexp1_vif (
      .hclk(fclk),
      .hresetn(sys_reset_n)
  );
  ahb_if initexp0_vif (
      .hclk(fclk),
      .hresetn(sys_reset_n)
  );
  ahb_if initexp1_vif (
      .hclk(fclk),
      .hresetn(sys_reset_n)
  );

  // APB Interface Array (2 to 15)
  apb_slave_if apb_vif[2:15] (
      .pclk(fclk),
      .presetn(sys_reset_n)
  );

  // ----------------------------------------------------------------
  // 3. Static Logic Signals (Defaults)
  // ----------------------------------------------------------------
  logic         cpu0_stclk;
  logic [ 25:0] cpu0_stcalib;
  logic         cpu0_bigend;
  logic         cpu0_dbgen;
  logic         cpu0_niden;
  logic         cpu0_fixmastertype;
  logic         cpu0_isolaten;
  logic         cpu0_retainn;
  logic         cpu0_mpudisable;
  logic         cpu0_sleepholdreqn;
  logic         cpu0_rxev;
  logic         cpu0_edbgrq;
  logic         cpu0_dbgrestart;
  logic [ 31:0] cpu0_auxfault;
  logic         cpu0_wicenreq;
  logic         cpu0_cdbgpwrupreq;
  logic         cpu0_sysresetreq;
  logic         cpu0_lockup;
  logic         wdog_reset_req;
  logic         mtx_remap;
  logic [239:0] cpu0_intisr;
  logic         cpu0_intnmi;

  logic nTRST, SWCLKTCK, SWDITMS, TDI;
  logic dftscanmode, dftcgen, dftse;

  initial begin
    cpu0_stclk         = 0;
    cpu0_stcalib       = 26'h0;
    cpu0_bigend        = 0;
    cpu0_dbgen         = 1;
    cpu0_niden         = 1;
    cpu0_fixmastertype = 0;
    cpu0_isolaten      = 1;
    cpu0_retainn       = 1;
    cpu0_mpudisable    = 0;
    cpu0_sleepholdreqn = 1;
    cpu0_rxev          = 0;
    cpu0_edbgrq        = 0;
    cpu0_dbgrestart    = 0;
    cpu0_auxfault      = 32'h0;
    cpu0_wicenreq      = 0;
    cpu0_cdbgpwrupreq  = 0;
    cpu0_sysresetreq   = 0;
    cpu0_lockup        = 0;
    wdog_reset_req     = 0;
    mtx_remap          = 0;
    cpu0_intisr        = 240'h0;
    cpu0_intnmi        = 0;
    nTRST              = 1;
    SWCLKTCK           = 0;
    SWDITMS            = 0;
    TDI                = 0;
    dftscanmode        = 0;
    dftcgen            = 1;
    dftse              = 0;
  end

  // ----------------------------------------------------------------
  // 4. DUT Instantiation
  // ----------------------------------------------------------------
  dut_wrapper u_dut (
      .fclk            (fclk),
      .cpu0_po_reset_n (cpu0_po_reset_n),
      .sys_reset_n     (sys_reset_n),
      .cpu0_sys_reset_n(cpu0_sys_reset_n),

      // Static Inputs
      .cpu0_stclk(cpu0_stclk),
      .cpu0_stcalib(cpu0_stcalib),
      .cpu0_bigend(cpu0_bigend),
      .cpu0_dbgen(cpu0_dbgen),
      .cpu0_niden(cpu0_niden),
      .cpu0_fixmastertype(cpu0_fixmastertype),
      .cpu0_isolaten(cpu0_isolaten),
      .cpu0_retainn(cpu0_retainn),
      .cpu0_mpudisable(cpu0_mpudisable),
      .cpu0_sleepholdreqn(cpu0_sleepholdreqn),
      .cpu0_rxev(cpu0_rxev),
      .cpu0_edbgrq(cpu0_edbgrq),
      .cpu0_dbgrestart(cpu0_dbgrestart),
      .cpu0_auxfault(cpu0_auxfault),
      .cpu0_wicenreq(cpu0_wicenreq),
      .cpu0_cdbgpwrupreq(cpu0_cdbgpwrupreq),
      .cpu0_sysresetreq(cpu0_sysresetreq),
      .cpu0_lockup(cpu0_lockup),
      .wdog_reset_req(wdog_reset_req),
      .mtx_remap(mtx_remap),
      .cpu0_intisr(cpu0_intisr),
      .cpu0_intnmi(cpu0_intnmi),

      // SRAM Connections
      // We map the specific indices of the interface array to the specific DUT ports
      .sram0_rdata(sram_vif[0].RDATA),
      .sram0_addr(sram_vif[0].ADDR),
      .sram0_wren(sram_vif[0].WREN),
      .sram0_wdata(sram_vif[0].WDATA),
      .sram0_cs(sram_vif[0].CS),
      .sram1_rdata(sram_vif[1].RDATA),
      .sram1_addr(sram_vif[1].ADDR),
      .sram1_wren(sram_vif[1].WREN),
      .sram1_wdata(sram_vif[1].WDATA),
      .sram1_cs(sram_vif[1].CS),
      .sram2_rdata(sram_vif[2].RDATA),
      .sram2_addr(sram_vif[2].ADDR),
      .sram2_wren(sram_vif[2].WREN),
      .sram2_wdata(sram_vif[2].WDATA),
      .sram2_cs(sram_vif[2].CS),
      .sram3_rdata(sram_vif[3].RDATA),
      .sram3_addr(sram_vif[3].ADDR),
      .sram3_wren(sram_vif[3].WREN),
      .sram3_wdata(sram_vif[3].WDATA),
      .sram3_cs(sram_vif[3].CS),

      // AHB Connections
      .targexp0hsel(targexp0_vif.HSEL),
      .targexp0haddr(targexp0_vif.HADDR),
      .targexp0htrans(targexp0_vif.HTRANS),
      .targexp0hwrite(targexp0_vif.HWRITE),
      .targexp0hsize(targexp0_vif.HSIZE),
      .targexp0hburst(targexp0_vif.HBURST),
      .targexp0hprot(targexp0_vif.HPROT),
      .targexp0hwdata(targexp0_vif.HWDATA),
      .targexp0hrdata(targexp0_vif.HRDATA),
      .targexp0hreadyout(targexp0_vif.HREADYOUT),
      .targexp0hresp(targexp0_vif.HRESP),
      .targexp1hsel(targexp1_vif.HSEL),
      .targexp1haddr(targexp1_vif.HADDR),
      .targexp1htrans(targexp1_vif.HTRANS),
      .targexp1hwrite(targexp1_vif.HWRITE),
      .targexp1hsize(targexp1_vif.HSIZE),
      .targexp1hburst(targexp1_vif.HBURST),
      .targexp1hprot(targexp1_vif.HPROT),
      .targexp1hwdata(targexp1_vif.HWDATA),
      .targexp1hrdata(targexp1_vif.HRDATA),
      .targexp1hreadyout(targexp1_vif.HREADYOUT),
      .targexp1hresp(targexp1_vif.HRESP),

      .initexp0hsel  (initexp0_vif.HSEL),
      .initexp0haddr (initexp0_vif.HADDR),
      .initexp0htrans(initexp0_vif.HTRANS),
      .initexp0hwrite(initexp0_vif.HWRITE),
      .initexp0hsize (initexp0_vif.HSIZE),
      .initexp0hburst(initexp0_vif.HBURST),
      .initexp0hprot (initexp0_vif.HPROT),
      .initexp0hwdata(initexp0_vif.HWDATA),
      .initexp0hrdata(initexp0_vif.HRDATA),
      .initexp0hready(initexp0_vif.HREADYOUT),
      .initexp0hresp (initexp0_vif.HRESP),
      .initexp1hsel  (initexp1_vif.HSEL),
      .initexp1haddr (initexp1_vif.HADDR),
      .initexp1htrans(initexp1_vif.HTRANS),
      .initexp1hwrite(initexp1_vif.HWRITE),
      .initexp1hsize (initexp1_vif.HSIZE),
      .initexp1hburst(initexp1_vif.HBURST),
      .initexp1hprot (initexp1_vif.HPROT),
      .initexp1hwdata(initexp1_vif.HWDATA),
      .initexp1hrdata(initexp1_vif.HRDATA),
      .initexp1hready(initexp1_vif.HREADYOUT),
      .initexp1hresp (initexp1_vif.HRESP),

      // AHB Tie-offs
      .targexp0memattr(),
      .targexp0exreq(),
      .targexp0hmaster(),
      .targexp0hmastlock(),
      .targexp0hreadymux(),
      .targexp0hauser(),
      .targexp0hwuser(),
      .targexp0exresp(1'b0),
      .targexp0hruser(3'b0),
      .targexp1memattr(),
      .targexp1exreq(),
      .targexp1hmaster(),
      .targexp1hmastlock(),
      .targexp1hreadymux(),
      .targexp1hauser(),
      .targexp1hwuser(),
      .targexp1exresp(1'b0),
      .targexp1hruser(3'b0),
      .initexp0memattr(2'b0),
      .initexp0exreq(1'b0),
      .initexp0hmaster(4'b0),
      .initexp0hauser(1'b0),
      .initexp0hwuser(4'b0),
      .initexp0exresp(),
      .initexp0hruser(),
      .initexp0hmastlock(1'b0),
      .initexp1memattr(2'b0),
      .initexp1exreq(1'b0),
      .initexp1hmaster(4'b0),
      .initexp1hauser(1'b0),
      .initexp1hwuser(4'b0),
      .initexp1exresp(),
      .initexp1hruser(),
      .initexp1hmastlock(1'b0),

      // APB Connections [2-15]
      // Mapped to the apb_vif array
      .apbtargexp2psel(apb_vif[2].psel),
      .apbtargexp2penable(apb_vif[2].penable),
      .apbtargexp2paddr(apb_vif[2].paddr),
      .apbtargexp2pwrite(apb_vif[2].pwrite),
      .apbtargexp2pwdata(apb_vif[2].pwdata),
      .apbtargexp2prdata(apb_vif[2].prdata),
      .apbtargexp2pready(apb_vif[2].pready),
      .apbtargexp2pslverr(apb_vif[2].pslverr),
      .apbtargexp2pstrb(apb_vif[2].pstrb),
      .apbtargexp2pprot(apb_vif[2].pprot),
      .apbtargexp3psel(apb_vif[3].psel),
      .apbtargexp3penable(apb_vif[3].penable),
      .apbtargexp3paddr(apb_vif[3].paddr),
      .apbtargexp3pwrite(apb_vif[3].pwrite),
      .apbtargexp3pwdata(apb_vif[3].pwdata),
      .apbtargexp3prdata(apb_vif[3].prdata),
      .apbtargexp3pready(apb_vif[3].pready),
      .apbtargexp3pslverr(apb_vif[3].pslverr),
      .apbtargexp3pstrb(apb_vif[3].pstrb),
      .apbtargexp3pprot(apb_vif[3].pprot),
      .apbtargexp4psel(apb_vif[4].psel),
      .apbtargexp4penable(apb_vif[4].penable),
      .apbtargexp4paddr(apb_vif[4].paddr),
      .apbtargexp4pwrite(apb_vif[4].pwrite),
      .apbtargexp4pwdata(apb_vif[4].pwdata),
      .apbtargexp4prdata(apb_vif[4].prdata),
      .apbtargexp4pready(apb_vif[4].pready),
      .apbtargexp4pslverr(apb_vif[4].pslverr),
      .apbtargexp4pstrb(apb_vif[4].pstrb),
      .apbtargexp4pprot(apb_vif[4].pprot),
      .apbtargexp5psel(apb_vif[5].psel),
      .apbtargexp5penable(apb_vif[5].penable),
      .apbtargexp5paddr(apb_vif[5].paddr),
      .apbtargexp5pwrite(apb_vif[5].pwrite),
      .apbtargexp5pwdata(apb_vif[5].pwdata),
      .apbtargexp5prdata(apb_vif[5].prdata),
      .apbtargexp5pready(apb_vif[5].pready),
      .apbtargexp5pslverr(apb_vif[5].pslverr),
      .apbtargexp5pstrb(apb_vif[5].pstrb),
      .apbtargexp5pprot(apb_vif[5].pprot),
      .apbtargexp6psel(apb_vif[6].psel),
      .apbtargexp6penable(apb_vif[6].penable),
      .apbtargexp6paddr(apb_vif[6].paddr),
      .apbtargexp6pwrite(apb_vif[6].pwrite),
      .apbtargexp6pwdata(apb_vif[6].pwdata),
      .apbtargexp6prdata(apb_vif[6].prdata),
      .apbtargexp6pready(apb_vif[6].pready),
      .apbtargexp6pslverr(apb_vif[6].pslverr),
      .apbtargexp6pstrb(apb_vif[6].pstrb),
      .apbtargexp6pprot(apb_vif[6].pprot),
      .apbtargexp7psel(apb_vif[7].psel),
      .apbtargexp7penable(apb_vif[7].penable),
      .apbtargexp7paddr(apb_vif[7].paddr),
      .apbtargexp7pwrite(apb_vif[7].pwrite),
      .apbtargexp7pwdata(apb_vif[7].pwdata),
      .apbtargexp7prdata(apb_vif[7].prdata),
      .apbtargexp7pready(apb_vif[7].pready),
      .apbtargexp7pslverr(apb_vif[7].pslverr),
      .apbtargexp7pstrb(apb_vif[7].pstrb),
      .apbtargexp7pprot(apb_vif[7].pprot),
      .apbtargexp8psel(apb_vif[8].psel),
      .apbtargexp8penable(apb_vif[8].penable),
      .apbtargexp8paddr(apb_vif[8].paddr),
      .apbtargexp8pwrite(apb_vif[8].pwrite),
      .apbtargexp8pwdata(apb_vif[8].pwdata),
      .apbtargexp8prdata(apb_vif[8].prdata),
      .apbtargexp8pready(apb_vif[8].pready),
      .apbtargexp8pslverr(apb_vif[8].pslverr),
      .apbtargexp8pstrb(apb_vif[8].pstrb),
      .apbtargexp8pprot(apb_vif[8].pprot),
      .apbtargexp9psel(apb_vif[9].psel),
      .apbtargexp9penable(apb_vif[9].penable),
      .apbtargexp9paddr(apb_vif[9].paddr),
      .apbtargexp9pwrite(apb_vif[9].pwrite),
      .apbtargexp9pwdata(apb_vif[9].pwdata),
      .apbtargexp9prdata(apb_vif[9].prdata),
      .apbtargexp9pready(apb_vif[9].pready),
      .apbtargexp9pslverr(apb_vif[9].pslverr),
      .apbtargexp9pstrb(apb_vif[9].pstrb),
      .apbtargexp9pprot(apb_vif[9].pprot),
      .apbtargexp10psel(apb_vif[10].psel),
      .apbtargexp10penable(apb_vif[10].penable),
      .apbtargexp10paddr(apb_vif[10].paddr),
      .apbtargexp10pwrite(apb_vif[10].pwrite),
      .apbtargexp10pwdata(apb_vif[10].pwdata),
      .apbtargexp10prdata(apb_vif[10].prdata),
      .apbtargexp10pready(apb_vif[10].pready),
      .apbtargexp10pslverr(apb_vif[10].pslverr),
      .apbtargexp10pstrb(apb_vif[10].pstrb),
      .apbtargexp10pprot(apb_vif[10].pprot),
      .apbtargexp11psel(apb_vif[11].psel),
      .apbtargexp11penable(apb_vif[11].penable),
      .apbtargexp11paddr(apb_vif[11].paddr),
      .apbtargexp11pwrite(apb_vif[11].pwrite),
      .apbtargexp11pwdata(apb_vif[11].pwdata),
      .apbtargexp11prdata(apb_vif[11].prdata),
      .apbtargexp11pready(apb_vif[11].pready),
      .apbtargexp11pslverr(apb_vif[11].pslverr),
      .apbtargexp11pstrb(apb_vif[11].pstrb),
      .apbtargexp11pprot(apb_vif[11].pprot),
      .apbtargexp12psel(apb_vif[12].psel),
      .apbtargexp12penable(apb_vif[12].penable),
      .apbtargexp12paddr(apb_vif[12].paddr),
      .apbtargexp12pwrite(apb_vif[12].pwrite),
      .apbtargexp12pwdata(apb_vif[12].pwdata),
      .apbtargexp12prdata(apb_vif[12].prdata),
      .apbtargexp12pready(apb_vif[12].pready),
      .apbtargexp12pslverr(apb_vif[12].pslverr),
      .apbtargexp12pstrb(apb_vif[12].pstrb),
      .apbtargexp12pprot(apb_vif[12].pprot),
      .apbtargexp13psel(apb_vif[13].psel),
      .apbtargexp13penable(apb_vif[13].penable),
      .apbtargexp13paddr(apb_vif[13].paddr),
      .apbtargexp13pwrite(apb_vif[13].pwrite),
      .apbtargexp13pwdata(apb_vif[13].pwdata),
      .apbtargexp13prdata(apb_vif[13].prdata),
      .apbtargexp13pready(apb_vif[13].pready),
      .apbtargexp13pslverr(apb_vif[13].pslverr),
      .apbtargexp13pstrb(apb_vif[13].pstrb),
      .apbtargexp13pprot(apb_vif[13].pprot),
      .apbtargexp14psel(apb_vif[14].psel),
      .apbtargexp14penable(apb_vif[14].penable),
      .apbtargexp14paddr(apb_vif[14].paddr),
      .apbtargexp14pwrite(apb_vif[14].pwrite),
      .apbtargexp14pwdata(apb_vif[14].pwdata),
      .apbtargexp14prdata(apb_vif[14].prdata),
      .apbtargexp14pready(apb_vif[14].pready),
      .apbtargexp14pslverr(apb_vif[14].pslverr),
      .apbtargexp14pstrb(apb_vif[14].pstrb),
      .apbtargexp14pprot(apb_vif[14].pprot),
      .apbtargexp15psel(apb_vif[15].psel),
      .apbtargexp15penable(apb_vif[15].penable),
      .apbtargexp15paddr(apb_vif[15].paddr),
      .apbtargexp15pwrite(apb_vif[15].pwrite),
      .apbtargexp15pwdata(apb_vif[15].pwdata),
      .apbtargexp15prdata(apb_vif[15].prdata),
      .apbtargexp15pready(apb_vif[15].pready),
      .apbtargexp15pslverr(apb_vif[15].pslverr),
      .apbtargexp15pstrb(apb_vif[15].pstrb),
      .apbtargexp15pprot(apb_vif[15].pprot),


      // Debug & Misc
      .nTRST(nTRST),
      .SWCLKTCK(SWCLKTCK),
      .SWDITMS(SWDITMS),
      .TDI(TDI),
      .TDO(),
      .nTDOEN(),
      .SWDO(),
      .SWDOEN(),
      .JTAGNSW(),
      .SWV(),
      .TRACECLK(),
      .TRACEDATA(),
      .trcena(),
      .cpu0tsvalueb(),
      .cpu0halted(),
      .cpu0wakeup(),
      .cpu0wicenack(),
      .cpu0wicsense(),
      .cpu0cdbgpwrupack(),
      .flash_err_o(),
      .flash_int_o(),
      .dftscanmode(dftscanmode),
      .dftcgen(dftcgen),
      .dftse(dftse)
  );

  initial begin
    fclk = 0;
    forever #5 fclk = ~fclk;
  end

  // Reset Generation Sequence
  initial begin
    cpu0_po_reset_n  = 0;
    sys_reset_n      = 0;
    cpu0_sys_reset_n = 0;

    repeat (10) @(posedge fclk);
    cpu0_po_reset_n = 1;

    repeat (10) @(posedge fclk);
    sys_reset_n      = 1;
    cpu0_sys_reset_n = 1;
  end
  // ----------------------------------------------------------------
  // 5. UVM Config DB Settings
  // ----------------------------------------------------------------
  initial begin
    // 1. Set SRAM Interfaces (Array)
    // Matches the foreach loop in iot_env: "sram_vif_0", "sram_vif_1", etc.
    //foreach (sram_vif[i]) begin
    //  uvm_config_db#(virtual sram_if.TB)::set(null, "*", $sformatf("sram_vif_%0d", i), sram_vif[i]);
    //end
    // 2. Set AHB Interfaces
    uvm_config_db#(virtual ahb_if.SLAVE)::set(null, "*", "vif", targexp0_vif);
    uvm_config_db#(virtual ahb_if.SLAVE)::set(null, "*", "vif", targexp1_vif);
    uvm_config_db#(virtual ahb_if.MASTER)::set(null, "*", "vif", initexp0_vif);
    uvm_config_db#(virtual ahb_if.MASTER)::set(null, "*", "vif", initexp1_vif);

    // 3. Set APB Interfaces (2 to 15)
    // Matches the naming convention in iot_env: "APB_2", "APB_3", etc.
    //for (int i = 2; i <= 15; i++) begin
    //uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, $sformatf("*APB_%0d*", i), "vif", apb_vif[i]);
    //end


    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_2*", "vif", apb_vif[2].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_3*", "vif", apb_vif[3].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_4*", "vif", apb_vif[4].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_5*", "vif", apb_vif[5].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_6*", "vif", apb_vif[6].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_7*", "vif", apb_vif[7].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_8*", "vif", apb_vif[8].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_9*", "vif", apb_vif[9].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_10*", "vif",
                                                       apb_vif[10].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_11*", "vif",
                                                       apb_vif[11].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_12*", "vif",
                                                       apb_vif[12].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_13*", "vif",
                                                       apb_vif[13].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_14*", "vif",
                                                       apb_vif[14].slave_mp);
    uvm_config_db#(virtual apb_slave_if.slave_mp)::set(null, "*APB_15*", "vif",
                                                       apb_vif[15].slave_mp);


    uvm_config_db#(virtual sram_if)::set(null, "*", "sram_vif_0", sram_vif[0]);
    uvm_config_db#(virtual sram_if)::set(null, "*", "sram_vif_1", sram_vif[1]);
    uvm_config_db#(virtual sram_if)::set(null, "*", "sram_vif_2", sram_vif[2]);
    uvm_config_db#(virtual sram_if)::set(null, "*", "sram_vif_3", sram_vif[3]);
    // ----------------------------------------------------------------
    //
    // 6. Run Test
    // ----------------------------------------------------------------
  end
  initial begin
    run_test("iot_ahb_wr_rd_test");
  end

endmodule
