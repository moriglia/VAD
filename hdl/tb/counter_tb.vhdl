library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end entity counter_tb;

architecture behaviour of counter_tb is
  constant N: positive := 3;
  signal en_s : std_logic := '0';
  signal q_s : std_logic_vector(N-1 downto 0);
  signal ovf_s : std_logic;

  signal clk : std_logic := '0';
  signal resetn : std_logic := '0';

  constant T_CLK : time := 8 ns;

  constant N_zeroes : std_logic_vector(N - 1 downto 0) := (others => '0');
  constant after_ovf : std_logic_vector(N - 1 downto 0) := (N-1 => '1', others => '0');

  signal testing : boolean := true;

  component counter is
    generic (
      Nbit : positive;
      val_after_reset : std_logic_vector;
      val_after_ovf : std_logic_vector
    );
    port (
      clk     : in std_logic;
      resetn  : in std_logic;
      enable  : in std_logic;
      restart : in std_logic;
  
      q     : out std_logic_vector(Nbit - 1 downto 0);
      ovf   : out std_logic
    );
  end component counter;

  begin
    clk <= not clk after T_CLK/2 when testing else '0';

    counter_ut: counter
    generic map (
      Nbit => N,
      val_after_reset => N_zeroes,
      val_after_ovf => after_ovf
    )
    port map (
      clk     => clk,
      resetn  => resetn,
      enable  => en_s,
      restart  => '0',

      q       => q_s,
      ovf     => ovf_s
    );

    stimulus : process(clk)
    variable t: integer := 0;
    begin
      if rising_edge(clk) then
        case t is
          when 0 => resetn <= '1';
          when 5 => en_s <= '1';
          when 10 => en_s <= '0';
          when 15 => en_s <= '1';
          when 20 => resetn <= '0';
          when 21 => resetn <= '1';
          when 30 => testing <= false;
          when others => null;
        end case;
        t := t+1;
      end if;
    end process stimulus;
  end architecture behaviour;
