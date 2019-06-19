library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SubBytes is
  port(
    SB_in: in STD_LOGIC_VECTOR(127 downto 0);
    SB_out: out STD_LOGIC_VECTOR(127 downto 0)
  );
end SubBytes;

architecture Behavioural of SubBytes is

component AES_Sbox_Canright is
  port(
    a :in std_logic_vector( 7 downto 0 );
    q :out std_logic_vector( 7 downto 0 )
  );
end component;

begin
--instantiatie van component
C1 : AES_Sbox_Canright port map (SB_in(127 downto 120), SB_out(127 downto 120));
C2 : AES_Sbox_Canright port map (SB_in(119 downto 112), SB_out(119 downto 112));
C3 : AES_Sbox_Canright port map (SB_in(111 downto 104), SB_out(111 downto 104));
C4 : AES_Sbox_Canright port map (SB_in(103 downto 96), SB_out(103 downto 96));
C5 : AES_Sbox_Canright port map (SB_in(95 downto 88), SB_out(95 downto 88));
C6 : AES_Sbox_Canright port map (SB_in(87 downto 80), SB_out(87 downto 80));
C7 : AES_Sbox_Canright port map (SB_in(79 downto 72), SB_out(79 downto 72));
C8 : AES_Sbox_Canright port map (SB_in(71 downto 64), SB_out(71 downto 64));
C9 : AES_Sbox_Canright port map (SB_in(63 downto 56), SB_out(63 downto 56));
C10 : AES_Sbox_Canright port map (SB_in(55 downto 48), SB_out(55 downto 48));
C11 : AES_Sbox_Canright port map (SB_in(47 downto 40), SB_out(47 downto 40));
C12 : AES_Sbox_Canright port map (SB_in(39 downto 32), SB_out(39 downto 32));
C13 : AES_Sbox_Canright port map (SB_in(31 downto 24), SB_out(31 downto 24));
C14 : AES_Sbox_Canright port map (SB_in(23 downto 16), SB_out(23 downto 16));
C15 : AES_Sbox_Canright port map (SB_in(15 downto 8), SB_out(15 downto 8));
C16 : AES_Sbox_Canright port map (SB_in(7 downto 0), SB_out(7 downto 0));

end Behavioural;
