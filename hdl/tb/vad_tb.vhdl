library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity vad_tb is
end entity vad_tb;

architecture behaviour of vad_tb is

  signal clk    : std_logic := '1';
  signal frame_clk : std_logic := '0';
  signal testing: boolean := true;

  signal x_data : std_logic_vector(15 downto 0);
  signal fs_s   : std_logic := '0';
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
    clk <= not clk after 31.250 ns when testing else '0';
    frame_clk <= not frame_clk after 31250 ns when testing else '0';

    vad_ut : vad
    port map (
      x           => x_data,
      FRAME_START => fs_s,

      clk         => clk,
      rst_n       => rst_n,

      vad_out     => vad_out
    );

    stimulus  : process(frame_clk, clk)
    variable t              : integer := 0;
    variable frame_started  : boolean := false;
    variable sample         : integer;
    variable int_line       : line;
    begin
      if rising_edge(frame_clk) then
        case t is
          when 0 => rst_n <= '1';
          when others =>

            if endfile(input) then
              testing <= false;
            else
              readline(input, int_line);
              read(int_line, sample);
              x_data <= std_logic_vector(to_signed(sample, x_data'length));
            end if;

            if t mod 256 = 1 then -- every N*256 + 1 frame clocks
              if t /= 1 then      -- except for N = 0
                -- write the output of the vad to stdout
                if vad_out = '1' then
                  write(int_line, 1);
                else
                  write(int_line, 0);
                end if;
                writeline(output, int_line);
              end if;
              frame_started := true;
            end if;

        end case;

        t := t+1;

      end if; -- rising_edge(frame_clk)

      if rising_edge(clk) then
        if fs_s = '0' and frame_started then
          fs_s <= '1';
          frame_started := false;
        end if;
        if fs_s = '1' and not frame_started then
          fs_s <= '0';
        end if;
      end if;
    end process stimulus;

  end architecture behaviour;
