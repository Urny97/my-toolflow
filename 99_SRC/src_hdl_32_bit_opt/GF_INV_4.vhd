library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GF_INV_4 is
	port(	a: in std_logic_vector(3 downto 0);
			q: out std_logic_vector(3 downto 0));
end GF_INV_4;

architecture Behavioral of GF_INV_4 is
	component GF_MULS_2
		port(	a: in std_logic_vector(1 downto 0);
				ab: in std_logic;
				b: in std_logic_vector(1 downto 0);
				cd: in std_logic;
				q: out std_logic_vector(1 downto 0));
	end component;
	component GF_SQ_2
		port(	a: in std_logic_vector(1 downto 0);
				q: out std_logic_vector(1 downto 0));
	end component;
	component GF_SCLW2_2
		port(	a: in std_logic_vector(1 downto 0);
				q: out std_logic_vector(1 downto 0));
	end component;
	signal a_int, b, c, d, p, q_int, ab, ab2, ab2n, a_int_xor_b, ab_xor_ab2n: std_logic_vector(1 downto 0);
	signal sa, sb, sd: std_logic;
begin
	a_int <= a(3 downto 2);
	b <= a(1 downto 0);

	sa <= a_int(1) xor a_int(0);
	sb <= b(1) xor b(0);

	inst_GF_MULS_2_1: GF_MULS_2
		port map(a_int, sa, b, sb, ab);

	a_int_xor_b <= a_int xor b;

	inst_GF_SQ_2_1: GF_SQ_2
		port map(a_int_xor_b, ab2);

	inst_GF_SCLW2_2: GF_SCLW2_2
		port map(ab2, ab2n);

	ab_xor_ab2n <= ab xor ab2n;

	inst_GF_SQ_2_2: GF_SQ_2
		port map(ab_xor_ab2n, d);

	sd <= d(1) xor d(0);

	inst_GF_MULS_2_3: GF_MULS_2
		port map(d, sd, b, sb, p);

	inst_GF_MULS_2_4: GF_MULS_2
		port map(d, sd, a_int, sa, q_int);

	q <= p & q_int;

end Behavioral;
