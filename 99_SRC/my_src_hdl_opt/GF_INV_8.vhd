
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GF_INV_8 is
	port(	a: in std_logic_vector(7 downto 0);
			q: out std_logic_vector(7 downto 0));
end GF_INV_8;

architecture Behavioral of GF_INV_8 is
	component GF_MULS_4
	port(	a: in std_logic_vector(3 downto 0);
			a_small: in std_logic_vector(1 downto 0);
			al, ah, aa: in std_logic;
			b: in std_logic_vector(3 downto 0);
			b_small: in std_logic_vector(1 downto 0);
			bl, bh, bb: in std_logic;
			q: out std_logic_vector(3 downto 0));
	end component;
	component GF_SQ_SCL_4
		port(	a: in std_logic_vector(3 downto 0);
				q: out std_logic_vector(3 downto 0));
	end component;
	component GF_INV_4
		port(	a: in std_logic_vector(3 downto 0);
				q: out std_logic_vector(3 downto 0));
	end component;
	signal a_int, b, c, d, p, q_int, ab, ab2, a_int_xor_b, ab_xor_ab2: std_logic_vector(3 downto 0);
	signal sa, sb, sd, t: std_logic_vector(1 downto 0);
	signal al, ah, aa, bl, bh, bb, dl, dh, dd: std_logic;
	signal c1, c2, c3: std_logic;
begin
	a_int <= a(7 downto 4);
	b <= a(3 downto 0);
	sa <= a_int(3 downto 2) xor a_int(1 downto 0);
	sb <= b(3 downto 2) xor b(1 downto 0);
	al <= a_int(1) xor a_int(0);
	ah <= a_int(3) xor a_int(2);
	aa <= sa(1) xor sa(0);
	bl <= b(1) xor b(0);
	bh <= b(3) xor b(2);
	bb <= sb(1) xor sb(0);

	inst_GF_MULS_4_1: GF_MULS_4
		port map(a_int, sa, al, ah, aa, b, sb, bl, bh, bb, ab);

	a_int_xor_b <= a_int xor b;

	inst_GF_SQ_SCL_4: GF_SQ_SCL_4
		port map(a_int_xor_b, ab2);

	ab_xor_ab2 <= ab xor ab2;

	inst_GF_INV_4: GF_INV_4
		port map(ab_xor_ab2, d);
		
	sd <= d(3 downto 2) xor d(1 downto 0);
	dl <= d(1) xor d(0);
	dh <= d(3) xor d(2);
	dd <= sd(1) xor sd(0);
	
	inst_GF_MULS_4_2: GF_MULS_4
		port map(d, sd, dl, dh, dd, b, sb, bl, bh, bb, p);
		
	inst_GF_MULS_4_3: GF_MULS_4
		port map(d, sd, dl, dh, dd, a_int, sa, al, ah, aa, q_int);
		
	q <= p & q_int;
	
end Behavioral;