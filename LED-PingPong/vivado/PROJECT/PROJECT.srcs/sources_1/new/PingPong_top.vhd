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
    
--Counter for scores

--                      Signals
---------------------------------------------------------------------------------------------------------------
    signal sig_rst           : std_logic;                           --obsolete?
    signal sig_btnl_press    : std_logic;
    signal sig_btnr_press    : std_logic;
    signal sig_btnu_press    : std_logic;
    signal sig_btnd_press    : std_logic;
    signal sig_speed         : std_logic_vector(2 downto 0);        --output of CNT_B_BD
    signal sig_step          : std_logic;                           --step input of CNT_D_BD
    signal sig_dir           : std_logic := '1';                    --direction of CNT_D_BD
    signal sig_led           : std_logic_vector(15 downto 0);       --obsolete?
    signal sig_count         : std_logic_vector(19 downto 0);       --output of CNT_D_BD
    signal sig_left_score    : unsigned(3 downto 0) := (others => '0');
    signal sig_right_score   : unsigned(3 downto 0) := (others => '0');
    signal sig_display_data  : std_logic_vector(31 downto 0);
    signal btn_states        : std_logic_vector(3 downto 0);
begin

    sig_rst <= btnc;
    led <= sig_count(17 downto 2);
 
 --                     Instantiation of components
 -------------------------------------------------------------------------------------------------------------------
 
 clock0 : clk_en2
    generic map ( G_BASE_COUNT => 100000000 )
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
        rst => btnc,
        led => sig_count(17 downto 2),
        count18 => sig_count(18),
        count17 => sig_count(17),
        count2 => sig_count(2),
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
up : debounce
    port map (
        clk => clk,
        rst => btnc,
        btn_in => btnu,
        btn_state => btn_states (0),
        btn_press => sig_btnu_press
    );
    
-- debounce for down button
down : debounce
    port map (
        clk => clk,
        rst => btnc,
        btn_in => btnd,
        btn_state => btn_states (1),
        btn_press => sig_btnd_press
    );
    
-- debounce for up button
right : debounce
    port map (
        clk => clk,
        rst => btnc,
        btn_in => btnr,
        btn_state => btn_states (2),
        btn_press => sig_btnr_press
    );
    
-- debounce for up button
left : debounce
    port map (
        clk => clk,
        rst => btnc,
        btn_in => btnl,
        btn_state => btn_states (3),
        btn_press => sig_btnl_press
    );

--                          Main game process
-------------------------------------------------------------------------------------------------


 

end architecture Behavioral;