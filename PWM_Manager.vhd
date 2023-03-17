LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM_Manager is
	port(
	clk : in std_logic;
	count : in std_logic_vector(7 downto 0);
	PWM_out : out std_logic
	
	);
end PWM_Manager;

architecture arch of PWM_Manager is
	
signal num : std_logic_vector(7 downto 0) := "00000000";
	
begin

process(clk)
 begin	
	if rising_edge(clk) then 
		if num < count(7 downto 0) then
			PWM_out <= '1';
		else
			PWM_out <= '0';
		end if;
		
		num <= num + "00000001";
		
		if num = "11111111" then
			num <= "00000000";
		end if;
		
	end if;
end process;
end arch;
	
	
		
	