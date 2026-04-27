library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RS_FlipFlop is
    Port ( S : in  STD_LOGIC;
           R : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           Q : out  STD_LOGIC;
end RS_FlipFlop;

architecture Behavioral of RS is
begin
    process(Clk)
    begin
        if rising_edge(Clk) then
            if (S = '0' and R = '0') then
                Q <= Q; -- No change
            elsif (S = '1' and R = '0') then
                Q <= '1'; -- Set
            elsif (S = '0' and R = '1') then
                Q <= '0'; -- Reset
            else
                Q <= '0'; -- Undefined state, using zero as result
            end if;
        end if;
    end process;
end Behavioral;