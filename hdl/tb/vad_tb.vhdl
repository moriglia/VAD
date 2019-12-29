library ieee;
use ieee.std_logic_1164.all;

entity vad_tb is
end entity vad_tb;

architecture behaviour of vad_tb is

  signal clk    : std_logic := '0';
  signal testing: boolean := true;

  signal x_data : std_logic_vector(15 downto 0);
  signal fs_s   : std_logic;
  signal rst_n  : std_logic := '0';

  signal vad_out: std_logic;


  component vad is
    port (
      x           : in  std_logic_vector(15 downto 0);
      FRAME_START : in  std_logic;

      clk         : in std_logic;
      rst_n       : in std_logic;

      vad_out     : out std_logic
    );
  end component vad;

  begin
    clk <= not clk after 31250 ns when testing else '0';

    vad_ut : vad
    port map (
      x           => x_data,
      FRAME_START => fs_s,

      clk         => clk,
      rst_n       => rst_n,

      vad_out     => vad_out
    );

    stimulus  : process(clk)
    variable t : integer := 0;
    begin
      if rising_edge(clk) then
        case t is
          when 0 => rst_n <= '1';
          when 1 =>
            fs_s    <= '1';
            x_data(15)  <= '1';
            x_data(14 downto 0) <= (others => '0');
          when 2 =>
            fs_s <= '0';

          when 280 => testing <= false;
          when others => null;

        end case;
        t := t+1;
      end if;
    end process stimulus;

  end architecture behaviour;
