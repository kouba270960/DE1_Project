library ieee;
use ieee.std_logic_1164.all;

entity tb_counter10 is
end tb_counter10;

architecture tb of tb_counter10 is

    component counter10
        port (clk   : in std_logic;
              rst   : in std_logic;
              count : in std_logic;
              cnt   : out std_logic_vector (3 downto 0);
              c_out : out std_logic);
    end component;

    signal clk   : std_logic;
    signal rst   : std_logic;
    signal count : std_logic;
    signal cnt   : std_logic_vector (3 downto 0);
    signal c_out : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : counter10
    port map (clk   => clk,
              rst   => rst,
              count => count,
              cnt   => cnt,
              c_out => c_out);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        count <= '0';

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        count <= '1';
        wait for 3 * TbPeriod;
        count <= '0';
        wait for 3 * TbPeriod;
        rst <= '1';
        wait for 3 * TbPeriod;
        rst <= '0';
        wait for 3 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_counter10 of tb_counter10 is
    for tb
    end for;
end cfg_tb_counter10;