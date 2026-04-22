library ieee;
use ieee.std_logic_1164.all;

entity cnt_d_bd is
    port (
        clk     : in  std_logic;
        u_d     : in  std_logic;  -- '1' = doprava, '0' = doleva
        step    : in  std_logic;  -- posun o 1 krok
        rst     : in  std_logic;

        led     : out std_logic_vector(15 downto 0);
        count   : out std_logic_vector(19 downto 0)
    );
end cnt_d_bd;

architecture Behavioral of cnt_d_bd is
    signal pos : integer range 0 to 19 := 2;
    signal sig_count : std_logic_vector(19 downto 0);
begin

    -- hlavní čítač pozice
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                pos <= 2;  -- start na levém kraji herního pole
            elsif step = '1' then
                if u_d = '1' then
                    if pos < 19 then
                        pos <= pos + 1;
                    else
                        pos <= 19;
                    end if;
                else
                    if pos > 0 then
                        pos <= pos - 1;
                    else
                        pos <= 0;
                    end if;
                end if;
            end if;
        end if;
    end process;

    -- indikace pozice jako one-hot vektor
    process(pos)
        variable tmp : std_logic_vector(19 downto 0);
    begin
        tmp := (others => '0');
        tmp(pos) := '1';
        sig_count <= tmp;
    end process;

    count <= sig_count;

    -- převod pozice na LED(15:0)
    -- stav 2..17 odpovídá 16 LED
    process(pos)
        variable tmp : std_logic_vector(15 downto 0);
    begin
        tmp := (others => '0');

        case pos is
            when 2  => tmp(0)  := '1';
            when 3  => tmp(1)  := '1';
            when 4  => tmp(2)  := '1';
            when 5  => tmp(3)  := '1';
            when 6  => tmp(4)  := '1';
            when 7  => tmp(5)  := '1';
            when 8  => tmp(6)  := '1';
            when 9  => tmp(7)  := '1';
            when 10 => tmp(8)  := '1';
            when 11 => tmp(9)  := '1';
            when 12 => tmp(10) := '1';
            when 13 => tmp(11) := '1';
            when 14 => tmp(12) := '1';
            when 15 => tmp(13) := '1';
            when 16 => tmp(14) := '1';
            when 17 => tmp(15) := '1';
            when others => null;  -- pro 0,1,18,19 nic nesvítí
        end case;

        led <= tmp;
    end process;

end Behavioral;
