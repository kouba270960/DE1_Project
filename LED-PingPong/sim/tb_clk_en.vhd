 library ieee;
use ieee.std_logic_1164.all;

entity tb_clk_en is
end tb_clk_en;

architecture tb of tb_clk_en is

    component clk_en
        port (
            clk     : in  std_logic;
            cnt_set : in  std_logic_vector(2 downto 0);
            rst     : in  std_logic;
            ce      : out std_logic
        );
    end component;

    signal clk     : std_logic := '0';
    signal cnt_set : std_logic_vector(2 downto 0) := (others => '0');
    signal rst     : std_logic := '0';
    signal ce      : std_logic;

    -- pro simulaci stačí 10 ns perioda
    constant TbPeriod : time := 10 ns;
    signal TbSimEnded : std_logic := '0';

begin

    dut : clk_en
        port map (
            clk     => clk,
            cnt_set => cnt_set,
            rst     => rst,
            ce      => ce
        );

    -- generování clocku
    clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin
        -- počáteční stav
        cnt_set <= "000";
        rst <= '1';
        wait for 30 ns;
        rst <= '0';

        -- rychlost 000
        wait for 300 ns;

        -- rychlost 001
        cnt_set <= "001";
        wait for 300 ns;

        -- rychlost 010
        cnt_set <= "010";
        wait for 300 ns;

        -- rychlost 011
        cnt_set <= "011";
        wait for 300 ns;

        -- rychlost 100
        cnt_set <= "100";
        wait for 300 ns;

        -- rychlost 101
        cnt_set <= "101";
        wait for 300 ns;

        -- rychlost 110
        cnt_set <= "110";
        wait for 300 ns;

        -- rychlost 111
        cnt_set <= "111";
        wait for 300 ns;

        -- zkusíme reset i během běhu
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 200 ns;

        -- ukončení simulace
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_clk_en of tb_clk_en is
    for tb
    end for;
end cfg_tb_clk_en;
