vlib work

vcom divfreq.vhd
vcom transserie.vhd
vcom interbus.vhd
vcom uasync.vhd
vcom test_uasync.vhd

vsim -gui work.testuasync(bench)
add wave -noupdate -divider {Signaux d'entrée} rst clk Cs Rw Adr cts writedata
add wave -noupdate -divider {Signaux de sortie} txd readdata 

run 25 ms
wave zoom full