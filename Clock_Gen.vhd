library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL; -- adds std_logic_vector arthimitic

entity Clock_Gen is
  Port ( 
    clk         : in std_logic;
    Enable      : in std_logic := '0';
    Input       : in std_logic_vector(7 downto 0); 
    reset       : in std_logic := '0';
 
  
  
    ClockOut : out std_logic -- output clock
  );
  
end Clock_Gen;

architecture Behavioral of Clock_Gen is

constant StepNum          : integer := 131;

--signal Internal_vect       : std_logic_vector(8 downto 0) := x"000"; 
signal Clk_out_cnt         : integer  range 0 to 55000 := 0;
signal Clk_out_Max         : integer; -- half the clock cycle 
signal Clk_out             : std_logic := '0';

signal Var_Clk            : integer;


begin
    process(clk, Input, Enable, reset)
    begin
        --Internal_vect(7 downto 0) <= Input;
        Var_Clk <= to_integer(unsigned(Input)); -- takes the input standard logic and converts to intger 
        Clk_out_Max <= Var_Clk*StepNum + 16666;
    
        if reset = '1' then
           Clk_out    <= '0';
           Clk_out_cnt <= 0;
        elsif(Enable = '1') then
            if rising_edge(clk) then
                if Clk_out_cnt >= Clk_out_Max or Clk_out_cnt = 50000 then
                    Clk_out <= not Clk_out;
                    Clk_out_cnt <= 0;
                else
                    Clk_out_cnt <= Clk_out_cnt + 1;
                end if;
            end if;
        end if;
        
        ClockOut <= Clk_out;
    end process;
end Behavioral;
