-------------------------------------------------
--! @brief N-bit synchronous up counter with enable
--! @version 1.4
--! @copyright (c) 2019-2026 Tomas Fryza, MIT license
--!
--! This design implements a parameterizable N-bit
--! binary up counter with synchronous, high-active
--! reset and clock enable input. The counter wraps
--! around to zero after reaching its maximum value
--! (2^G_BITS - 1).
--
-- Notes:
-- - Synchronous design (rising edge of clk)
-- - High-active synchronous reset
-- - Enable input controls counting
-- - Modulo 2^N operation (automatic wrap-around)
-- - Integer-based internal counter
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;  -- Package for data types conversion

-------------------------------------------------

entity counter10 is
    port (
        clk : in  std_logic;                             --! Main clock
        rst : in  std_logic;                             --! High-active synchronous reset
        en  : in  std_logic;                             --! Clock enable input
        cnt : out std_logic_vector(3 downto 0)           --! Counter value
        c_out : out std_logic;                           --! Carry bit for next counter
    );
end entity counter;

-------------------------------------------------

architecture Behavioral of counter10 is

    -- Integer counter with defined range
    signal sig_cnt : integer range 0 to C_MAX;

begin

    --! Clocked process with synchronous reset which implements
    --! N-bit up counter.

    p_counter : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then    -- Synchronous, active-high reset
                sig_cnt <= 0;
                c_out <= 0;

            elsif en = '1' then  -- Clock enable activated
                if sig_cnt = 9
                    sig_cnt <= 0;
                    c_out <= 1;
                else
                    sig_cnt <= sig_cnt + 1;
                    c_out <= 0;
                end if;          -- Each `if` must end by `end if`
            end if;
        end if;
    end process p_counter;

    -- Convert integer to std_logic_vector
    cnt <= std_logic_vector(to_unsigned(sig_cnt, 4));

end Behavioral;
