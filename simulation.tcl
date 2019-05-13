vlib work

vcom transserie.vhd
vcom testserie.vhd

vsim -gui work.testtransserie(bench)
add wave -noupdate -divider {Signaux d'entrée} h rst txrdy cts D
add wave -noupdate -divider {Signaux d'interne} sim:/testtransserie/UUT1/etat sim:/testtransserie/UUT1/netat sim:/testtransserie/UUT1/I sim:/testtransserie/UUT1/z
add wave -noupdate -divider {Signaux de sortie} txd trans 

run 1000 ns
wave zoom full
