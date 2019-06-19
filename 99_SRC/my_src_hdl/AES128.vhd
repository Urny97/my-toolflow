library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity AES128 is
  port(
    reset: in std_logic;
    clock: in std_logic;
    ce: in std_logic;
    data_in: in std_logic_vector(127 downto 0);
    key: in std_logic_vector(127 downto 0);
    data_out: out std_logic_vector(127 downto 0);
    done: out std_logic
  );
end AES128;

architecture Behavioral of AES128 is

  -- signalen om componenten aan elkaar te hangen
  signal key_out_ARK_in, ARK_out_reg_in, SB_out_shiftrow_in,
         SR_out_MC_in, ARK_mux_out_ARK_in, MC_out_ARK_mux_in,
         final_data_out, reg_out_SB_in, DI_reg_out,
         DO_reg_out: STD_LOGIC_VECTOR(127 downto 0);

  signal rcon_contr_rcon_keys: STD_LOGIC_VECTOR(3 downto 0);
  signal contr_out_ARK_mux_sel: STD_LOGIC_VECTOR(1 downto 0);
  signal done_sign, clear_sign: STD_LOGIC;

  component Control_FSM is
    port(
    clock, reset, ce: in STD_LOGIC;
    roundcounter: out STD_LOGIC_VECTOR(3 downto 0);
    ARK_mux_sel: out STD_LOGIC_VECTOR(1 downto 0);
    done, clear: out STD_LOGIC
    );
  end component;

  component KeyScheduler is
    port(
      roundcounter: in STD_LOGIC_VECTOR(3 downto 0);
		  clock: in std_logic;
			reset: in std_logic;
			ce: in std_logic;
      key: in std_logic_vector(127 downto 0);
      done: in std_logic;
      key_out: out std_logic_vector(127 downto 0)
    );
  end component;

  component AddRoundKey is
    port(
      key_in: in std_logic_vector(127 downto 0);
      text_in: in std_logic_vector(127 downto 0);
      ARK_out: out std_logic_vector(127 downto 0)
    );
  end component;

  component SubBytes is
    port(
      SB_in: in std_logic_vector( 127 downto 0 );
      SB_out: out std_logic_vector( 127 downto 0 )
    );
  end component;

  component ShiftRow is
    port(
      shiftrow_in: in std_logic_vector(127 downto 0);
      shiftrow_out: out std_logic_vector(127 downto 0)
    );
  end component;

  component MixColumn is
    port(
      MC_in: in std_logic_vector (127 downto 0);
		  MC_out: out std_logic_vector(127 downto 0)
    );
  end component;

begin

  -- instantiaties van componenten
  KeyS: KeyScheduler port map(rcon_contr_rcon_keys, clock, reset, ce, key,
                              done_sign, key_out_ARK_in);
  Ctl_FSM: Control_FSM port map(clock, reset, ce, rcon_contr_rcon_keys,
                                contr_out_ARK_mux_sel, done_sign, clear_sign);
  ARK: AddRoundKey port map(key_out_ARK_in, ARK_mux_out_ARK_in, ARK_out_reg_in);
  SB: SubBytes port map(reg_out_SB_in, SB_out_shiftrow_in);
  SR: ShiftRow port map(SB_out_shiftrow_in, SR_out_MC_in);
  MC: MixColumn port map(SR_out_MC_in, MC_out_ARK_mux_in);

  data_out <= final_data_out;
  done <= done_sign;

  -- ARK mux
  ARK_mux: process(contr_out_ARK_mux_sel, data_in, MC_out_ARK_mux_in, SR_out_MC_in)
  begin
    case contr_out_ARK_mux_sel is
      when "00" => ARK_mux_out_ARK_in <= data_in;
      when "01" => ARK_mux_out_ARK_in <= MC_out_ARK_mux_in;
      when "11" => ARK_mux_out_ARK_in <= SR_out_MC_in;
      when others => ARK_mux_out_ARK_in <= (others => '0');
    end case;
  end process;

  -- DataOut mux
  DO_mux: process(done_sign, ARK_out_reg_in)
  begin
    case done_sign is
      when '0' => final_data_out <= (others => '0');
      when '1' => final_data_out <= ARK_out_reg_in;
      when others => final_data_out <= (others => '0');
    end case;
  end process;

  -- SB_reg
  SB_reg: process(clock, reset)
  begin
    if reset = '1' then
      reg_out_SB_in <= (others => '0');
    elsif rising_edge(clock) then
      if ce = '1' then
        if clear_sign = '1' then
          reg_out_SB_in <= (others => '0');
        elsif done_sign = '1' then
          reg_out_SB_in <= reg_out_SB_in;
        else
          reg_out_SB_in <= ARK_out_reg_in;
        end if;
      end if;
    end if;
  end process;

end Behavioral;
