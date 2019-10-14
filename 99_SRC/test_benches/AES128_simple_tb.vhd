library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use STD.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.PKG_AES128.ALL;

entity AES128_simple_tb is
end AES128_simple_tb;

architecture Behavioural of AES128_simple_tb is

  signal reset, clock : STD_LOGIC;
  signal ce, done : STD_LOGIC;
  signal data_in, data_out, key : STD_LOGIC_VECTOR(127 downto 0);
  
  signal failed : STD_LOGIC;

  constant clock_period : time := C_SIM_CLKPERIOD;

  shared variable endsim : boolean := false;

begin

  -- clock
  PCLK: process
  begin
    if endsim=false then
      clock <= '0';
      wait for clock_period/2;
      clock <= '1';
      wait for clock_period/2;
    else
      wait;
    end if;
  end process;

  -- DUT
  DUT: component AES128 port map(
    reset => reset, 
    clock => clock,
    ce => ce,
    data_in => data_in,
    key => key,
    data_out => data_out,
    done => done
  );

   PSTIM: process
   begin
    -- initialisation
    reset <= '1';
    ce <= '0';
    failed <= '0';
    data_in <= (others => '0');
    key <= (others => '0');
    wait for clock_period*5;
	  reset <= '0';
    wait for clock_period*30;
    
    -- TestVector on nominal operation
    data_in <= x"3243f6a8885a308d313198a2e0370734";
    --data_in <= x"54776F204F6E65204E696E652054776F";
    key <= x"2b7e151628aed2a6abf7158809cf4f3c";
    --key <= x"5468617473206D79204B756E67204675";
    wait for clock_period;
    ce <= '1';
    wait until done = '1';
    if(data_out /= x"3925841d02dc09fbdc118597196a0b32") then failed <= '1'; end if;
    wait for clock_period;
	  ce <= '0';
    wait for clock_period*10;

    endsim := true;
    report "Simulation ended";

    wait;
   end process;

end Behavioural;