library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;  -- Package for data types conversion


entity counter10 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           count : in STD_LOGIC;
           cnt : out STD_LOGIC_VECTOR (3 downto 0);
           c_out : out STD_LOGIC);
end counter10;

architecture Behavioral of counter10 is
    -- Integer counter with defined range
    signal sig_cnt : integer range 0 to 9;
    signal sig_c_out : std_logic;
    signal sig_count_enable : std_logic;
begin
    --! Clocked process with synchronous reset which implements
    --! 4-bit up counter ending in state 9.

    p_counter : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then    -- synchronous, active-high reset
                sig_cnt <= 0;
                sig_c_out <= '0';
                sig_count_enable <= '0';    --active low
            elsif (count = '1' and sig_count_enable = '0') then  -- Clock enable activated
                sig_count_enable <= '1';
                if sig_cnt = 9 then
                    sig_cnt <= 0;
                    sig_c_out <= '1';
                else
                    sig_cnt <= sig_cnt + 1;
                    sig_c_out <= '0';
                end if;          -- Each `if` must end by `end if`
            elsif (count = '0' and sig_count_enable = '1') then
                sig_count_enable <= '0';
            end if;
        end if;
    end process p_counter;

    -- Convert integer to std_logic_vector
    cnt <= std_logic_vector(to_unsigned(sig_cnt, 4));
    c_out <= sig_c_out;

end Behavioral;
