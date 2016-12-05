----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Register_n_bits
-- Module Name:    Register_n_bits 
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Register of size bits with no reset signal,that only registers when ce equals to 1
--
-- The circuits parameters
--
-- size :
--
-- The size of the register in bits.
--
-- Dependencies:
-- VHDL-93
-- 
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_nbits is
    Generic (size : integer);
    Port (
        d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
        clk : in  STD_LOGIC;
        ce : in  STD_LOGIC;
        q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
    );
end register_nbits;

architecture Behavioral of register_nbits is

begin

process(clk)
begin
    if(rising_edge(clk))then
        if(ce = '1') then
            q <= d;
        else
            null;
        end if;
    end if;
end process;

end Behavioral;

