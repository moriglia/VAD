library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2toN is 
    generic (N : integer := 4);
    port(
        in0   : in    std_logic_vector(N-1 downto 0) ;
        in1   : in    std_logic_vector(N-1 downto 0) ;
        s     : in    std_logic ;
        q     : out   std_logic_vector(N-1 downto 0) 
    );
end mux_2toN;

architecture rtl of mux_2toN is    
begin
    mux_proc : process(in0, in1, s)
    begin
        case s is
        when '0' => q <= in0 ;
        when '1' => q <= in1 ;
        when others => q <= (others => 'X') ;
        end case;
    end process mux_proc;
end rtl;
