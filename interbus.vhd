library ieee;
use ieee.std_logic_1164.all, ieee.std_logic_unsigned.all, ieee.numeric_std.all;

entity interbus is
port(
	Cs,Rw,Adr,trans,clk,rst:std_logic;
	writedata:std_logic_vector(15 downto 0);
	readdata: out std_logic_vector(15 downto 0);
	Txrdy: out std_logic;
	D: out std_logic_vector(7 downto 0);
	Tb: out std_logic_vector(1 downto 0)
);
end interbus;

architecture rtl of interbus is
type defetat is (T0,T1,T2,T3);
signal etat,netat:defetat;
signal en_D,en_Tb,R,S,en_readdata:std_logic;
signal Txrdyout:std_logic;
begin
	process(clk,rst)
	begin
		if rst='0' then etat<=T0;
		elsif clk='1' and clk'event then
			etat<=netat;
		end if;
	end process;

	process(trans,Cs,Adr,Rw,etat)
	begin
		en_D<='0';
		en_Tb<='0';
		S<='0';
		R<='0';
		en_readdata<='1';
		case etat is
			when T0 =>
				if (Cs='1' and Rw='1' and Adr='1') then
					netat<=T1;
				elsif (Cs='1' and Rw='1' and Adr='0') then
					en_Tb<='1';
				elsif (Cs='1' and Rw='0') then
					en_readdata<='0';
				end if;
			when T1 => 
				if Rw='1' then
					en_D<='1';
					S<='1';
					R<='0';
					netat<=T2;
				end if;
			when T2 =>
				if trans='1' then
					netat<=T3;
				end if;
			when T3=> 
				en_D<='1';
				if trans='0' then
					S<='0';
					R<='1';
					netat<=T0;
				end if;		
		end case;
	end process;

process(clk,en_D)
variable tmp:std_logic_vector( 7 downto 0);
begin
	if (clk='1' and clk'event and en_D='1') then
		tmp:=writedata(7 downto 0);
	end if;
	D<=tmp;
end process;

process(clk,en_Tb)
variable tmp:std_logic_vector(1 downto 0);
begin
	if (clk='1' and clk'event) then
		if (en_Tb='1') then
			tmp:=writedata(1 downto 0);
		end if;
	end if;
	Tb<=tmp;
end process;

process(clk)
variable tmp: std_logic;
begin
	if(clk='1' and clk'event) then
		if(S='0' and R='0')then
			tmp:=tmp;
		elsif(S='1' and R='1')then
			tmp:='Z';
		elsif(S='0' and R='1')then
			tmp:='0';
		else
			tmp:='1';
		end if;
	end if;
	Txrdyout <= tmp;
end process;
Txrdy<=Txrdyout;
readdata(15 downto 1)<=(others=>'Z') when en_readdata='1' else (others=>'0');
readdata(0) <= 'Z' when en_readdata='1' else Txrdyout;

end rtl;