library ieee;
use ieee.std_logic_1164.all, ieee.std_logic_unsigned.all, ieee.numeric_std.all;

entity uasync is
port(
	rst,clk,Cs,Rw,Adr,cts : std_logic;
	txd : out std_logic;
	writedata:std_logic_vector(15 downto 0);
	readdata: out std_logic_vector(15 downto 0)
);
end uasync;

architecture beh of uasync is

component divfreq is
port(
	Tb : std_logic_vector(1 downto 0);
	clk,rst: std_logic;
	HE: out std_logic
);
end component;

component transserie is
port(
	Txrdy,cts,rst,H:std_logic;
	d:std_logic_vector(7 downto 0);
	Txd,trans:out std_logic
);
end component;

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

for UUTdivfreq:divfreq use entity work.divfreq(rtl);
for UUTtransserie:transserie use entity work.transserie(dflow);
for UUTinterbus:interbus use entity work.interbus(rtl);

signal readdata_R:std_logic_vector(15 downto 0);
signal Txrdy_R,trans_R,HE_R,Txd_R:std_logic;
signal d_R:std_logic_vector(7 downto 0);
signal Tb_R:std_logic_vector(1 downto 0);

begin
	UUTdivfreq:divfreq port map(Tb=>Tb_R,clk=>clk,rst=>rst,HE=>HE_R);
	UUTtransserie:transserie port map(Txrdy=>Txrdy_R,cts=>cts,rst=>rst,H=>HE_R,d=>d_R,Txd=>Txd_R,trans=>trans_R);
	UUTinterbus:interbus port map(Cs=>Cs,Rw=>Rw,Adr=>Adr,trans=>trans_R,clk=>clk,rst=>rst,writedata=>writedata,readdata=>readdata_R,Txrdy=>Txrdy_R,D=>D_R,Tb=>Tb_R);
	txd<=Txd_R;
	readdata<=readdata_R;
end beh;