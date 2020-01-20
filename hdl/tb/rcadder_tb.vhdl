library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rcadder_tb is
end entity rcadder_tb;

architecture rcadder_tb_arch of rcadder_tb is
  constant N : positive := 3 ;

  signal a : std_logic_vector(N - 1 downto 0);
  signal b : std_logic_vector(N - 1 downto 0);
  signal cin : std_logic;

  signal s : std_logic_vector(N - 1 downto 0);
  signal cout : std_logic;

  component rcadder is
    generic (
      Nbit : positive
    );
    port (
      a     : in std_logic_vector(Nbit - 1 downto 0);
      b     : in std_logic_vector(Nbit - 1 downto 0);
      cin   : in std_logic;

      s     : out std_logic_vector(Nbit - 1 downto 0);
      cout  : out std_logic
    );
  end component rcadder;


  begin

    rcaut : rcadder
    generic map (
      Nbit => N
    )
    port map (
      a => a,
      b => b,
      cin => cin,

      s => s,
      cout => cout
    );

    stimulus : process
    begin
      a <= std_logic_vector(to_unsigned(3, N));
      b <= std_logic_vector(to_unsigned(5, N));
      cin <= '0';

      wait for 10 ns ;

      a <= std_logic_vector(to_unsigned(1, N));
      b <= std_logic_vector(to_unsigned(2, N));
      cin <= '1';

      wait for 10 ns ;

      a <= std_logic_vector(to_unsigned(3, N));
      b <= std_logic_vector(to_unsigned(4, N));
      cin <= '1';

      wait for 10 ns ;

      a <= std_logic_vector(to_unsigned(3, N));
      b <= std_logic_vector(to_unsigned(4, N));
      cin <= '0';

      wait for 10 ns ;
      wait ; -- Stop simulation

    end process stimulus;


  end architecture rcadder_tb_arch;
