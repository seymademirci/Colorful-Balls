----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.08.2019 16:31:53
-- Design Name: 
-- Module Name: SSD - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port (CLK  : in std_logic;
        SCORE  : in integer;
        anode  : out std_logic_vector ( 3 downto 0 );
        result : out std_logic_vector ( 6 downto 0)
        ); 
   end SSD;
   
   architecture Behavioral of SSD is
   
   signal Segment1 : std_logic_vector ( 3 downto 0):="0000";
   signal Segment2 : std_logic_vector ( 3 downto 0):="0000";
   signal Segment3 : std_logic_vector ( 3 downto 0):="0000";
   signal Segment4 : std_logic_vector ( 3 downto 0):="0000";
   signal count    : std_logic_vector ( 1 downto 0):= "00";
   signal count2   : integer;

   begin
   process ( CLK )
   begin
   
   if rising_edge (CLK) then
   
        Segment1  <= conv_std_logic_vector (SCORE mod 10, 4);
        Segment2  <= conv_std_logic_vector ((SCORE mod 100 - SCORE mod 10)/10, 4);
        Segment3  <= conv_std_logic_vector ((SCORE mod 1000 - SCORE mod 100)/100, 4);
        Segment4  <= conv_std_logic_vector ((SCORE mod 10000 - SCORE mod 1000)/1000, 4);

        if(count2 < 1000)then
            count2 <= count2 + 1;
        else
            count2 <= 0;
        end if;

        if(count2 = 0)then
            count <= count + 1;
        end if;
   
        if(count = "00") then
            anode <= "1110";
            case Segment1 is
                when "0000" => result <= "1000000";
                when "0001" => result <= "1111001";
                when "0010" => result <= "0100100";
                when "0011" => result <= "0110000";
                when "0100" => result <= "0011001";
                when "0101" => result <= "0010010";
                when "0110" => result <= "0000010";
                when "0111" => result <= "1111000";
                when "1000" => result <= "0000000";
                when "1001" => result <= "0010000";
                when others => result <= (others => '0');
            end case;
        elsif(count = "01") then
            anode <= "1101";
            case Segment2 is
                when "0000" => result <= "1000000";
                when "0001" => result <= "1111001";
                when "0010" => result <= "0100100";
                when "0011" => result <= "0110000";
                when "0100" => result <= "0011001";
                when "0101" => result <= "0010010";
                when "0110" => result <= "0000010";
                when "0111" => result <= "1111000";
                when "1000" => result <= "0000000";
                when "1001" => result <= "0010000";
                when others => result <= (others => '0');
            end case;
        elsif(count = "10") then
            anode <= "1011";
            case Segment3 is
                when "0000" => result <= "1000000";
                when "0001" => result <= "1111001";
                when "0010" => result <= "0100100";
                when "0011" => result <= "0110000";
                when "0100" => result <= "0011001";
                when "0101" => result <= "0010010";
                when "0110" => result <= "0000010";
                when "0111" => result <= "1111000";
                when "1000" => result <= "0000000";
                when "1001" => result <= "0010000";
                when others => result <= (others => '0');
            end case;
        
        elsif(count = "11") then
            anode <= "0111";
            case Segment4 is
                when "0000" => result <= "1000000";
                when "0001" => result <= "1111001";
                when "0010" => result <= "0100100";
                when "0011" => result <= "0110000";
                when "0100" => result <= "0011001";
                when "0101" => result <= "0010010";
                when "0110" => result <= "0000010";
                when "0111" => result <= "1111000";
                when "1000" => result <= "0000000";
                when "1001" => result <= "0010000";
                when others => result <= (others => '0');
            end case;
        end if;
    end if;
    end process;
end Behavioral;
