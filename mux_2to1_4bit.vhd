library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2to1_4bit is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (3 downto 0);
           B   : in  STD_LOGIC_VECTOR (3 downto 0);
           X   : out STD_LOGIC_VECTOR (3 downto 0));
end mux_2to1_4bit;

architecture Behavioral of mux_2to1_4bit is
begin
    X <= A when (SEL = '0') else B;
end Behavioral;