library ieee;
use ieee.std_logic_1164.all;

entity tb_RSFlipFlop is
end tb_RSFlipFlop;

architecture tb of tb_RSFlipFlop is

    component RSFlipFlop
        port (S   : in std_logic;
              R   : in std_logic;
              Q   : out std_logic;
              clk : in std_logic);
    end component;

    signal S   : std_logic;
    signal R   : std_logic;
    signal Q   : std_logic;
    signal clk : std_logic;

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : RSFlipFlop
    port map (S   => S,
              R   => R,
              Q   => Q,
              clk => clk);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        S <= '0';
        R <= '0';

        -- ***EDIT*** Add stimuli here
        wait for 5 * TbPeriod;
        S <= '1';
        wait for 5 * TbPeriod;
        S <= '0';
        wait for 5 * TbPeriod;
        R <= '1';
        wait for 5 * TbPeriod;
        R <= '0';
        wait for 5 * TbPeriod;
        S <= '1';
        wait for 5 * TbPeriod;
        R <= '1';
        wait for 5 * TbPeriod;
        S <= '0';

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_RSFlipFlop of tb_RSFlipFlop is
    for tb
    end for;
end cfg_tb_RSFlipFlop;