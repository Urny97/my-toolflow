library ieee;
use ieee.std_logic_1164.all;

entity MixColumn32 is 
	port (	MC_in : in std_logic_vector (31 downto 0);
			MC_out : out std_logic_vector(31 downto 0)
			);
end entity;


architecture MixColumn_arch of MixColumn32 is

	function MULT(t : std_logic_vector(7 downto 0)) return std_logic_vector is
		variable tmp : std_logic_vector(7 downto 0);
	begin
		if(t(7) = '1') then
			tmp := (t(6 downto 0)&'0') xor x"1b";
		else
			tmp := t(6 downto 0)&'0';
		end if;
		return tmp;
	end MULT;

begin
	MC_out(31 downto 0) <=  (MULT(MC_in(31 downto 24)) xor
							(MULT(MC_in(23 downto 16)) xor 
							MC_in(23 downto 16)) xor
							MC_in(15 downto 8) xor 
							MC_in(7 downto 0)) &
							 
							(MC_in(31 downto 24) xor 
							MULT(MC_in(23 downto 16)) xor
							(MULT(MC_in(15 downto 8)) xor
							MC_in(15 downto 8)) xor 
							MC_in(7 downto 0)) &
							 
							(MC_in(31 downto 24) xor
							MC_in(23 downto 16) xor
							MULT(MC_in(15 downto 8)) xor
							(MULT(MC_in(7 downto 0))xor
							MC_in(7 downto 0))) &
							 
							((MULT(MC_in(31 downto 24))xor
							MC_in(31 downto 24)) xor
							MC_in(23 downto 16) xor
							MC_in(15 downto 8) xor
							MULT(MC_in(7 downto 0)));


end;