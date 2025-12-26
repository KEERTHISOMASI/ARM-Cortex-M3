//RTL Package

package rtl_pkg;

  `include "../../../../../m3designstart/logical/fpga_top/verilog/fpga_options_defs.v"


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
endpackage
