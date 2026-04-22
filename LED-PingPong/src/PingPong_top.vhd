library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PingPong_top is
    port (
        clk  : in  std_logic;
        btnc : in  std_logic;
        btnu : in  std_logic;
        btnl : in  std_logic;
        btnr : in  std_logic;
        btnd : in  std_logic;
        led  : out std_logic_vector(15 downto 0);
        seg  : out std_logic_vector(6 downto 0);
        an   : out std_logic_vector(7 downto 0);
        dp   : out std_logic
    );
end entity PingPong_top;

architecture Behavioral of PingPong_top is
    constant C_AN_ENABLE : std_logic_vector(7 downto 0) := "11111000";

    signal sig_rst           : std_logic;
    signal sig_btnl_press    : std_logic;
    signal sig_btnr_press    : std_logic;
    signal sig_btnu_press    : std_logic;
    signal sig_btnd_press    : std_logic;
    signal sig_speed         : std_logic_vector(2 downto 0);
    signal sig_step          : std_logic;
    signal sig_dir           : std_logic := '1';
    signal sig_led           : std_logic_vector(15 downto 0);
    signal sig_count18       : std_logic;
    signal sig_count17       : std_logic;
    signal sig_count2        : std_logic;
    signal sig_count1        : std_logic;
    signal sig_count19       : std_logic;
    signal sig_count0        : std_logic;
    signal sig_count19_prev  : std_logic := '0';
    signal sig_count0_prev   : std_logic := '0';
    signal sig_left_score    : unsigned(3 downto 0) := (others => '0');
    signal sig_right_score   : unsigned(3 downto 0) := (others => '0');
    signal sig_display_data  : std_logic_vector(31 downto 0);
begin

    sig_rst <= btnc;
    led <= sig_led;
    dp <= '1';

    debounce_left : entity work.debounce
        port map (
            clk       => clk,
            rst       => sig_rst,
            btn_in    => btnl,
            btn_state => open,
            btn_press => sig_btnl_press
        );

    debounce_right : entity work.debounce
        port map (
            clk       => clk,
            rst       => sig_rst,
            btn_in    => btnr,
            btn_state => open,
            btn_press => sig_btnr_press
        );

    debounce_up : entity work.debounce
        port map (
            clk       => clk,
            rst       => sig_rst,
            btn_in    => btnu,
            btn_state => open,
            btn_press => sig_btnu_press
        );

    debounce_down : entity work.debounce
        port map (
            clk       => clk,
            rst       => sig_rst,
            btn_in    => btnd,
            btn_state => open,
            btn_press => sig_btnd_press
        );

    speed_counter : entity work.cnt_b_bd
        port map (
            clk        => clk,
            rst        => sig_rst,
            count_up   => sig_btnu_press,
            count_down => sig_btnd_press,
            count      => sig_speed
        );

    speed_enable : entity work.clk_en
        generic map (
            G_BASE_COUNT => 3_000_000
        )
        port map (
            clk     => clk,
            cnt_set => sig_speed,
            rst     => sig_rst,
            ce      => sig_step
        );

    ball_counter : entity work.cnt_d_bd
        port map (
            clk     => clk,
            u_d     => sig_dir,
            step    => sig_step,
            rst     => sig_rst,
            led     => sig_led,
            count18 => sig_count18,
            count17 => sig_count17,
            count2  => sig_count2,
            count1  => sig_count1,
            count19 => sig_count19,
            count0  => sig_count0
        );

    p_game_control : process (clk) is
    begin
        if rising_edge(clk) then
            if sig_rst = '1' then
                sig_dir          <= '1';
                sig_left_score   <= (others => '0');
                sig_right_score  <= (others => '0');
                sig_count19_prev <= '0';
                sig_count0_prev  <= '0';
            else
                sig_count19_prev <= sig_count19;
                sig_count0_prev  <= sig_count0;

                if (sig_count1 = '1' or sig_count2 = '1') and sig_btnl_press = '1' then
                    sig_dir <= '1';
                elsif (sig_count17 = '1' or sig_count18 = '1') and sig_btnr_press = '1' then
                    sig_dir <= '0';
                end if;

                if sig_count19 = '1' and sig_count19_prev = '0' then
                    if sig_left_score < 9 then
                        sig_left_score <= sig_left_score + 1;
                    else
                        sig_left_score <= (others => '0');
                    end if;
                    sig_dir <= '0';
                elsif sig_count0 = '1' and sig_count0_prev = '0' then
                    if sig_right_score < 9 then
                        sig_right_score <= sig_right_score + 1;
                    else
                        sig_right_score <= (others => '0');
                    end if;
                    sig_dir <= '1';
                end if;
            end if;
        end if;
    end process p_game_control;

    sig_display_data <= x"00000" &
                        '0' & sig_speed &
                        std_logic_vector(sig_left_score) &
                        std_logic_vector(sig_right_score);

    display : entity work.display_driver
        port map (
            clk       => clk,
            rst       => sig_rst,
            data      => sig_display_data,
            an_enable => C_AN_ENABLE,
            seg       => seg,
            anode     => an
        );

end architecture Behavioral;
