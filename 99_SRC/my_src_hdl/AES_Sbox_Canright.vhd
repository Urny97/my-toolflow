
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- find either Sbox or its inverse in GF(2^8), by Canright Algorithm
entity AES_Sbox_Canright is
  port(  a: in std_logic_vector(7 downto 0);
			   q: out std_logic_vector(7 downto 0));
end AES_Sbox_Canright;

architecture Behavioral of AES_Sbox_Canright is
  component GF_INV_8
  	port(	a: in std_logic_vector(7 downto 0);
        q: out std_logic_vector(7 downto 0));
  end component;

  signal b, c, d, z : std_logic_vector(7 downto 0);
  signal r1, r2, r3, r4, r5, r6, r7, r8, r9: std_logic;
  signal t1, t2, t3, t4, t5, t6, t7, t8, t9: std_logic;

begin
  -- change basis from GF(2^8)
  -- combine with bit inverse matrix multiply of Sbox
  r1 <= a(7) xor a(5);
  r2 <= a(7) xnor a(4);
  r3 <= a(6) xor a(0);
  r4 <= a(5) xnor r3;
  r5 <= a(4) xor r4;
  r6 <= a(3) xor a(0);
  r7 <= a(2) xor r1;
  r8 <= a(1) xor r3;
  r9 <= a(3) xor r8;

  b(7) <= r7 xnor r8;
  b(6) <= r5;
  b(5) <= a(1) xor r4;
  b(4) <= r1 xnor r3;
  b(3) <= a(1) xor r2 xor r6;
  b(2) <= not a(0);
  b(1) <= r4;
  b(0) <= a(2) xnor r9;

  z <= not b;

  inst_GF_INV_8: GF_INV_8
    port map(z, c);

  -- change basis back from GF(2^8)/GF(2^4)/GF(2^2) to GF(2^8)
  t1 <= c(7) xor c(3);
  t2 <= c(6) xor c(4);
  t3 <= c(6) xor c(0);
  t4 <= c(5) xnor c(3);
  t5 <= c(5) xnor t1;
  t6 <= c(5) xnor c(1);
  t7 <= c(4) xnor t6;
  t8 <= c(2) xor t4;
  t9 <= c(1) xor t2;

  d(7) <= t4;
  d(6) <= t1;
  d(5) <= t3;
  d(4) <= t5;
  d(3) <= t2 xor t5;
  d(2) <= t3 xor t8;
  d(1) <= t7;
  d(0) <= t9;

  q <= not d;

end Behavioral;
