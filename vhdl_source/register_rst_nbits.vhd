----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Register_rst_n_bits
-- Module Name:    Register_rst_n_bits 
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Register of size bits with reset signal, that only registers when ce equals to 1.
-- The reset is synchronous and the value loaded during reset is defined by reset_value.
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
-- Revision 1.1
-- Fixed some languages issues.
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_rst_nbits is
    Generic (size : integer);
    Port (
        d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
        clk : in  STD_LOGIC;
        ce : in  STD_LOGIC;
        rst : in STD_LOGIC;
        rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
        q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
    );
end register_rst_nbits;

architecture Behavioral of register_rst_nbits is

begin

process(clk)
begin
    if(rising_edge(clk))then
        if(rst = '0') then
            q <= rst_value;
        elsif(ce = '1') then
            q <= d;
        else
            null;
        end if;
    end if;
end process;

end Behavioral;