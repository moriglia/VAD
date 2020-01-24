library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rtl_adder is
  generic (
    Nbit : positive
  );
  port (
    a     : in std_logic_vector(Nbit - 1 downto 0);
    b     : in std_logic_vector(Nbit - 1 downto 0);

    s     : out std_logic_vector(Nbit - 1 downto 0);
    cout  : out std_logic
  );
end entity rtl_adder;


architecture rtl_adder_arch of rtl_adder is
  signal a_u  : unsigned(Nbit downto 0);
  signal b_u  : unsigned(Nbit downto 0);
  signal s_u  : unsigned(Nbit downto 0);

  begin
    a_u <= resize(unsigned(a), Nbit+1);
    b_u <= resize(unsigned(b), Nbit+1);

    s_u <= a_u + b_u;

    s <= std_logic_vector(s_u(Nbit-1 downto 0));
    cout <= s_u(Nbit);

  end architecture rtl_adder_arch ;
