library ieee;
use ieee.std_logic_1164.all;

entity counter is
  generic (
    Nbit : positive;
    val_after_reset : std_logic_vector;
    val_after_ovf : std_logic_vector
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
  component dffe is
    generic (
      Nbit    : positive;
      default : std_logic_vector
    );
    port (
      clk     : in std_logic;
      resetn  : in std_logic;
      en      : in std_logic ;
      d       : in std_logic_vector(Nbit - 1 downto 0);
      q       : out std_logic_vector(Nbit - 1 downto 0)
    );
  end component dffe;

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

  component mux_2toN is 
    generic (N : integer := 4);
    port(
        in0   : in    std_logic_vector(N-1 downto 0) ;
        in1   : in    std_logic_vector(N-1 downto 0) ;
        s     : in    std_logic ;
        q     : out   std_logic_vector(N-1 downto 0) 
    );
  end component mux_2toN;

  signal q_s    : std_logic_vector(Nbit - 1 downto 0);
  signal d_s    : std_logic_vector(Nbit - 1 downto 0);
  signal ovf_s    : std_logic;
  signal d_in   : std_logic_vector(Nbit - 1 downto 0);

  begin

    dff_comp : dffe
    generic map (
      Nbit => Nbit,
      default => val_after_reset
    )
    port map (
      clk => clk,
      resetn => resetn,
      en => enable,

      d => d_in,
      q => q_s
    );

    ovf_register : dffe
    generic map (
      Nbit => 1,
      default => "0"
    )
    port map (
      clk => clk,
      resetn => resetn,
      en => enable,

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
    
    d_mux : mux_2toN
    generic map(
      N => Nbit
    ) port map (
      in0 => d_s,
      in1 => val_after_ovf,
      s => ovf_s,
      q => d_in
    );

    q <= q_s;

  end architecture counter_arch;
