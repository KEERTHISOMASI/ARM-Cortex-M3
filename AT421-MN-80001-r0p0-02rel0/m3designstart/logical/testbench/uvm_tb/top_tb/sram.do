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
add wave -noupdate -divider sram0
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
WaveRestoreCursors {{Cursor 1} {130207 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 216
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
WaveRestoreZoom {0 ps} {278250 ps}
