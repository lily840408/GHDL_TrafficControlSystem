library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
use ieee.numeric_std.all;

entity traffic_control_system is
    generic(FrequencyHz : integer := 10);
    Port ( clk,clk_car,clr  : in  std_logic;
		   RED_NS,GREEN_NS,YELLOW_NS : out  STD_LOGIC;
		   RED_WE,GREEN_WE,YELLOW_WE : out  STD_LOGIC );
end traffic_control_system;

architecture Behavioral of traffic_control_system is

	COMPONENT car_num9
		PORT( clk,clr: in STD_LOGIC;
				    m: out STD_LOGIC_VECTOR(3 downto 0) );
    END COMPONENT;
	
	COMPONENT car_num4
		PORT( clk,clr: in STD_LOGIC;
				    m: out STD_LOGIC_VECTOR(1 downto 0) );
    END COMPONENT;

    signal tick:    integer range 0 to FrequencyHz - 1 := 0;
	signal red_NS_sec : integer := 6;
	signal green_NS_sec : integer := 2;
	signal yellow_NS_sec : integer := 1;
			
	signal	red_WE_sec : integer := 3;
	signal	green_WE_sec : integer := 4;
	signal	yellow_WE_sec : integer := 2;
	
    signal counter,counter2,nn: integer := 0;  
	signal gg_NS,gg_WE:	std_logic;

	signal m_WE: STD_LOGIC_VECTOR(3 downto 0);
	signal m_NS: STD_LOGIC_VECTOR(1 downto 0);
	signal num_NS, num_WE: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	
begin

	uut_0 : entity work.car_num9
		PORT MAP (clk => clk_car,
				  clr => clr,
				  m => m_WE);
				  
	uut_1 : entity work.car_num4
		PORT MAP (clk => clk_car,
				  clr => clr,
				  m => m_NS);
	-- 1 sec counter -------------------------------			  	  
    counter_0: process(clk, tick, counter,counter2)
    begin
        if falling_edge(clk) then
			if tick = FrequencyHz - 1 then
                tick <= 0;
				if counter = (red_NS_sec + green_NS_sec + yellow_NS_sec - 1) then  
                    counter <= 0;
					if counter2 = 2 then
						counter2 <= 0;
					else
						counter2 <= counter2 + 1;
					end if;
                else
                    counter <= counter + 1;
                end if;			
			else
                tick <= tick + 1;
            end if;
        end if;
    end process;

	-- North-South -------------------------------
	RGB_NS: process(counter)
    begin
		if counter < yellow_NS_sec then
			RED_NS <= '0';
			gg_NS <= '0';
			YELLOW_NS <= '1';
		elsif  ((counter >= yellow_NS_sec) and (counter < yellow_NS_sec + red_NS_sec)) then
			RED_NS <= '1';
			gg_NS <= '0';
			YELLOW_NS <= '0';
		elsif (counter >= yellow_NS_sec + red_NS_sec) then
			RED_NS <= '0';
			gg_NS <= '1';
			YELLOW_NS <= '0';
		end if;
	end process;

    car_NS: process(clk_car,clr)
	begin
		if clr='1' then 
		elsif (clk_car'event and clk_car='1') then
				num_NS <= num_NS + m_NS;
			if gg_NS = '1' then
				if num_NS < "00000110" then
					num_NS <= "00000000";
				else
					num_NS <= num_NS - "00000101";
				end if;
			end if;
		end if;
	end process;
	GREEN_NS <= gg_NS;
	
	-- East-West -------------------------------
	RGB_WE: process(counter)
    begin
		if counter < 1 then
			RED_WE <= '1';
			gg_WE <= '0';
			YELLOW_WE <= '0';
		elsif counter < green_WE_sec + 1 then
			RED_WE <= '0';
			gg_WE <= '1';
			YELLOW_WE <= '0';
		elsif  ((counter >= green_WE_sec + 1) and (counter < yellow_WE_sec + green_WE_sec + 1 )) then
			RED_WE <= '0';
			gg_WE <= '0';
			YELLOW_WE <= '1';
		elsif (counter >= yellow_WE_sec + green_WE_sec + 1) then
			RED_WE <= '1';
			gg_WE <= '0';
			YELLOW_WE <= '0';
		end if;
	end process;

    car_WE: process(clk_car,clr)
	begin
		if clr='1' then 
		elsif (clk_car'event and clk_car='1') then
				num_WE <= num_WE + m_WE;
			if gg_WE = '1' then
				if num_WE < "00000110" then
					num_WE <= "00000000";
				else
					num_WE <= num_WE - "00000101";
				end if;
			end if;
		end if;
	end process;
	GREEN_WE <= gg_WE;
	
	-- monitor -------------------------------
    mon_0: process(clk_car,clr)
	begin
		if counter2 = 2 then
			if num_WE < num_NS then
				red_NS_sec <= 3;
				green_NS_sec <= 4;
				yellow_NS_sec <= 2;
			
				red_WE_sec <= 6;
				green_WE_sec <= 2;
				yellow_WE_sec <= 1;
			else
				red_NS_sec <= 6;
				green_NS_sec <= 2;
				yellow_NS_sec <= 1;
			
				red_WE_sec <= 3;
				green_WE_sec <= 4;
				yellow_WE_sec <= 2;
			end if;
			
		end if;
	end process;	
end Behavioral;