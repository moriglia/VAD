library ieee;
use ieee.std_logic_1164.all;

entity fulladder_tb is
end entity fulladder_tb;

architecture behaviour of fulladder_tb is
  signal a: std_logic := '0';
  signal b: std_logic := '0';
  signal cin: std_logic := '0';

  signal cout: std_logic;
  signal s: std_logic;

  signal clk : std_logic := '0';

  constant T_CLK : time := 8 ns;

  signal testing : boolean := true;

  component fulladder is
    port (
      a   : in std_logic;
      b   : in std_logic;
      cin : in std_logic;

      s   : out std_logic;
      cout: out std_logic
    );
  end component fulladder ;

  begin
    clk <= not clk after T_CLK/2 when testing else '0';

    faut: fulladder
    port map (
      a => a,
      b => b,
      cin => cin,

      cout => cout,
      s => s
    );

    stimulus : process(clk)
    variable t: integer := 0;
    begin
      if rising_edge(clk) then
        case t is
          when 0 => a<='0'; b<='0'; cin<='0';
          when 1 => a<='1'; b<='0'; cin<='0';
          when 2 => a<='0'; b<='1'; cin<='0';
          when 3 => a<='0'; b<='0'; cin<='1';
          when 4 => a<='1'; b<='1'; cin<='0';
          when 5 => a<='1'; b<='0'; cin<='1';
          when 6 => a<='0'; b<='1'; cin<='1';
          when 7 => a<='1'; b<='1'; cin<='1';
          when 8 => testing <= false;
          when others => null;
        end case;
        t := t+1;
      end if;
    end process stimulus;
  end architecture behaviour;
