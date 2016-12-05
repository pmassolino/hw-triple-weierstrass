----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012
-- Design Name:    Synth Double RAM 
-- Module Name:    Synth Double RAM
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Circuit to simulate the behavior of a double synthesizable RAM.
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

entity synth_double_ram is
    Generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    Port (
        data_in_a : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        data_in_b : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        rw_a : in STD_LOGIC;
        rw_b : in STD_LOGIC;
        clk : in STD_LOGIC;
        address_a : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        address_b : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        data_out_a : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        data_out_b : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
    );
end synth_double_ram;

architecture Behavioral of synth_double_ram is

type ramtype is array(integer range 0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);    

shared variable memory_ram : ramtype;

begin                                                        

process (clk)                                                
    begin                                                        
        if (rising_edge(clk)) then
            if rw_a = '1' then                                             
                memory_ram(to_integer(unsigned(address_a))) := data_in_a((ram_word_size - 1) downto (0));         
            end if;                                           
                data_out_a((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(unsigned(address_a)));
        end if;
end process;             

process (clk)                                                
    begin                                                        
        if (rising_edge(clk)) then
            if rw_b = '1' then                                             
                memory_ram(to_integer(unsigned(address_b))) := data_in_b((ram_word_size - 1) downto (0));         
            end if;                                           
                data_out_b((ram_word_size - 1) downto (0)) <= memory_ram(to_integer(unsigned(address_b)));
        end if;
end process;             


end Behavioral;