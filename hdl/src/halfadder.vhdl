library ieee;
use ieee.std_logic_1164.all;

entity halfadder is
  port (
    a   : in  std_logic;
    cin : in  std_logic;
    s   : out std_logic;
    cout: out std_logic
  );
end entity halfadder;

architecture halfadder_combinatorial_network of halfadder is
  begin
    s <= a xor cin;
    cout <= a and cin;
  end architecture halfadder_combinatorial_network;
