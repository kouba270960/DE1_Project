
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
------------------------------------------------
entity comparators is
    Port ( a        : in STD_LOGIC_VECTOR (1 downto 0);
           b        : in STD_LOGIC_VECTOR (1 downto 0);
           b_gt     : out STD_LOGIC;
           b_a_eq   : out STD_LOGIC;
           a_gt     : out STD_LOGIC);
end comparators;
------------------------------------------------
architecture Behavioral of comparators is
begin

b_gt <= '1' when (b > a) else '0';
b_a_eq <= '1' when (b = a)else '0';
--a_gt <= '1' when (a > b) else '0';
a_gt <= (not(b(1)) and a(1)) or (not(b(1))and not(b(0)) and a(0)) or (not(b(0)) and a(1) and a(0));

end Behavioral;
