
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GF_MULS_2 is
	port(	a: in std_logic_vector(1 downto 0);
			ab: in std_logic;
			b: in std_logic_vector(1 downto 0);
			cd: in std_logic;
			q: out std_logic_vector(1 downto 0));
end GF_MULS_2;

architecture Behavioral of GF_MULS_2 is
	signal abcd, p, q_int: std_logic;
begin
	--abcd <= '1' xor (ab and cd);
	abcd <= (ab nand cd);
	p <= (a(1) nand b(1)) xor abcd;
	q_int <= (a(0) nand b(0)) xor abcd;
	q <= p & q_int;
end Behavioral;
