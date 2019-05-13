library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity transserie is
port (Txrdy,cts,rst,H:std_logic;
		d:std_logic_vector(7 downto 0);
		Txd,trans:out std_logic);
end entity;

architecture dflow of transserie is
subtype defetat is std_logic_vector(1 downto 0);
constant T0:defetat:="00";
constant T1:defetat:="01";
constant T2:defetat:="10"; 
constant eq10:integer range 0 to 10:=10;

signal I:integer range 0 to 10;
signal etat,netat: defetat;
signal c1,c2,c3:std_logic;
signal z:std_logic;

signal ld:std_logic;
signal shift:std_logic;
signal dec:std_logic;

begin
-- unite de controle
memoire:process(H,rst)
		begin
		if rst ='0' then
			etat<=T0;
		elsif (H='1' and H'event) then
			etat <= netat;
		end if ;
end process;

combinatoire:process (etat,txrdy,cts,z)
		begin
		C1<='0';C2<='0';C3<='0';
		netat<=etat;
		case etat is
			when T0	=> if txrdy='0' then 
						C1<='0';
						C2<='0';
						C3<='0';
						elsif txrdy='1' and cts ='0' then
							netat<=T1;
						end if;
			when T1	=> netat <= T2;
						C1 <='1';
						C2<='0';
						C3<='0';
			when T2	=> if z='0' then 
						C1<='0';
						C2<='1';
						C3<='1';
						elsif z='1' then
						C1<='0';
						C2<='1';
						C3<='0';
						netat<=T0;
			end if;
			when others => null ;
		end case;
end process;
--Decompteur a prechargement
decompteur:process (H)	
	begin
		if (H='1' and H'event) then
			if ld='1' then
				I<=eq10;
			elsif dec='1' then
				I<=I-1;
			end if;
		end if;
end process;
--eq0
Z<='1' when I=0 else '0';
--registre a dec et prechargement
reg:process(H,rst)
	variable DI:std_logic_vector(10 downto 0);
	begin
		if rst='0' then
			DI(10):='1';
			DI(9 downto 1):=(others =>'0');
			DI(0):='0';
		elsif (H='1' and H'event) then
			if (ld='1') then
				DI(10):='1';
				DI(9) := ((d(7) xor d(6)) xor (d(5) xor d(4))) xor ((d(3) xor d(2)) xor (d(1) xor d(0)));
				DI(8):=d(7);
				DI(7):=d(6);
				DI(6):=d(5);
				DI(5):=d(4);
				DI(4):=d(3);
				DI(3):=d(2);
				DI(2):=d(1);
				DI(1):=d(0);
				DI(0):='0';
				txd<=DI(0);
			elsif (shift='1') then
				txd<=DI(0);
				DI:='0'&DI(10 downto 1);
			end if;
		end if;
	end process;
trans<=c1;
shift<=c2;
ld<=c1;
dec<=c3;
end architecture;

	
				
				
				

		
		
		
	

