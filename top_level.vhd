library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_level is
		--generic(N: integer := 4);
	port( 	
			clk     		: in std_LOGIC;  --20ns 50MHz
			key2			: in std_logic;
			key1			: in std_logic;
			key0			: in std_logic;
			PWMo			: out std_LOGIC;
			CLKo			: out std_LOGIC;
			SCL0			: inout std_logic;
			SDA0			: inout std_logic;
			SCL1			: inout std_logic;
			SDA1			: inout std_logic
		);
end top_level;

architecture Structural of top_level is 

component Reset_Delay IS
	    generic(MAX: integer 	:= 15);	
		 PORT (
			  iCLK 					: IN std_logic;	
			  oRESET 				: OUT std_logic
				);	
end component;

component btn_debounce_toggle is
	GENERIC (
	CONSTANT CNTR_MAX : std_logic_vector(15 downto 0) := X"FFFF");  
    Port ( 
		   BTN_I 	: in  STD_LOGIC;
           CLK 		: in  STD_LOGIC;
           BTN_O 	: out  STD_LOGIC;
           TOGGLE_O : out  STD_LOGIC;
		   PULSE_O  : out STD_LOGIC);
end component;

component PWM_Manager is
	port(
		clk : in std_logic;
		count : in std_logic_vector(7 downto 0);
		PWM_out : out std_logic
	);
end component;
	
component i2c_ADC_Userlogic is
    GENERIC(
    input_clk : INTEGER := 50_000_000; --input clock speed from user logic in Hz
    bus_clk   : INTEGER := 400_000);   --speed the i2c bus (scl) will run at in Hz
    Port ( 
        clk, reset : in STD_LOGIC;
        pwm_sig    : in std_logic_vector(1 downto 0);
        adc_data   : out std_logic_vector(7 downto 0);
        sda, scl   : inout std_logic
    );
end component; 

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

component Clock_Gen is
  Port ( 
    clk         : in std_logic;
    Enable      : in std_logic := '0';
    Input       : in std_logic_vector(7 downto 0); 
    reset       : in std_logic := '0';
    ClockOut 	: out std_logic -- output clock
  );
end component;

TYPE STATE_TYPE is (init, AIN0, AIN0_clk, AIN1, AIN1_clk, AIN2, AIN2_clk, AIN3, AIN3_clk);
signal state : STATE_TYPE:= init;	

signal key1_db : std_logic;
signal key2_db : std_logic;
signal kp : std_logic;
	
signal reset_db         : std_LOGIC;
signal reset_power_on   : std_LOGIC;
signal reset_sig		: std_logic;   --output of OR gate

signal clk_gen_e	: std_logic;

signal pwm_state : std_logic_vector(1 downto 0);

signal adc_d : std_logic_vector(7 downto 0);

begin	
	
Inst_key2_db: btn_debounce_toggle
GENERIC map(
CNTR_MAX => X"FFFF")  
	Port map ( 
	BTN_I 	 => key2,
    CLK 	 => clk,
    BTN_O 	 => open,
    TOGGLE_O => open,
	PULSE_O  => key2_db
	);
	
Inst_key1_db: btn_debounce_toggle
GENERIC map(
CNTR_MAX => X"FFFF")  
    Port map ( 
	BTN_I 	 => key1,
    CLK 	 => clk,
    BTN_O 	 => open,
    TOGGLE_O => open,
	PULSE_O  => key1_db
	);
			
Inst_key0_db: btn_debounce_toggle
GENERIC map(
CNTR_MAX => X"FFFF")  
	Port map ( 
	BTN_I 	 => key0,
    CLK 	 => clk,
    BTN_O 	 => reset_db,
    TOGGLE_O => open,
	PULSE_O  => open
	);

Inst_clk_Reset_Delay: Reset_Delay	
generic map(
MAX 	=> 15) 
	port map(
	iCLK 		=> clk,	
	oRESET    	=> reset_power_on		
	);		
	
Inst_ADC_I2C: i2c_ADC_Userlogic
generic map(input_clk => 50_000_000, --input clock speed from user logic in Hz
			bus_clk   => 10_000)   --speed the i2c bus (scl) will run at in Hz
	port map(
	clk			=> clk,
	reset 		=> reset_sig,
    pwm_sig     => pwm_state,
	adc_data    => adc_d,
    sda			=> SDA1,
	scl        	=> SCL1
	);

Inst_lcd_i2c: i2c_lcd_userlogic
generic map(input_clk => 50_000_000, --input clock speed from user logic in Hz
			bus_clk   => 50_000)   --speed the i2c bus (scl) will run at in Hz
	port map(
	clk			=> clk,
	clk_gen_en  => clk_gen_e,	
	reset 		=> reset_sig,
    pwm_sig     => pwm_state,
    sda 		=> SDA0,
	scl        	=> SCL0		
	);
	
Inst_clock: Clock_Gen
	port map(
    clk         => clk,
    Enable      => clk_gen_e,
    Input       => adc_d,
    reset       => reset_sig,
    ClockOut 	=> CLKo
	);

Inst_pwm: PWM_Manager
	port map(
	clk 	=> clk,
	count 	=> adc_d,
	PWM_out => PWMo	
	);
	
	kp <= key1_db or key2_db;
	reset_sig <= reset_power_on or (not reset_db);
	
	process(clk)
	begin
	if(clk'event and clk = '1') then
	
		if reset_sig = '1' then
		clk_gen_e <= '0';
		state <= init;
		end if;
	
		case state is
		
			when init =>
			
			clk_gen_e <= '0';
			state <= AIN0;
			pwm_state <= "00";
			
	--------------------------------------------------		
			
			when AIN0 =>
			
			pwm_state <= "00";
			
			if(kp = '1') then
			
				if(key1_db = '1') then
			
					state <= AIN1;
			
					elsif(key2_db = '1') then
					
					clk_gen_e <= '1';
					state <= AIN0_clk;
			
					else
			
					state <= AIN0;
			
				end if;
				
			end if;
			
			when AIN0_clk =>
			
			if(kp = '1') then
			
				if(key1_db = '1') then
			
					state <= AIN1_clk;
			
					elsif(key2_db = '1') then
					
					clk_gen_e <= '0';
					state <= AIN0;
			
					else
			
					state <= AIN0_clk;
			
				end if;
					
			end if;					
	
	--------------------------------------------------
			
			when AIN1 =>
			
			pwm_state <= "01";
			
			if(kp = '1') then
			
				if(key1_db = '1') then
			
					state <= AIN2;
			
					elsif(key2_db = '1') then
					
					clk_gen_e <= '1';
					state <= AIN1_clk;
			
					else
			
					state <= AIN1;
			
				end if;
				
			end if;
			
			when AIN1_clk =>
			
			if(kp = '1') then
			
				if(key1_db = '1') then
			
					state <= AIN2_clk;
			
					elsif(key2_db = '1') then
					
					clk_gen_e <= '0';
					state <= AIN1;
			
					else
			
					state <= AIN1_clk;
			
				end if;
					
			end if;					
	
	--------------------------------------------------
			
			when AIN2 =>
			
			pwm_state <= "10";
			
			if(kp = '1') then
			
				if(key1_db = '1') then
			
					state <= AIN3;
			
					elsif(key2_db = '1') then
					
					clk_gen_e <= '1';
					state <= AIN2_clk;
			
					else
			
					state <= AIN2;
			
				end if;
				
			end if;
			
			when AIN2_clk =>
			
			if(kp = '1') then
			
				if(key1_db = '1') then
			
					state <= AIN3_clk;
			
					elsif(key2_db = '1') then
					
					clk_gen_e <= '0';
					state <= AIN2;
			
					else
			
					state <= AIN2_clk;
			
				end if;
					
			end if;					
	
	--------------------------------------------------
	
			when AIN3 =>
			
			pwm_state <= "11";
			
			if(kp = '1') then
			
				if(key1_db = '1') then
			
				state <= AIN0;
			
				elsif(key2_db = '1') then
				
				clk_gen_e <= '1';
				state <= AIN3_clk;
			
				else
			
				state <= AIN3;
			
				end if;
				
			end if;
			
			when AIN3_clk =>
			
			if(kp = '1') then
			
				if(key1_db = '1') then
			
					state <= AIN0_clk;
			
					elsif(key2_db = '1') then
					
					clk_gen_e <= '0';
					state <= AIN3;
			
					else
			
					state <= AIN3_clk;
			
				end if;
					
			end if;					
	
	--------------------------------------------------
	
		end case;
	end if;
	end process;
end Structural;