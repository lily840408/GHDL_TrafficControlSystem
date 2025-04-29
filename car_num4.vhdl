library ieee;
use ieee.std_logic_1164.ALL;
use ieee.std_logic_unsigned.ALL;

entity car_num4 is
	port( clk,clr: in STD_LOGIC;
		        m: out STD_LOGIC_VECTOR(1 downto 0));
end car_num4;

architecture Behavioral of car_num4 is
	signal temp: STD_LOGIC_VECTOR(1 downto 0);
begin
	process(clk,clr)
	begin
		if clr='1' then 
			temp <="00";
		elsif (clk'event and clk='1') then
			if temp="00" then temp<="01";
			else
				temp(0)<=temp(0) xor temp(1);
				temp(1)<=temp(0);
			end if;
		end if;
	end process;
	
	m <=temp;
end Behavioral;