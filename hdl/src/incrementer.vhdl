library ieee;
use ieee.std_logic_1164.all;

entity incrementer is
  generic (
    Nbit : positive
  );
  port (
    cin   : in  std_logic;
    a     : in  std_logic_vector(Nbit-1 downto 0);

    s     : out std_logic_vector(Nbit-1 downto 0);
    cout  : out std_logic
  );
end entity incrementer;

architecture rtl of incrementer is
  signal carry: std_logic_vector(Nbit-1 downto 1);

  component halfadder is
    port (
      a   : in  std_logic;
      cin : in  std_logic;
      s   : out std_logic;
      cout: out std_logic
    );
  end component halfadder;

  begin
    GEN: for i in 0 to Nbit - 1 generate
      HA0: if i = 0 generate
        halfadder_0: halfadder
        port map (
          a => a(0),
          cin => cin,

          s => s(0),
          cout => carry(1)
        );
      end generate HA0;

      HALast: if i = Nbit-1 generate
        halfadder_last: halfadder
        port map (
          a => a(i),
          cin => carry(Nbit - 1),

          s => s(Nbit - 1),
          cout => cout
        );
      end generate HALast;

      HAX: if i > 0 and i < Nbit - 1 generate
        halfadder_X: halfadder
        port map (
          a => a(i),
          cin => carry(i),

          s => s(i),
          cout => carry(i+1)
        );
      end generate HAX;
    end generate GEN;
  end architecture rtl;
