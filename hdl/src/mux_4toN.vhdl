library IEEE;
use IEEE.std_logic_1164.all;

entity mux_4toN is 
    generic (N : integer := 4);
    port(
        in0   : in    std_logic_vector(N-1 downto 0) ;
        in1   : in    std_logic_vector(N-1 downto 0) ;
        in2   : in    std_logic_vector(N-1 downto 0) ;
        in3   : in    std_logic_vector(N-1 downto 0) ;
        s     : in    std_logic_vector(1 downto 0) ;
        q   : out   std_logic_vector(N-1 downto 0) 
    );
end mux_4toN;

architecture rtl of mux_4toN is    
begin
    mux_proc : process(in0, in1, in2, in3, s)
    begin
        case s is
        when "00" => q <= in0 ;
        when "01" => q <= in1 ;
        when "10" => q <= in2 ;
        when "11" => q <= in3 ;
        when others => q <= (others => 'X') ;
        end case;
    end process mux_proc;
end rtl;
