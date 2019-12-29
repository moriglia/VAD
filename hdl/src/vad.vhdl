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
      Nbit : positive
    );
    port (
      clk   : in std_logic;
      resetn: in std_logic;
      incr  : in std_logic_vector(Nbit - 1 downto 0);

      q     : out std_logic_vector(Nbit - 1 downto 0);
      ovf   : out std_logic
    );
  end component accumulator;

  component counter is
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
  end component counter;

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

  signal resetn   : std_logic;

  signal abs_repr           : std_logic_vector(15 downto 0);
  signal square_power_repr  : std_logic_vector(33 downto 0);
  signal sum_repr           : std_logic_vector(34 downto 0);

  constant threshold        : unsigned(34 downto 0) := "01100110011001100110011001100110011";
  signal voice_detected     : std_logic;

  signal counter_tick       : std_logic;
  signal clk_tick           : std_logic;

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

    square_power_repr(33 downto 32) <= "00";

    accumulator_component : accumulator
    generic map (
      Nbit    => 34
    )
    port map (
    clk     => clk,
    resetn  => resetn,
    incr    => square_power_repr,  -- from 0 to 2^30

    -- sum is from 0 to 2^34
    q       => sum_repr(33 downto 0),
    ovf     => sum_repr(34)
    );

    voice_detected <= '1' when (unsigned(sum_repr) > threshold) else '0';

    counter_component : counter
    generic map (
      Nbit  => 8
    )
    port map (
      clk     => clk,
      resetn  => resetn,
      enable  => '1',
      ovf     => counter_tick
    );

    clk_tick  <= clk and counter_tick;

    vad_out_register  : dff
    generic map (
      Nbit => 1
    )
    port map (
      clk     => clk_tick,
      resetn  => resetn,

      d(0)    => voice_detected,
      q(0)    => vad_out
    );


  end architecture vad_rtl;
