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



 --                     Declaration of components
 --------------------------------------------------------------------------------------------------------------
 --adjustable clock enable
    component clk_en2 is
        generic( G_BASE_COUNT : positive);
        port (
        clk     : in  std_logic;
        cnt_set : in  std_logic_vector(2 downto 0);
        rst     : in  std_logic;
        ce      : out std_logic
        );
    end component;
    
-- display driver
    component display_driver is
        Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (31 downto 0);
           an_enable : in STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
--Main decadic counter
    component cnt_d_bd is
        port (
        u_d     : in  std_logic;  -- '1' = doprava, '0' = doleva
        step    : in  std_logic;  -- posun o 1 krok
        rst     : in  std_logic;

        led     : out std_logic_vector(15 downto 0);

        count18 : out std_logic;
        count17 : out std_logic;
        count2  : out std_logic;
        count1  : out std_logic;
        count19 : out std_logic;
        count0  : out std_logic
    );
    end component;
    
--Binary counter
    component cnt_b_bd is
        port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        count_up   : in  std_logic;
        count_down : in  std_logic;
        count      : out std_logic_vector(2 downto 0)
    );
    end component;
    
--Debouncer
    component debounce is
        Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btn_in : in STD_LOGIC;
           btn_state : out STD_LOGIC;
           btn_press : out STD_LOGIC);
    end component;
    
--Counters for scores
    component counter10 is
        Port ( 
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           count : in STD_LOGIC;
           cnt : out STD_LOGIC_VECTOR(3 downto 0);
           c_out : out STD_LOGIC);
    end component;


--RS FlipFlop
    component RSFlipFlop is
        port(
            clk : in STD_LOGIC;
            R   : in STD_LOGIC;
            S   : in STD_LOGIC;
            Q   : out STD_LOGIC
        );
    end component;


--                      Signals
---------------------------------------------------------------------------------------------------------------
    signal sig_btnl_press    : std_logic;
    signal sig_btnr_press    : std_logic;
    signal sig_btnu_press    : std_logic;
    signal sig_btnd_press    : std_logic;
    signal sig_speed         : std_logic_vector(2 downto 0);        --output of CNT_B_BD
    signal sig_step          : std_logic;                           --step input of CNT_D_BD
    signal sig_dir           : std_logic;                           --direction of CNT_D_BD
    signal sig_count         : std_logic_vector(19 downto 0);       --output of CNT_D_BD
    signal sig_left_score    : unsigned(3 downto 0) := (others => '0');
    signal sig_right_score   : unsigned(3 downto 0) := (others => '0');
    signal sig_display_data  : std_logic_vector(31 downto 0);

    signal sig_player1CntCarry   : std_logic;
    signal sig_player2CntCarry   : std_logic;

    signal sig_player1ScoreL     : std_logic_vector(3 downto 0);
    signal sig_player1ScoreH     : std_logic_vector(3 downto 0);

    signal sig_player2ScoreL     : std_logic_vector(3 downto 0);
    signal sig_player2ScoreH     : std_logic_vector(3 downto 0);
    
    signal sig_game_rst : std_logic;
    
    signal sig_R : std_logic;
    signal sig_S : std_logic;
    
    signal sig_addP1 : std_logic;
    signal sig_addP2 : std_logic;



begin

    led <= sig_count(17 downto 2);
    sig_game_rst <= btnc or (sig_count(0) or sig_count(19));
    
    sig_addP2 <= sig_count(19) or sig_count(18);
    sig_addP1 <= sig_count(0) or sig_count(1);
    
    sig_R <= sig_btnl_press and sig_count(17);
    sig_S <= sig_btnr_press and sig_count(2);
 
 --                     Instantiation of components
 -------------------------------------------------------------------------------------------------------------------
 
 clock0 : clk_en2
    generic map ( G_BASE_COUNT => 2500_000 ) --2500_000 for run, 100 for simulation
    port map (
        clk => clk,
        rst => btnc,
        cnt_set => sig_speed,
        ce => sig_step    
    );
    
 -- main game counter
 game : cnt_d_bd
    port map (
        u_d => sig_dir,
        step => sig_step,
        rst => sig_game_rst,
        led => sig_count(17 downto 2),
        count18 => sig_count(18),
        count17 => open,
        count2 => open,
        count1 => sig_count(1),
        count19 => sig_count(19),
        count0 => sig_count(0)
    );
    
-- speed counter
speed : cnt_b_bd
    port map (
        clk => clk,
        rst => btnc,
        count_up => sig_btnu_press,
        count_down => sig_btnd_press,
        count => sig_speed
    );

-- display
display : display_driver
    port map (
        clk => clk,
        rst => btnc,
        data => sig_display_data,
        an_enable => C_AN_ENABLE,
        seg => seg,
        anode => an
    );
    
-- debounce for up button
upb : debounce
    port map (
        clk => clk,
        rst => btnc,
        btn_in => btnu,
        btn_state => open,
        btn_press => sig_btnu_press
    );
    
-- debounce for down button
downb : debounce
    port map (
        clk => clk,
        rst => btnc,
        btn_in => btnd,
        btn_state => open,
        btn_press => sig_btnd_press
    );
    
-- debounce for up button
rightb : debounce
    port map (
        clk => clk,
        rst => btnc,
        btn_in => btnr,
        btn_state => open,
        btn_press => sig_btnr_press
    );
    
-- debounce for up button
leftb : debounce
    port map (
        clk => clk,
        rst => btnc,
        btn_in => btnl,
        btn_state => open,
        btn_press => sig_btnl_press
    );

-- direction changing FlipFlop
FlipFlop : RSFlipFlop
    port map (
        clk => clk,
        R => sig_R,
        S => sig_S,
        Q => sig_dir
    );

--p_rs : process (clk) is
--    begin
--    if rising_edge(Clk) then
--            if ((sig_btnl_press and (sig_count(17) or sig_count(18))) = '1') then
--                sig_dir <= '1'; 
--            elsif ((sig_btnr_press and (sig_count(2) or sig_count(1))) = '1') then
--                sig_dir <= '0'; 
--            elsif (((sig_btnr_press and (sig_count(2) or sig_count(1))) = '0') and ((sig_btnl_press and (sig_count(17) or sig_count(18))) = '0')) then
--                sig_dir <= '1'; 
--            else
--                sig_dir <= sig_dir;
--            end if;
--        end if;

--end process p_rs;

--player 1 score counters (asynchronous!):
P1L : counter10
    port map (
        clk => clk,
        rst => btnc,
        count => sig_addP1,
        cnt => sig_player1ScoreL(3 downto 0),
        c_out => sig_player1CntCarry
    );

P1H : counter10
    port map (
        clk => clk,
        rst => btnc,
        count => sig_player1CntCarry,
        cnt => sig_player1ScoreH(3 downto 0),
        c_out => open
    );

--player 2 score counters (asynchronous!):
P2L : counter10
    port map (
        clk => clk,
        rst => btnc,
        count => sig_addP2,
        cnt => sig_player2ScoreL(3 downto 0),
        c_out => sig_player2CntCarry
    );

P2H : counter10
    port map (
        clk => clk,
        rst => btnc,
        count => sig_player2CntCarry,
        cnt => sig_player2ScoreH(3 downto 0),
        c_out => open
    );
    


--making of display data vector
sig_display_data <= (sig_player1ScoreH & sig_player1ScoreL & b"0000_0000_0" & sig_speed & b"0000" & sig_player2ScoreH & sig_player2ScoreL);

 

end architecture Behavioral;