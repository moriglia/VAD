library IEEE;
use IEEE.std_logic_1164.all;

entity mux is 
    generic (N_mux : integer := 4);
    port(
        in1_mux   : in    std_logic_vector(N_mux-1 downto 0) ;
        in2_mux   : in    std_logic_vector(N_mux-1 downto 0) ;
        s_mux     : in    std_logic ;
        out_mux   : out   std_logic_vector(N_mux-1 downto 0) 
    );
end mux;

architecture rtl of mux is    
begin
    mux_proc : process(in1_mux, in2_mux, s_mux)
    begin
        case s_mux is
        when '0' => out_mux <= in1_mux ;
        when '1' => out_mux <= in2_mux ;
        when others => out_mux <= in1_mux ;
        end case;
    end process mux_proc;
end rtl;
