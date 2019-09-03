----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.08.2019 16:25:24
-- Design Name: 
-- Module Name: SYNC - Behavioral
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

entity SYNC is
  Port ( CLK       : in std_logic;
         DrawSM    : in std_logic;
         DrawSR    : in std_logic;
         DrawSL    : in std_logic;  
         drawMain  : in std_logic; 
        DrawBallRB : in std_logic;
        DrawBallMB : in std_logic;
        DrawBallLB : in std_logic;
        DrawBallRG : in std_logic;
        DrawBallMG : in std_logic;
        DrawBallLG : in std_logic;
        DrawBallRP : in std_logic;
        DrawBallMP : in std_logic;
        DrawBallLP : in std_logic;
        DrawBallRY : in std_logic;
        DrawBallMY : in std_logic;
        DrawBallLY : in std_logic;
        drawGameOver: in std_logic;
         reset     : in std_logic;
         gameOverr : out std_logic;
         SCORE     : out integer;
         HPOS      : out integer;
         VPOS      : out integer;
         VGA_HS    : out std_logic;
         VGA_VS    : out std_logic;
         VGA_R     : out std_logic_vector (3 downto 0);
         VGA_B     : out std_logic_vector (3 downto 0); 
         VGA_G     : out std_logic_vector (3 downto 0));
end SYNC;

architecture Behavioral of SYNC is
    

constant horizon_disp : integer := 1440; 
constant hfp : integer := 80;
constant hsp : integer := 152;
constant hbp : integer := 232;
constant sumOfHor : integer := horizon_disp + hfp + hsp + hbp;

constant vertical_disp : integer := 900;
constant vfp : integer := 1;
constant vsp : integer := 3;
constant vbp : integer := 28;
constant sumOfVer : integer := vertical_disp + vfp + vsp + vbp;

signal s_HPOS : integer range 0 to 1904:= 0;
signal s_VPOS : integer range 0 to 932 := 0;
signal colY: std_logic:= '0';
signal colB: std_logic:= '0';
signal colP: std_logic:= '0';
signal colG: std_logic:= '0';
signal col : std_logic:= '0';
signal s_score : integer := 0;
signal s_gameOver     : std_logic := '0';
signal s_drawGameOver : std_logic := '0';
signal counter : integer := 0;
signal s1_scoredetecB : std_logic;
signal s2_scoredetecB : std_logic;
signal s_pulseB : std_logic;
signal s1_scoredetecG : std_logic;
signal s2_scoredetecG : std_logic;
signal s_pulseG : std_logic;
signal s1_scoredetecP : std_logic;
signal s2_scoredetecP : std_logic;
signal s_pulseP : std_logic;
signal s1_scoredetecY : std_logic;
signal s2_scoredetecY : std_logic;
signal s_pulseY : std_logic;





begin
	VGA : process(CLK, reset) 
    begin 
        if(reset = '1') then
            s_HPOS <= 0;
            s_VPOS <= 0;
		elsif rising_edge (CLK) then
			if (s_HPOS = sumOfHor )then
                s_HPOS <= 0;
                if (s_VPOS = sumOfVer ) then 
                    s_VPOS <= 0;
                else
                    s_VPOS <= s_VPOS + 1 ;
                end if;
            else
            s_HPOS <= s_HPOS + 1;
            end if;
             
            if  s_HPOS >= hsp then 
                VGA_HS <= '1';
            else 
                VGA_HS <= '0';
            end if;
            if  s_VPOS >= vsp then 
                VGA_VS <= '1';
            else 
                VGA_VS <= '0';
            end if;
        end if;
    end process; 
    HPOS <= s_HPOS;
    VPOS <= s_VPOS;
-------------------------------------------------------------------------------------------------------------------------------
-- controling colusions
colusion_controling : process (CLK, reset)
    begin
    if reset = '1' then
        colB <= '0';
        colG <= '0';
        colP <= '0';
        colY <= '0';
        s_drawGameOver <= '0';
        s_gameOver <= '0';
    elsif rising_edge(CLK) then
       if ((drawMain = '1' and DrawSM = '1') or (drawMain = '1' and DrawSR = '1') or (drawMain = '1' and DrawSL = '1')) then
            s_GameOver <= '1';
            colB <= '0';
            colG <= '0';
            colP <= '0';
            colY <= '0';
        end if;
        if ((drawMain = '1' and DrawBallRB = '1') or (drawMain = '1' and DrawBallMB = '1') or (drawMain = '1' and DrawBallLB = '1')) then
            s_GameOver <= '0';
            colB <= '1';
            colG <= '0';
            colP <= '0';
            colY <= '0';
        end if;
        if ((drawMain = '1' and DrawBallRG = '1') or (drawMain = '1' and DrawBallMG = '1') or (drawMain = '1' and DrawBallLG = '1')) then
            s_GameOver <= '0';
            colB <= '0';
            colG <= '1';
            colP <= '0'; 
            colY <= '0';
        end if;
        if ((drawMain = '1' and DrawBallRP = '1') or (drawMain = '1' and DrawBallMP = '1') or (drawMain = '1' and DrawBallLP = '1')) then
            s_GameOver <= '0';
            colB <= '0';
            colG <= '0';
            colP <= '1';
            colY <= '0';
        end if;
        if ((drawMain = '1' and DrawBallRY = '1') or (drawMain = '1' and DrawBallMY = '1') or (drawMain = '1' and DrawBallLY = '1')) then
            s_GameOver <= '0';
            colB <= '0';
            colG <= '0';
            colP <= '0';
            colY <= '1';
        end if; 
    end if; 
    end process;
    gameOverr <= s_gameOver;
  
----------------------------------------------------------------------------------------------------------------------------------------
-- counting score first rising edge of colusions only  
pulseB : process (CLK, reset)
    begin
        if (reset = '1') then
            s1_scoredetecB <= '0';
            s2_scoredetecB <= '0';
            --s_pulse <= '0';
        elsif (rising_edge(CLK)) then
            s1_scoredetecB <= colB;
            s2_scoredetecB <= s1_scoredetecB;
        end if;
    end process;
    s_pulseB <= (not s2_scoredetecB) and s1_scoredetecB;

----------------------------------------------------------------------------------------------------------------------------------------
-- counting score first rising edge of colusions only  
pulseG : process (CLK, reset)
    begin
        if (reset = '1') then
            s1_scoredetecG <= '0';
            s2_scoredetecG <= '0';
            --s_pulse <= '0';
        elsif (rising_edge(CLK)) then
            s1_scoredetecG <= colG;
            s2_scoredetecG <= s1_scoredetecG;
        end if;
    end process;
    s_pulseG <= (not s2_scoredetecG) and s1_scoredetecG;

    ----------------------------------------------------------------------------------------------------------------------------------------
-- counting score first rising edge of colusions only  
pulseP : process (CLK, reset)
begin
    if (reset = '1') then
        s1_scoredetecP <= '0';
        s2_scoredetecP <= '0';
        --s_pulse <= '0';
    elsif (rising_edge(CLK)) then
        s1_scoredetecP <= colP;
        s2_scoredetecP <= s1_scoredetecP;
    end if;
end process;
s_pulseP <= (not s2_scoredetecP) and s1_scoredetecP;
----------------------------------------------------------------------------------------------------------------------------------------
-- counting score first rising edge of colusions only  
pulseY : process (CLK, reset)
    begin
        if (reset = '1') then
            s1_scoredetecY <= '0';
            s2_scoredetecY <= '0';
            --s_pulse <= '0';
        elsif (rising_edge(CLK)) then
            s1_scoredetecY <= colY;
            s2_scoredetecY <= s1_scoredetecY;
        end if;
    end process;
    s_pulseY <= (not s2_scoredetecY) and s1_scoredetecY;
        
 -----------------------------------------------------------------------------------------------------------------------------
-- counting score
    score_counting : process (CLK, reset)
    begin
        if (reset = '1') then
            s_score <= 0;
        elsif (rising_edge(CLK)) then
            if (s_pulseB = '1' or s_pulseG = '1'or s_pulseP = '1' or s_pulseY = '1') then
                s_score <= s_score + 1;
            end if;
        end if;
    end process;  
    SCORE <= s_score;

----------------------------------------------------------------------------------------------------------------------------
-- Defining color of game.
    color_defining : process (CLK) 
    begin
        if rising_edge(CLK) then 
            if (drawGameOver = '1' and s_gameOver = '1') then 
                VGA_R   <= "0000";
                VGA_B   <= "1111";
                VGA_G   <= "0000";
            elsif (drawMain = '1' or DrawSM = '1' or DrawSR = '1' or DrawSL = '1' or DrawBallRB = '1'or DrawBallMB = '1'
            or DrawBallLB = '1' or DrawBallRG = '1' or DrawBallMG = '1' or DrawBallLG = '1' or DrawBallRP = '1' 
            or DrawBallMP = '1' or DrawBallLP = '1' or DrawBallRY = '1' or DrawBallMY = '1' or DrawBallLY = '1' or drawGameOver = '1') then
                if drawMain = '1' and colB = '1' then -- Main Ball's color
                    VGA_R   <= "0000";
                    VGA_B   <= "1111";
                    VGA_G   <= "1111";
                elsif drawMain = '1' and colG = '1' then -- Main Ball's color
                    VGA_R   <= "0000";
                    VGA_B   <= "1000";
                    VGA_G   <= "1111";
                elsif drawMain = '1' and colP = '1' then -- Main Ball's color
                    VGA_R   <= "1111";
                    VGA_B   <= "1111";
                    VGA_G   <= "0000";
                elsif drawMain = '1' and colY = '1' then -- Main Ball's color
                    VGA_R   <= "1111";
                    VGA_B   <= "0000";
                    VGA_G   <= "1111";
                elsif drawMain = '1' then -- Main Ball's color
                    VGA_R   <= "1111";
                    VGA_B   <= "1111";
                    VGA_G   <= "0000";
                end if;
                if (DrawSM = '1') then -- Squares' color
                    VGA_R   <= "1111";
                    VGA_B   <= "1111";
                    VGA_G   <= "1111";
                end if;
                if (DrawSR = '1') then
                    VGA_R   <= "1111";
                    VGA_B   <= "1111";
                    VGA_G   <= "1111";
                end if;
                if (DrawSL = '1') then
                    VGA_R   <= "1111";
                    VGA_B   <= "1111";
                    VGA_G   <= "1111";
                end if;
                if (DrawBallRB = '1') then -- Blue Balls' color
                    VGA_R   <= "0000";
                    VGA_B   <= "1111";
                    VGA_G   <= "1111";
                end if;
                if (DrawBallLB = '1') then 
                    VGA_R   <= "0000";
                    VGA_B   <= "1111";
                    VGA_G   <= "1111";
                end if;
                if (DrawBallMB = '1') then 
                    VGA_R   <= "0000";
                    VGA_B   <= "1111";
                    VGA_G   <= "1111";
                end if;
                if (DrawBallRG = '1') then -- Balls' color
                    VGA_R   <= "0000";
                    VGA_B   <= "1000";
                    VGA_G   <= "1111";
                end if;
                if (DrawBallLG = '1') then 
                    VGA_R   <= "0000";
                    VGA_B   <= "1000";
                    VGA_G   <= "1111";
                end if;
                if (DrawBallMG = '1') then 
                    VGA_R   <= "0000";
                    VGA_B   <= "1000";
                    VGA_G   <= "1111";
                end if;
                if (DrawBallRP = '1') then -- Balls' color
                    VGA_R   <= "1111";
                    VGA_B   <= "1111";
                    VGA_G   <= "0000";
                end if;
                if (DrawBallLP = '1') then   
                    VGA_R   <= "1111";
                    VGA_B   <= "1111";
                    VGA_G   <= "0000";
                end if;
                if (DrawBallMP = '1') then 
                    VGA_R   <= "1111";
                    VGA_B   <= "1111";
                    VGA_G   <= "0000";
                end if;
                if (DrawBallRY = '1') then -- Balls' color
                    VGA_R   <= "1111";
                    VGA_B   <= "0000";
                    VGA_G   <= "1111";
                end if;
                if (DrawBallLY = '1') then 
                    VGA_R   <= "1111";
                    VGA_B   <= "0000";
                    VGA_G   <= "1111";
                end if;
                if (DrawBallMY = '1') then 
                    VGA_R   <= "1111";
                    VGA_B   <= "0000";
                    VGA_G   <= "1111";
                end if;
            else
                VGA_R <= "0000";
                VGA_B <= "0000";
                VGA_G <= "0000";
            end if;  
        end if; 
    end process;   
end Behavioral;