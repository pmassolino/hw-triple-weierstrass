----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    05/12/2012
-- Design Name:    RAM_Double
-- Module Name:    RAM_Double
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Xilinx ISE 13.3 WebPack
--
-- Description: 
--
-- Circuit to simulate the behavioral of a double memory RAM.
-- With this memory is possible to read and write at the same cycle.
-- Only used for tests.
--
-- The circuits parameters
-- 
-- ram_address_size :
--
-- Address size of the RAM used on the circuit.
--
-- ram_word_size :
-- 
-- The size of internal word on the RAM.
--
-- file_ram_word_size :
-- 
-- The size of the word used in the file to be loaded on the RAM.(ARCH: FILE_LOAD)
--
-- load_file_name :
-- 
-- The name of file to be loaded.(ARCH: FILE_LOAD)
--
-- dump_file_name :
-- 
-- The name of the file to be used to dump the memory.(ARCH: FILE_LOAD)
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- IEEE.STD_LOGIC_TEXTIO.ALL;
-- STD.TEXTIO.ALL;
-- 
-- Revision: 
-- Revision 1.1
-- Fixed some languages issues.
-- Changed reset to be active at 0.
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;

library STD;
use STD.TEXTIO.ALL;

entity ram_double is
    Generic (
        ram_address_size : integer;
        ram_word_size : integer;
        file_ram_word_size : integer;
        load_file_name : string := "ram.dat";
        dump_file_name : string := "ram.dat"
    );
    Port (
        data_in_a : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        data_in_b : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        rw_a : in STD_LOGIC;
        rw_b : in STD_LOGIC;
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        dump : in STD_LOGIC;
        address_a : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        address_b : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        data_out_a : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        data_out_b : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
    );
end ram_double;

architecture simple of ram_double is

type ramtype is array(integer range 0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);    

procedure dump_ram (ram_file_name : in string; memory_ram : in ramtype) is                                                   
    FILE ram_file : text open write_mode is ram_file_name;                       
    variable line_n : line;                                 
    begin                                                        
        for I in ramtype'range loop
            IEEE.STD_LOGIC_TEXTIO.write (line_n, memory_ram(I));
            STD.TEXTIO.writeline (ram_file, line_n);
      end loop;                                                                                        
 end procedure;

signal memory_ram : ramtype;

begin                                                        

process (clk)                                                
begin                                                        
    if(rising_edge(clk)) then   
        if rst = '0' then
            for I in ramtype'range loop
                memory_ram(I) <= rst_value;
            end loop;
        end if;
        if dump = '1' then
            dump_ram(dump_file_name, memory_ram);
        end if;
        if rw_a = '1' then                                             
            memory_ram(to_integer(unsigned(address_a))) <= data_in_a;         
      end if;                                                      
        data_out_a <= memory_ram(to_integer(unsigned(address_a)));      
        if rw_b = '1' then
            memory_ram(to_integer(unsigned(address_b))) <= data_in_b;
        end if;
        data_out_b <= memory_ram(to_integer(unsigned(address_b)));
    end if;
    end process;          

end simple;

architecture file_load of ram_double is

type ramtype is array(integer range 0 to (2**ram_address_size - 1)) of std_logic_vector((ram_word_size - 1) downto 0);    

impure function load_ram (ram_file_name : in string) return ramtype is                                                   
    FILE ram_file : text open read_mode is ram_file_name;                       
    variable line_n : line;                                 
    variable memory_ram : ramtype;
    variable file_read_buffer : std_logic_vector((file_ram_word_size - 1) downto 0);
    variable file_buffer_amount : integer;
    variable ram_buffer_amount : integer;
   begin                                 
        file_buffer_amount := file_ram_word_size;
        for I in ramtype'range loop
            ram_buffer_amount := 0;     
            if (not endfile(ram_file) or (file_buffer_amount /= file_ram_word_size)) then
                while ram_buffer_amount /= ram_word_size loop
                    if file_buffer_amount = file_ram_word_size then
                        if (not endfile(ram_file)) then
                            STD.TEXTIO.readline (ram_file, line_n);                             
                            IEEE.STD_LOGIC_TEXTIO.read (line_n, file_read_buffer);
                        else
                            file_read_buffer := (others => '0');
                        end if;
                        file_buffer_amount := 0;
                    end if;
                    memory_ram(I)(ram_buffer_amount) := file_read_buffer(file_buffer_amount);
                    ram_buffer_amount := ram_buffer_amount + 1;
                    file_buffer_amount := file_buffer_amount + 1;
                end loop;
            else
                    memory_ram(I) := (others => '0');
            end if;
      end loop;                                                    
        return memory_ram;                                                  
end function;   

procedure dump_ram (ram_file_name : in string; memory_ram : in ramtype) is                                                   
    FILE ram_file : text open write_mode is ram_file_name;                       
    variable line_n : line;                                 
    begin                                                        
        for I in ramtype'range loop
            IEEE.STD_LOGIC_TEXTIO.write (line_n, memory_ram(I));
            STD.TEXTIO.writeline (ram_file, line_n);
      end loop;                                                                                        
 end procedure;

signal memory_ram : ramtype := load_ram(load_file_name);

begin                                                        

process (clk)                                                
begin                                                        
    if (rising_edge(clk)) then
        if rst = '0' then
            memory_ram <= load_ram(load_file_name);
        end if;
        if dump = '1' then
            dump_ram(dump_file_name, memory_ram);
        end if;     
        if rw_a = '1' then                                             
            memory_ram(to_integer(unsigned(address_a))) <= data_in_a;         
      end if;                                                      
        data_out_a <= memory_ram(to_integer(unsigned(address_a)));      
        if rw_b = '1' then
            memory_ram(to_integer(unsigned(address_b))) <= data_in_b;
        end if;
        data_out_b <= memory_ram(to_integer(unsigned(address_b)));
    end if;
    end process;          

end file_load;                                                   

