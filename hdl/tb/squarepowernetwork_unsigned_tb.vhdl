library ieee;
use ieee.std_logic_1164.all;


entity squarepowernetwork_unsigned_tb is
end entity squarepowernetwork_unsigned_tb;

architecture beh of squarepowernetwork_unsigned_tb is
  signal clk: std_logic;
  signal testing : boolean := true;

  constant N    : positive := 4;
  signal net_in : std_logic_vector(N - 1 downto 0);
  signal net_out: std_logic_vector(2*N - 1 downto 0);

  component squarepowernetwork_unsigned is
    generic (
      Nbit  : positive
    );
    port (
      n_repr    : in  std_logic_vector(Nbit - 1 downto 0);
      n_sq_repr : out std_logic_vector(2*Nbit - 1 downto 0)
    );
  end component squarepowernetwork_unsigned;

  begin
    clk <= not clk after 4 ns when testing else '0';

    squarepowernetwork_unsigned_ut : squarepowernetwork_unsigned
    generic map (
      Nbit  => N
    )
    port map (
      n_repr    => net_in,
      n_sq_repr => net_out
    );

    stimulus : process(clk)
    variable t : integer := 0;
    begin
      if rising_edge(clk) then
        case t is
          when 0 => net_in <= "0000";
          when 1 => net_in <= "0001";
          when 2 => net_in <= "0011";
          when 3 => net_in <= "1001";
          when 4 => net_in <= "1010";
          when 5 => net_in <= "0110";
          when 6 => testing <= false;
          when others => null;
        end case;

        t := t+1;
      end if;

    end process stimulus;

  end architecture beh;
