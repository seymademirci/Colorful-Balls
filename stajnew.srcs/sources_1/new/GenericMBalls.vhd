----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.08.2019 17:08:05
-- Design Name: 
-- Module Name: GenericMBalls - Behavioral
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

entity GenericMBalls is
    generic(Hposition    : in integer;  -- it can be -240, 0, 240
            Vposition    : in integer);
    Port (CLK        : in std_logic; 
          HPOS       : in integer;
          VPOS       : in integer;
          FlowBall   : in integer;
          reset      : in std_logic;
          DrawBall   : out std_logic
           );
end GenericMBalls;

architecture Behavioral of GenericMBalls is
constant horizon_disp : integer := 1440;
constant hfp : integer := 80;
constant hsp : integer := 152;
constant hbp : integer := 232;

constant vertical_disp : integer := 900;
constant vfp : integer := 1;
constant vsp : integer := 3;
constant vbp : integer := 28;

constant hball : integer := hsp + hbp + horizon_disp/2 -70;
constant vball : integer := vsp + vbp;
constant ballswidth : integer := 140;

signal s_DrawBall : std_logic := '0';
signal s_addrb : STD_LOGIC_VECTOR(7 downto 0);
signal s_doutb : STD_LOGIC_VECTOR (139 downto 0);
signal g_Hoffset : integer;
signal g_Voffset : integer;

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

    blk_mem_gen_0_ii: blk_mem_gen_0
    PORT MAP (clka => CLK, 
    addra => s_addrb,
    douta => s_doutb);

Balls : process(CLK, reset)
begin
    if (reset = '1') then
        s_drawBall <= '0';
    elsif rising_edge(CLK) then
        g_Hoffset <= HPOS - hball - Hposition;
        g_Voffset <= VPOS - vball + Vposition - FlowBall;
        if (g_Hoffset < ballswidth and g_Hoffset >= 0 and g_Voffset < ballswidth and g_Voffset >= 0 ) then
            s_addrb <= std_logic_vector(to_unsigned(g_Voffset, s_addrb'length));
            s_drawBall <= s_doutb(g_Hoffset);
        else 
            s_drawBall <= '0';
        end if;
    end if;
end process ; -- Balls
DrawBall <= s_DrawBall;


end Behavioral;
