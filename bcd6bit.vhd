library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bcd6bit is
    Port ( v: in std_logic_vector(5 downto 0); 
           d1, d0: out std_logic_vector(3 downto 0)
     );
end bcd6bit;

architecture Behavioral of bcd6bit is
signal dd0: std_logic_vector(5 downto 0);
signal dd1: std_logic_vector(3 downto 0);
begin

		dd1 <= "0110" when v > "111011" else
		"0101" when v > "110001" else
		"0100" when v > "100111" else
		"0011" when v > "011101" else
		"0010" when v > "010011" else
		"0001" when v > "001001" else
		"0000" when v > "000000";
		
		dd0 <= v - "111100" when v > "111011" else
		v - "110010" when v > "110001" else
		v - "101000" when v > "100111" else
		v - "011110" when v > "011101" else
		v - "010100" when v > "010011" else
		v - "001010" when v > "001001" else
		v when v > "000000";

d0 <= dd0(3 downto 0);
d1 <= dd1(3 downto 0);
	


end Behavioral;