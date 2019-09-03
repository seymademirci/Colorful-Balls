----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.08.2019 09:13:35
-- Design Name: 
-- Module Name: Balls - Behavioral
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

entity MainBall is
  Port ( CLK        : in std_logic;
         hpos       : in integer;
         vpos       : in integer;
         MBCont     : in integer;
         reset      : in std_logic;
         drawMain   : out std_logic);
end MainBall;

architecture Behavioral of MainBall is


constant horizon_disp : integer := 1440;
constant hfp : integer := 80;
constant hsp : integer := 152;
constant hbp : integer := 232;

constant vertical_disp : integer := 900;
constant vfp : integer := 1;
constant vsp : integer := 3;
constant vbp : integer := 28;

constant vball      : integer := (vsp + vbp);
constant hball      : integer := (hsp + hbp);
constant vballDown  : integer := (vsp + vbp + vertical_disp/2 + 420);
constant vballUp    : integer := (vsp + vbp + vertical_disp/2 + 280);
constant hballMid   : integer := (hsp + hbp + horizon_disp/2);
constant hballLeft  : integer := (- 70);
constant hballRight : integer := (hsp + hbp + horizon_disp/2 + 70);

constant ballswidth : integer := 140;
signal Hoffset : integer ;
signal Voffset : integer;

signal s_drawMain   : std_logic := '0';
signal s_addra : std_logic_vector(7 downto 0);
signal s_douta : std_logic_vector(139 downto 0);
--------------------------------------------------------------------
component blk_mem_gen_0 is
    Port ( 
        clka  : in STD_LOGIC;
        addra : in STD_LOGIC_VECTOR ( 7 downto 0 );
        douta : out STD_LOGIC_VECTOR ( 139 downto 0 )
      );
end component;
--------------------------------------------------------------------
begin
    blk_mem_gen_0_i: blk_mem_gen_0
    PORT MAP (clka => CLK,
    addra => s_addra,
    douta => s_douta);


process (CLK,reset) -- Main Ball
begin 
    if (reset = '1') then
        s_drawMain <= '0';
        s_addra <= (others => '0');
    elsif rising_edge(CLK) then 
        Hoffset <= HPOS - hballLeft - MBCont;
        Voffset <= VPOS - vballUp;
        if (Hoffset < ballswidth and Hoffset >= 0 and Voffset < ballswidth and Voffset >= 0 ) then
            s_addra <= std_logic_vector(to_unsigned(Voffset, s_addra'length));
            s_drawMain <= s_douta(Hoffset);
        else 
            s_drawMain <= '0';
        end if;
    end if;
end process;

drawMain <= s_drawMain; 
end Behavioral;
