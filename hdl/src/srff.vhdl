library IEEE;
use IEEE.std_logic_1164.all;

-- SR flip flop
--
-- Truth table
-- S R Q | D
-- ---------
-- 0 0 0 | 0
-- 0 0 1 | 1
-- 0 1 0 | 0
-- 0 1 1 | 0
-- 1 0 0 | 1
-- 1 0 1 | 1
-- 1 1 0 | 1
-- 1 1 1 | 1

entity srff is
    port(
        clk      : in    std_logic ;
        resetn   : in    std_logic ;
        s        : in    std_logic ;
        r        : in    std_logic ;
        q        : out   std_logic
    );
end srff;

architecture srff_arch of srff is  
begin
    clk_process : process(clk, resetn)
    begin
    if resetn = '0' then
        q <= '0';
    elsif rising_edge(clk) then
        if s = '1' then
            q <= '1';
        elsif  r = '1' then
            q <= '0';
        end if;
    end if;
    end process clk_process ;
  
end architecture srff_arch ;
