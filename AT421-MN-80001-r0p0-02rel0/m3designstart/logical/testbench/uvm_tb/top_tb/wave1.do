onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/initexp1_vif/hclk
add wave -noupdate /tb_top/initexp1_vif/hresetn
add wave -noupdate /tb_top/initexp1_vif/HADDR
add wave -noupdate /tb_top/initexp1_vif/HWRITE
add wave -noupdate /tb_top/initexp1_vif/HTRANS
add wave -noupdate /tb_top/initexp1_vif/HSIZE
add wave -noupdate /tb_top/initexp1_vif/HBURST
add wave -noupdate /tb_top/initexp1_vif/HPROT
add wave -noupdate /tb_top/initexp1_vif/HWDATA
add wave -noupdate /tb_top/initexp1_vif/HRDATA
add wave -noupdate /tb_top/initexp1_vif/HRESP
add wave -noupdate /tb_top/initexp1_vif/HSEL
add wave -noupdate /tb_top/initexp1_vif/HREADY
add wave -noupdate -expand -label {Contributors: HREADY} -group {Contributors: sim:/tb_top/initexp1_vif/HREADY} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/hreadyoutinitexp1
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/hreadyoutinitexp1
add wave -noupdate -expand -label {Contributors: hreadyoutinitexp1} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/hreadyoutinitexp1} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/data_valid
add wave -noupdate -expand -label {Contributors: hreadyoutinitexp1} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/hreadyoutinitexp1} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran_reg
add wave -noupdate -expand -label {Contributors: hreadyoutinitexp1} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/hreadyoutinitexp1} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip
add wave -noupdate -expand -label {Contributors: hreadyoutinitexp1} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/hreadyoutinitexp1} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/resp_ip
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran_reg
add wave -noupdate -expand -label {Contributors: pend_tran_reg} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran_reg} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/HCLK
add wave -noupdate -expand -label {Contributors: pend_tran_reg} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran_reg} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/HRESETn
add wave -noupdate -expand -label {Contributors: pend_tran_reg} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran_reg} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran
add wave -noupdate -expand -label {Contributors: pend_tran} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip
add wave -noupdate -expand -label {Contributors: pend_tran} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/load_reg
add wave -noupdate -expand -label {Contributors: pend_tran} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran_reg
add wave -noupdate -expand -label {Contributors: pend_tran} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/pend_tran} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip
add wave -noupdate -expand -label {Contributors: active_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec0
add wave -noupdate -expand -label {Contributors: active_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec1
add wave -noupdate -expand -label {Contributors: active_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec2
add wave -noupdate -expand -label {Contributors: active_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec3
add wave -noupdate -expand -label {Contributors: active_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec4
add wave -noupdate -expand -label {Contributors: active_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec5
add wave -noupdate -expand -label {Contributors: active_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec6
add wave -noupdate -expand -label {Contributors: active_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec7
add wave -noupdate -expand -label {Contributors: active_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/active_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/addr_out_port
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/addr_out_port
add wave -noupdate -expand -label {Contributors: addr_out_port} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/addr_out_port} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/data_out_port
add wave -noupdate -expand -label {Contributors: addr_out_port} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/addr_out_port} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/decode_addr_dec
add wave -noupdate -expand -label {Contributors: addr_out_port} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/addr_out_port} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/remapping_dec
add wave -noupdate -expand -label {Contributors: addr_out_port} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/addr_out_port} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/trans_dec
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/data_out_port
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec0
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec1
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec2
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec3
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec4
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec5
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec6
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec7
add wave -noupdate -expand -label {Contributors: readyout_ip} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/readyout_ip} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dft_slv
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec6
add wave -noupdate -expand -label {Contributors: readyout_dec6} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/readyout_dec6} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/i_hreadymuxm
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/i_hreadymuxm
add wave -noupdate -expand -label {Contributors: i_hreadymuxm} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/i_hreadymuxm} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/HREADYOUTM
add wave -noupdate -expand -label {Contributors: i_hreadymuxm} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/i_hreadymuxm} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/slave_sel
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/slave_sel
add wave -noupdate -expand -label {Contributors: slave_sel} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/slave_sel} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/HCLK
add wave -noupdate -expand -label {Contributors: slave_sel} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/slave_sel} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/HRESETn
add wave -noupdate -expand -label {Contributors: slave_sel} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/slave_sel} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/i_hreadymuxm
add wave -noupdate -expand -label {Contributors: slave_sel} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/slave_sel} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/i_hselm
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp0_6/i_hselm
add wave -noupdate -divider DUT
add wave -noupdate -divider Targexp1
add wave -noupdate /tb_top/targexp1_vif/hclk
add wave -noupdate /tb_top/targexp1_vif/hresetn
add wave -noupdate /tb_top/targexp1_vif/HADDR
add wave -noupdate /tb_top/targexp1_vif/HWRITE
add wave -noupdate /tb_top/targexp1_vif/HTRANS
add wave -noupdate /tb_top/targexp1_vif/HSIZE
add wave -noupdate /tb_top/targexp1_vif/HBURST
add wave -noupdate /tb_top/targexp1_vif/HPROT
add wave -noupdate /tb_top/targexp1_vif/HWDATA
add wave -noupdate /tb_top/targexp1_vif/HRDATA
add wave -noupdate /tb_top/targexp1_vif/HREADYOUT
add wave -noupdate /tb_top/targexp1_vif/HRESP
add wave -noupdate /tb_top/targexp1_vif/HSEL
add wave -noupdate /tb_top/targexp1_vif/HREADYMUX
add wave -noupdate /tb_top/targexp1_vif/HREADY
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/addr_out_port
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec7
add wave -noupdate -expand -label {Contributors: active_dec7} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec7} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/addr_in_port
add wave -noupdate -expand -label {Contributors: active_dec7} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/active_dec7} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/no_port
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/addr_in_port
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/no_port
add wave -noupdate -expand -label {Contributors: no_port} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/no_port} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/u_output_arb/i_no_port
add wave -noupdate -expand -label {Contributors: addr_in_port} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/addr_in_port} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/u_output_arb/i_addr_in_port
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/addr_valid
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/HSELS
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_input_stage_3/HTRANSS
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_decoderinitexp1/data_out_port
add wave -noupdate /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/slave_sel
add wave -noupdate -expand -label {Contributors: slave_sel (1)} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/slave_sel} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/HCLK
add wave -noupdate -expand -label {Contributors: slave_sel (1)} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/slave_sel} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/HRESETn
add wave -noupdate -expand -label {Contributors: slave_sel (1)} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/slave_sel} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/i_hreadymuxm
add wave -noupdate -expand -label {Contributors: slave_sel (1)} -group {Contributors: sim:/tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/slave_sel} /tb_top/u_dut/u_iot_top/u_p_beid_interconnect_f0/u_p_beid_interconnect_f0_ahb_mtx/u_p_beid_interconnect_f0_ahb_mtx_output_stagetargexp1_7/i_hselm
add wave -noupdate -divider Targexp0
add wave -noupdate /tb_top/targexp0_vif/hclk
add wave -noupdate /tb_top/targexp0_vif/hresetn
add wave -noupdate /tb_top/targexp0_vif/HADDR
add wave -noupdate /tb_top/targexp0_vif/HWRITE
add wave -noupdate /tb_top/targexp0_vif/HTRANS
add wave -noupdate /tb_top/targexp0_vif/HSIZE
add wave -noupdate /tb_top/targexp0_vif/HBURST
add wave -noupdate /tb_top/targexp0_vif/HPROT
add wave -noupdate /tb_top/targexp0_vif/HWDATA
add wave -noupdate /tb_top/targexp0_vif/HRDATA
add wave -noupdate /tb_top/targexp0_vif/HREADYOUT
add wave -noupdate /tb_top/targexp0_vif/HRESP
add wave -noupdate /tb_top/targexp0_vif/HSEL
add wave -noupdate /tb_top/targexp0_vif/HREADYMUX
add wave -noupdate /tb_top/targexp0_vif/HREADY
add wave -noupdate -divider {APB 5}
add wave -noupdate {/tb_top/apb_vif[5]/pclk}
add wave -noupdate {/tb_top/apb_vif[5]/presetn}
add wave -noupdate {/tb_top/apb_vif[5]/psel}
add wave -noupdate {/tb_top/apb_vif[5]/penable}
add wave -noupdate {/tb_top/apb_vif[5]/pwrite}
add wave -noupdate {/tb_top/apb_vif[5]/paddr}
add wave -noupdate {/tb_top/apb_vif[5]/pwdata}
add wave -noupdate {/tb_top/apb_vif[5]/prdata}
add wave -noupdate {/tb_top/apb_vif[5]/pready}
add wave -noupdate {/tb_top/apb_vif[5]/pslverr}
add wave -noupdate {/tb_top/apb_vif[5]/pstrb}
add wave -noupdate {/tb_top/apb_vif[5]/pprot}
add wave -noupdate -divider {apb 8}
add wave -noupdate {/tb_top/apb_vif[8]/pclk}
add wave -noupdate {/tb_top/apb_vif[8]/presetn}
add wave -noupdate {/tb_top/apb_vif[8]/psel}
add wave -noupdate {/tb_top/apb_vif[8]/penable}
add wave -noupdate {/tb_top/apb_vif[8]/pwrite}
add wave -noupdate {/tb_top/apb_vif[8]/paddr}
add wave -noupdate {/tb_top/apb_vif[8]/pwdata}
add wave -noupdate {/tb_top/apb_vif[8]/prdata}
add wave -noupdate {/tb_top/apb_vif[8]/pready}
add wave -noupdate {/tb_top/apb_vif[8]/pslverr}
add wave -noupdate {/tb_top/apb_vif[8]/pstrb}
add wave -noupdate {/tb_top/apb_vif[8]/pprot}
add wave -noupdate -divider {sram 2}
add wave -noupdate {/tb_top/sram_vif[2]/CLK}
add wave -noupdate {/tb_top/sram_vif[2]/CS}
add wave -noupdate {/tb_top/sram_vif[2]/ADDR}
add wave -noupdate {/tb_top/sram_vif[2]/WREN}
add wave -noupdate {/tb_top/sram_vif[2]/WDATA}
add wave -noupdate {/tb_top/sram_vif[2]/RDATA}
add wave -noupdate -divider spi
add wave -noupdate /tb_top/initexp0_vif/hclk
add wave -noupdate /tb_top/initexp0_vif/hresetn
add wave -noupdate /tb_top/initexp0_vif/HADDR
add wave -noupdate /tb_top/initexp0_vif/HWRITE
add wave -noupdate /tb_top/initexp0_vif/HTRANS
add wave -noupdate /tb_top/initexp0_vif/HSIZE
add wave -noupdate /tb_top/initexp0_vif/HBURST
add wave -noupdate /tb_top/initexp0_vif/HPROT
add wave -noupdate /tb_top/initexp0_vif/HWDATA
add wave -noupdate /tb_top/initexp0_vif/HRDATA
add wave -noupdate /tb_top/initexp0_vif/HREADYOUT
add wave -noupdate /tb_top/initexp0_vif/HRESP
add wave -noupdate /tb_top/initexp0_vif/HSEL
add wave -noupdate /tb_top/initexp0_vif/HREADYMUX
add wave -noupdate /tb_top/initexp0_vif/HMASTLOCK
add wave -noupdate /tb_top/initexp0_vif/HREADY
add wave -noupdate -divider dma
add wave -noupdate /tb_top/initexp1_vif/hclk
add wave -noupdate /tb_top/initexp1_vif/hresetn
add wave -noupdate /tb_top/initexp1_vif/HADDR
add wave -noupdate /tb_top/initexp1_vif/HWRITE
add wave -noupdate /tb_top/initexp1_vif/HTRANS
add wave -noupdate /tb_top/initexp1_vif/HSIZE
add wave -noupdate /tb_top/initexp1_vif/HBURST
add wave -noupdate /tb_top/initexp1_vif/HPROT
add wave -noupdate /tb_top/initexp1_vif/HWDATA
add wave -noupdate /tb_top/initexp1_vif/HRDATA
add wave -noupdate /tb_top/initexp1_vif/HREADYOUT
add wave -noupdate /tb_top/initexp1_vif/HRESP
add wave -noupdate /tb_top/initexp1_vif/HSEL
add wave -noupdate /tb_top/initexp1_vif/HREADYMUX
add wave -noupdate /tb_top/initexp1_vif/HMASTLOCK
add wave -noupdate /tb_top/initexp1_vif/HREADY
add wave -noupdate {/tb_top/sram_vif[0]/CLK}
add wave -noupdate {/tb_top/sram_vif[0]/CS}
add wave -noupdate {/tb_top/sram_vif[0]/ADDR}
add wave -noupdate {/tb_top/sram_vif[0]/WREN}
add wave -noupdate {/tb_top/sram_vif[0]/WDATA}
add wave -noupdate {/tb_top/sram_vif[0]/RDATA}
add wave -noupdate {/tb_top/sram_vif[1]/CLK}
add wave -noupdate {/tb_top/sram_vif[1]/CS}
add wave -noupdate {/tb_top/sram_vif[1]/ADDR}
add wave -noupdate {/tb_top/sram_vif[1]/WREN}
add wave -noupdate {/tb_top/sram_vif[1]/WDATA}
add wave -noupdate {/tb_top/sram_vif[1]/RDATA}
add wave -noupdate {/tb_top/sram_vif[2]/CLK}
add wave -noupdate {/tb_top/sram_vif[2]/CS}
add wave -noupdate {/tb_top/sram_vif[2]/ADDR}
add wave -noupdate {/tb_top/sram_vif[2]/WREN}
add wave -noupdate {/tb_top/sram_vif[2]/WDATA}
add wave -noupdate {/tb_top/sram_vif[2]/RDATA}
add wave -noupdate {/tb_top/sram_vif[3]/CLK}
add wave -noupdate {/tb_top/sram_vif[3]/CS}
add wave -noupdate {/tb_top/sram_vif[3]/ADDR}
add wave -noupdate {/tb_top/sram_vif[3]/WREN}
add wave -noupdate {/tb_top/sram_vif[3]/WDATA}
add wave -noupdate {/tb_top/sram_vif[3]/RDATA}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {68250 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 384
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {456750 ps}
