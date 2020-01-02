library ieee;
use ieee.std_logic_1164.all;


entity dff_tb is
end entity dff_tb;

architecture behaviour of dff_tb is
  signal clk: std_logic := '0';
  signal resetn: std_logic := '0';

  constant N: positive := 8;
  constant zero_default: std_logic_vector(N - 1 downto 0) := (others => '0');

  signal d: std_logic_vector(N - 1 downto 0);
  signal q: std_logic_vector(N - 1 downto 0);

  constant T_CLK: time := 8 ns;

  signal testing: boolean := true;

  component dff is
    generic (
      Nbit    : positive;
      default : std_logic_vector
    );
    port (
      clk     : in std_logic;
      resetn  : in std_logic;

      d       : in std_logic_vector(Nbit - 1 downto 0);
      q       : out std_logic_vector(Nbit - 1 downto 0)
    );
  end component dff;

  begin

    clk <= not clk after T_CLK/2 when testing else '0';

    dff_ut : dff
    generic map (
      Nbit => N,
      default => zero_default
    )
    port map (
      clk => clk,
      resetn => resetn,

      d => d,
      q => q
    );

    testing_process : process(clk)
    variable t: integer := 0;
    begin
      if rising_edge(clk) then
        case t is
          when 0 =>
            d <= (others => '0');
            resetn <= '1';
          when 1 =>
            d(0) <= '1';
          when 2 =>
            d(1) <= '1';
          when 3 =>
            d(0) <= '0';
            d(1) <= '1';
            d(3) <= '1';
          when 4 =>
            resetn <= '0';
          when 5 =>
            resetn <= '1';
          when 6 =>
            d <= (others => '1');
          when 7 =>
            testing <= false;
          when others => null;
        end case;

        t := t + 1;
      end if;


    end process testing_process;

  end architecture behaviour;
