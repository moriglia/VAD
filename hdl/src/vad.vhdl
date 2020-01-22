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
      restart : in std_logic; --synchronous reset

      en    : in    std_logic ;

      q     : out std_logic_vector(Nbit - 1 downto 0);
      ovf   : out std_logic
    );
  end component accumulator;

  component counter is
    generic (
      Nbit : positive;
      val_after_reset : std_logic_vector;
      val_after_ovf : std_logic_vector
    );
    port (
      clk     : in std_logic;
      resetn  : in std_logic;
      enable  : in std_logic;
      restart : in std_logic; --synchronous reset

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

  component srff is
    port(
        clk      : in    std_logic ;
        resetn   : in    std_logic ;
        s        : in    std_logic ;
        r        : in    std_logic ;
        q        : out   std_logic
    );
  end component srff;


  signal resetn   : std_logic;
  signal accumulator_restart  : std_logic;

  signal abs_repr           : std_logic_vector(15 downto 0);
  signal square_power_repr  : std_logic_vector(33 downto 0);

  constant compl_threshold  : std_logic_vector(33 downto 0) := "0011001100110011001100110011001101";
  constant eighteen_zeroes : std_logic_vector(17 downto 0) := (others => '0');

  constant N_bit_frame : integer := 10;
  constant frame_tick_after_rst : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(525, 10));
  constant frame_tick_after_ovf : std_logic_vector(9 downto 0) := std_logic_vector(to_unsigned(24, 10));
  constant frame_counter_default : std_logic_vector(7 downto 0) := (others => '0');

  signal voice_detected     : std_logic;

  signal frame_tick         : std_logic;
  signal counter_tick       : std_logic;
  signal acc_ovf : std_logic;
  signal reset : std_logic;
  signal in_frame : std_logic;
  signal en_vad_out : std_logic;
  signal vad_out_in : std_logic;

  begin
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

    in_frame_srff : srff
    port map (
      clk => clk,
      s => FRAME_START,
      r => counter_tick,
      resetn => rst_n,
      q => in_frame
    );

    frame_clocker : counter
    generic map (
      Nbit => N_bit_frame,
      val_after_reset => frame_tick_after_rst,
      val_after_ovf => frame_tick_after_ovf
    )
    port map (
      clk     => clk,
      resetn  => rst_n,
      enable  => in_frame,
      ovf     => frame_tick,
      restart => FRAME_START
    );

    accumulator_restart <= FRAME_START or counter_tick;

    energy_accumulator : accumulator
    generic map (
      Nbit    => 34,
      default => compl_threshold
    )
    port map (
    clk     => clk,
    resetn  => rst_n,
    incr    => square_power_repr,  -- from 0 to 2^30
    en      => frame_tick,
    q       => open,
    ovf     => acc_ovf,
    restart => accumulator_restart
    );

    voice_detected_srff : srff
    port map (
      clk => clk,
      s => acc_ovf,
      r => FRAME_START,
      resetn => rst_n,
      q => voice_detected
    );

    sample_counter : counter
    generic map (
      Nbit  => 8,
      val_after_reset => frame_counter_default,
      val_after_ovf => frame_counter_default
    )
    port map (
      clk     => clk,
      resetn  => rst_n,
      restart => FRAME_START,
      enable  => frame_tick,
      ovf     => counter_tick
    );

    -- keep vad_out until next frame starts
    vad_out_in <= (not FRAME_START) and voice_detected;
    en_vad_out <= FRAME_START or counter_tick;

    vad_out_register  : dffe
    generic map (
      Nbit => 1,
      default => "0"
    )
    port map (
      clk     => clk,
      resetn  => rst_n,
      en      => en_vad_out,

      d(0)    => vad_out_in,
      q(0)    => vad_out
    );


  end architecture vad_rtl;
