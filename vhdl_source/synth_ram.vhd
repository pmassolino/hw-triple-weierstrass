----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012
-- Design Name:    Synth RAM 
-- Module Name:    Synth RAM
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Circuit to simulate the behavior of a synthesizable RAM.
--
-- The circuits parameters
-- 
-- ram_address_size :
--
-- Address size of the synthesizable RAM used on the circuit.
--
-- ram_word_size :
--
-- The size of internal word on the synthesizable RAM.
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
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
use IEEE.NUMERIC_STD.ALL;

entity synth_ram is
    Generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    Port (
        data_in : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        rw : in STD_LOGIC;
        clk : in STD_LOGIC;
        address : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        data_out : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
    );
end synth_ram;

architecture Behavioral of synth_ram is

type ramtype is array(integer range 0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);    

signal memory_ram : ramtype;

begin                                                        
process (clk)                                                
    begin                                                        
        if (rising_edge(clk)) then
            if rw = '1' then                                             
                memory_ram(to_integer(unsigned(address))) <= data_in((ram_word_size - 1) downto (0));         
            end if;                                           
                data_out((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(unsigned(address)));
        end if;
    end process;
    
end Behavioral;