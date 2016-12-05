----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    small_montgomery_processor_3_with_mem
-- Module Name:    small_montgomery_processor_3_with_mem
-- Project Name:   Montgomery processor
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- Montgomery multiplication processor circuit version 3 with the memory module.
-- This circuit is exactly the Small Montgomery processor 3, but added 
-- the two memory modules necessary. 
-- This is done so it is easier to change the memory modules.
--
-- The circuits parameters
-- 
-- memory_size :
--
-- The size of the two memories that is going to be used together in the circuit. 
--
-- multiplication_word_length :
--
-- The size of the multiplication word and the size of each memory word.
-- The size of the multiplication is the same as the multiplier in the DSP applied.
--
-- accumulation_word_length :
--
-- The size of the accumulator is the one applied in the DSP for the
-- addition process. 
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
--
-- small_montgomery_processor_3 Rev 1.0
-- synth_ram_triple Rev 1.0
-- register_nbits Rev 1.0
-- 
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity small_montgomery_processor_3_with_mem is
    Generic(
        memory_size : integer := 6;
        multiplication_word_length : integer := 17;
        accumulation_word_length : integer := 44
    );
    Port(
        rst : in STD_LOGIC;
        start : in STD_LOGIC;
        clk : in STD_LOGIC;
        instruction : in STD_LOGIC_VECTOR(2 downto 0);
        operands_size : in STD_LOGIC_VECTOR((memory_size - 2) downto 0);
        variable_a_position : in STD_LOGIC_VECTOR(1 downto 0);
        variable_b_position : in STD_LOGIC_VECTOR(1 downto 0);
        variable_p_position : in STD_LOGIC_VECTOR(1 downto 0);
        write_value : in STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
        address_write_value : in STD_LOGIC_VECTOR(memory_size downto 0);
        address_read_value : in STD_LOGIC_VECTOR(memory_size downto 0);
        write_enable_value : in STD_LOGIC;
        processor_free : out STD_LOGIC;
        read_value : out STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0)
    );
end small_montgomery_processor_3_with_mem;

architecture Behavioral of small_montgomery_processor_3_with_mem is

component small_montgomery_processor_3
    Generic(
        memory_size : integer := 6;
        multiplication_word_length : integer := 17;
        accumulation_word_length : integer := 44
    );
    Port(
        mem1_value_a : in STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
        mem1_value_b : in STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
        mem2_value_a : in STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
        mem2_value_b : in STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
        rst : in STD_LOGIC;
        start : in STD_LOGIC;
        clk : in STD_LOGIC;
        instruction : in STD_LOGIC_VECTOR(2 downto 0);
        operands_size : in STD_LOGIC_VECTOR((memory_size - 2) downto 0);
        variable_a_position : in STD_LOGIC_VECTOR(1 downto 0);
        variable_b_position : in STD_LOGIC_VECTOR(1 downto 0);
        variable_p_position : in STD_LOGIC_VECTOR(1 downto 0);
        mem1_write_enable_new_value : out STD_LOGIC;
        mem2_write_enable_new_value : out STD_LOGIC;
        processor_free : out STD_LOGIC;
        mem1_address_value_a : out STD_LOGIC_VECTOR((memory_size - 1) downto 0);
        mem1_address_value_b : out STD_LOGIC_VECTOR((memory_size - 1) downto 0);
        mem2_address_value_a : out STD_LOGIC_VECTOR((memory_size - 1) downto 0);
        mem2_address_value_b : out STD_LOGIC_VECTOR((memory_size - 1) downto 0);
        address_new_value : out STD_LOGIC_VECTOR((memory_size - 1) downto 0);
        new_value : out STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0)
    );
end component;

component synth_ram_triple
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
end component;

component register_nbits
    Generic (size : integer);
    Port (
        d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
        clk : in  STD_LOGIC;
        ce : in  STD_LOGIC;
        q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
    );
end component;

signal processor_mem1_value_a : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal processor_mem1_value_b : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal processor_mem2_value_a : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal processor_mem2_value_b : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal processor_instruction : STD_LOGIC_VECTOR(2 downto 0);
signal processor_operands_size : STD_LOGIC_VECTOR((memory_size - 2) downto 0);
signal processor_variable_a_position : STD_LOGIC_VECTOR(1 downto 0);
signal processor_variable_b_position : STD_LOGIC_VECTOR(1 downto 0);
signal processor_variable_p_position : STD_LOGIC_VECTOR(1 downto 0);
signal processor_mem1_write_enable_new_value : STD_LOGIC;
signal processor_mem2_write_enable_new_value : STD_LOGIC;
signal processor_processor_free : STD_LOGIC;
signal processor_mem1_address_value_a : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal processor_mem1_address_value_b : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal processor_mem2_address_value_a : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal processor_mem2_address_value_b : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal processor_address_new_value : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal processor_new_value : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal mem1_data_in : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal mem1_write_enable : STD_LOGIC;
signal mem1_address_out_a : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal mem1_address_out_b : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal mem1_address_in : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal mem1_data_out_a : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal mem1_data_out_b : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal mem2_data_in : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal mem2_write_enable : STD_LOGIC;
signal mem2_address_out_a : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal mem2_address_out_b : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal mem2_address_in : STD_LOGIC_VECTOR((memory_size - 1) downto 0);
signal mem2_data_out_a : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal mem2_data_out_b : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal write_register_d : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal write_register_q : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal read_register_d : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal read_register_q : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

begin

processor : small_montgomery_processor_3
    Generic Map(
        memory_size => memory_size,
        multiplication_word_length => multiplication_word_length,
        accumulation_word_length => accumulation_word_length
    )
    Port Map(
        mem1_value_a => processor_mem1_value_a,
        mem1_value_b => processor_mem1_value_b,
        mem2_value_a => processor_mem2_value_a,
        mem2_value_b => processor_mem2_value_b,
        rst => rst,
        start => start,
        clk => clk,
        instruction => processor_instruction,
        operands_size => processor_operands_size,
        variable_a_position => processor_variable_a_position,
        variable_b_position => processor_variable_b_position,
        variable_p_position => processor_variable_p_position,
        mem1_write_enable_new_value => processor_mem1_write_enable_new_value,
        mem2_write_enable_new_value => processor_mem2_write_enable_new_value,
        processor_free => processor_processor_free,
        mem1_address_value_a => processor_mem1_address_value_a,
        mem1_address_value_b => processor_mem1_address_value_b,
        mem2_address_value_a => processor_mem2_address_value_a,
        mem2_address_value_b => processor_mem2_address_value_b,
        address_new_value => processor_address_new_value,
        new_value => processor_new_value
    );

mem1 : synth_ram_triple
    Generic Map(
        ram_address_size => memory_size,
        ram_word_size => multiplication_word_length
    )
    Port Map(
        data_in => mem1_data_in,
        clk => clk,
        write_enable => mem1_write_enable,
        address_out_a => mem1_address_out_a,
        address_out_b => mem1_address_out_b,
        address_in => mem1_address_in,
        data_out_a => mem1_data_out_a,
        data_out_b => mem1_data_out_b
    );

mem2 : synth_ram_triple
    Generic Map(
        ram_address_size => memory_size,
        ram_word_size => multiplication_word_length
    )
    Port Map(
        data_in => mem2_data_in,
        clk => clk,
        write_enable => mem2_write_enable,
        address_out_a => mem2_address_out_a,
        address_out_b => mem2_address_out_b,
        address_in => mem2_address_in,
        data_out_a => mem2_data_out_a,
        data_out_b => mem2_data_out_b
    );

    
write_register : register_nbits
    Generic Map(size => multiplication_word_length)
    Port Map(
        d => write_register_d,
        clk => clk,
        ce => '1',
        q => write_register_q
    );

read_register : register_nbits
    Generic Map(size => multiplication_word_length)
    Port Map(
        d => read_register_d,
        clk => clk,
        ce => '1',
        q => read_register_q
    );

processor_mem1_value_a <= mem1_data_out_a;
processor_mem1_value_b <= mem1_data_out_b;
processor_mem2_value_a <= mem2_data_out_a;
processor_mem2_value_b <= mem2_data_out_b;
processor_instruction <= instruction;
processor_variable_a_position <= variable_a_position;
processor_variable_b_position <= variable_b_position;
processor_variable_p_position <= variable_p_position;
processor_operands_size <= operands_size;

write_register_d <= write_value;

mem1_data_in <= write_register_q when (processor_processor_free = '1') else
                    processor_new_value;

mem2_data_in <= write_register_q when (processor_processor_free = '1') else
                     processor_new_value;

mem1_write_enable <= write_enable_value when ((processor_processor_free = '1') and (address_write_value(memory_size) = '0')) else
                            processor_mem1_write_enable_new_value;

mem2_write_enable <= write_enable_value when ((processor_processor_free = '1') and (address_write_value(memory_size) = '1')) else
                            processor_mem2_write_enable_new_value;

mem1_address_out_a <= address_read_value((memory_size - 1) downto 0) when (processor_processor_free = '1') else
                     processor_mem1_address_value_a;
mem1_address_out_b <= address_read_value((memory_size - 1) downto 0) when (processor_processor_free = '1') else
                     processor_mem1_address_value_b;

mem2_address_out_a <= address_read_value((memory_size - 1) downto 0) when (processor_processor_free = '1') else
                     processor_mem2_address_value_a;
mem2_address_out_b <= address_read_value((memory_size - 1) downto 0) when (processor_processor_free = '1') else
                     processor_mem2_address_value_b;

mem1_address_in <= address_write_value((memory_size - 1) downto 0) when (processor_processor_free = '1') else
                            processor_address_new_value;

mem2_address_in <= address_write_value((memory_size - 1) downto 0) when (processor_processor_free = '1') else
                            processor_address_new_value;

processor_free <= processor_processor_free;

read_register_d <= mem2_data_out_b when (address_read_value(memory_size) = '1') else
                            mem1_data_out_b;
read_value <= read_register_q;

end Behavioral;

