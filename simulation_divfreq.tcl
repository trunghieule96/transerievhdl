vlib work
vcom divfreq.vhd
vcom test.vhd
vsim -gui work.test(bench)
add wave -noupdate -divider {Signaux d'entrée} clk rst Tb
add wave -noupdate -divider {Signaux de sortie}  HE
run 70 ms
wave zoom full
