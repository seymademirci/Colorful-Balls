----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.08.2019 17:06:51
-- Design Name: 
-- Module Name: clk_divider - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity clk_divider is
    Port ( CLK    : in std_logic;
           clkNew : out std_logic;
           clkMB  : out std_logic
     );
  end clk_divider;
  
  architecture Behavioral of clk_divider is
  signal clk_n  : std_logic;
  signal clk_mb : std_logic;
  
  begin
  process(CLK, clk_n)
  variable cnt : integer range 0 to 10_000_000:=0;
  begin 
      if (rising_edge (CLK)) then
          if(cnt < 500_000) then 
              cnt := cnt +1;
           else
              clk_n <= not clk_n;
              cnt := 0;
           end if;
      end if;
      clkNew <= clk_n;
  end process;
  
  process(CLK, clk_mb)
  variable cnt1 : integer range 0 to 10_000_000:=0;
  begin 
      if (rising_edge (CLK)) then
          if(cnt1 < 7_500_000) then 
              cnt1 := cnt1 +1;
           else
              clk_mb <= not clk_mb;
              cnt1 := 0;
           end if;
      end if;
      clkMB <= clk_mb;
  end process;
  end Behavioral;