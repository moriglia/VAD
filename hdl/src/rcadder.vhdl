library ieee;
use ieee.std_logic_1164.all;

entity rcadder is
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
end entity rcadder;


architecture rcadder_arch of rcadder is
  signal carry : std_logic_vector(Nbit - 1 downto 1);

  component fulladder is
    port (
      a   : in std_logic;
      b   : in std_logic;
      cin : in std_logic;

      s   : out std_logic;
      cout: out std_logic
    );
  end component fulladder ;

  begin

    GEN: for i in 0 to Nbit - 1 generate
      FA_GEN_0: if i = 0 generate
        FA0: fulladder
        port map (
          a => a(0),
          b => b(0),
          cin => cin,

          s => s(0),
          cout => carry(1)
        );
      end generate FA_GEN_0;

      FA_GEN_I: if i > 0 and i < Nbit - 1 generate
        FAI: fulladder
        port map (
          a => a(i),
          b => b(i),
          cin => carry(i),

          s => s(i),
          cout => carry(i+1)
        );
      end generate FA_GEN_I;

      FA_GEN_N : if i = Nbit -1 generate
        FAN: fulladder
        port map (
          a => a(i),
          b => b(i),
          cin => carry(i),

          s => s(i),
          cout => cout
        );
      end generate FA_GEN_N;

    end generate GEN;

  end architecture rcadder_arch ;
