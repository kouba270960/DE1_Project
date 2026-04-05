----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2026 09:02:10 AM
-- Design Name: 
-- Module Name: deMorgan - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity deMorgan is
    Port ( a: in std_logic;
           b : in STD_LOGIC; 
           c : in STD_LOGIC;
           f_org : out STD_LOGIC;
           f_nand : out STD_LOGIC;
           f_nor : out STD_LOGIC);
end deMorgan;

architecture Behavioral of deMorgan is

begin
    f_org <= (a and not(b))or c;
    f_nand <= not(not(a and not(b)) and not (c));
    f_nor <= (not(not(a) or b)or c);

end Behavioral;
