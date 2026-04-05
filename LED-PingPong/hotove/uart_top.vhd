library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_top is
    Port ( clk : in STD_LOGIC;
           btnu : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (7 downto 0);
           btnd : in STD_LOGIC;
           uart_rxd_out : out STD_LOGIC;
           led17_g : out STD_LOGIC);
end uart_top;

architecture Behavioral of uart_top is

    component debounce is
        Port ( clk       : in  STD_LOGIC;
               rst       : in  STD_LOGIC;
               btn_in    : in  STD_LOGIC;
               btn_state : out STD_LOGIC;
               btn_press : out STD_LOGIC);
    end component debounce;

    component uart_tx is
        Port ( clk : in STD_LOGIC;
               rst : in STD_LOGIC;
               data : in STD_LOGIC_VECTOR (7 downto 0); ------------------------------------------dodelane
               tx_start : in STD_LOGIC;
               tx : out STD_LOGIC;
               tx_busy : out STD_LOGIC);
    end component uart_tx;

    -- Internal signal(s)
    signal sig_start : std_logic;

begin

    ------------------------------------------------------------------------
    -- Button debouncer
    ------------------------------------------------------------------------
    debounce_inst : debounce
        port map (
            clk       => clk,
            rst       => btnu,
            btn_in    => btnd,
            btn_press => sig_start,
            btn_state => open
        );

    ------------------------------------------------------------------------
    -- UART transmitter
    ------------------------------------------------------------------------
    uart_inst : uart_tx
        port map (
        clk         => clk,
        rst         => btnu,
        tx_start    => sig_start,   
        data        => sw,
        tx_busy     => led17_g,
        tx          => uart_rxd_out
        );

end Behavioral;