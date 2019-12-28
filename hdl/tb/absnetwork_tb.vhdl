library ieee;
use ieee.std_logic_1164.all;

entity absnetwork_tb is
end entity absnetwork_tb;

architecture behavioural_absnetwork_tb of absnetwork_tb is
  signal clk: std_logic := '0';
  signal testing: boolean := true;

  constant N: positive := 3;

  signal z_s: std_logic_vector(N-1 downto 0);
  signal n_s: std_logic_vector(N-1 downto 0);

  component absnetwork is
    generic (
      Nbit : positive
    );
    port (
      z_number  : in  std_logic_vector(Nbit - 1 downto 0);
      n_number  : out std_logic_vector(Nbit - 1 downto 0)
    );
  end component absnetwork;

  begin
    clk <= not clk after 4 ns when testing else '0';

    absnetwork_ut: absnetwork
    generic map (
      Nbit => N
    )
    port map (
      z_number => z_s,
      n_number => n_s
    );

    stimulus : process(clk)
    variable t: integer := 0;
    begin
      if rising_edge(clk) then
        case t is
          when 0 => z_s <= "000";
          when 1 => z_s <= "011";
          when 2 => z_s <= "110";
          when 4 => z_s <= "101";
          when 5 => testing <= false;
          when others => null;
        end case;
        t := t + 1;
      end if;
    end process stimulus;

  end architecture behavioural_absnetwork_tb;
