
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GF_SQ_2 is
	port(	a: in std_logic_vector(1 downto 0);
			q: out std_logic_vector(1 downto 0));
end GF_SQ_2;

architecture Behavioral of GF_SQ_2 is

begin
	q <= a(0) & a(1);

end Behavioral;