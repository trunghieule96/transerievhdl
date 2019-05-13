library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity testtransserie is
end entity;

architecture bench of testtransserie is
component transserie is
port (txrdy,cts,rst,h:std_logic;
		d:std_logic_vector(7 downto 0);
		txd,trans:out std_logic);
end component;

signal txrdy,cts,rst,h:std_logic:='0';
signal d:std_logic_vector(7 downto 0):="00000000";
signal txd,trans:std_logic:='0';

for UUT1:transserie use entity work.transserie(dflow);
begin
	UUT1:transserie port map (txrdy,cts,rst,h,d,txd,trans);
	h<= not h after 10 ns;
	rst<='0', '1' after 7 ns;
	cts<='0','1' after 16 ns, '0' after 50 ns, '1' after 100 ns, '0' after 200 ns,'1' after 400 ns;
	txrdy<='0','1' after 16 ns;
	D<="10101010" after 9 ns, "00001111" after 320 ns,"11111110" after 480 ns;
end architecture;
	