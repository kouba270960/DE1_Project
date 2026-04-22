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
        an   : out std_logic_vector(7 downto 0)
    );
end entity PingPong_top;

architecture Behavioral of PingPong_top is
    constant C_AN_ENABLE : std_logic_vector(7 downto 0) := "00110100";

    signal sig_rst           : std_logic;
    signal sig_btnl_press    : std_logic;
    signal sig_btnr_press    : std_logic;
    signal sig_btnu_press    : std_logic;
    signal sig_btnd_press    : std_logic;
    signal sig_left_bounce   : std_logic;
    signal sig_right_bounce  : std_logic;
    signal sig_up_bounce     : std_logic;
    signal sig_down_bounce   : std_logic;
    signal sig_speed         : std_logic_vector(2 downto 0);
    signal sig_step          : std_logic;
    signal sig_dir           : std_logic := '1';
    signal sig_led           : std_logic_vector(15 downto 0);
    signal sig_count         : std_logic_vector(19 downto 0);
    signal sig_left_window   : std_logic;
    signal sig_right_window  : std_logic;
    signal sig_left_hit      : std_logic;
    signal sig_right_hit     : std_logic;
    signal sig_count19_prev  : std_logic := '0';
    signal sig_count0_prev   : std_logic := '0';
    signal sig_left_score_en : std_logic := '0';
    signal sig_right_score_en: std_logic := '0';
    signal sig_left_score    : std_logic_vector(7 downto 0);
    signal sig_right_score   : std_logic_vector(7 downto 0);
    signal sig_display_data  : std_logic_vector(31 downto 0);
begin

    sig_rst <= btnc;
    led <= sig_led;

    debounce_left : entity work.debounce
        port map (
            clk       => clk,
            rst       => sig_rst,
            btn_in    => btnr,
            btn_state => sig_left_bounce,
            btn_press => sig_btnl_press
        );

    debounce_right : entity work.debounce
        port map (
            clk       => clk,
            rst       => sig_rst,
            btn_in    => btnl,
            btn_state => sig_right_bounce,
            btn_press => sig_btnr_press
        );

    debounce_up : entity work.debounce
        port map (
            clk       => clk,
            rst       => sig_rst,
            btn_in    => btnu,
            btn_state => sig_up_bounce,
            btn_press => sig_btnu_press
        );

    debounce_down : entity work.debounce
        port map (
            clk       => clk,
            rst       => sig_rst,
            btn_in    => btnd,
            btn_state => sig_down_bounce,
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
            count   => sig_count
        );

    sig_left_window <= sig_count(2);
    sig_right_window <= sig_count(17);

    sig_left_hit <= sig_btnl_press and sig_left_window;
    sig_right_hit <= sig_btnr_press and sig_right_window;

    p_direction_latch : process (clk) is
    begin
        if rising_edge(clk) then
            if sig_rst = '1' then
                sig_dir <= '1';
                sig_count19_prev <= '0';
                sig_count0_prev <= '0';
                sig_left_score_en <= '0';
                sig_right_score_en <= '0';
            else
                sig_count19_prev <= sig_count(19);
                sig_count0_prev <= sig_count(0);
                sig_left_score_en <= sig_count(19) and not sig_count19_prev;
                sig_right_score_en <= sig_count(0) and not sig_count0_prev;

                if sig_left_hit = '1' then
                    sig_dir <= '1';
                elsif sig_right_hit = '1' then
                    sig_dir <= '0';
                elsif sig_count(19) = '1' then
                    sig_dir <= '0';
                elsif sig_count(0) = '1' then
                    sig_dir <= '1';
                end if;
            end if;
        end if;
    end process p_direction_latch;

    left_score_counter : entity work.cnt_8bit
        port map (
            clk   => clk,
            rst   => sig_rst,
            count => sig_left_score_en,
            outp  => sig_left_score
        );

    right_score_counter : entity work.cnt_8bit
        port map (
            clk   => clk,
            rst   => sig_rst,
            count => sig_right_score_en,
            outp  => sig_right_score
        );

    sig_display_data(31 downto 24) <= sig_right_score;
    sig_display_data(23 downto 15) <= (others => '0');
    sig_display_data(14 downto 12) <= sig_speed;
    sig_display_data(11 downto 8)  <= (others => '0');
    sig_display_data(7 downto 0)   <= sig_left_score;

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
