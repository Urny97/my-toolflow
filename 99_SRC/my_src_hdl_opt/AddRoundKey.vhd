library ieee;
use ieee.std_logic_1164.all;

entity AddRoundKey is
  port (  key_in : in std_logic_vector(127 downto 0);
	  text_in: in std_logic_vector(127 downto 0);
	  ARK_out: out std_logic_vector(127 downto 0));
end entity;

architecture AddRoundKey_arch of AddRoundKey is
begin
  process(key_in, text_in)
  begin
    ARK_out(127 downto 120) <= key_in(127 downto 120) xor text_in(127 downto 120);
    ARK_out(119 downto 112) <= key_in(119 downto 112) xor text_in(119 downto 112);
    ARK_out(111 downto 104) <= key_in(111 downto 104) xor text_in(111 downto 104);
    ARK_out(103 downto 96) <= key_in(103 downto 96) xor text_in(103 downto 96);
    ARK_out(95 downto 88) <= key_in(95 downto 88) xor text_in(95 downto 88);
    ARK_out(87 downto 80) <= key_in(87 downto 80) xor text_in(87 downto 80);
    ARK_out(79 downto 72) <= key_in(79 downto 72) xor text_in(79 downto 72);
    ARK_out(71 downto 64) <= key_in(71 downto 64) xor text_in(71 downto 64);
    ARK_out(63 downto 56) <= key_in(63 downto 56) xor text_in(63 downto 56);
    ARK_out(55 downto 48) <= key_in(55 downto 48) xor text_in(55 downto 48);
    ARK_out(47 downto 40) <= key_in(47 downto 40) xor text_in(47 downto 40);
    ARK_out(39 downto 32) <= key_in(39 downto 32) xor text_in(39 downto 32);
    ARK_out(31 downto 24) <= key_in(31 downto 24) xor text_in(31 downto 24);
    ARK_out(23 downto 16) <= key_in(23 downto 16) xor text_in(23 downto 16);
    ARK_out(15 downto 8) <= key_in(15 downto 8) xor text_in(15 downto 8);
    ARK_out(7 downto 0) <= key_in(7 downto 0) xor text_in(7 downto 0);
  end process;

end;
