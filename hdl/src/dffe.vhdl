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

    component mux is
        generic (N_mux : integer := 4);
        port(
            in1_mux   : in    std_logic_vector(N_mux-1 downto 0) ;
            in2_mux   : in    std_logic_vector(N_mux-1 downto 0) ;
            s_mux     : in    std_logic ;
            out_mux   : out   std_logic_vector(N_mux-1 downto 0)
        );
    end component;

    signal q_loop : std_logic_vector(Nbit-1 downto 0);
    signal mux_out : std_logic_vector(Nbit-1 downto 0);

    constant zero_default : std_logic_vector(Nbit - 1 downto 0) := (others => '0');
begin
    m_dff : dff generic map (Nbit => Nbit, default => zero_default)
        port map (d => mux_out, clk => clk, resetn => resetn, q => q_loop);


    m_mux : mux generic map (N_mux => Nbit)
        port map (in1_mux => q_loop, in2_mux => d, s_mux => en, out_mux => mux_out);

    q <= q_loop;
end gen;
