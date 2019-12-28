library ieee;
use ieee.std_logic_1164.all;

entity counter is
  generic (
    Nbit : positive
  );
  port (
    clk     : in std_logic;
    resetn  : in std_logic;
    enable  : in std_logic;

    q     : out std_logic_vector(Nbit - 1 downto 0);
    ovf   : out std_logic
  );
end entity counter;

architecture counter_arch of counter is
  component dff is
    generic (
      Nbit : positive
    );
    port (
      clk     : in std_logic;
      resetn  : in std_logic;

      d       : in std_logic_vector(Nbit - 1 downto 0);
      q       : out std_logic_vector(Nbit - 1 downto 0)
    );
  end component dff;

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

  signal q_s    : std_logic_vector(Nbit - 1 downto 0);
  signal d_s    : std_logic_vector(Nbit - 1 downto 0);
  signal ovf_s  : std_logic;
  signal clk_en : std_logic;

  begin
    clk_en <= clk and enable ;

    dff_comp : dff
    generic map (
      Nbit => Nbit
    )
    port map (
      clk => clk_en,
      resetn => resetn,

      d => d_s,
      q => q_s
    );

    ovf_register : dff
    generic map (
      Nbit => 1
    )
    port map (
      clk => clk_en,
      resetn => resetn,

      d(0) => ovf_s,  -- Assign a 1 bit std_logic_vector to a std_logic
      q(0) => ovf     -- Assign a 1 bit std_logic_vector to a std_logic
    );

    incrementer_comp : incrementer
    generic map (
      Nbit => Nbit
    )
    port map (
      a => q_s,
      cin => '1',

      s => d_s,
      cout => ovf_s
    );

    q <= q_s;

  end architecture counter_arch;
