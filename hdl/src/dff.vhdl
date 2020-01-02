library ieee;
use ieee.std_logic_1164.all;

entity dff is
  generic (
    Nbit    : positive;
    default : std_logic_vector
  );
  port (
    clk     : in std_logic;
    resetn  : in std_logic;

    d       : in std_logic_vector(Nbit - 1 downto 0);
    q       : out std_logic_vector(Nbit - 1 downto 0)
  );
end entity dff;

architecture dff_arch of dff is

  signal memory_signal : std_logic_vector(Nbit - 1 downto 0);

  begin
    clk_process : process(clk, resetn)
    begin
      if resetn = '0' then
        memory_signal <= default;
      elsif rising_edge(clk) then
        memory_signal <= d;
      end if;
    end process clk_process ;

    q <= memory_signal;

  end architecture dff_arch ;
