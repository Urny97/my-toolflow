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
  signal done_sign, clear_sign, hold_data_out_sign,
         contr_out_DO_mux_sel, read_data_in_sign: STD_LOGIC;

  component Control_FSM is
    port(
    clock, reset, ce: in STD_LOGIC;
    roundcounter: out STD_LOGIC_VECTOR(3 downto 0);
    ARK_mux_sel: out STD_LOGIC_VECTOR(1 downto 0);
    DO_mux_sel, done, clear, hold_data_out,
    read_data_in: out STD_LOGIC
    );
  end component;

  component KeyScheduler is
    port(
      roundcounter: in STD_LOGIC_VECTOR(3 downto 0);
		  clock: in std_logic;
			reset: in std_logic;
			ce: in std_logic;
			key: in std_logic_vector(127 downto 0);
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
                            key_out_ARK_in);
  Ctl_FSM: Control_FSM port map(clock, reset, ce, rcon_contr_rcon_keys,
                           contr_out_ARK_mux_sel, contr_out_DO_mux_sel,
                           done_sign, clear_sign, hold_data_out_sign,
                           read_data_in_sign);
  ARK: AddRoundKey port map(key_out_ARK_in, ARK_mux_out_ARK_in, ARK_out_reg_in);
  SB: SubBytes port map(reg_out_SB_in, SB_out_shiftrow_in);
  SR: ShiftRow port map(SB_out_shiftrow_in, SR_out_MC_in);
  MC: MixColumn port map(SR_out_MC_in, MC_out_ARK_mux_in);

  data_out <= final_data_out;
  done <= done_sign;

  -- ARK mux
  ARK_mux: process(contr_out_ARK_mux_sel, DI_reg_out, MC_out_ARK_mux_in, SR_out_MC_in)
  begin
    case contr_out_ARK_mux_sel is
      when "00" => ARK_mux_out_ARK_in <= DI_reg_out;
      when "01" => ARK_mux_out_ARK_in <= MC_out_ARK_mux_in;
      when "11" => ARK_mux_out_ARK_in <= SR_out_MC_in;
      when others => ARK_mux_out_ARK_in <= (others => '0');
    end case;
  end process;

  -- DataOut mux
  DO_mux: process(contr_out_DO_mux_sel, ARK_out_reg_in)
  begin
    case contr_out_DO_mux_sel is
      when '0' => final_data_out <= (others => '0');
      when '1' => final_data_out <= DO_reg_out;
      when others => final_data_out <= (others => '0');
    end case;
  end process;

  -- SB_reg
  SB_reg: process(clock, reset, clear_sign, ARK_out_reg_in)
  begin
    if reset = '1' then
      reg_out_SB_in <= (others => '0');
    elsif rising_edge(clock) then
      if ce = '1' then
        if clear_sign = '1' then
          reg_out_SB_in <= (others => '0');
        else
          reg_out_SB_in <= ARK_out_reg_in;
        end if;
      end if;
    end if;
  end process;

  --data_in_reg
  DI_reg: process(clock, reset, read_data_in_sign)
  begin
    if reset = '1' then
      DI_reg_out <= (others => '0');
    elsif rising_edge(clock) then
      if ce = '1' then
        if read_data_in_sign = '1' then
          DI_reg_out <= data_in;
        end if;
      end if;
    end if;
  end process;

  --data_out_reg
  DO_reg: process(clock, reset, ARK_out_reg_in, hold_data_out_sign)
  begin
    if reset = '1' then
      DO_reg_out <= (others => '0');
    elsif rising_edge(clock) then
      if ce = '1' then  
        if hold_data_out_sign = '1' then
          DO_reg_out <= ARK_out_reg_in;
        end if;
      end if;
    end if;
  end process;

end Behavioral;
