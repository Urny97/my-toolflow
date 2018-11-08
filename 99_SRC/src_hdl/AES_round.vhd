library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AES_round is
	port(	input, key: in std_logic_vector(127 downto 0);
			output, output_lastround: out std_logic_vector(127 downto 0));
end AES_round;

architecture Behavioral of AES_round is
    component AES_sbox is
        port (
            SB_in  : in  std_logic_vector( 7 downto 0 );
            SB_out : out std_logic_vector( 7 downto 0 )
        );
    end component AES_sbox;	
	component AES_mixcolumn
		port(	MC_in : in std_logic_vector (127 downto 0);
				MC_out : out std_logic_vector(127 downto 0));
	end component;
	signal after_addroundkey, after_subbytes, after_shiftrows, after_mixcolumns: std_logic_vector(127 downto 0);
begin
  -- Key addition layer
	after_addroundkey <= input xor key;

	-- Byte substitution layer
	gen_subbytes: for i in 0 to 15 generate
	    inst_sbox: AES_sbox
	        port map ( 
	        	SB_in  => after_addroundkey((i+1)*8-1 downto i*8),
	            SB_out => after_subbytes((i+1)*8-1 downto i*8)
	        );			
	end generate;

	-- ShiftRows
	after_shiftrows(127 downto 120) <= after_subbytes(127 downto 120);
	after_shiftrows(95 downto 88) <= after_subbytes(95 downto 88);
	after_shiftrows(63 downto 56) <= after_subbytes(63 downto 56);
	after_shiftrows(31 downto 24) <= after_subbytes(31 downto 24);

	after_shiftrows(119 downto 112) <= after_subbytes(87 downto 80);
	after_shiftrows(87 downto 80) <= after_subbytes(55 downto 48);
	after_shiftrows(55 downto 48) <= after_subbytes(23 downto 16);
	after_shiftrows(23 downto 16) <= after_subbytes(119 downto 112);

	after_shiftrows(111 downto 104) <= after_subbytes(47 downto 40);
	after_shiftrows(79 downto 72) <= after_subbytes(15 downto 8);
	after_shiftrows(47 downto 40) <= after_subbytes(111 downto 104);
	after_shiftrows(15 downto 8) <= after_subbytes(79 downto 72);

	after_shiftrows(103 downto 96) <= after_subbytes(7 downto 0);
	after_shiftrows(71 downto 64) <= after_subbytes(103 downto 96);
	after_shiftrows(39 downto 32) <= after_subbytes(71 downto 64);
	after_shiftrows(7 downto 0) <= after_subbytes(39 downto 32);

	-- MixColumn
	inst_mixcolumn: AES_mixcolumn
		port map(after_shiftrows, after_mixcolumns);

	-- Output
	output <= after_mixcolumns;
	output_lastround <= after_shiftrows;

end Behavioral;
