library ieee;
use ieee.std_logic_1164.all;

entity tb_cnt_d_bd is
end tb_cnt_d_bd;

architecture tb of tb_cnt_d_bd is

    component cnt_d_bd
        port (
            clk     : in  std_logic;
            u_d     : in  std_logic;
            step    : in  std_logic;
            rst     : in  std_logic;
            led     : out std_logic_vector(15 downto 0);
            count   : out std_logic_vector(19 downto 0)
        );
    end component;

    signal clk     : std_logic := '0';
    signal u_d     : std_logic := '1';
    signal step    : std_logic := '0';
    signal rst     : std_logic := '0';

    signal led     : std_logic_vector(15 downto 0);
    signal count   : std_logic_vector(19 downto 0);

begin

    clk <= not clk after 5 ns;

    dut : cnt_d_bd
        port map (
            clk     => clk,
            u_d     => u_d,
            step    => step,
            rst     => rst,
            led     => led,
            count   => count
        );

    stimuli : process
        procedure make_step is
        begin
            step <= '1';
            wait for 10 ns;
            step <= '0';
            wait for 10 ns;
        end procedure;
    begin
        -- reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- pohyb doprava
        u_d <= '1';
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;

        -- pokračování doprava až ke kraji
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;

        -- změna směru doleva
        u_d <= '0';
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;

        -- dojezd doleva k levému kraji
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;
        make_step;

        wait;
    end process;

end tb;
