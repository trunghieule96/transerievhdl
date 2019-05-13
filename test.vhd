library ieee;
use ieee.std_logic_1164.all,
ieee.numeric_std.all;

entity test is 
end entity;

architecture bench of test is
component divfreq
port (	-- l'entree du systeme avec les signal de controle
	Tb : std_logic_vector(1 downto 0);
	clk,rst: std_logic;
	-- Signal de sortie
	HE: out std_logic);
end component;

signal Tb:std_logic_vector (1 downto 0):=(others=>'0');
signal clk:std_logic:='0';
signal HE:std_logic:='0';
signal rst:std_logic;
for UUT2:divfreq use entity work.divfreq(rtl);
begin 
	UUT2:divfreq port map (Tb=>Tb,clk=>clk,rst=>rst,HE=>HE);
	clk<=not clk after 10 ns;
	Tb<="00", "01" after 10 ms, "10" after 30 ms, "11" after 50 ms;
	rst<='0', '1' after 10 ns;
end architecture;