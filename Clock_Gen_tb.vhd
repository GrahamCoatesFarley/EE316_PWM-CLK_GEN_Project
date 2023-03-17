----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2023 01:21:57 PM
-- Design Name: 
-- Module Name: Clock_Gen_tb - Behavioral
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

entity Clock_Gen_tb is
--  Port ( );
end Clock_Gen_tb;

architecture Behavioral of Clock_Gen_tb is

component Clock_Gen is
		port(
		    clk         : in std_logic;
            Enable      : in std_logic := '0';
            Input       : in std_logic_vector(7 downto 0); 
            reset       : in std_logic := '0';
 
            ClockOut : out std_logic -- output clock
		);
	end component;
	
	-- Testbench Signals
	signal clk					: std_logic := '0';
	signal Enable               : std_logic := '0';
	signal Input                : std_logic_vector(7 downto 0); 
	signal reset				: std_logic := '0';
	signal ClockOut             : std_logic := '0';

begin

	DUT : Clock_Gen
		port map(
		    clk       => clk,
            Enable    => Enable,
            Input     => Input,
            reset     => reset,
 
            ClockOut  => ClockOut -- output clock
		);
		
	clk <= not clk after 10 ns;
		
	process
	begin
    Enable  <= '1';
    Input   <= x"00";
    reset   <= '0';
    wait for 3 ms;
   
   
    Enable  <= '1';
    Input   <= x"FF";
    reset   <= '0';
    wait for 3 ms;
    
     Enable  <= '1';
    Input   <= x"6D";
    reset   <= '0';
    wait for 3 ms;
    
    Enable  <= '0';
    Input   <= x"FF";
    reset   <= '0';
    wait for 1 ms;
    
    Enable  <= '0';
    Input   <= x"FF";
    reset   <= '1';
    wait for 1 ms;
    
		wait;
	end process;
	
end Behavioral;
