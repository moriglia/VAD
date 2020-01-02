library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Description of combinatorial network
-- for 2 Complement to unsigned conversion
-- using std_logic representation with approximation
-- (no +1 is performed)

entity absnetwork_approx is
  generic (
    Nbit : positive
  );
  port (
    -- 2 complement representation of the integer number to elaborate
    z_number  : in  std_logic_vector(Nbit - 1 downto 0);

    -- unsigned (natural) representation of absolute value of input
    n_number  : out std_logic_vector(Nbit - 1 downto 0)
  );
end entity absnetwork_approx;

architecture absnetwork_arch of absnetwork_approx is
  signal z_complement   : std_logic_vector(Nbit - 1 downto 0);

  begin
    -- assume Z is the 2 compl representation of z
    -- if z < 0, -z is approximated by compl(Z)

    -- Representation of compl(Z)
    z_complement <= not z_number;

    n_number <= z_complement when z_number(Nbit - 1) = '1' else z_number;
  end architecture absnetwork_arch;
