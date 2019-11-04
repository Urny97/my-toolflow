
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GF_SQ_SCL_4 is
	port(	a: in std_logic_vector(3 downto 0);
			q: out std_logic_vector(3 downto 0));
end GF_SQ_SCL_4;

architecture Behavioral of GF_SQ_SCL_4 is
	component GF_SQ_2
		port(	a: in std_logic_vector(1 downto 0);
				q: out std_logic_vector(1 downto 0));
	end component;
	component GF_SCLW_2
		port(	a: in std_logic_vector(1 downto 0);
				q: out std_logic_vector(1 downto 0));
	end component;
	signal a_int, b, ab2, b2, b2n2, a_int_xor_b: std_logic_vector(1 downto 0);
begin
	a_int <= a(3 downto 2);
	b <= a(1 downto 0);

	a_int_xor_b <= a_int xor b;

	inst_GF_SQ_2_1: GF_SQ_2
		port map(a_int_xor_b, ab2);

	inst_GF_SQ_2_2: GF_SQ_2
		port map(b, b2);

	inst_GF_SCLW_2: GF_SCLW_2
		port map(b2, b2n2);

	q <= ab2 & b2n2;
end Behavioral;
