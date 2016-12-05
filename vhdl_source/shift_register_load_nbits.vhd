----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    shift_register_load_nbits
-- Module Name:    shift_register_load_nbits
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
-- 
-- Description: 
--
-- Shift register that can load data in parallel or in serial.
-- It is possible to read data in both parallel and serial. 
--
-- size :
--
-- The size of the shift register in bits.
-- 
--
--
-- Dependencies:
-- VHDL-93
-- 
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_load_nbits is
    Generic (size : integer);
    Port (
        d : in STD_LOGIC_VECTOR ((size - 1) downto 0);
        data_in : in STD_LOGIC;
        clk : in  STD_LOGIC;
        ce : in  STD_LOGIC;
        load : in STD_LOGIC;
        q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
    );
end shift_register_load_nbits;

architecture Behavioral of shift_register_load_nbits is

signal internal_value : STD_LOGIC_VECTOR((size - 1) downto 0);

begin

process(clk)
begin
    if(rising_edge(clk))then
        if(ce = '1') then 
            if(load = '1') then
                internal_value <= d;
            else
                internal_value <= data_in & internal_value((size - 1) downto 1);
            end if;
        else
            null;
        end if;
    end if;
end process;

q <= internal_value;

end Behavioral;