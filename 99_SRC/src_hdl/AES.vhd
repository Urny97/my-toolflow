library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity AES is
	port(	plaintext, key: in std_logic_vector(127 downto 0);
			clk, reset: in std_logic;
			ciphertext: out std_logic_vector(127 downto 0));
end AES;

architecture Behavioral of AES is
	constant C_NO_AESROUNDS : integer := 10;
	constant C_Q : integer := 128;
	type T_AESMEM_SMALL is array(0 to C_NO_AESROUNDS-1) of STD_LOGIC_VECTOR(C_Q-1 downto 0);
	type T_AESROUND_C is array(0 to C_NO_AESROUNDS-1) of STD_LOGIC_VECTOR(8-1 downto 0);

	component AES_round
		port(	input, key: in std_logic_vector(127 downto 0);
				output, output_lastround: out std_logic_vector(127 downto 0));
	end component;

	component AES_key_schedule
		port(	roundkey_in: in std_logic_vector(127 downto 0);
				round_constant: in std_logic_vector(7 downto 0);
				roundkey_out: out std_logic_vector(127 downto 0));
	end component;

	signal out_lastround, out_keyschedule: std_logic_vector(127 downto 0);

	signal reg_data, reg_key : T_AESMEM_SMALL;
	signal out_data, out_key : T_AESMEM_SMALL;
	signal round_constant: T_AESROUND_C;

begin

	round_constant<= ( 0 => "00000001", 1 => "00000010", 2 => "00000100", 3 => "00001000", 4 => "00010000",
					   5 => "00100000", 6 => "01000000", 7 => "10000000", 8 => "00011011", 9 => "00110110");

	p_reg: process(clk, reset)
	begin
		if reset='1' then
			reg_data <= (others=>(others=>'0'));
			reg_key <= (others=>(others=>'0'));

		elsif clk'event and clk='1' then
			reg_data(0) <= plaintext;						reg_key(0) <= key;
			reg_data(1) <=	out_data(0);					reg_key(1) <= out_key(0);
			reg_data(2) <=	out_data(1);					reg_key(2) <= out_key(1);
			reg_data(3) <=	out_data(2);					reg_key(3) <= out_key(2);
			reg_data(4) <=	out_data(3);					reg_key(4) <= out_key(3);
			reg_data(5) <=	out_data(4);					reg_key(5) <= out_key(4);
			reg_data(6) <=	out_data(5);					reg_key(6) <= out_key(5);
			reg_data(7) <=	out_data(6);					reg_key(7) <= out_key(6);
			reg_data(8) <=	out_data(7);					reg_key(8) <= out_key(7);
			reg_data(9) <=	out_data(8);					reg_key(9) <= out_key(8);
		end if;
	end process;

	inst_AES_round0: AES_round port map(input => reg_data(0), key => reg_key(0), output => out_data(0), output_lastround => open);
	inst_AES_key_schedule0: AES_key_schedule port map(roundkey_in => reg_key(0), round_constant => round_constant(0), roundkey_out => out_key(0));

	inst_AES_round1: AES_round port map(input => reg_data(1), key => reg_key(1), output => out_data(1), output_lastround => open);
	inst_AES_key_schedule1: AES_key_schedule port map(roundkey_in => reg_key(1), round_constant => round_constant(1), roundkey_out => out_key(1));

	inst_AES_round2: AES_round port map(input => reg_data(2), key => reg_key(2), output => out_data(2), output_lastround => open);
	inst_AES_key_schedule2: AES_key_schedule port map(roundkey_in => reg_key(2), round_constant => round_constant(2), roundkey_out => out_key(2));

	inst_AES_round3: AES_round port map(input => reg_data(3), key => reg_key(3), output => out_data(3), output_lastround => open);
	inst_AES_key_schedule3: AES_key_schedule port map(roundkey_in => reg_key(3), round_constant => round_constant(3), roundkey_out => out_key(3));

	inst_AES_round4: AES_round port map(input => reg_data(4), key => reg_key(4), output => out_data(4), output_lastround => open);
	inst_AES_key_schedule4: AES_key_schedule port map(roundkey_in => reg_key(4), round_constant => round_constant(4), roundkey_out => out_key(4));

	inst_AES_round5: AES_round port map(input => reg_data(5), key => reg_key(5), output => out_data(5), output_lastround => open);
	inst_AES_key_schedule5: AES_key_schedule port map(roundkey_in => reg_key(5), round_constant => round_constant(5), roundkey_out => out_key(5));

	inst_AES_round6: AES_round port map(input => reg_data(6), key => reg_key(6), output => out_data(6), output_lastround => open);
	inst_AES_key_schedule6: AES_key_schedule port map(roundkey_in => reg_key(6), round_constant => round_constant(6), roundkey_out => out_key(6));

	inst_AES_round7: AES_round port map(input => reg_data(7), key => reg_key(7), output => out_data(7), output_lastround => open);
	inst_AES_key_schedule7: AES_key_schedule port map(roundkey_in => reg_key(7), round_constant => round_constant(7), roundkey_out => out_key(7));

	inst_AES_round8: AES_round port map(input => reg_data(8), key => reg_key(8), output => out_data(8), output_lastround => open);
	inst_AES_key_schedule8: AES_key_schedule port map(roundkey_in => reg_key(8), round_constant => round_constant(8), roundkey_out => out_key(8));

	inst_AES_round9: AES_round port map(input => reg_data(9), key => reg_key(9), output => out_data(9), output_lastround => out_lastround);
	inst_AES_key_schedule9: AES_key_schedule port map(roundkey_in => reg_key(9), round_constant => round_constant(9), roundkey_out => out_key(9));

	ciphertext <= out_lastround xor out_key(9);

end Behavioral;
