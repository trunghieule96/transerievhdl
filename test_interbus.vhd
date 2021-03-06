library ieee;
use ieee.std_logic_1164.all, ieee.std_logic_unsigned.all, ieee.numeric_std.all;

entity testinterbus is
end entity;

architecture bench of testinterbus is
component interbus is
port(
	Cs,Rw,Adr,trans,clk,rst:std_logic;
	writedata:std_logic_vector(15 downto 0);
	readdata: out std_logic_vector(15 downto 0);
	Txrdy: out std_logic;
	D: out std_logic_vector(7 downto 0);
	Tb: out std_logic_vector(1 downto 0)
);
end component;

signal Cs,Rw,Adr,trans,rst,Txrdy:std_logic;
signal clk :std_logic:='0';
signal writedata,readdata:std_logic_vector(15 downto 0);
signal D: std_logic_vector(7 downto 0);
signal Tb: std_logic_vector(1 downto 0);


for UUT:interbus use entity work.interbus(rtl);
begin
	UUT:interbus port map(Cs=>Cs,Rw=>Rw,Adr=>Adr,trans=>trans,clk=>clk,rst=>rst,writedata=>writedata,readdata=>readdata,Txrdy=>Txrdy,D=>D,Tb=>Tb);
	rst <= '0', '1' after 10 ns;
	clk <= not clk after 10 ns;
	writedata <= "1010101010101010" after 10 ns;
	Cs<='0','1' after 50 ns;
	Rw<='0','1' after 50 ns, '0' after 400 ns;
	Adr<='0', '1' after 170 ns;
	trans<='1' after 200 ns, '0' after 300 ns;
end bench;