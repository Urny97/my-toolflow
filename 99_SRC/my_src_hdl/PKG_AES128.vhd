library ieee;
use ieee.std_logic_1164.all;

use STD.textio.all;
use ieee.std_logic_textio.all;

package PKG_AES128 is

  constant C_SIM_CLKPERIOD : time := 10 ns;
  constant C_SIM_MINCLKPERIODTOFINISH : time := 20 * C_SIM_CLKPERIOD;

  type T_TV is record
    input : STD_LOGIC_VECTOR(127 downto 0);
    key : STD_LOGIC_VECTOR(127 downto 0);
    output : STD_LOGIC_VECTOR(127 downto 0);
  end record T_TV;
   
  type T_TVCATALOG is array (0 to 99) of T_TV;

  type T_TESTS is array(1 to 256) of integer;

  component ByteSub is
    port( 
      BS_in :in std_logic_vector(7 downto 0);
      BS_out :out std_logic_vector(7 downto 0)
    );
  end component;

  component Keyscheduler is 
    port( 
      roundcounter: in STD_LOGIC_VECTOR(3 downto 0);
      clock: in std_logic; 
      reset: in std_logic;
      ce: in std_logic;
      key: in std_logic_vector(127 downto 0);
      key_out: out std_logic_vector(127 downto 0)
    );
  end component;

  component MixColumn is 
    port (  
      MC_in : in std_logic_vector (127 downto 0);
      MC_out : out std_logic_vector(127 downto 0)
    );
  end component;

  component ShiftRow is 
    port (  
      shiftrow_in : in std_logic_vector(127 downto 0);
      shiftrow_out : out std_logic_vector(127 downto 0)
    );
  end component;

  component AES128 is
    Port ( 
      reset : in  STD_LOGIC;
      clock : in  STD_LOGIC;
      ce : in  STD_LOGIC;
      data_in : in STD_LOGIC_VECTOR(127 downto 0);
      key : in STD_LOGIC_VECTOR(127 downto 0);
      data_out : out STD_LOGIC_VECTOR(127 downto 0);
      done : out STD_LOGIC);
  end component;

  procedure printTestreport (
    signal testreport : in T_TESTS);
  procedure saveTestreport (
      signal testreport : in T_TESTS);

end PKG_AES128;

package body PKG_AES128 is

  procedure printTestreport (
    signal testreport : in T_TESTS) is
  begin
    for i in 1 to 256 loop
      report("T" & integer'image(i) & ": " & integer'image(testreport(i))) severity note;
    end loop;
  end printTestreport;
  
  procedure saveTestreport (
    signal testreport : in T_TESTS) is
    variable v_line : line;
    file fh_report : text;
  begin
    file_open(fh_report, "testreport.txt", write_mode);

    for i in 1 to 256 loop
      write(v_line, integer'image(i) & "," & integer'image(testreport(i)));
      writeline(fh_report, v_line);
    end loop;

    file_close(fh_report);
  end saveTestreport;
  
end PKG_AES128;
