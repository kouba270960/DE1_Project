
library ieee;
use ieee.std_logic_1164.all;

entity tb_PingPong_top is
end tb_PingPong_top;

architecture tb of tb_PingPong_top is

    component PingPong_top
        port (clk  : in std_logic;
              btnc : in std_logic;
              btnu : in std_logic;
              btnl : in std_logic;
              btnr : in std_logic;
              btnd : in std_logic;
              led  : out std_logic_vector (15 downto 0);
              seg  : out std_logic_vector (6 downto 0);
              an   : out std_logic_vector (7 downto 0));
    end component;

    signal clk  : std_logic;
    signal btnc : std_logic;
    signal btnu : std_logic;
    signal btnl : std_logic;
    signal btnr : std_logic;
    signal btnd : std_logic;
    signal led  : std_logic_vector (15 downto 0);
    signal seg  : std_logic_vector (6 downto 0);
    signal an   : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : PingPong_top
    port map (clk  => clk,
              btnc => btnc,
              btnu => btnu,
              btnl => btnl,
              btnr => btnr,
              btnd => btnd,
              led  => led,
              seg  => seg,
              an   => an);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        btnu <= '0';
        btnl <= '0';
        btnr <= '0';
        btnd <= '0';

        -- Reset generation
        --  ***EDIT*** Replace YOURRESETSIGNAL below by the name of your reset as I haven't guessed it
        btnc <= '1';
        wait for 100 ns;
        btnc <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 2 * TbPeriod;
        btnu <= '1';
        wait for 10 * TbPeriod;
        btnu <= '0';
        wait for 10 * TbPeriod;
        btnu <= '1';
        wait for 10 * TbPeriod;
        btnu <= '0';
        wait for 10 * TbPeriod;
        btnu <= '1';
        wait for 10 * TbPeriod;
        btnu <= '0';
        wait for 10 * TbPeriod;
        btnu <= '1';
        wait for 10 * TbPeriod;
        btnu <= '0';
        wait for 10 * TbPeriod;
        btnu <= '1';
        wait for 10 * TbPeriod;
        btnu <= '0';
        wait for 10 * TbPeriod;
        btnu <= '1';
        wait for 10 * TbPeriod;
        btnu <= '0';
        wait for 10 * TbPeriod;
        btnu <= '1';
        wait for 10 * TbPeriod;
        btnu <= '0';
        wait for 1570 * TbPeriod;
        btnr <= '1';
        wait for 10 * TbPeriod;
        btnr <= '0';
        wait for 2990 * TbPeriod;
        btnl <= '1';
        wait for 10 * TbPeriod;
        btnl <= '0';
        
        
        
        
        
        wait for 20000 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_PingPong_top of tb_PingPong_top is
    for tb
    end for;
end cfg_tb_PingPong_top;