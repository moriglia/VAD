library ieee;
use ieee.std_logic_1164.all;

entity accumulator is
  generic (
    Nbit : positive
  );
  port (
    clk   : in std_logic;
    resetn: in std_logic;
    incr  : in std_logic_vector(Nbit - 1 downto 0);
    default : in std_logic_vector(Nbit - 1 downto 0);
    en    : in    std_logic ;

    q     : out std_logic_vector(Nbit - 1 downto 0);
    ovf   : out std_logic
  );
end entity accumulator;

architecture accumulator_arch of accumulator is
  component dffre is 
    generic (Nbit : integer := 4);
    port(
        clk      : in    std_logic ;
        resetn   : in    std_logic ;
        en       : in    std_logic ;
        default  : in    std_logic_vector(Nbit-1 downto 0) ;
        d        : in    std_logic_vector(Nbit-1 downto 0) ;
        q        : out   std_logic_vector(Nbit-1 downto 0) 
    );
  end component dffre;

  component rcadder is
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
  end component rcadder;

  signal q_s : std_logic_vector(Nbit - 1 downto 0);
  signal d_s : std_logic_vector(Nbit - 1 downto 0);

  begin

  dff_comp : dffre
  generic map (
    Nbit => Nbit
  )
  port map (
    clk => clk,
    resetn => resetn,
    en => en,
    default => default,

    d => d_s,
    q => q_s
  );

  rcadder_comp : rcadder
  generic map (
    Nbit => Nbit
  )
  port map (
    a => incr,
    b => q_s,
    cin => '0',

    s => d_s,
    cout => ovf
  );

  q <= q_s;

end architecture accumulator_arch;
