// TEST Package

package iot_test_pkg;
  `include "iot_test_base.sv"

  //AHB Tests
  `include "../ahb_tests/ahb_single_write_test.sv"
  `include "../ahb_tests/ahb_single_read_test.sv"
  `include "../ahb_tests/ahb_incr4_burst_test.sv"
  `include "../ahb_tests/ahb_wr_rd_test.sv"

  //APB Tests
  `include "../apb_tests/apb_wr_rd_test.sv"
  `include "../apb_tests/apb_strb_test.sv"

  //SRAM Tests
  `include "../SRAM_tests/ahb_sram_addr_boundary_test.sv"
  `include "../SRAM_tests/ahb_sram_concurrent_access_test.sv"
  `include "../SRAM_tests/ahb_sram_default_val_test.sv"
  `include "../SRAM_tests/ahb_sram_default_wren_test.sv"
  `include "../SRAM_tests/ahb_sram_coherency_test.sv"
endpackage

