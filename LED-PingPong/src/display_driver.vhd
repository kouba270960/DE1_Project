library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_driver is
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        data      : in  std_logic_vector(31 downto 0);
        an_enable : in  std_logic_vector(7 downto 0);
        seg       : out std_logic_vector(6 downto 0);
        anode     : out std_logic_vector(7 downto 0)
    );
end entity display_driver;

architecture Behavioral of display_driver is
    constant C_REFRESH_MAX : natural := 50_000;

    signal sig_refresh_cnt : natural range 0 to C_REFRESH_MAX - 1 := 0;
    signal sig_digit       : unsigned(2 downto 0) := (others => '0');
    signal sig_bin         : std_logic_vector(3 downto 0) := (others => '0');
begin

    p_refresh : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_refresh_cnt <= 0;
                sig_digit       <= (others => '0');
            elsif sig_refresh_cnt = C_REFRESH_MAX - 1 then
                sig_refresh_cnt <= 0;
                sig_digit       <= sig_digit + 1;
            else
                sig_refresh_cnt <= sig_refresh_cnt + 1;
            end if;
        end if;
    end process p_refresh;

    p_digit_select : process (sig_digit, data) is
    begin
        case sig_digit is
            when "000" => sig_bin <= data(3 downto 0);
            when "001" => sig_bin <= data(7 downto 4);
            when "010" => sig_bin <= data(11 downto 8);
            when "011" => sig_bin <= data(15 downto 12);
            when "100" => sig_bin <= data(19 downto 16);
            when "101" => sig_bin <= data(23 downto 20);
            when "110" => sig_bin <= data(27 downto 24);
            when others => sig_bin <= data(31 downto 28);
        end case;
    end process p_digit_select;

    p_bin2seg : process (sig_bin) is
    begin
        case sig_bin is
            when x"0" => seg <= "0000001";
            when x"1" => seg <= "1001111";
            when x"2" => seg <= "0010010";
            when x"3" => seg <= "0000110";
            when x"4" => seg <= "1001100";
            when x"5" => seg <= "0100100";
            when x"6" => seg <= "0100000";
            when x"7" => seg <= "0001111";
            when x"8" => seg <= "0000000";
            when x"9" => seg <= "0000100";
            when x"A" => seg <= "0001000";
            when x"B" => seg <= "1100000";
            when x"C" => seg <= "0110001";
            when x"D" => seg <= "1000010";
            when x"E" => seg <= "0110000";
            when others => seg <= "0111000";
        end case;
    end process p_bin2seg;

    p_anode_select : process (sig_digit, an_enable) is
    begin
        anode <= (others => '1');
        case sig_digit is
            when "000" => anode(0) <= an_enable(0);
            when "001" => anode(1) <= an_enable(1);
            when "010" => anode(2) <= an_enable(2);
            when "011" => anode(3) <= an_enable(3);
            when "100" => anode(4) <= an_enable(4);
            when "101" => anode(5) <= an_enable(5);
            when "110" => anode(6) <= an_enable(6);
            when others => anode(7) <= an_enable(7);
        end case;
    end process p_anode_select;

end architecture Behavioral;
