----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.08.2019 16:25:53
-- Design Name: 
-- Module Name: Top_Module - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_Module is
  Port (  Clock   : in std_logic;
          buttonR : in std_logic;
          buttonL : in std_logic;
          reset   : in std_logic;
          anode   : out std_logic_vector (3 downto 0);
          result  : out std_logic_vector (6 downto 0);
          VGA_R   : out std_logic_vector (3 downto 0);
          VGA_B   : out std_logic_vector (3 downto 0); 
          VGA_G   : out std_logic_vector (3 downto 0);
          VGA_HS  : out std_logic;
          VGA_VS  : out std_logic);
        end Top_Module;

architecture Behavioral of Top_Module is

  signal HPOS       : integer;
  signal VPOS       : integer;
  signal DrawS      : std_logic;
  signal DrawSM     : std_logic;
  signal DrawSR     : std_logic;
  signal DrawSL     : std_logic;
  signal DrawBall   : std_logic;
  signal DrawBallRB : std_logic;
  signal DrawBallMB : std_logic;
  signal DrawBallLB : std_logic;
  signal DrawBallRG : std_logic;
  signal DrawBallMG : std_logic;
  signal DrawBallLG : std_logic;
  signal DrawBallRP : std_logic;
  signal DrawBallMP : std_logic;
  signal DrawBallLP : std_logic;
  signal DrawBallRY : std_logic;
  signal DrawBallMY : std_logic;
  signal DrawBallLY : std_logic;
  signal FlowBallRB : integer;
  signal FlowBallLB : integer;
  signal FlowBallMB : integer;
  signal FlowBallRG : integer;
  signal FlowBallLG : integer;
  signal FlowBallMG : integer;
  signal FlowBallRP : integer;
  signal FlowBallLP : integer;
  signal FlowBallMP : integer;
  signal FlowBallRY : integer;
  signal FlowBallLY : integer;
  signal FlowBallMY : integer;
  signal FlowSquareR : integer;
  signal FlowSquareM : integer;
  signal FlowSquareL : integer;
  signal MBCont      : integer;
  signal drawMain    : std_logic;
  signal drawGameOver: std_logic;
  signal locked      : std_logic;
  signal CLK         : std_logic; 
  signal CLKslow     : std_logic;
  signal clknew      : std_logic;
  signal clkMB       : std_logic;
  signal gameOverr   : std_logic;
  signal SCORE       : integer;

  component clk_wiz_0 is
      Port ( CLK : out STD_LOGIC;
             CLKslow : out STD_LOGIC;
             --reset   : in STD_LOGIC;
             locked  : out STD_LOGIC;
             clk_in1 : in STD_LOGIC);
  end component clk_wiz_0;
---------------------------------------------------------------------

component SSD is
      Port (CLK: in std_logic;
        SCORE  : in integer;
        anode  : out std_logic_vector ( 3 downto 0 );
        result : out std_logic_vector ( 6 downto 0));
end component SSD;
---------------------------------------------------------------------
  
component clk_divider is
      Port ( CLK    : in std_logic;
             clkNew : out std_logic;
             clkMB  : out std_logic );
  end component;

  -------------------------------------------------------------------
  component MainBall is -- Creating Main Ball
    Port ( CLK      : in std_logic;
         HPOS       : in integer;
         VPOS       : in integer;
         reset      : in std_logic;
         MBCont     : in integer;
         drawMain   : out std_logic);
  end component MainBall;


  ---------------------------------------------------------------------
  component GameOver is -- Printing Game Over
      Port (CLK     : in std_logic;
          HPOS      : in integer;
          VPOS      : in integer;
          gameOverr : in std_logic;
          drawGameOver : out std_logic);
  end component GameOver;

  ---------------------------------------------------------------------

  component LocsAndFlow is  -- locations and flow of the balls and squares.
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
    end component LocsAndFlow;

    ---------------------------------------------------------------------

    component SYNC is -- Printing the game on VGA.
      Port (CLK        : in std_logic;
            DrawSM     : in std_logic;
            DrawSL     : in std_logic;
            DrawSR     : in std_logic;
            drawMain   : in std_logic; 
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
            reset      : in std_logic;
            gameOverr  : out std_logic;
            SCORE      : out integer;
	      HPOS       : out integer;
            VPOS       : out integer;
            VGA_HS     : out std_logic;
            VGA_VS     : out std_logic;
            VGA_R      : out std_logic_vector (3 downto 0);
            VGA_B      : out std_logic_vector (3 downto 0); 
            VGA_G      : out std_logic_vector (3 downto 0));
    end component SYNC;

    ---------------------------------------------------------------------
  
begin


clk_divider_i : clk_divider 
PORT MAP (CLK => CLK,
          clknew => clknew,
          clkMB => clkMB); --clock divider

clK_wiz_0_i : clK_wiz_0 
PORT MAP (clk_in1 => Clock,
      CLKslow => CLKslow,
      --reset   => reset,
      locked  => locked,
      CLK     => CLK);  -- PLL clock creating

Balls_i  : MainBall 
PORT MAP(CLK => CLK,
      HPOS     => HPOS, 
      VPOS     => VPOS, 
      reset    => reset,
      MBCont   => MBCont, 
      drawMain => drawMain); -- Main Ball creating

SYNC_i  : SYNC 
PORT MAP( CLK    => CLK,
      reset      => reset, 
      DrawSM     => DrawSM,
      DrawSR     => DrawSR,
      DrawSL     => DrawSL,
      drawMain   => drawMain, 
      DrawBallRB => DrawBallRB,
      DrawBallMB => DrawBallMB,
      DrawBallLB => DrawBallLB,
      DrawBallRG => DrawBallRG,
      DrawBallMG => DrawBallMG,
      DrawBallLG => DrawBallLG,
      DrawBallRP => DrawBallRP,
      DrawBallMP => DrawBallMP,
      DrawBallLP => DrawBallLP,
      DrawBallRY => DrawBallRY,
      DrawBallMY => DrawBallMY,
      DrawBallLY => DrawBallLY,
      drawGameOver =>drawGameOver,
      gameOverr   => gameOverr,
      SCORE      => SCORE,
      HPOS       => HPOS,
      VPOS       => VPOS,
      VGA_HS     => VGA_HS,
      VGA_VS     => VGA_VS,
      VGA_R      => VGA_R,
      VGA_G      => VGA_G,
      VGA_B      => VGA_B); -- VGA Printing


LocsAndFlow_i: LocsAndFlow 
PORT MAP(CLK => CLK,
      CLKnew     => CLKnew,
      clkMB      => clkMB,
      buttonR    => buttonR,
      buttonL    => buttonL,
      reset      => reset,
      DrawS      => DrawS,
      DrawBall   => DrawBall,
      HPOS       => HPOS, 
      VPOS       => VPOS,
      gameOverr  => gameOverr,
      DrawSM     => DrawSM,
      DrawSL     => DrawSL,
      DrawSR     => DrawSR,
      DrawBallRB => DrawBallRB,
      DrawBallMB => DrawBallMB,
      DrawBallLB => DrawBallLB,
      DrawBallRG => DrawBallRG,
      DrawBallMG => DrawBallMG,
      DrawBallLG => DrawBallLG,
      DrawBallRP => DrawBallRP,
      DrawBallMP => DrawBallMP,
      DrawBallLP => DrawBallLP,
      DrawBallRY => DrawBallRY,
      DrawBallMY => DrawBallMY,
      DrawBallLY => DrawBallLY,
      FlowBallRB => FlowBallRB,
      FlowBallLB => FlowBallLB,
      FlowBallMB => FlowBallMB,
      FlowBallRG => FlowBallRG,
      FlowBallLG => FlowBallLG,
      FlowBallMG => FlowBallMG,
      FlowBallRP => FlowBallRP,
      FlowBallLP => FlowBallLP,
      FlowBallMP => FlowBallMP,
      FlowBallRY => FlowBallRY,
      FlowBallLY => FlowBallLY,
      FlowBallMY => FlowBallMY,
      FlowSquareM => FlowSquareM,
      FlowSquareR => FlowSquareR,
      FlowSquareL => FlowSquareL,
      MBcont     => MBcont); -- Controling the locations and flow of the objects.
SSD_i: SSD 
PORT MAP (CLK => CLK,
      SCORE => SCORE,
      anode => anode,
      result => result);

GameOver_i: GameOver
PORT MAP ( CLK => CLK,
      VPOS => VPOS,
      HPOS => HPOS,
      gameOverr => gameOverr,
      drawGameOver => drawGameOver);

end Behavioral;
