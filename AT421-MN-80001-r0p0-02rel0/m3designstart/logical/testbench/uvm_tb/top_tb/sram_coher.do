onerror {resume}
quietly WaveActivateNextPane {} 0
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {11803 ps}
