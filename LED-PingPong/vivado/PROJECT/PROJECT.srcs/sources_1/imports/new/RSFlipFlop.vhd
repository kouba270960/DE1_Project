library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RSFlipFlop is
    Port ( S : in STD_LOGIC;
           R : in STD_LOGIC;
           Q : out STD_LOGIC;
           clk : in STD_LOGIC);
end RSFlipFlop;

architecture Behavioral of RSFlipFlop is
    signal sig_Q : std_logic := '0';
begin
    process(clk) is
    begin
        if rising_edge(clk) then
            if (S = '0' and R = '0') then
                sig_Q <= sig_Q; 
            elsif (S = '1' and R = '0') then
                sig_Q <= '1'; 
            elsif (S = '0' and R = '1') then
                sig_Q <= '0'; 
            else
                sig_Q <= '0'; -- Undefined state, using zero as result
            end if;
        end if;
    end process;
    Q <= sig_Q;

end Behavioral;
