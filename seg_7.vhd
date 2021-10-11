library ieee;
use ieee.std_logic_1164.all;

entity seg_7 is
port(
		c : in std_logic_vector(0 to 3);
		display :out std_logic_vector(0 to 6)
);
end entity seg_7;

architecture Behavioral of seg_7 is
begin
PROCESS(C)
   BEGIN
     CASE  C is
	    when "0000" => display <= "0000001"; --0
		 when "0001" => display <= "1001111"; --1
		 when "0010" => display <= "0010010"; --2
		 when "0011" => display <= "0000110"; --3
		 when "0100" => display <= "1001100"; --4
		 when "0101" => display <= "0100100"; --5
		 when "0110" => display <= "0100000"; --6
		 when "0111" => display <= "0001111"; --7
		 when "1000" => display <= "0000000"; --8
		 when "1001" => display <= "0000100"; --9
		 when "1010" => display <= "1111110"; -- -
		 when others => display <= "1111111"; 
	 END CASE;
 END PROCESS;
end architecture;