library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cnt_b_bd is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        count_up   : in  std_logic;
        count_down : in  std_logic;
        count      : out std_logic_vector(2 downto 0)
    );
end entity cnt_b_bd;

architecture Behavioral of cnt_b_bd is
    signal sig_count : unsigned(2 downto 0) := (others => '0');
begin

    p_cnt_b_bd : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_count <= (others => '0');
            elsif count_up = '1' and count_down = '0' then
                if sig_count < 7 then
                    sig_count <= sig_count + 1;
                end if;
            elsif count_down = '1' and count_up = '0' then
                if sig_count > 0 then
                    sig_count <= sig_count - 1;
                end if;
            end if;
        end if;
    end process p_cnt_b_bd;

    count <= std_logic_vector(sig_count);

end architecture Behavioral;
