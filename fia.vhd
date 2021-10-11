library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity clocker is
    Port ( clk_10, button1, button2: in std_logic; 
	 SW: in std_logic_vector (9 downto 0);
	 LEDR: OUT std_logic_vector (9 downto 0);
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector (0 to 7):="10011111"
     );
end clocker;

architecture Behavioral of clocker is
component bcd6bit
	Port ( v: in std_logic_vector(5 downto 0); 
           d0, d1: out std_logic_vector(3 downto 0)
     );
end component;

component mux_2to1_4bit
	Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (3 downto 0);
           B   : in  STD_LOGIC_VECTOR (3 downto 0);
           X   : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component seg_7
	port(
		C : in std_logic_vector(0 to 3);
		DISPLAY :out std_logic_vector(0 to 6));
end component;
signal clk_1s: std_logic;
signal counter: std_logic_vector(27 downto 0);
signal microseconds, seconds, minutes, hours, days, month: std_logic_vector(5 downto 0) := "000000";
signal secondsoh, minutesoh, hoursoh, daysoh, monthoh: std_logic_vector(3 downto 0);
signal secondsol, minutesol, hoursol, daysol, monthol: std_logic_vector(3 downto 0);
signal out5, out4, out3: std_logic_vector(3 downto 0);
signal out2, out1, out0: std_logic_vector(3 downto 0);
signal position : integer;
begin
	LEDR <= SW;
	

process(clk_10, BUTTON1)
	begin
		if button2 = '0' then
				seconds <= "000001";
				minutes <= "000001";
				hours <= "000001";
				days <= "000001";
				month <= "000001";
		else
			if(rising_edge(clk_10)) then
				counter <= counter + x"0000001";
				if counter >= x"01E8480" then
					counter <= x"0000000";
					microseconds <= microseconds + "000001";
					if button1 = '0' then
						if SW(1 downto 0) = "00" then
							minutes <= minutes + "000001";
							if(minutes >= "111011") then
								minutes <= "000000";
							end if;
						elsif SW(1 downto 0) = "10" then
							hours <= hours + "000001";
							if(hours >= "010111") then
								hours <= "000000";
							end if;
						elsif SW(1 downto 0) = "01" then
							if((month = "000001") or (month = "000011") or (month = "000101") or (month = "000111") or (month = "001010") or (month = "001100")) then
								days <= days + "000001";
								if (days >= "011111") then
									days <= "000001";
								end if;
							elsif ((month = "000100") or (month = "000110") or (month = "001000") or (month = "001001") or (month = "001011")) then
								days <= days + "000001";
								if (days >= "011110") then
									days <= "000001";
								end if;
							elsif (month = "000010") then
								days <= days + "000001";
								if (days >= "011100") then
									days <= "000001";
								end if;
							end if;
						elsif SW(1 downto 0) = "11" then
							month <= month + "000001";
							if (month >= "001100") then
								month <= "000001";
							end if;
						end if;
					end if;
					if microseconds >= "000101" then
						seconds <= seconds + "000001";
						microseconds <= "000000";
					
					if(seconds >= "111011") then
						minutes <= minutes + "000001";
						seconds <= "000000";
						if(minutes >= "111011") then
							hours <= hours + "000001";
							minutes <= "000000";
							if(hours >= "010111") then
								days <= days + "000001";
								hours <= "000000";
								if((month = "000001") or (month = "000011") or (month = "000101") or (month = "000111") or (month = "001010") or (month = "001100")) then
									if (days = "011111") then
										month <= month + "000001";
										days <= "000001";
									end if;
								elsif ((month = "000100") or (month = "000110") or (month = "001000") or (month = "001001") or (month = "001011")) then
									if (days = "011110") then
										month <= month + "000001";
										days <= "000001";
									end if;
								elsif (month = "000010") then
									if (days = "011100") then
										month <= month + "000001";
										days <= "000001";
									end if;
								elsif (month >= "001100") then
									month <= "000001";
								end if;
							end if;
						end if;
					end if;
				end if;
			end if;
			end if;
			end if;
end process;


	H2: bcd6bit port map (seconds, secondsol, secondsoh);
	H3: bcd6bit port map (minutes, minutesol, minutesoh);
	H4: bcd6bit port map (hours, hoursol, hoursoh);
	H5: bcd6bit port map (days, daysol, daysoh);
	H6: bcd6bit port map (month, monthol, monthoh);
	
	U1: mux_2to1_4bit port map (sw(0), hoursoh, "1111", out5);
	U2: mux_2to1_4bit port map (sw(0), hoursol, monthoh, out4);
	U3: mux_2to1_4bit port map (sw(0), minutesoh, monthol, out3);
	U4: mux_2to1_4bit port map (sw(0), minutesol, "1010", out2);
	U5: mux_2to1_4bit port map (sw(0), secondsoh, daysoh, out1);
	U6: mux_2to1_4bit port map (sw(0), secondsol, daysol, out0);
	
	
	H7: seg_7 port map (out5, HEX5(0 TO 6));
	H8: seg_7 port map (out4, HEX4(0 TO 6));
	H9: seg_7 port map (out3, HEX3(0 TO 6));
	H10: seg_7 port map (out2, HEX2(0 TO 6));
	H11: seg_7 port map (out1, HEX1(0 TO 6));
	H12: seg_7 port map (out0, HEX0(0 TO 6));
	
	--clk_1s <= '0' when counter < x"04C4B40" else '1';
	process(SW(0))
	begin
		if (Sw(0) = '0') then
			HEX5(7) <= '1';
			HEX4(7) <= '0';
			HEX3(7) <= '1';
			HEX2(7) <= '0';
			HEX1(7) <= '1';
			HEX0(7) <= '1';
		else
			HEX5(7) <= '1';
			HEX4(7) <= '1';
			HEX3(7) <= '1';
			HEX2(7) <= '1';
			HEX1(7) <= '1';
			HEX0(7) <= '1';
		end if;
	end process;


end Behavioral;