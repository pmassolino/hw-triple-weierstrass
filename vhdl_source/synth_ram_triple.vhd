----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    Synth Triple RAM 
-- Module Name:    Synth Triple RAM
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Circuit to simulate the behavior of a triple synthesizable RAM.
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
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity synth_ram_triple is
    Generic (
        ram_address_size : integer;
        ram_word_size : integer
    );
    Port (
        data_in : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        clk : in STD_LOGIC;
        write_enable : in STD_LOGIC;
        address_out_a : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        address_out_b : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        address_in : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        data_out_a : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        data_out_b : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
    );
end synth_ram_triple;

architecture Behavioral of synth_ram_triple is

type ramtype is array(integer range 0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);    

signal memory_ram : ramtype;

begin                                                        

process (clk)                                                
begin                                                        
    if (rising_edge(clk)) then    
        data_out_a <= memory_ram(to_integer(unsigned(address_out_a)));
        data_out_b <= memory_ram(to_integer(unsigned(address_out_b)));
        if(write_enable = '1') then
            assert (address_out_a /= address_in) report "Adress A is equal to writing address" severity error;
            assert (address_out_b /= address_in) report "Adress B is equal to writing address" severity error;
            memory_ram(to_integer(unsigned(address_in))) <= data_in;
        end if;   
    end if;                                                      
end process;             

end Behavioral;