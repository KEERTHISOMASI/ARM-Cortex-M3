vlog -f rtl.f
vlog +define+SIMULATION tb_top.sv
vsim tb_top -voptargs=+acc +UVM_TESTNAME=ahb_sram_wren_test
do wave1.do
run -all

