----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.08.2019 09:13:07
-- Design Name: 
-- Module Name: Square - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Square is
  Generic (SquareLoc : in integer;
           SquareVLoc: in integer);
  Port ( CLK        : in std_logic;
         HPOS       : in integer;
         VPOS       : in integer;
         FlowSquare : in integer;
         DrawS      : out std_logic
          );
end Square;

architecture Behavioral of Square is
    

constant horizon_disp : integer := 1440;
constant hfp : integer := 80;
constant hsp : integer := 152;
constant hbp : integer := 232;

constant vertical_disp : integer := 900;
constant vfp : integer := 1;
constant vsp : integer := 3;
constant vbp : integer := 28;

constant SVerU : integer := (vsp + vbp);
constant SVerD : integer := (vsp + vbp + 140);
constant SHorR : integer := (hsp + hbp + horizon_disp/2 +70);
constant SHorL : integer := (hsp + hbp + horizon_disp/2 -70);

signal s_drawS : std_logic := '0';

begin
process(CLK)
begin
    if rising_edge(CLK) then  
        if (hpos < SHorR + SquareLoc and hpos > SHorL + SquareLoc and vpos > SVerU - SquareVLoc + FlowSquare  and vpos < SVerD - SquareVLoc + FlowSquare )  then
            s_drawS <= '1';
        else
            s_drawS <= '0'; 
        end if;
     end if;
end process; 
drawS <= s_drawS;    
end Behavioral;
