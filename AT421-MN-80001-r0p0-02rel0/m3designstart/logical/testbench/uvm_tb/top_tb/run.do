vlog +define+SIMULATION tb_top.sv
vsim tb_top -voptargs=+acc
do wave.do
run -all

