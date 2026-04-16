  library ieee;
use ieee.std_logic_1164.all;

entity clk_en is
    port (
        clk     : in  std_logic;
        cnt_set : in  std_logic_vector(2 downto 0);
        rst     : in  std_logic;
        ce      : out std_logic
    );
end clk_en;

architecture Behavioral of clk_en is
    signal sig_cnt : integer range 0 to 9 := 0;
    signal max_cnt : integer range 1 to 9 := 9;
begin

    process(cnt_set)
    begin
        case cnt_set is
            when "000" => max_cnt <= 9;
            when "001" => max_cnt <= 8;
            when "010" => max_cnt <= 7;
            when "011" => max_cnt <= 6;
            when "100" => max_cnt <= 5;
            when "101" => max_cnt <= 4;
            when "110" => max_cnt <= 3;
            when others => max_cnt <= 2;
        end case;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ce <= '0';
                sig_cnt <= 0;
            elsif sig_cnt = max_cnt then
                ce <= '1';
                sig_cnt <= 0;
            else
                ce <= '0';
                sig_cnt <= sig_cnt + 1;
            end if;
        end if;
    end process;

end Behavioral;
