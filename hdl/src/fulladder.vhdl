library ieee;
use ieee.std_logic_1164.all;

entity fulladder is
  port (
    a   : in std_logic;
    b   : in std_logic;
    cin : in std_logic;

    s   : out std_logic;
    cout: out std_logic
  );
end entity fulladder ;

architecture fulladder_arch of fulladder is
  begin
    cout <= (a and b) or (a and cin) or (b and cin);
    s <= a xor b xor cin ;
  end architecture fulladder_arch;
