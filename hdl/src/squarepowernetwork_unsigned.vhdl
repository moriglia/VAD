library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity squarepowernetwork_unsigned is
  generic (
    Nbit  : positive
  );
  port (
    n_repr    : in  std_logic_vector(Nbit - 1 downto 0);
    n_sq_repr : out std_logic_vector(2*Nbit - 1 downto 0)
  );
end entity squarepowernetwork_unsigned;

architecture squarepowernetwork_unsigned_arch of squarepowernetwork_unsigned is
  signal n_u  : unsigned(Nbit-1 downto 0);

  begin
    n_u <= unsigned(n_repr);
    n_sq_repr <= std_logic_vector(n_u * n_u);
  end architecture squarepowernetwork_unsigned_arch;
