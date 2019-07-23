library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use STD.textio.all;
use ieee.std_logic_textio.all;

library work;
use work.PKG_AES128.ALL;

entity AES128_tb is
end AES128_tb;

architecture Behavioural of AES128_tb is

  signal reset, clock : STD_LOGIC;
  signal ce, done : STD_LOGIC;
  signal data_in, data_out, key : STD_LOGIC_VECTOR(127 downto 0);

  constant zeros : STD_LOGIC_VECTOR(127 downto 0) := x"00000000000000000000000000000000";
  constant clock_period : time := C_SIM_CLKPERIOD;

  signal testnumber : integer;
  signal testreport : T_TESTS;
  signal tvcatalog : T_TVCATALOG;
  
  file fh_TESTVECTORS : text;

begin

  -- clock
  PCLK: process
  begin
    clock <= '1';
    wait for clock_period/2;
    clock <= '0';
    wait for clock_period/2;
  end process;

  PTV: process
    variable v_lineIn : line;
    variable v_i : natural range 0 to 100;
    variable v_separator: character;
    variable v_temp : STD_LOGIC_VECTOR(127 downto 0);
  begin
    file_open(fh_TESTVECTORS, "tv_output.txt", read_mode);
    v_i := 0;
    while not endfile(fh_TESTVECTORS) loop      
      readline(fh_TESTVECTORS, v_lineIn);
      hread(v_lineIn, v_temp); 
      tvcatalog(v_i).input <= v_temp;
      read(v_lineIn, v_separator);
      hread(v_lineIn, v_temp); 
      tvcatalog(v_i).key <= v_temp;
      read(v_lineIn, v_separator);
      hread(v_lineIn, v_temp); 
      tvcatalog(v_i).output <= v_temp;
      v_i :=  v_i + 1;
    end loop;
    file_close(fh_TESTVECTORS);
    wait;
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

  -- stimuli
  PSTIM: process
    variable v_duration : integer;
  begin
    -- initialisation
    reset <= '1';
    ce <= '0';
    data_in <= (others => '0');
    key <= (others => '0');
    testreport <= (others => 0);
    v_duration := 0;
    wait for clock_period*5;
	reset <= '0';
    wait for clock_period*30;
  
    
    
    -- T7: TestVector on nominal operation
    testnumber <= 7;
    data_in <= x"3243f6a8885a308d313198a2e0370734";
    key <= x"2b7e151628aed2a6abf7158809cf4f3c";
    ce <= '1';
    wait until done = '1';
    if(data_out /= x"3925841d02dc09fbdc118597196a0b32") then testreport(testnumber) <= testreport(testnumber) + 1; end if;
    wait for clock_period;
	 ce <= '0';
    wait for clock_period*10;
    
    -- T8: 2 TestVectors consecutive on nominal operation
    testnumber <= 8;
    data_in <= x"3243f6a8885a308d313198a2e0370734";
    key <= x"2b7e151628aed2a6abf7158809cf4f3c";
    ce <= '1';
    wait until done = '1';
    if(data_out /= x"3925841d02dc09fbdc118597196a0b32") then testreport(testnumber) <= testreport(testnumber) + 1; end if;
	 wait for clock_period;
    ce <= '0';
    wait for clock_period*10;
    
    -- T9: TestVector on interrupted ce operation
    testnumber <= 9;
    data_in <= x"3243f6a8885a308d313198a2e0370734";
    key <= x"2b7e151628aed2a6abf7158809cf4f3c";
    ce <= '1';
    wait for clock_period*5;
    ce <= '0';
    wait for clock_period*50;
    ce <= '1';
    wait until done = '1';
    if(data_out /= x"3925841d02dc09fbdc118597196a0b32") then testreport(testnumber) <= testreport(testnumber) + 4; end if;
	 wait for clock_period;
    ce <= '0';
    wait for clock_period*10;
    
    -- T10: 2 TestVectors consecutive on fastest operation
    testnumber <= 10;
    data_in <= x"3243f6a8885a308d313198a2e0370734";
    key <= x"2b7e151628aed2a6abf7158809cf4f3c";
    ce <= '1';
    wait until done = '1';
    if(data_out /= x"3925841d02dc09fbdc118597196a0b32") then testreport(testnumber) <= testreport(testnumber) + 1; end if;
    wait for clock_period;
	 ce <= '0';
    wait for clock_period;
    ce <= '1';
    wait until done = '1';
    if(data_out /= x"3925841d02dc09fbdc118597196a0b32") then testreport(testnumber) <= testreport(testnumber) + 2; end if;
	 wait for clock_period;
    ce <= '0';
    wait for clock_period*10;
    
    -- T11: TestVector on interrupted reset operation
    testnumber <= 11;
    data_in <= x"3243f6a8885a308d313198a2e0370734";
    key <= x"2b7e151628aed2a6abf7158809cf4f3c";
    ce <= '1';
    wait for clock_period*5;
    reset <= '1';
    wait for clock_period*5;
    reset <= '0';
    wait until done = '1';
    if(data_out /= x"3925841d02dc09fbdc118597196a0b32") then testreport(testnumber) <= testreport(testnumber) + 1; end if;
	 wait for clock_period;
    ce <= '0';
    wait for clock_period*10;
    
    -- T100 - T199 : randomised test vectors
    for i in 100 to 199 loop
        testnumber <= i;
        data_in <= tvcatalog(i-100).input;
        key <= tvcatalog(i-100).key;
        ce <= '1';
        wait until done = '1';
        if(data_out /= tvcatalog(i-100).output) then testreport(testnumber) <= testreport(testnumber) + 1; end if;
		  wait for clock_period;
        ce <= '0';
        wait for clock_period;
    end loop;
    wait for clock_period*10;
    report("Tests done");

    -- M1: Measure duration
    testnumber <= 256;
    data_in <= tvcatalog(0).input;
    key <= tvcatalog(0).key;
    ce <= '1';
    
    while(done = '0') loop
      wait for clock_period;
      v_duration := v_duration + 1;
    end loop;
    ce <= '0';
    testreport(testnumber) <= v_duration;
    wait for clock_period*20;

    report("Measurement done");
    
    --printTestreport(testreport);
    saveTestreport(testreport);
    report("Saving report done");
    
    wait;
  end process;

end Behavioural;
