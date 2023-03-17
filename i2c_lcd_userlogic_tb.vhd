----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2023 10:12:48 AM
-- Design Name: 
-- Module Name: i2c_lcd_userlogic_tb - Behavioral
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

entity i2c_lcd_userlogic_tb is
--  Port ( );
end i2c_lcd_userlogic_tb;

architecture Behavioral of i2c_lcd_userlogic_tb is
component i2c_lcd_userlogic is
    GENERIC(
        input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
        bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
    Port ( 
        clk, clk_gen_en, reset : in STD_LOGIC;
        pwm_sig         : in std_logic_vector(1 downto 0);
        sda, scl        : inout std_logic
    );
end component;

signal clk, clk_gen_en, reset: std_logic := '0';
signal pwm_sig : std_logic_vector(1 downto 0) := "00";
signal sda, scl : std_logic;

begin
    clk <= not clk after 20 ns;
inst_lcd_userlogic: i2c_lcd_userlogic
    generic map(
        input_clk => 50_000_000,
        bus_clk => 50_000
    )
    port map (
        clk => clk,
        clk_gen_en => clk_gen_en,
        reset => reset,
        pwm_sig => pwm_sig,
        sda => sda,
        scl => scl
    );

process
begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 400 ms;
    clk_gen_en <= '1';
    wait;
end process;

end Behavioral;
