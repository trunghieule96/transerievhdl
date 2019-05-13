library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity testuasync is
end entity;

architecture bench of testuasync is

component uasync is
port(
	rst,clk,Cs,Rw,Adr,cts : std_logic;
	txd : out std_logic;
	writedata:std_logic_vector(15 downto 0);
	readdata: out std_logic_vector(15 downto 0)
);
end component;

signal rst,Cs,Rw,Adr,cts,txd:std_logic:='0';
signal clk:std_logic:='0';
signal writedata, readdata:std_logic_vector(15 downto 0):=(others=>'0');

for UUT:uasync use entity work.uasync(beh);
begin
	UUT:uasync port map(rst=>rst,clk=>clk,Cs=>Cs,Rw=>Rw,Adr=>Adr,cts=>cts,txd=>txd,writedata=>writedata,readdata=>readdata);
	rst<='0', '1' after 10 ns;
	clk <= not clk after 20 ns;
	cts<='0';
	cs<='1', '0' after 50 ns, '1' after 150 ns, '0' after 180 ns,'1' after 500 ns, '0' after 550 ns, '1' after 1050 ns, '0' after 1100 ns, '1' after 1250 ns, '0' after 1300 ns;
	rw<='1','0' after 50 ns, '1' after 150 ns, '0' after 170 ns, '1' after 1000 ns, '0' after 1250 ns;
	writedata<="0000000001000001";
	adr<='0', '1' after 150 ns;
end bench;