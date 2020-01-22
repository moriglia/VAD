library IEEE;
use IEEE.std_logic_1164.all;

entity dffe is
    generic (
        Nbit    : integer := 4;
        default : std_logic_vector -- default value
    );
    port(
        clk      : in    std_logic ;
        resetn   : in    std_logic ;
        en       : in    std_logic ;
        d        : in    std_logic_vector(Nbit-1 downto 0) ;
        q        : out   std_logic_vector(Nbit-1 downto 0)
    );
end dffe;

architecture gen of dffe is
    component dff is
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
    end component;

    component mux_2toN is 
        generic (N : integer := 4);
        port(
            in0   : in    std_logic_vector(N-1 downto 0) ;
            in1   : in    std_logic_vector(N-1 downto 0) ;
            s     : in    std_logic ;
            q     : out   std_logic_vector(N-1 downto 0) 
        );
    end component mux_2toN;

    signal q_loop : std_logic_vector(Nbit-1 downto 0);
    signal mux_out : std_logic_vector(Nbit-1 downto 0);

begin
    m_dff : dff generic map (Nbit => Nbit, default => default)
        port map (d => mux_out, clk => clk, resetn => resetn, q => q_loop);


    m_mux : mux_2toN generic map (N => Nbit)
        port map (in0 => q_loop, in1 => d, s => en, q => mux_out);

    q <= q_loop;
end gen;
