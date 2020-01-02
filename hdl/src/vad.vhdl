library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vad is
  port (
    x           : in  std_logic_vector(15 downto 0);
    FRAME_START : in  std_logic;

    clk         : in std_logic;
    rst_n       : in std_logic;

    vad_out     : out std_logic
  );
end entity vad;

architecture vad_rtl of vad is

  component absnetwork is
    generic (
      Nbit : positive
    );
    port (
      z_number  : in  std_logic_vector(Nbit - 1 downto 0);
      n_number  : out std_logic_vector(Nbit - 1 downto 0)
    );
  end component absnetwork;

  component squarepowernetwork_unsigned is
    generic (
      Nbit  : positive
    );
    port (
      n_repr    : in  std_logic_vector(Nbit - 1 downto 0);
      n_sq_repr : out std_logic_vector(2*Nbit - 1 downto 0)
    );
  end component squarepowernetwork_unsigned;

  component accumulator is
    generic (
      Nbit    : positive;
      default : std_logic_vector
    );
    port (
      clk   : in std_logic;
      resetn: in std_logic;
      incr  : in std_logic_vector(Nbit - 1 downto 0);

      en    : in    std_logic ;

      q     : out std_logic_vector(Nbit - 1 downto 0);
      ovf   : out std_logic
    );
  end component accumulator;

  component counter is
    generic (
      Nbit : positive;
      default : std_logic_vector
    );
    port (
      clk     : in std_logic;
      resetn  : in std_logic;
      enable  : in std_logic;

      q     : out std_logic_vector(Nbit - 1 downto 0);
      ovf   : out std_logic
    );
  end component counter;

  component dffe is
    generic (
      Nbit    : positive;
      default : std_logic_vector
    );
    port (
      clk     : in std_logic;
      resetn  : in std_logic;
      en      : in std_logic;
      d       : in std_logic_vector(Nbit - 1 downto 0);
      q       : out std_logic_vector(Nbit - 1 downto 0)
    );
  end component dffe;

  component srffe is
    port(
        clk      : in    std_logic ;
        resetn   : in    std_logic ;
        en       : in    std_logic ;
        s        : in    std_logic ;
        r        : in    std_logic ;
        q        : out   std_logic
    );
  end component srffe;


  signal resetn   : std_logic;
  signal accumulator_reset  : std_logic;

  signal abs_repr           : std_logic_vector(15 downto 0);
  signal square_power_repr  : std_logic_vector(33 downto 0);

  constant compl_threshold  : std_logic_vector(33 downto 0) := "0011001100110011001100110011001101";
  constant eight_zeroes : std_logic_vector(7 downto 0) := (others => '0');

  signal voice_detected     : std_logic;

  signal counter_tick       : std_logic;
  signal acc_ovf : std_logic;
  signal reset : std_logic;

  begin
    resetn <= rst_n and not FRAME_START;

    abs_component : absnetwork
    generic map (
      Nbit => 16
    )
    port map (
      z_number    => x,       -- from -2^15 to 2^15 - 1
      n_number    => abs_repr -- from 0 to 2^15
    );

    squarepowernet_component : squarepowernetwork_unsigned
    generic map (
      Nbit => 16
    )
    port map (
      n_repr      => abs_repr,                      -- from 0 to 2^15
      n_sq_repr   => square_power_repr(31 downto 0) -- from 0 to 2^30
    );

    square_power_repr(33 downto 32) <= (others => '0'); -- extend representation
    accumulator_reset <= resetn and not counter_tick;

    accumulator_component : accumulator
    generic map (
      Nbit    => 34,
      default => compl_threshold
    )
    port map (
    clk     => clk,
    resetn  => accumulator_reset,
    incr    => square_power_repr,  -- from 0 to 2^30
    en      => '1',

    q       => open,
    ovf     => acc_ovf
    );

    voice_detected_srffe : srffe
    port map (
      clk => clk,
      s => acc_ovf,
      r => '0',
      resetn => resetn,
      q => voice_detected,
      en => '1'
    );

    counter_component : counter
    generic map (
      Nbit  => 8,
      default => eight_zeroes
    )
    port map (
      clk     => clk,
      resetn  => resetn,
      enable  => '1',
      ovf     => counter_tick
    );

    vad_out_register  : dffe
    generic map (
      Nbit => 1,
      default => "0"
    )
    port map (
      clk     => clk,
      resetn  => resetn,
      en      => counter_tick,

      d(0)    => voice_detected,
      q(0)    => vad_out
    );


  end architecture vad_rtl;
