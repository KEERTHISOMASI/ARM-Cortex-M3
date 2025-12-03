onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HCLK
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HRESETn
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HSELBRAM
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HREADY
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HTRANS
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HSIZE
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HWRITE
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HADDR
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HWDATA
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HREADYOUT
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HRESP
add wave -noupdate /tb_fpga_shield/u_fpga_top/u_fpga_system/u_user_partition/u_m3ds_simple_flash/u_ahb_blockram_128/HRDATA
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {88696427395 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {88696064494 ps} {88696790296 ps}
