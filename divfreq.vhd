library ieee;
use ieee.std_logic_1164.all, ieee.numeric_std.all, ieee.std_logic_unsigned.all;

entity divfreq is
	port(clk, rst : std_logic;		--Variable de contrôle		
	     Tb : std_logic_vector(1 downto 0);
	     HE : out std_logic); 	--Variable de sortie
end entity;


architecture rtl of divfreq is
	signal I : unsigned(20 downto 0);
	signal C : unsigned(16 downto 0);
	signal raz, eq400, eq800, eq1200 : std_logic;

	constant T1200 : unsigned(16 downto 0) := "01010001011000011"; 
	constant T800  : unsigned(16 downto 0) := "01111010000100100";
	constant T400 : unsigned(16 downto 0) := "11110100001001000";

 	begin
		process(clk, rst, raz)					
		begin
			if rst = '0' then
				I <= (others=> '0');
				C <= (others=> '0');
			elsif clk = '1' and clk'event then
				I <= I + 1;
				if (raz = '0') then
					C <= C + 1;
				else
					C <= (others => '0');
				end if;
			end if;
		end process;

		eq1200 <= '1' when C = T1200
			else '0';
		eq400 <= '1' when C = T400
			else '0';
		eq800 <= '1' when C = T800
			else '0';

		raz <= ( not(Tb(0)) and not(Tb(1)) and eq800 )
			or ( Tb(0)  and not(Tb(1)) and eq1200 ) 
			or ( Tb(1)  and eq400 );
		HE <= raz;
end architecture;