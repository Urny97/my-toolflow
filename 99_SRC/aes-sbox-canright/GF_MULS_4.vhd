
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GF_MULS_4 is
	port(	a: in std_logic_vector(3 downto 0);
			a_small: in std_logic_vector(1 downto 0);
			al, ah, aa: in std_logic;
			b: in std_logic_vector(3 downto 0);
			b_small: in std_logic_vector(1 downto 0);
			bl, bh, bb: in std_logic;
			q: out std_logic_vector(3 downto 0));
end GF_MULS_4;

architecture Behavioral of GF_MULS_4 is
	component GF_MULS_2
		port(	a: in std_logic_vector(1 downto 0);
				ab: in std_logic;
				b: in std_logic_vector(1 downto 0);
				cd: in std_logic;
				q: out std_logic_vector(1 downto 0));
	end component;
	component GF_MULS_SCL_2
		port(	a: in std_logic_vector(1 downto 0);
				ab: in std_logic;
				b: in std_logic_vector(1 downto 0);
				cd: in std_logic;
				q: out std_logic_vector(1 downto 0));
	end component;
	signal ph, pl, ps, p: std_logic_vector(1 downto 0);
	signal t: std_logic;
begin
	inst_GF_MULS_2_1: GF_MULS_2
		port map(a(3 downto 2), ah, b(3 downto 2), bh, ph);

	inst_GF_MULS_2_2: GF_MULS_2
		port map(a(1 downto 0), al, b(1 downto 0), bl, pl);

	inst_GF_MULS_SCL_2: GF_MULS_SCL_2
		port map(a_small, aa, b_small, bb, p);

	q <= (ph xor p) & (pl xor p);
end Behavioral;
