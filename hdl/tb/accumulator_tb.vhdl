library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accumulator_tb is
end entity accumulator_tb;

architecture behaviour of accumulator_tb is
  constant N: positive := 3;
  signal incr_s : std_logic_vector(N-1 downto 0);
  signal q_s : std_logic_vector(N-1 downto 0);
  signal ovf_s : std_logic;

  signal clk : std_logic := '0';
  signal resetn : std_logic := '0';

  constant T_CLK : time := 8 ns;

  signal testing : boolean := true;

  component accumulator is
    generic (
      Nbit : positive
    );
    port (
      clk   : in std_logic;
      resetn: in std_logic;
      incr  : in std_logic_vector(Nbit - 1 downto 0);

      q     : out std_logic_vector(Nbit - 1 downto 0);
      ovf   : out std_logic
    );
  end component accumulator;

  begin
    clk <= not clk after T_CLK/2 when testing else '0';

    aut: accumulator
    generic map (
      Nbit => N
    )
    port map (
      clk => clk,
      resetn => resetn,
      incr => incr_s,

      q => q_s,
      ovf => ovf_s
    );

    stimulus : process(clk)
    variable t: integer := 0;
    begin
      if rising_edge(clk) then
        case t is
          when 0 => resetn <= '1'; incr_s <= std_logic_vector(to_unsigned(2, N));
          when 5 => incr_s <= std_logic_vector(to_unsigned(5, N));
          when 10 => incr_s <= std_logic_vector(to_unsigned(3, N));
          when 15 => incr_s <= std_logic_vector(to_unsigned(1, N));
          when 20 => resetn <= '0';
          when 21 => resetn <= '1';
          when 30 => testing <= false;
          when others => null;
        end case;
        t := t+1;
      end if;
    end process stimulus;
  end architecture behaviour;
