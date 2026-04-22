library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt_8bit is
    port (
        rst   : in  std_logic;
        count : in  std_logic;
        outp  : out std_logic_vector(7 downto 0)
    );
end entity cnt_8bit;

architecture Behavioral of cnt_8bit is
    signal sig_cnt : unsigned(7 downto 0) := (others => '0');
begin

    p_counter : process (count, rst) is
    begin
        if rst = '1' then
            sig_cnt <= (others => '0');
        elsif rising_edge(count) then
            sig_cnt <= sig_cnt + 1;
        end if;
    end process p_counter;

    outp <= std_logic_vector(sig_cnt);

end architecture Behavioral;
