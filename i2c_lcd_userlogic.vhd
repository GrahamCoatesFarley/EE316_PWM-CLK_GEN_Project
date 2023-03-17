library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity i2c_lcd_userlogic is
    GENERIC(
        input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
        bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
    Port ( 
        clk, clk_gen_en, reset : in STD_LOGIC;
        pwm_sig         : in std_logic_vector(1 downto 0);
        sda, scl        : inout std_logic
    );
end i2c_lcd_userlogic;

architecture Behavioral of i2c_lcd_userlogic is

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
signal reset_n, ena, rw, busy : std_logic;
signal addr_master : std_logic_vector(6 downto 0) := "0100111";
signal data_wr_sig : std_logic_vector(7 downto 0);
signal pwm_byte : std_logic_vector(7 downto 0); -- Final byte to display AIN#
signal byteSel : integer range 0 to 500 := 0;
signal counter_delay : integer range 0 to 250000 := 0;
signal clear_display : std_logic := '0';
signal clk_gen_en_reg : std_logic;

attribute mark_debug : string;
attribute mark_debug of byteSel: signal is "true";

begin
    reset_n <= not reset;
    
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
            data_rd   => open,
            ack_error => open,
            sda       => sda,                 
            scl       => scl
		); 
		
    process(byteSel)
     begin
        case pwm_sig is
            when "00" => pwm_byte <= X"30"; -- ASCII = 0
            when "01" => pwm_byte <= X"31"; -- ASCII = 1
            when "10" => pwm_byte <= X"32"; -- ASCII = 2
            when "11" => pwm_byte <= X"33"; -- ASCII = 3
            when others => null;
        end case;
    end process;
    
    process(byteSel)
    begin
        case byteSel is
           when 0   => data_wr_sig <= X"28"; -- extra nibble
           when 1   => data_wr_sig <= X"2C";
           when 2   => data_wr_sig <= X"28";
           when 3   => data_wr_sig <= X"28"; -- 0x28 2 lines and 5x7 matrix command
           when 4   => data_wr_sig <= X"2C";
           when 5   => data_wr_sig <= X"28";
           when 6   => data_wr_sig <= X"88";
           when 7   => data_wr_sig <= X"8C";
           when 8   => data_wr_sig <= X"88";
           when 9   => data_wr_sig <= X"28"; -- 0x28
           when 10  => data_wr_sig <= X"2C";
           when 11  => data_wr_sig <= X"28";
           when 12  => data_wr_sig <= X"88";
           when 13  => data_wr_sig <= X"8C";
           when 14  => data_wr_sig <= X"88";
           when 15  => data_wr_sig <= X"28"; -- 0x28
           when 16  => data_wr_sig <= X"2C";
           when 17  => data_wr_sig <= X"28";
           when 18  => data_wr_sig <= X"88";
           when 19  => data_wr_sig <= X"8C";
           when 20  => data_wr_sig <= X"88";
           when 21  => data_wr_sig <= X"08"; -- 0x06 Increment cursor command
           when 22  => data_wr_sig <= X"0C";
           when 23  => data_wr_sig <= X"08";
           when 24  => data_wr_sig <= X"68";
           when 25  => data_wr_sig <= X"6C";
           when 26  => data_wr_sig <= X"68";
           when 27  => data_wr_sig <= X"08"; -- 0x0C Display on, cursor off command 
           when 28  => data_wr_sig <= X"0C";
           when 29  => data_wr_sig <= X"08";
           when 30  => data_wr_sig <= X"C8";
           when 31  => data_wr_sig <= X"CC";
           when 32  => data_wr_sig <= X"C8";
           when 33  => data_wr_sig <= X"08"; -- 0x01 Clear display screen command
           when 34  => data_wr_sig <= X"0C";
           when 35  => data_wr_sig <= X"08";
           when 36  => data_wr_sig <= X"18";
           when 37  => data_wr_sig <= X"1C";
           when 38  => data_wr_sig <= X"18";
           when 39  => data_wr_sig <= X"88"; -- 0x80 1st line command
           when 40  => data_wr_sig <= X"8C";
           when 41  => data_wr_sig <= X"88";
           when 42  => data_wr_sig <= X"08";
           when 43  => data_wr_sig <= X"0C";
           when 44  => data_wr_sig <= X"08";
           when 45  => data_wr_sig <= X"49"; -- 0x41 'A' ASCII Data
           when 46  => data_wr_sig <= X"4D";
           when 47  => data_wr_sig <= X"49";
           when 48  => data_wr_sig <= X"19";
           when 49  => data_wr_sig <= X"1D";
           when 50  => data_wr_sig <= X"19";
           when 51  => data_wr_sig <= X"49"; -- 0x49 'I' ASCII Data
           when 52  => data_wr_sig <= X"4D";
           when 53  => data_wr_sig <= X"49";
           when 54  => data_wr_sig <= X"99";
           when 55  => data_wr_sig <= X"9D";
           when 56  => data_wr_sig <= X"99";
           when 57  => data_wr_sig <= X"49"; -- 0x4E 'N' ASCII Data
           when 58  => data_wr_sig <= X"4D";
           when 59  => data_wr_sig <= X"49";
           when 60  => data_wr_sig <= X"E9";
           when 61  => data_wr_sig <= X"ED";
           when 62  => data_wr_sig <= X"E9";
           when 63  => data_wr_sig <= pwm_byte(7 downto 4)&X"9"; -- Source # ASCII Data
           when 64  => data_wr_sig <= pwm_byte(7 downto 4)&X"D";
           when 65  => data_wr_sig <= pwm_byte(7 downto 4)&X"9";
           when 66  => data_wr_sig <= pwm_byte(3 downto 0)&X"9";
           when 67  => data_wr_sig <= pwm_byte(3 downto 0)&X"D";
           when 68  => data_wr_sig <= pwm_byte(3 downto 0)&X"9";
           when 69  => data_wr_sig <= X"C8"; -- 0xC0 2nd line command
           when 70  => data_wr_sig <= X"CC";
           when 71  => data_wr_sig <= X"C8";
           when 72  => data_wr_sig <= X"08";
           when 73  => data_wr_sig <= X"0C";
           when 74  => data_wr_sig <= X"08";
           when 75  => data_wr_sig <= X"49"; -- 0x43 'C' ASCII Data
           when 76  => data_wr_sig <= X"4D";
           when 77  => data_wr_sig <= X"49";
           when 78  => data_wr_sig <= X"39";
           when 79  => data_wr_sig <= X"3D";
           when 80  => data_wr_sig <= X"39";
           when 81  => data_wr_sig <= X"69"; -- 0x6C 'l' ASCII Data
           when 82  => data_wr_sig <= X"6D";
           when 83  => data_wr_sig <= X"69";
           when 84  => data_wr_sig <= X"C9";
           when 85  => data_wr_sig <= X"CD";
           when 86  => data_wr_sig <= X"C9";
           when 87  => data_wr_sig <= X"69"; -- 0x6C 'o' ASCII Data
           when 88  => data_wr_sig <= X"6D";
           when 89  => data_wr_sig <= X"69";
           when 90  => data_wr_sig <= X"F9";
           when 91  => data_wr_sig <= X"FD";
           when 92  => data_wr_sig <= X"F9";
           when 93  => data_wr_sig <= X"69"; -- 0x63 'c' ASCII Data
           when 94  => data_wr_sig <= X"6D";
           when 95  => data_wr_sig <= X"69";
           when 96  => data_wr_sig <= X"39";
           when 97  => data_wr_sig <= X"3D";
           when 98  => data_wr_sig <= X"39";
           when 99  => data_wr_sig <= X"69"; -- 0x6B 'k' ASCII Data
           when 100 => data_wr_sig <= X"6D";
           when 101 => data_wr_sig <= X"69";
           when 102 => data_wr_sig <= X"B9";
           when 103 => data_wr_sig <= X"BD";
           when 104 => data_wr_sig <= X"B9";
           when 105 => data_wr_sig <= X"29"; -- 0x20 ' ' ASCII Data
           when 106 => data_wr_sig <= X"2D";
           when 107 => data_wr_sig <= X"29";
           when 108 => data_wr_sig <= X"09";
           when 109 => data_wr_sig <= X"0D";
           when 110 => data_wr_sig <= X"09";
           when 111 => data_wr_sig <= X"49"; -- 0x4F 'O' ASCII Data
           when 112 => data_wr_sig <= X"4D";
           when 113 => data_wr_sig <= X"49";
           when 114 => data_wr_sig <= X"F9";
           when 115 => data_wr_sig <= X"FD";
           when 116 => data_wr_sig <= X"F9";
           when 117 => data_wr_sig <= X"79"; -- 0x75 'u' ASCII Data
           when 118 => data_wr_sig <= X"7D";
           when 119 => data_wr_sig <= X"79";
           when 120 => data_wr_sig <= X"59";
           when 121 => data_wr_sig <= X"5D";
           when 122 => data_wr_sig <= X"59";
           when 123 => data_wr_sig <= X"79"; -- 0x74 't' ASCII Data
           when 124 => data_wr_sig <= X"7D";
           when 125 => data_wr_sig <= X"79";
           when 126 => data_wr_sig <= X"49";
           when 127 => data_wr_sig <= X"4D";
           when 128 => data_wr_sig <= X"49";
           when 129 => data_wr_sig <= X"79"; -- 0x70 'p' ASCII Data
           when 130 => data_wr_sig <= X"7D";
           when 131 => data_wr_sig <= X"79";
           when 132 => data_wr_sig <= X"09";
           when 133 => data_wr_sig <= X"0D";
           when 134 => data_wr_sig <= X"09";
           when 135 => data_wr_sig <= X"79"; -- 0x75 'u' ASCII Data
           when 136 => data_wr_sig <= X"7D";
           when 137 => data_wr_sig <= X"79";
           when 138 => data_wr_sig <= X"59";
           when 139 => data_wr_sig <= X"5D";
           when 140 => data_wr_sig <= X"59";
           when 141 => data_wr_sig <= X"79"; -- 0x74 't' ASCII Data
           when 142 => data_wr_sig <= X"7D";
           when 143 => data_wr_sig <= X"79";
           when 144 => data_wr_sig <= X"49";
           when 145 => data_wr_sig <= X"4D";
           when 146 => data_wr_sig <= X"49";
           when others => data_wr_sig <= X"00";
       end case; 
    end process;
		
    process(clk)
    begin
    if(clk'event and clk = '1') then
        if clk_gen_en_reg /= clk_gen_en then
            clear_display <= '1';
        end if;
        
        case state is 
            when start =>
	            if reset = '1' then	
	                counter_delay <= 0;
		            byteSel <= 0;	
		            ena 	<= '0'; 
                    state   <= start; 
	            else
                    ena <= '1';  -- enable for communication with master
                    rw <= '0';   -- write
                    --data_wr <= data_wr_sig;   --data to be written 
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
                if counter_delay = 250000 then
                    if byteSel < 68 or ((byteSel < 146) and (clk_gen_en = '1'))then
                        byteSel <= byteSel + 1;
                    elsif clear_display = '1' then
                        byteSel <= 33;
                        clear_display <= '0';
                    else
                        byteSel <= 39;        
                    end if; 		  
                    counter_delay <= 0;
                    state <= start; 
                else
                    counter_delay <= counter_delay + 1;
                    state <= repeat;
   	            end if;
            when others => null;
        end case;
        
        clk_gen_en_reg <= clk_gen_en;
    end if;  
    end process;

end Behavioral;