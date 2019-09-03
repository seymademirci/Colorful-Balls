----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.08.2019 11:18:08
-- Design Name: 
-- Module Name: LocsAndFlow - Behavioral
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

entity LocsAndFlow is
  Port (CLK         : in std_logic;
        CLKnew      : in std_logic;
        clkMB       : in std_logic;
        buttonR     : in std_logic;
        buttonL     : in std_logic;
        reset       : in std_logic;
        DrawS       : in std_logic;
        DrawBall    : in std_logic;
        HPOS        : in integer;
        VPOS        : in integer; 
        gameOverr   : in std_logic;
        DrawSM      : out std_logic;
        DrawSR      : out std_logic;
        DrawSL      : out std_logic;
        DrawBallRB  : out std_logic;
        DrawBallMB  : out std_logic;
        DrawBallLB  : out std_logic;
        DrawBallRG  : out std_logic;
        DrawBallMG  : out std_logic;
        DrawBallLG  : out std_logic;
        DrawBallRP  : out std_logic;
        DrawBallMP  : out std_logic;
        DrawBallLP  : out std_logic;
        DrawBallRY  : out std_logic;
        DrawBallMY  : out std_logic;
        DrawBallLY  : out std_logic;
        FlowBallRB  : out integer;
        FlowBallLB  : out integer;
        FlowBallMB  : out integer;
        FlowBallRG  : out integer; 
        FlowBallLG  : out integer; 
        FlowBallMG  : out integer; 
        FlowBallRP  : out integer; 
        FlowBallLP  : out integer; 
        FlowBallMP  : out integer; 
        FlowBallRY  : out integer; 
        FlowBallLY  : out integer; 
        FlowBallMY  : out integer; 
        FlowSquareM : out integer;
        FlowSquareR : out integer;
        FlowSquareL : out integer;
        MBCont      : out integer);
end LocsAndFlow;

architecture Behavioral of LocsAndFlow is
   

constant horizon_disp : integer := 1440;
constant hfp : integer := 80;
constant hsp : integer := 152;
constant hbp : integer := 232;

constant vertical_disp : integer := 900;
constant vfp : integer := 1;
constant vsp : integer := 3;
constant vbp : integer := 28;
constant r    : integer    := 70;
constant rightCont : integer :=  hsp + hbp + 70 + 410;
constant leftCont  : integer := hsp + hbp + horizon_disp - 70 - 410;

signal hball : integer := (hsp + hbp + horizon_disp/2); 
signal velocityvec : integer := 1;


signal s_MBCont     : integer := (hsp + hbp + horizon_disp/2);
signal s_drawPM     : std_logic;
signal s_drawBM     : std_logic;
signal s_drawGM     : std_logic;
signal s_drawYM     : std_logic;
signal s_FlowBallRB : integer := 0;
signal s_FlowBallLB : integer := 0;
signal s_FlowBallMB : integer := 0;
signal s_FlowBallRG : integer := 0;
signal s_FlowBallLG : integer := 0;
signal s_FlowBallMG : integer := 0;
signal s_FlowBallRP : integer := 0;
signal s_FlowBallLP : integer := 0;
signal s_FlowBallMP : integer := 0;
signal s_FlowBallRY : integer := 0;
signal s_FlowBallLY : integer := 0;
signal s_FlowBallMY : integer := 0;
signal s_FlowSquareR : integer :=0;
signal s_FlowSquareM : integer :=0;
signal s_FlowSquareL : integer :=0;
signal s_BallOrderR  : integer := 0;
signal s_SquareOrderR: integer := 10;
signal s_BallOrderL  : integer := 0;
signal s_SquareOrderL: integer := 10;
signal s_BallOrderM  : integer := 0;
signal s_SquareOrderM: integer := 10;
signal s_gameOverr : std_logic := '0';

component Square is 
    Generic (SquareLoc : in integer;
            SquareVLoc : in integer);
    Port ( CLK      : in std_logic;
        HPOS       : in integer;
        VPOS       : in integer;
        FlowSquare : in integer;
        DrawS      : out std_logic);
end component;

component GenericMBalls is
    generic(Hposition    :in integer;  -- it can be -240, 240, 240
            Vposition    :in integer);
    Port (CLK        :in std_logic;
          HPOS       :in integer;
          VPOS       :in integer;
          FlowBall   :in integer;
          DrawBall   :out std_logic
           );
end component;

begin

    SquareM : Square --Square in mid lane
    GENERIC MAP ( SquareLoc => 0,
    SquareVLoc => 500)
    PORT MAP (CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowSquare => s_FlowSquareM,
    DrawS => DrawSM);

    SquareR : Square -- Square in right lane
    GENERIC MAP ( SquareLoc => -240,
    SquareVLoc => 400)
    PORT MAP (CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowSquare => s_FlowSquareR,
    DrawS => DrawSR);

    SquareL : Square --square in left lane
    GENERIC MAP ( SquareLoc => 240,
    SquareVLoc => 300)
    PORT MAP (CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowSquare => s_FlowSquareL,
    DrawS => DrawSL);

    BlueBallRB : GenericMBalls  -- blue ball in right lane
    GENERIC MAP ( Hposition => -240,
    Vposition => 400)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallRB,
    DrawBall => DrawBallRB);

    BlueBallMB : GenericMBalls -- blue ball in mid lane
    GENERIC MAP ( Hposition => 0,
    Vposition => 500)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallMB,
    DrawBall => DrawBallMB);


    BlueBallLB : GenericMBalls -- blue ball in left lane
    GENERIC MAP ( Hposition => 240,
    Vposition => 300)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallLP,
    DrawBall => DrawBallLB);
    ----
    GreenBallRG : GenericMBalls  -- Green ball in right lane
    GENERIC MAP ( Hposition => -240,
    Vposition => 400)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallRG,
    DrawBall => DrawBallRG);

    GreenBallMG : GenericMBalls -- Green ball in mid lane
    GENERIC MAP ( Hposition => 0,
    Vposition => 500)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallMG,
    DrawBall => DrawBallMG);

    GreenBallLG : GenericMBalls -- Green ball in left lane
    GENERIC MAP ( Hposition => 240,
    Vposition => 300)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallLG,
    DrawBall => DrawBallLG);
    ---
    PinkBallRP : GenericMBalls  -- Pink ball in right lane
    GENERIC MAP ( Hposition => -240,
    Vposition => 400)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallRP,
    DrawBall => DrawBallRP);

    PinkBallMP : GenericMBalls -- Pink ball in mid lane
    GENERIC MAP ( Hposition => 0,
    Vposition => 500)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallMP,
    DrawBall => DrawBallMP);


    PinkBallLP : GenericMBalls -- Pink ball in left lane
    GENERIC MAP ( Hposition => 240,
    Vposition => 300)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallLP,
    DrawBall => DrawBallLP);
    ---
    YellowBallRY : GenericMBalls  -- Yellow ball in right lane
    GENERIC MAP ( Hposition => -240,
    Vposition => 400)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallRY,
    DrawBall => DrawBallRY);

    YellowBallMY : GenericMBalls -- Yellow ball in mid lane
    GENERIC MAP ( Hposition => 0,
    Vposition => 500)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallMY,
    DrawBall => DrawBallMY);


    YellowBallLY : GenericMBalls -- Yellow ball in left lane
    GENERIC MAP ( Hposition => 240,
    Vposition => 300)
    PORT MAP(CLK   => CLK,
    HPOS  => HPOS,
    VPOS  => VPOS,
    FlowBall => s_FlowBallLY,
    DrawBall => DrawBallLY);



process (clkMB, reset) --changing location of main ball
begin
    if (reset = '1') then
        s_MBCont <= 1104; -- hsp + hbp + horizon_disp/2
    elsif rising_edge(clkMB) then
        if (gameOverr = '0')then
            if(buttonL = '1' and s_MBCont > rightCont) then
                s_MBCont <= s_MBCont - 240;
            elsif (buttonR = '1' and s_MBCont < leftCont ) then
                s_MBCont <= s_MBCont + 240;
            end if;
        end if; 
    end if; 
end process;
MBCont <= s_MBCont;

process(clknew, reset) -- Flow of the balls
begin
    if(reset = '1') then
        s_FlowBallRB <= 0;
        s_FlowBallRG <= 0;
        s_FlowBallRP <= 0;
        s_FlowBallRY <= 0;
        s_FlowSquareR <= 0;
        s_BallOrderR  <= 0; 
        s_SquareOrderR <= 10;
    elsif rising_edge(CLKnew) then   
    if gameOverr = '0' then
        if (s_BallOrderR = s_SquareOrderR)then
            s_FlowBallRG <= s_FlowBallRG + velocityvec;
        elsif (s_BallOrderR = 1 or s_BallOrderR = 7) then 
            s_FlowSquareR <= s_FlowSquareR + velocityvec;
        elsif (s_BallOrderR = 2 or s_BallOrderR = 6) then 
            s_FlowBallRY <= s_FlowBallRY + velocityvec;
        elsif (s_BallOrderR = 4 or s_BallOrderR = 8) then 
            s_FlowBallRB <= s_FlowBallRB + velocityvec;
        else 
            s_FlowBallRP <= s_FlowBallRP + velocityvec;
        end if;

        if (s_FlowBallRG > 1300) then
            s_BallOrderR <= s_BallOrderR + 1;
            s_FlowBallRG <= 0;
            s_BallOrderR <= 0;
        end if;
        if (s_FlowBallRB > 1300) then
            s_BallOrderR <= s_BallOrderR + 1;
            s_FlowBallRB <= 0;
        end if;
        if (s_FlowBallRY > 1300) then
            s_BallOrderR <= s_BallOrderR + 1;
            s_FlowBallRY <= 0;
        end if;
        if (s_FlowBallRP > 1300) then
            s_BallOrderR <= s_BallOrderR + 1;
            s_FlowBallRP <= 0;
        end if;
        if (s_FlowSquareR > 1300) then
            s_BallOrderR <= s_BallOrderR + 1;
            s_FlowSquareR <= 0;
        end if;
    end if;
    end if;
end process;

process(clknew, reset) -- Flow of the balls
begin
    if(reset = '1') then
        s_FlowBallMB <= 0;
        s_FlowBallMG <= 0;
        s_FlowBallMP <= 0;
        s_FlowBallMY <= 0;
        s_FlowSquareM <= 0;
        s_BallOrderM  <= 0; 
        s_SquareOrderM <= 10;
    elsif rising_edge(CLKnew) then   
    if gameOverr = '0' then
        if (s_BallOrderM = s_SquareOrderM)then
            s_FlowBallMB <= s_FlowBallMB + velocityvec;
        elsif (s_BallOrderM = 1 or s_BallOrderM = 7) then 
            s_FlowBallMY <= s_FlowBallMY + velocityvec;
        elsif (s_BallOrderM = 2 or s_BallOrderM = 6) then 
            s_FlowSquareM <= s_FlowSquareM + velocityvec;
        elsif (s_BallOrderM = 4 or s_BallOrderM = 8) then 
            s_FlowBallMP <= s_FlowBallMP + velocityvec;
        else 
            s_FlowBallMG <= s_FlowBallMG + velocityvec;
        end if;

        if (s_FlowBallMG >1400) then
            s_BallOrderM <= s_BallOrderM + 1;
            s_FlowBallMG <= 0;
        end if;
        if (s_FlowBallMB > 1400) then
            s_BallOrderM <= s_BallOrderM + 1;
            s_FlowBallMB <= 0;
            s_BallOrderM <= 0;
        end if;
        if (s_FlowBallMY > 1400) then
            s_BallOrderM <= s_BallOrderM + 1;
            s_FlowBallMY <= 0;
        end if;
        if (s_FlowBallMP > 1400) then
            s_BallOrderM <= s_BallOrderM + 1;
            s_FlowBallMP <= 0;
        end if;
        if (s_FlowSquareM > 1400) then
            s_BallOrderM <= s_BallOrderM + 1;
            s_FlowSquareM <= 0;
        end if;
    end if;
    end if;
end process;

process(clknew, reset) -- Flow of the balls
begin
    if(reset = '1') then
    
        s_FlowBallLB <= 0;
        s_FlowBallLG <= 0;
        s_FlowBallLP <= 0;
        s_FlowBallLY <= 0;  
        s_FlowSquareL <= 0;
        s_BallOrderL  <= 0;
        s_SquareOrderL <= 10;
    elsif rising_edge(CLKnew) then 
    if gameOverr = '0' then  
        if (s_BallOrderL = s_SquareOrderL)then
            s_FlowBallLY <= s_FlowBallLY + velocityvec;
        elsif (s_BallOrderL = 1 or s_BallOrderL = 7) then 
            s_FlowBallLG <= s_FlowBallLG + velocityvec;
        elsif (s_BallOrderL = 2 or s_BallOrderL = 6) then 
            s_FlowBallLP <= s_FlowBallLP + velocityvec;
        elsif (s_BallOrderL = 4 or s_BallOrderL = 8) then 
            s_FlowBallLB <= s_FlowBallLB + velocityvec;
        else 
            s_FlowSquareL <= s_FlowSquareL + velocityvec;
        end if;

        if (s_FlowBallLG > 1200) then
            s_BallOrderL <= s_BallOrderL + 1;
            s_FlowBallLG <= 0;
        end if;
        if (s_FlowBallLB > 1200) then
            s_BallOrderL <= s_BallOrderL + 1;
            s_FlowBallLB <= 0;
        end if;
        if (s_FlowBallLY > 1200) then
            s_BallOrderL <= s_BallOrderL + 1;
            s_FlowBallLY <= 0;
            s_BallOrderL <= 0;
        end if;
        if (s_FlowBallLP > 1200) then 
            s_BallOrderL <= s_BallOrderL + 1;
            s_FlowBallLP <= 0;
        end if;
        if (s_FlowSquareL > 1200) then
            s_BallOrderL <= s_BallOrderL + 1;
            s_FlowSquareL <= 0;
        end if; 
    end if;
    end if;
end process;

 FlowBallRB <= s_FlowBallRB;
 FlowBallLB <= s_FlowBallLB;
 FlowBallMB <= s_FlowBallMB;
 FlowBallRG <= s_FlowBallRG;
 FlowBallLG <= s_FlowBallLG;
 FlowBallMG <= s_FlowBallMG;
 FlowBallRP <= s_FlowBallRP;
 FlowBallLP <= s_FlowBallLP;
 FlowBallMP <= s_FlowBallMP;
 FlowBallRY <= s_FlowBallRY;
 FlowBallLY <= s_FlowBallLY;
 FlowBallMY <= s_FlowBallMY;
 FlowSquareM <= s_FlowSquareM;
 FlowSquareR <= s_FlowSquareR;
 FlowSquareL <= s_FlowSquareL;
end Behavioral;
 