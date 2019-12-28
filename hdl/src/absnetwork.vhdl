library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Description of combinatorial network
-- for 2 Complement to unsigned conversion
-- using std_logic representation

entity absnetwork is
  generic (
    Nbit : positive
  );
  port (
    -- 2 complement representation of the integer number to elaborate
    z_number  : in  std_logic_vector(Nbit - 1 downto 0);

    -- unsigned (natural) representation of absolute value of input
    n_number  : out std_logic_vector(Nbit - 1 downto 0)
  );
end entity absnetwork;

architecture absnetwork_arch of absnetwork is
  signal z_complement   : std_logic_vector(Nbit - 1 downto 0);
  signal z_opposite     : std_logic_vector(Nbit - 1 downto 0);

  component incrementer is
    generic (
      Nbit : positive
    );
    port (
      cin   : in  std_logic;
      a     : in  std_logic_vector(Nbit-1 downto 0);

      s     : out std_logic_vector(Nbit-1 downto 0);
      cout  : out std_logic
    );
  end component incrementer;

  begin
    -- assume Z is the 2 compl representation of z
    -- if z < 0, -z is represented by compl(Z) + 1

    -- Representation of compl(Z)
    z_complement <= not z_number;

    incrementer_component: incrementer
    generic map (
      Nbit => Nbit
    )
    port map (
      cin   => '1',
      a     => z_complement,

      -- Representation of (-z)
      s     => z_opposite
      -- we are not interested in an possible carry out
      -- carry out will be 1 only for "0000...000" input
      -- which does not require sign operations
    );

    n_number <= z_opposite when z_number(Nbit - 1) = '1' else z_number;
  end architecture absnetwork_arch;
