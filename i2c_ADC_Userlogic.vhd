----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/16/2023 12:27:01 PM
-- Design Name: 
-- Module Name: i2c_ADC_Userlogic - Behavioral
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

entity i2c_ADC_Userlogic is
    GENERIC(
    input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
    Port ( 
        clk, reset : in STD_LOGIC;
        pwm_sig    : in std_logic_vector(1 downto 0);
        adc_data   : out std_logic_vector(7 downto 0);
        sda, scl   : inout std_logic
    );
end i2c_ADC_Userlogic;

architecture Behavioral of i2c_ADC_Userlogic is
component i2c_master IS
  GENERIC(
    input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
  PORT(
    clk       : IN     STD_LOGIC;                    --system clock
    reset_n   : IN     STD_LOGIC;                    --active low reset
    ena       : IN     STD_LOGIC;                    --latch in command
    addr      : IN     STD_LOGIC_VECTOR(6 DOWNTO 0); --address of target slave
    rw        : IN     STD_LOGIC;                    --'0' is write, '1' is read
    data_wr   : IN     STD_LOGIC_VECTOR(7 DOWNTO 0); --data to write to slave
    busy      : OUT    STD_LOGIC;                    --indicates transaction in progress
    data_rd   : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0); --data read from slave
    ack_error : BUFFER STD_LOGIC;                    --flag if improper acknowledge from slave
    sda       : INOUT  STD_LOGIC;                    --serial data output of i2c bus
    scl       : INOUT  STD_LOGIC);                   --serial clock output of i2c bus
END component;

TYPE state_type IS (start, ready, data_valid, busy_high, repeat);
signal state : state_type := start;
signal reset_n, ena, busy : std_logic;
signal rw : std_logic := '0'; -- Read/write signal sent to i2c_master, start by writing
signal addr_master : std_logic_vector(6 downto 0) := "1001000";
signal data_wr_sig : std_logic_vector(7 downto 0) := X"00"; -- Control byte of the ADC
--signal byteSel : integer range 0 to 500 := 0;
signal data_rd : std_logic_vector(7 downto 0) := X"00"; -- read data register
signal pwm_sig_reg : std_logic_vector(1 downto 0):= "00";

signal scl_sig, sda_sig: std_logic; -- debug signals

attribute mark_debug : string;
attribute mark_debug of rw: signal is "true";
attribute mark_debug of ena: signal is "true";
--attribute mark_debug of scl_sig: signal is "true";
--attribute mark_debug of sda_sig: signal is "true";

begin
    scl_sig <= scl;
    sda_sig <= sda;
    reset_n <= not reset;
    data_wr_sig <= "000000"&pwm_sig; -- Control byte set to read from appropriate input port

Inst_i2c_master: i2c_master
	GENERIC map(input_clk => input_clk,
                bus_clk   => bus_clk)
	port map(
		    clk       => clk,               
            reset_n   => reset_n,              
            ena       => ena,         
            addr      => addr_master,
            rw        => rw,      
            data_wr   => data_wr_sig,
            busy      => busy,           
            data_rd   => data_rd,
            ack_error => open,
            sda       => sda,                 
            scl       => scl
		);
    
--    process(byteSel)
--    begin
--        case byteSel is
--           when 0 => data_wr_sig <= X"20";
--           when others => data_wr_sig <= X"00";
--       end case; 
--    end process;
		
    process(clk)
    begin
    if(clk'event and clk = '1') then
        case state is 
            when start =>
	            if reset = '1' then	
		            ena 	<= '0'; 
		            rw      <= '0'; --default to write
                    state   <= start; 
	            else
                    ena <= '1';  -- enable for communication with master
   	                state   <= ready;  -- ready to write           
                end if;

            when ready =>		
	            if busy = '0' then                      -- state to signal ready for transaction
	      	        ena     <= '1';
	      	        state   <= data_valid;
	            end if;

            when data_valid =>                              --state for conducting this transaction
                if busy = '1' then  
        	        ena     <= '0';
        	        state   <= busy_high;
                end if;

            when busy_high => 
                if busy = '0' then                -- busy just went low 
		            state <= repeat;
   	            end if;		     
            when repeat => 
                if rw = '0' then -- after writing control byte, start read process
                    rw <= '1';  -- read
                else
                    adc_data <= data_rd; -- set acd_data to read data
                    if pwm_sig /= pwm_sig_reg then --if pwm_sig has changed, start write process
                        rw <= '0'; -- write
                    end if;
                end if;
                
   	            state <= start; 
            when others => null;
            end case;   
            
            pwm_sig_reg <= pwm_sig;
    end if;  
    end process;
end Behavioral;