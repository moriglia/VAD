library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rtl_adder_tb is
end entity rtl_adder_tb;

architecture rtl_adder_tb_arch of rtl_adder_tb is
  constant N : positive := 3 ;

  signal a : std_logic_vector(N - 1 downto 0);
  signal b : std_logic_vector(N - 1 downto 0);
  signal cin : std_logic;

  signal s : std_logic_vector(N - 1 downto 0);
  signal cout : std_logic;

  component rtl_adder is
    generic (
      Nbit : positive
    );
    port (
      a     : in std_logic_vector(Nbit - 1 downto 0);
      b     : in std_logic_vector(Nbit - 1 downto 0);

      s     : out std_logic_vector(Nbit - 1 downto 0);
      cout  : out std_logic
    );
  end component rtl_adder;


  begin

    rcaut : rtl_adder
    generic map (
      Nbit => N
    )
    port map (
      a => a,
      b => b,

      s => s,
      cout => cout
    );

    stimulus : process
    begin
      a <= std_logic_vector(to_unsigned(3, N));
      b <= std_logic_vector(to_unsigned(5, N));

      wait for 10 ns ;
      assert (s = "000" and cout = '1') report "Wrong sum 1" severity failure;

      a <= std_logic_vector(to_unsigned(1, N));
      b <= std_logic_vector(to_unsigned(2, N));

      wait for 10 ns ;
      assert (s = "011" and cout = '0') report "Wrong sum 2" severity failure;

      a <= std_logic_vector(to_unsigned(3, N));
      b <= std_logic_vector(to_unsigned(4, N));

      wait for 10 ns ;
      assert (s = "111" and cout = '0') report "Wrong sum 3" severity failure;

      a <= std_logic_vector(to_unsigned(4, N));
      b <= std_logic_vector(to_unsigned(3, N));

      wait for 10 ns ;
      assert (s = "111" and cout = '0') report "Wrong sum 4" severity failure;

      a <= std_logic_vector(to_unsigned(0, N));
      b <= std_logic_vector(to_unsigned(0, N));

      wait for 10 ns ;
      assert (s = "000" and cout = '0') report "Wrong sum 4" severity failure;

      wait ; -- Stop simulation

    end process stimulus;


  end architecture rtl_adder_tb_arch;
