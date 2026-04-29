
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-------------------------------------------------------------

entity display_driver is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (31 downto 0);
           an_enable : in STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           anode : out STD_LOGIC_VECTOR (7 downto 0));
end display_driver;

architecture Behavioral of display_driver is

    -- Component declaration for clock enable
    component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component clk_en;
 
    -- Component declaration for binary counter
    component counter is
        generic ( G_BITS : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;
 
    component bin2seg is

        Port ( bin : in STD_LOGIC_VECTOR (3 downto 0);
               seg : out STD_LOGIC_VECTOR (6 downto 0));

    end component bin2seg;
 
    -- Internal signals
    signal sig_en : std_logic;
    signal sig_digit: std_logic_vector(2 downto 0);
    signal sig_bin: std_logic_vector(3 downto 0);

begin

    ------------------------------------------------------------------------
    -- Clock enable generator for refresh timing
    ------------------------------------------------------------------------
    clock_0 : clk_en
        generic map ( G_MAX => 4_000_000 )  -- Adjust for flicker-free multiplexing
        port map (                  -- For simulation: 8
            clk => clk,             -- For implementation: 4_000_000
            rst => rst,
            ce  => sig_en
        );

    counter_0 : counter
        generic map ( G_BITS => 3 )
        port map (
            clk => clk,
            rst => rst,
            en  => sig_en,
            cnt => sig_digit
        );

    ------------------------------------------------------------------------
    -- Digit select
    ------------------------------------------------------------------------
    
    p_digit_select: process (sig_digit) is
    begin
        case sig_digit is
            when b"000" =>
                sig_bin <= data(3 downto 0);
            when b"001" =>
                sig_bin <= data(7 downto 4);
            when b"010" =>
                sig_bin <= data(11 downto 8);
            when b"011" =>
                sig_bin <= data(15 downto 12);
            when b"100" =>
                sig_bin <= data(19 downto 16);
            when b"101" =>
                sig_bin <= data(23 downto 20);
            when b"110" =>
                sig_bin <= data(27 downto 24);
            when b"111" =>
                sig_bin <= data(31 downto 28);
            when others =>
                sig_bin <= b"0000";
        end case;
    end process p_digit_select;
    
    
    
    --sig_bin <= data(3 downto 0) when sig_digit = "0" else
    --           data(7 downto 4);

    ------------------------------------------------------------------------
    -- 7-segment decoder
    ------------------------------------------------------------------------
    decoder_0 : bin2seg
        port map (

            bin => sig_bin,
            seg => seg

        );

    ------------------------------------------------------------------------
    -- Anode select process
    ------------------------------------------------------------------------
    p_anode_select : process (sig_digit) is
    begin
        case sig_digit is
            when b"000" =>
                anode <= b"1111_111" & an_enable(0);
            when b"001" =>
                anode <= b"1111_11" & an_enable(1) & b"1";
            when b"010" =>
                anode <= b"1111_1" & an_enable(2) & b"11";
            when b"011" =>
                anode <= b"1111" & an_enable(3) & b"111";
            when b"100" =>
                anode <= b"111" & an_enable(4) & b"1111";
            when b"101" =>
                anode <= b"11" & an_enable(5) & b"1_1111";
            when b"110" =>
                anode <= b"1" & an_enable(6) & b"11_1111";
            when b"111" =>
                anode <= an_enable(7) & b"111_1111";
            
            when others =>
                anode <= b"1111_1111";  -- All off
        end case;
    end process;

end Behavioral;
