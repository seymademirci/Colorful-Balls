----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2019 09:18:08
-- Design Name: 
-- Module Name: GameOver - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GameOver is
    Port (CLK      : in std_logic;
          VPOS     : in integer;
          HPOS     : in integer;
          gameOverr : in std_logic;
          drawGameOver : out std_logic);
end GameOver;

architecture Behavioral of GameOver is

constant horizon_disp : integer := 1440;
constant hfp : integer := 80;
constant hsp : integer := 152;
constant hbp : integer := 232;

constant vertical_disp : integer := 900;
constant vfp : integer := 1;
constant vsp : integer := 3;
constant vbp : integer := 28;

constant ver : integer := vsp + vbp;
constant verr: integer := vsp + vbp + vertical_disp;
constant hor : integer := hsp + hbp;
constant horr: integer := hsp + hbp + horizon_disp;

signal s_drawGameOver : std_logic;

begin
process( CLK )
begin
    if rising_edge(clk) then
        if (gameOverr = '1')then
            if hpos < horr and hpos > hor and vpos < verr and vpos > ver then 
                s_drawGameOver <= '1';
            else
                s_drawGameOver <= '0'; 
            end if;
        end if;    
    end if;
end process;
drawGameOver <= s_drawGameOver;
end Behavioral;
