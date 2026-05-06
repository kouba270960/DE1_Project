library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_cnt_b_bd is
end entity tb_cnt_b_bd;

architecture sim of tb_cnt_b_bd is
    constant C_CLK_PERIOD : time := 10 ns;

    signal clk        : std_logic := '0';
    signal rst        : std_logic := '0';
    signal count_up   : std_logic := '0';
    signal count_down : std_logic := '0';
    signal count      : std_logic_vector(2 downto 0);
begin

    uut : entity work.cnt_b_bd
        port map (
            clk        => clk,
            rst        => rst,
            count_up   => count_up,
            count_down => count_down,
            count      => count
        );

    p_clk : process is
    begin
        while now < 300 ns loop
            clk <= '0';
            wait for C_CLK_PERIOD / 2;
            clk <= '1';
            wait for C_CLK_PERIOD / 2;
        end loop;
        wait;
    end process p_clk;

    p_stimulus : process is
        procedure pulse_up is
        begin
            count_up <= '1';
            wait for C_CLK_PERIOD;
            count_up <= '0';
            wait for C_CLK_PERIOD;
        end procedure;

        procedure pulse_down is
        begin
            count_down <= '1';
            wait for C_CLK_PERIOD;
            count_down <= '0';
            wait for C_CLK_PERIOD;
        end procedure;
    begin
        rst <= '1';
        wait for C_CLK_PERIOD;
        rst <= '0';
        wait for C_CLK_PERIOD;

        assert count = "000"
            report "Reset should clear count to 000"
            severity error;

        pulse_up;
        assert count = "001"
            report "Count should increment to 001"
            severity error;

        pulse_up;
        pulse_up;
        assert count = "011"
            report "Count should increment to 011"
            severity error;

        pulse_down;
        assert count = "010"
            report "Count should decrement to 010"
            severity error;

        for i in 1 to 8 loop
            pulse_up;
        end loop;
        assert count = "111"
            report "Count should saturate at 111"
            severity error;

        for i in 1 to 8 loop
            pulse_down;
        end loop;
        assert count = "000"
            report "Count should saturate at 000"
            severity error;

        count_up <= '1';
        count_down <= '1';
        wait for C_CLK_PERIOD;
        count_up <= '0';
        count_down <= '0';
        wait for C_CLK_PERIOD;
        assert count = "000"
            report "Simultaneous up/down should not change count"
            severity error;

        assert false
            report "tb_cnt_b_bd completed successfully"
            severity note;
        wait;
    end process p_stimulus;

end architecture sim;
