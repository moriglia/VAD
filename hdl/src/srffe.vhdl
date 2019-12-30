library IEEE;
use IEEE.std_logic_1164.all;

-- SR flip flop
-- In order to reset it, just use S or R
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

entity srffe is 
    port(
        clk      : in    std_logic ;
        resetn   : in    std_logic ;
        en       : in    std_logic ;
        s        : in    std_logic ;
        r        : in    std_logic ;
        q        : out   std_logic
    );
end srffe;

architecture gen of srffe is   
    component dffe is 
        generic (
            Nbit : positive
        );
        port (
            clk     : in std_logic;
            resetn  : in std_logic;
            en      : in std_logic;
            d       : in std_logic_vector(Nbit - 1 downto 0);
            q       : out std_logic_vector(Nbit - 1 downto 0)
        );
    end component;

    signal q_fb : std_logic;
    signal d : std_logic;
begin
    q <= q_fb;

    d <= s or ((not s) and (not r) and q_fb);

    m_dffe : dffe generic map (Nbit => 1)
        port map (d(0) => d, clk => clk, resetn => resetn, q(0) => q_fb, en => en);
end gen;
