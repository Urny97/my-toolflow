library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AES_key_schedule is
	port(	roundkey_in: in std_logic_vector(127 downto 0);
			round_constant: in std_logic_vector(7 downto 0);
			roundkey_out: out std_logic_vector(127 downto 0));
end AES_key_schedule;

architecture Behavioral of AES_key_schedule is
	component AES_sbox
		port(	SB_in: in std_logic_vector(7 downto 0);
				SB_out: out std_logic_vector(7 downto 0));
	end component;
	signal after_rotate, after_subbytes, after_add_round_constant: std_logic_vector(31 downto 0);
	signal roundkey_out_int: std_logic_vector(127 downto 0);
begin
	after_rotate(31 downto 0) <= roundkey_in(23 downto 0) & roundkey_in(31 downto 24);

	gen_subbytes: for i in 0 to 3 generate
		inst_sbox: AES_SBOX
			port map(after_rotate((i+1)*8-1 downto i*8), after_subbytes((i+1)*8-1 downto i*8));
	end generate;

	after_add_round_constant(31 downto 24) <= after_subbytes(31 downto 24) xor round_constant;
	after_add_round_constant(23 downto 0) <= after_subbytes(23 downto 0);

	roundkey_out_int(127 downto 96) <= roundkey_in(127 downto 96) xor after_add_round_constant;
	roundkey_out_int(95 downto 64) <= roundkey_in(95 downto 64) xor roundkey_out_int(127 downto 96);
	roundkey_out_int(63 downto 32) <= roundkey_in(63 downto 32) xor roundkey_out_int(95 downto 64);
	roundkey_out_int(31 downto 0) <= roundkey_in(31 downto 0) xor roundkey_out_int(63 downto 32);

	roundkey_out <= roundkey_out_int;
end Behavioral;
