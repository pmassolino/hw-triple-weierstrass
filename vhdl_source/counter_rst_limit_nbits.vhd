----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012 
-- Design Name:    Counter_rst_limit_nbits
-- Module Name:    Counter_rst_limit_nbits 
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Counter of size bits with reset signal, that only decrements when ce equals to 1.
-- The reset is synchronous and the value loaded during reset is defined by reset_value.
-- When the counter reaches 0 the signal limit becomes '1'.
-- If the ce is still '1' after limit reaches '1', the counter will continue to decrement 
-- reaching the maximum value and therefore making limit go back to '0'.
--
-- The circuits parameters
--
-- size :
--
-- The size of the counter in bits.
--
-- increment_value :
--
-- The amount will be incremented each cycle. 
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- 
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_rst_limit_nbits is
    Generic (
        size : integer;
        decrement_value : integer
    );
    Port (
        clk : in  STD_LOGIC;
        ce : in  STD_LOGIC;
        rst : in STD_LOGIC;
        rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);
        limit : out STD_LOGIC
    );
end counter_rst_limit_nbits;

architecture Behavioral of counter_rst_limit_nbits is

signal counter_value_old : UNSIGNED((size - 1) downto 0);
signal counter_value_new : UNSIGNED((size - 1) downto 0);
signal internal_limit : STD_LOGIC;

begin

process(clk)
begin
    if(rising_edge(clk))then
        if(rst = '0') then
            counter_value_old <= unsigned(rst_value);
            internal_limit <= '0';
        elsif(ce = '1') then
            counter_value_old <= counter_value_new;
            if(counter_value_new = to_unsigned(0, size)) then
                internal_limit <= '1';
            else
                internal_limit <= '0';
            end if;
        else
            null;
        end if;
    end if;
end process;

counter_value_new <= counter_value_old - to_unsigned(decrement_value, size);
limit <= internal_limit;

end Behavioral;