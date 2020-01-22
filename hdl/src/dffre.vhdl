library IEEE;
use IEEE.std_logic_1164.all;

entity dffre is
    generic (
        Nbit    : integer := 4;
        default : std_logic_vector -- default value
    );
    port(
        clk      : in    std_logic ;
        resetn   : in    std_logic ;
        en       : in    std_logic ;
        r        : in    std_logic ;
        d        : in    std_logic_vector(Nbit-1 downto 0) ;
        q        : out   std_logic_vector(Nbit-1 downto 0)
    );
end dffre;

architecture gen of dffre is
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

    component mux_4toN is 
        generic (N : integer := 4);
        port(
            in0   : in    std_logic_vector(N-1 downto 0) ;
            in1   : in    std_logic_vector(N-1 downto 0) ;
            in2   : in    std_logic_vector(N-1 downto 0) ;
            in3   : in    std_logic_vector(N-1 downto 0) ;
            s     : in    std_logic_vector(1 downto 0) ;
            q   : out   std_logic_vector(N-1 downto 0) 
        );
    end component mux_4toN;

    signal q_loop : std_logic_vector(Nbit-1 downto 0);
    signal mux_out : std_logic_vector(Nbit-1 downto 0);
    signal mux_s : std_logic_vector(1 downto 0);

begin
    m_dff : dff generic map (Nbit => Nbit, default => default)
        port map (d => mux_out, clk => clk, resetn => resetn, q => q_loop);

    mux_s(0) <= r;
    mux_s(1) <= en;

    m_mux : mux_4toN generic map (N => Nbit)
        port map (in0 => q_loop, 
                  in1 => default, 
                  in2 => d, 
                  in3 => default, 
                  s => mux_s, 
                  q => mux_out);

    q <= q_loop;
end gen;
