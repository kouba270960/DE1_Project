library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity segmnet_top is
    Port ( sw : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           dp : out STD_LOGIC;
           an : out STD_LOGIC_VECTOR (7 downto 0));
end segmnet_top;

architecture Behavioral of segmnet_top is

    --component declaration
    

    component bin2seg

      Port ( bin : in STD_LOGIC_VECTOR (3 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    		
begin
     --component instantiotion
    displ : bin2seg
    port map (
        bin => sw,
        seg => seg
    );
    
    dp <= '1';
    an <= b"1110_1111";
    
end Behavioral;
