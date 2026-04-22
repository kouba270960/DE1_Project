library ieee;
use ieee.std_logic_1164.all;

entity debounce is
    generic (
        G_SAMPLE_MAX : positive := 1_000_000
    );
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        btn_in    : in  std_logic;
        btn_state : out std_logic;
        btn_press : out std_logic
    );
end entity debounce;

architecture Behavioral of debounce is
    signal sig_sample_cnt : natural range 0 to G_SAMPLE_MAX - 1 := 0;
    signal sig_sync_0     : std_logic := '0';
    signal sig_sync_1     : std_logic := '0';
    signal sig_state      : std_logic := '0';
    signal sig_prev_state : std_logic := '0';
begin

    p_debounce : process (clk) is
    begin
        if rising_edge(clk) then
            if rst = '1' then
                sig_sample_cnt <= 0;
                sig_sync_0     <= '0';
                sig_sync_1     <= '0';
                sig_state      <= '0';
                sig_prev_state <= '0';
            else
                sig_sync_0 <= btn_in;
                sig_sync_1 <= sig_sync_0;

                if sig_sample_cnt = G_SAMPLE_MAX - 1 then
                    sig_sample_cnt <= 0;
                    sig_prev_state <= sig_state;
                    sig_state      <= sig_sync_1;
                else
                    sig_sample_cnt <= sig_sample_cnt + 1;
                    sig_prev_state <= sig_state;
                end if;
            end if;
        end if;
    end process p_debounce;

    btn_state <= sig_state;
    btn_press <= sig_state and not sig_prev_state;

end architecture Behavioral;
