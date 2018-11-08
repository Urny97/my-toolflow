library ieee;
use ieee.STD_LOGIC_1164.ALL;
use ieee.STD_LOGIC_ARITH.ALL;
use ieee.STD_LOGIC_UNSIGNED.ALL;

entity Control_FSM is
  port(
    clock, reset, ce: in STD_LOGIC;
    roundcounter: out STD_LOGIC_VECTOR(3 downto 0);
    ARK_mux_sel: out STD_LOGIC_VECTOR(1 downto 0);
    DO_mux_sel, done, clear, hold_data_out,
    read_data_in: out STD_LOGIC
  );
end Control_FSM;

architecture Behavioural of Control_FSM is

  type tStates is (sIdle, sFirstRound, sLoopUntil10, sLastRound, sDone);
  -- Idle: de chip doet niets
  -- sFirstRound: Plain_text wordt een eerste ronde geëncodeerd
  -- LoopUntil9: data loopt negen keer door de verschillende codeerstappen
  -- LastLoop: in de 10e ronde wordt de MixColumn stap overgeslagen
  -- Done: de chip is klaar met de encryptie

  signal curState, nxtState: tStates;
  signal rcon_reg: STD_LOGIC_VECTOR(3 downto 0) := "0000";
  signal done_sign, count_enable, clear_sign, hold_data_out_sign,
  read_data_in_sign: STD_LOGIC;

  begin
    roundcounter <= rcon_reg;
    done <= done_sign;
    clear <= clear_sign;
    hold_data_out <= hold_data_out_sign;
    read_data_in <= read_data_in_sign;

-- Increment Counter
  incr_ctr: process(clock, reset)
  begin
    if reset = '1' then
      rcon_reg <= "0000";
    elsif rising_edge(clock) then
      if ce = '1' and count_enable = '1' then
        if rcon_reg = "1011" then
          rcon_reg <= "0000";
        else
          rcon_reg <= rcon_reg + 1;
        end if;
      else
        rcon_reg <= rcon_reg;
      end if;
    end if;
  end process;

-- State Register
  FSM_switchstate : process(clock, reset)
  begin
    if reset = '1' then
      curState <= sIdle;
    elsif rising_edge(clock) then
      curState <= nxtState;
    end if;
  end process;

--Next State Register
  FSM_nxtState : process(curState, ce, rcon_reg, reset)
  begin
    case curState is
        when sIdle =>
          if reset = '1' then
            nxtState <= sIdle;
          else
            if ce = '1' then
              if rcon_reg = "0000" then
                nxtState <= sFirstRound;
              end if;
            else
              nxtState <= curState;
            end if;
          end if;

        when sFirstRound =>
          if reset = '1' then
            nxtState <= sIdle;
          else
            if ce = '1' then
              if rcon_reg = "0001" then
                nxtState <= sLoopUntil10;
              end if;
            else
              nxtState <= curState;
            end if;
          end if;

        when sLoopUntil10 =>
          if reset = '1' then
            nxtState <= sIdle;
          else
            if ce = '1' then
              if rcon_reg = "1010" then
                nxtState <= sLastRound;
              end if;
            else
              nxtState <= curState;
            end if;
          end if;

        when sLastRound =>
          if reset = '1' then
            nxtState <= sIdle;
          else
            if ce = '1' then
              nxtState <= sDone;
            else
              nxtState <= curState;
            end if;
          end if;

        when sDone =>
          if reset = '1' then
            nxtState <= sIdle;
          else
            if ce = '0' then
              nxtState <= sIdle;
            else
              nxtState <= curState;
            end if;
          end if;

        when others =>
          if reset = '1' then
            nxtState <= sIdle;
          else
            if ce = '1' then
              nxtState <= sIdle;
            else
              nxtState <= curState;
            end if;
          end if;
    end case;
  end process;

  -- Output Function
  Control_out: process(curState)
  begin
    case curState is
      when sIdle => DO_mux_sel <= '0'; ARK_mux_sel <= "00"; done_sign <= '0'; 
                    clear_sign <= '1'; count_enable <= '0';
                    hold_data_out_sign <= '0'; read_data_in_sign <= '0';

      when sFirstRound => DO_mux_sel <= '0'; ARK_mux_sel <= "00"; done_sign <= '0';
                          clear_sign <= '0'; count_enable <= '1'; 
                          hold_data_out_sign <= '0'; read_data_in_sign <= '1';

      when sLoopUntil10 => DO_mux_sel <= '0'; ARK_mux_sel <= "01"; done_sign <= '0';
                          clear_sign <= '0'; count_enable <= '1'; 
                          hold_data_out_sign <= '0'; read_data_in_sign <= '0';

      when sLastRound => DO_mux_sel <= '1'; ARK_mux_sel <= "11"; done_sign <= '0';
                         clear_sign <= '0'; count_enable <= '1'; 
                         hold_data_out_sign <= '1'; read_data_in_sign <= '0';

      when sDone => DO_mux_sel <= '1'; ARK_mux_sel <= "11"; done_sign <= '1';
                    clear_sign <= '0'; count_enable <= '0'; 
                    hold_data_out_sign <= '0'; read_data_in_sign <= '0';
    end case;
  end process;

end Behavioural;
