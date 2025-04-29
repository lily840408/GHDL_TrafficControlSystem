-- ****************************************************
--   Traffic control system at a single intersection
-- ****************************************************
LIBRARY ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;
use std.textio.all;		-- standard textio package
 
 
ENTITY traffic_control_system_tb IS
END traffic_control_system_tb;
 
ARCHITECTURE behavior OF traffic_control_system_tb IS 
 
    constant FrequencyHz : integer := 10; -- 10 Hz
    constant clk_period  : time    := 1000 ms / FrequencyHz;

    COMPONENT traffic_control_system
		PORT( clk,clk_car,clr  : in  std_logic;
			  RED_NS,GREEN_NS,YELLOW_NS : out  STD_LOGIC;
			  RED_WE,GREEN_WE,YELLOW_WE : out  STD_LOGIC );
    END COMPONENT;

    --Inputs
    signal clk : std_logic := '0';
	signal clk_car : std_logic := '0';
	signal clr : std_logic := '0';

    --Outputs
    signal RED_NS,GREEN_NS,YELLOW_NS : std_logic;
	signal RED_WE,GREEN_WE,YELLOW_WE : std_logic;

BEGIN
 	
    uut : entity work.traffic_control_system
        generic map(FrequencyHz => FrequencyHz) 
        PORT MAP (clk => clk, clk_car => clk_car,
				  clr => clr,
                  RED_NS => RED_NS, GREEN_NS => GREEN_NS, YELLOW_NS => YELLOW_NS,
				  RED_WE => RED_WE, GREEN_WE => GREEN_WE, YELLOW_WE => YELLOW_WE);
				  
-- --------------------------------------------------
    -- Clock process definitions
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
	
	clk_car_process :process
    begin
        clk_car <= '0';
        wait for 0.2*1000 ms;
        clk_car <= '1';
        wait for 0.2*1000 ms;
    end process;	
	
	clr_process :process
    begin
        clr <= '0';
        wait for 0.2*1000 ms;
        clr <= '1';
        wait for 0.2*1000 ms;
		clr <= '0';
        wait for 2*1000 ms;
    end process;

END;