vlog -f rtl.f
vlog +define+SIMULATION tb_top.sv
vsim tb_top -voptargs=+acc +UVM_TESTNAME=ahb_incr4_burst_test
do wave.do
run -all

