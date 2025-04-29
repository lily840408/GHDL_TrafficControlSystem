library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;

entity car_num9 is
	port( clk,clr: in STD_LOGIC;
		        m: out STD_LOGIC_VECTOR(3 downto 0) );
end car_num9;

architecture Behavioral of car_num9 is

	signal temp,temp_end: STD_LOGIC_VECTOR(3 downto 0);
begin
	process(clk,clr)
	begin
		if clr='1' then 
			temp  <="0000";
			temp_end  <="0000";
		elsif (clk'event and clk='1') then
			if temp="0000" then temp<="0001";
			else
				temp(0)<=temp(0) xor temp(3);
				temp(1)<=temp(0);
				temp(2)<=temp(1);
				temp(3)<=temp(2);
			end if;
		end if;
		
		case temp is
			when "1000" =>  temp_end<= "0111";
			when "1001" =>  temp_end<= "0110";
			when "1010" =>  temp_end<= "0001";
			when "1011" =>  temp_end<= "0010";
			
			when "1100" =>  temp_end<= "0011";
			when "1101" =>  temp_end<= "0100";
			
			when "1110" =>  temp_end<= "0101";
			when "1111" =>  temp_end<= "0110";
			when others =>  temp_end<= temp;
		end case;
	end process;
	
	m <=temp_end;
end Behavioral;