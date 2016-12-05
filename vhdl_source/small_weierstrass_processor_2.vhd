----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    small_weierstrass_processor_2
-- Module Name:    small_weierstrass_processor_2
-- Project Name:   Weierstrass processor
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- Small Weierstrass processor version number 2.
-- This version is made to be used together with the Montgomery processor version 3.
-- This processor works with 2 main control systems, one is the memory transfer.
-- The other is the main state machine controller. 
-- The processor is able to do scalar multiplication of projective points and 
-- reply in affine coordinates.
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
-- The size of the accumulator that is applied in the DSP for the
-- addition process. 
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
--
-- control_small_weierstrass_processor_2 Rev 1.0
-- memory_tranfer_unit_small_weierstrass_processor Rev 1.0
-- small_montgomery_processor_3_with_mem Rev 1.0
-- synth_double_ram Rev 1.0
-- register_rst_nbits Rev 1.0
-- counter_rst_nbits Rev 1.0
-- counter_load_rst_nbits Rev 1.0
-- counter_decrement_load_rst_nbits Rev 1.0
-- counter_rst_limit_nbits Rev 1.0
-- shift_register_load_nbits Rev 1.0
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

entity small_weierstrass_processor_2 is
    Generic(
        internal_memory_size : integer := 10;
        scalar_max_size : integer := 10;
        word_length : integer := 17;
        word_length_size : integer := 5;
        montgomery_multiplier_memory_size : integer := 7;
        montgomery_accumulation_word_length : integer := 44
    );
    Port(
        rst : in STD_LOGIC;
        clk : in STD_LOGIC;
        start : in STD_LOGIC;
        prime_size : in STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 3) downto 0);
        scalar_size : in STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0);
        write_value : in STD_LOGIC_VECTOR((word_length - 1) downto 0);
        address_value : in STD_LOGIC_VECTOR((internal_memory_size - 1) downto 0);
        write_enable_value : in STD_LOGIC;
        processor_free : out STD_LOGIC;
        finish_pre_processing : out STD_LOGIC;
        finish_point_addition : out STD_LOGIC;
        finish_scalar_multiplication : out STD_LOGIC;
        finish_final_processing : out STD_LOGIC;
        read_value : out STD_LOGIC_VECTOR((word_length - 1) downto 0)
    );
end small_weierstrass_processor_2;

architecture Behavioral of small_weierstrass_processor_2 is

component control_small_weierstrass_processor_2
    Generic (
        internal_memory_size : integer := 10;
        word_length : integer := 17;
        montgomery_multiplier_memory_size : integer := 7
    );
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        start : in STD_LOGIC;
        montgomery_processor_0_processor_free : in STD_LOGIC;
        montgomery_processor_1_processor_free : in STD_LOGIC;
        montgomery_processor_2_processor_free : in STD_LOGIC;
        reg_comparison_a_equal_b : in STD_LOGIC;
        ctr_scalar_word_shifter_limit : in STD_LOGIC;
        memory_transfer_unit_free : in STD_LOGIC;
        scalar_bit : in STD_LOGIC;
        state_machine_free : out STD_LOGIC;
        state_machine_finish_pre_processing : out STD_LOGIC;
        state_machine_finish_point_addition : out STD_LOGIC;
        state_machine_finish_scalar_multiplication : out STD_LOGIC;
        state_machine_finish_final_processing : out STD_LOGIC;
        memory_tranfer_unit_instruction : out STD_LOGIC_VECTOR(1 downto 0);
        memory_tranfer_unit_continue_transfering : out STD_LOGIC;
        memory_tranfer_unit_montgomery_unit_0_enable : out STD_LOGIC;
        memory_tranfer_unit_montgomery_unit_1_enable : out STD_LOGIC;
        memory_tranfer_unit_montgomery_unit_2_enable : out STD_LOGIC;
        memory_tranfer_unit_enable_internal_memory_a : out STD_LOGIC;
        memory_tranfer_unit_enable_internal_memory_b : out STD_LOGIC;
        memory_tranfer_unit_enable_value_injection_a : out STD_LOGIC;
        memory_tranfer_unit_enable_value_injection_b : out STD_LOGIC;
        memory_tranfer_unit_value_injection_a : out STD_LOGIC_VECTOR((word_length - 1) downto 0);
        memory_tranfer_unit_value_injection_b : out STD_LOGIC_VECTOR((word_length - 1) downto 0);
        memory_tranfer_unit_internal_memory_address_a : out STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
        memory_tranfer_unit_internal_memory_address_b : out STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
        memory_tranfer_unit_montomery_unit_0_address : out STD_LOGIC_VECTOR(1 downto 0);
        memory_tranfer_unit_montomery_unit_1_2_address : out STD_LOGIC_VECTOR(1 downto 0);
        montgomery_processor_0_start : out STD_LOGIC;
        montgomery_processor_0_instruction : out STD_LOGIC_VECTOR(2 downto 0);
        montgomery_processor_0_variable_a_position : out STD_LOGIC_VECTOR(1 downto 0);
        montgomery_processor_0_variable_b_position : out STD_LOGIC_VECTOR(1 downto 0);
        montgomery_processor_0_variable_p_position : out STD_LOGIC_VECTOR(1 downto 0);
        montgomery_processor_1_start : out STD_LOGIC;
        montgomery_processor_1_instruction : out STD_LOGIC_VECTOR(2 downto 0);
        montgomery_processor_1_variable_a_position : out STD_LOGIC_VECTOR(1 downto 0);
        montgomery_processor_1_variable_b_position : out STD_LOGIC_VECTOR(1 downto 0);
        montgomery_processor_1_variable_p_position : out STD_LOGIC_VECTOR(1 downto 0);
        montgomery_processor_2_start : out STD_LOGIC;
        montgomery_processor_2_instruction : out STD_LOGIC_VECTOR(2 downto 0);
        montgomery_processor_2_variable_a_position : out STD_LOGIC_VECTOR(1 downto 0);
        montgomery_processor_2_variable_b_position : out STD_LOGIC_VECTOR(1 downto 0);
        montgomery_processor_2_variable_p_position : out STD_LOGIC_VECTOR(1 downto 0);
        local_shifter_ce : out STD_LOGIC;
        local_shifter_load : out STD_LOGIC;
        reg_prime_size_ce : out STD_LOGIC;
        ctr_scalar_size_ce : out STD_LOGIC;
        ctr_scalar_size_load : out STD_LOGIC;
        reg_scalar_word_address_ce : out STD_LOGIC;
        reg_scalar_word_address_rst : out STD_LOGIC;
        ctr_scalar_word_shifter_ce : out STD_LOGIC;
        ctr_scalar_word_shifter_rst : out STD_LOGIC;
        reg_comparison_a_rst : out STD_LOGiC;
        reg_comparison_b_rst : out STD_LOGiC;
        sel_comparison_scalar : out STD_LOGIC;
        sel_inversion_mode : out STD_LOGIC
    );
end component;

component memory_tranfer_unit_small_weierstrass_processor
    Generic (
        internal_memory_size : integer := 10;
        word_length : integer := 17;
        montgomery_multiplier_memory_size : integer := 7
    );
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        instruction : in STD_LOGIC_VECTOR(1 downto 0);
        continue_transfering : in STD_LOGIC;
        montgomery_unit_0_enable : in STD_LOGIC;
        montgomery_unit_1_enable : in STD_LOGIC;
        montgomery_unit_2_enable : in STD_LOGIC;
        enable_internal_memory_a : in STD_LOGIC;
        enable_internal_memory_b : in STD_LOGIC;
        enable_value_injection_a : in STD_LOGIC;
        enable_value_injection_b : in STD_LOGIC;
        value_injection_a : in STD_LOGIC_VECTOR((word_length - 1) downto 0);
        value_injection_b : in STD_LOGIC_VECTOR((word_length - 1) downto 0);
        internal_memory_address_a : in STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
        internal_memory_address_b : in STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
        montomery_unit_0_address : in STD_LOGIC_VECTOR(1 downto 0);
        montomery_unit_1_2_address : in STD_LOGIC_VECTOR(1 downto 0);
        reg_comparison_a_equal_b : in STD_LOGIC;
        montgomery_processor_0_processor_free : in STD_LOGIC;
        montgomery_processor_1_processor_free : in STD_LOGIC;
        montgomery_processor_2_processor_free : in STD_LOGIC;
        memory_transfer_unit_free : out STD_LOGIC;
        internal_memory_rw_a : out STD_LOGIC;
        internal_memory_rw_b : out STD_LOGIC;
        montgomery_processor_0_write_enable_value : out STD_LOGIC;
        montgomery_processor_1_write_enable_value : out STD_LOGIC;
        montgomery_processor_2_write_enable_value : out STD_LOGIC;
        value_injection_mem : out STD_LOGIC_VECTOR((word_length - 1) downto 0);
        sel_value_injection_mem : out STD_LOGIC;
        value_injection_data_a : out STD_LOGIC_VECTOR((word_length - 1) downto 0);
        sel_value_injection_a : out STD_LOGIC;
        value_injection_data_b : out STD_LOGIC_VECTOR((word_length - 1) downto 0);
        sel_value_injection_b : out STD_LOGIC;
        state_machine_internal_memory_address_variable_a : out STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
        reg_address_variable_a_ce : out STD_LOGIC;
        state_machine_internal_memory_address_variable_b : out STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
        reg_address_variable_b_ce : out STD_LOGIC;
        ctr_address_variable_ce : out STD_LOGIC;
        ctr_address_variable_load : out STD_LOGIC;
        ctr_address_variable_rst : out STD_LOGIC;
        reg_read_address_montgomery_unit_0_d : out STD_LOGIC_VECTOR(1 downto 0);
        reg_write_address_montgomery_unit_0_d : out STD_LOGIC_VECTOR(1 downto 0);
        reg_address_montgomery_unit_0_ce : out STD_LOGIC;
        reg_read_address_montgomery_unit_1_2_d : out STD_LOGIC_VECTOR(1 downto 0);
        reg_write_address_montgomery_unit_1_2_d : out STD_LOGIC_VECTOR(1 downto 0);
        reg_address_montgomery_unit_1_2_ce : out STD_LOGIC;
        ctr_address_montgomery_unit_ce : out STD_LOGIC;
        ctr_address_montgomery_unit_rst : out STD_LOGIC;
        sel_read_montgomery_processor_1 : out STD_LOGIC
    );
end component;

component small_montgomery_processor_3_with_mem
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
end component;

component synth_double_ram
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
end component;

component register_rst_nbits
    Generic (size : integer);
    Port (
        d : in  STD_LOGIC_VECTOR((size - 1) downto 0);
        clk : in  STD_LOGIC;
        ce : in  STD_LOGIC;
        rst : in  STD_LOGIC;
        rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);
        q : out  STD_LOGIC_VECTOR((size - 1) downto 0)
    );
end component;

component counter_rst_nbits
    Generic (
        size : integer;
        increment_value : integer
    );
    Port (
        clk : in  STD_LOGIC;
        ce : in  STD_LOGIC;
        rst : in STD_LOGIC;
        rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
        q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
    );
end component;

component counter_load_rst_nbits
    Generic (
        size : integer;
        increment_value : integer
    );
    Port (
        d : in STD_LOGIC_VECTOR((size - 1) downto 0);
        clk : in STD_LOGIC;
        load : in STD_LOGIC;
        ce : in STD_LOGIC;
        rst : in STD_LOGIC;
        rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);
        q : out  STD_LOGIC_VECTOR((size - 1) downto 0)
    );
end component;

component counter_decrement_load_rst_nbits
    Generic (
        size : integer;
        decrement_value : integer
    );
    Port (
        d : in STD_LOGIC_VECTOR((size - 1) downto 0);
        clk : in STD_LOGIC;
        load : in STD_LOGIC;
        ce : in STD_LOGIC;
        rst : in STD_LOGIC;
        rst_value : in STD_LOGIC_VECTOR((size - 1) downto 0);
        q : out  STD_LOGIC_VECTOR((size - 1) downto 0)
    );
end component;

component counter_rst_limit_nbits
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
end component;

component shift_register_load_nbits
    Generic (size : integer);
    Port (
        d : in STD_LOGIC_VECTOR ((size - 1) downto 0);
        data_in : in STD_LOGIC;
        clk : in  STD_LOGIC;
        ce : in  STD_LOGIC;
        load : in STD_LOGIC;
        q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
    );
end component;

signal internal_memory_data_in_a : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal internal_memory_data_in_b : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal internal_memory_rw_a : STD_LOGIC;
signal internal_memory_rw_b : STD_LOGIC;
signal internal_memory_address_a : STD_LOGIC_VECTOR((internal_memory_size - 1) downto 0);
signal internal_memory_address_b : STD_LOGIC_VECTOR((internal_memory_size - 1) downto 0);
signal internal_memory_data_out_a : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal internal_memory_data_out_b : STD_LOGIC_VECTOR((word_length - 1) downto 0);

signal montgomery_processor_0_start : STD_LOGIC;
signal montgomery_processor_0_instruction : STD_LOGIC_VECTOR(2 downto 0);
signal montgomery_processor_0_operands_size : STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 3) downto 0);
signal montgomery_processor_0_variable_a_position : STD_LOGIC_VECTOR(1 downto 0);
signal montgomery_processor_0_variable_b_position : STD_LOGIC_VECTOR(1 downto 0);
signal montgomery_processor_0_variable_p_position : STD_LOGIC_VECTOR(1 downto 0);
signal montgomery_processor_0_write_value : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal montgomery_processor_0_address_write_value : STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 1) downto 0);
signal montgomery_processor_0_address_read_value : STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 1) downto 0);
signal montgomery_processor_0_write_enable_value : STD_LOGIC;
signal montgomery_processor_0_processor_free : STD_LOGIC;
signal montgomery_processor_0_read_value : STD_LOGIC_VECTOR((word_length - 1) downto 0);

signal montgomery_processor_1_start : STD_LOGIC;
signal montgomery_processor_1_instruction : STD_LOGIC_VECTOR(2 downto 0);
signal montgomery_processor_1_operands_size : STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 3) downto 0);
signal montgomery_processor_1_variable_a_position : STD_LOGIC_VECTOR(1 downto 0);
signal montgomery_processor_1_variable_b_position : STD_LOGIC_VECTOR(1 downto 0);
signal montgomery_processor_1_variable_p_position : STD_LOGIC_VECTOR(1 downto 0);
signal montgomery_processor_1_write_value : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal montgomery_processor_1_address_write_value : STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 1) downto 0);
signal montgomery_processor_1_address_read_value : STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 1) downto 0);
signal montgomery_processor_1_write_enable_value : STD_LOGIC;
signal montgomery_processor_1_processor_free : STD_LOGIC;
signal montgomery_processor_1_read_value : STD_LOGIC_VECTOR((word_length - 1) downto 0);
    
signal montgomery_processor_2_start : STD_LOGIC;
signal montgomery_processor_2_instruction : STD_LOGIC_VECTOR(2 downto 0);
signal montgomery_processor_2_operands_size : STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 3) downto 0);
signal montgomery_processor_2_variable_a_position : STD_LOGIC_VECTOR(1 downto 0);
signal montgomery_processor_2_variable_b_position : STD_LOGIC_VECTOR(1 downto 0);
signal montgomery_processor_2_variable_p_position : STD_LOGIC_VECTOR(1 downto 0);
signal montgomery_processor_2_write_value : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal montgomery_processor_2_address_write_value : STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 1) downto 0);
signal montgomery_processor_2_address_read_value : STD_LOGIC_VECTOR((montgomery_multiplier_memory_size - 1) downto 0);
signal montgomery_processor_2_write_enable_value : STD_LOGIC;
signal montgomery_processor_2_processor_free : STD_LOGIC;
signal montgomery_processor_2_read_value : STD_LOGIC_VECTOR((word_length - 1) downto 0);
    
signal reg_internal_memory_in_a_d : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal reg_internal_memory_in_a_ce : STD_LOGIC;
signal reg_internal_memory_in_a_rst : STD_LOGIC;
constant reg_internal_memory_in_a_rst_value : STD_LOGIC_VECTOR((word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, word_length));
signal reg_internal_memory_in_a_q : STD_LOGIC_VECTOR((word_length - 1) downto 0);

signal reg_internal_memory_in_b_d : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal reg_internal_memory_in_b_ce : STD_LOGIC;
signal reg_internal_memory_in_b_rst : STD_LOGIC;
constant reg_internal_memory_in_b_rst_value : STD_LOGIC_VECTOR((word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, word_length));
signal reg_internal_memory_in_b_q : STD_LOGIC_VECTOR((word_length - 1) downto 0);
    
signal reg_internal_memory_out_a_d : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal reg_internal_memory_out_a_ce : STD_LOGIC;
signal reg_internal_memory_out_a_rst : STD_LOGIC;
constant reg_internal_memory_out_a_rst_value : STD_LOGIC_VECTOR((word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, word_length));
signal reg_internal_memory_out_a_q : STD_LOGIC_VECTOR((word_length - 1) downto 0);

signal reg_internal_memory_out_b_d : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal reg_internal_memory_out_b_ce : STD_LOGIC;
signal reg_internal_memory_out_b_rst : STD_LOGIC;
constant reg_internal_memory_out_b_rst_value : STD_LOGIC_VECTOR((word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, word_length));
signal reg_internal_memory_out_b_q : STD_LOGIC_VECTOR((word_length - 1) downto 0);
    
signal local_shifter_d : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal local_shifter_data_in : STD_LOGIC;
signal local_shifter_ce : STD_LOGIC;
signal local_shifter_load : STD_LOGIC;
signal local_shifter_q : STD_LOGIC_VECTOR((word_length - 1) downto 0);

signal reg_read_address_montgomery_unit_0_d : STD_LOGIC_VECTOR(1 downto 0);
signal reg_read_address_montgomery_unit_0_ce : STD_LOGIC;
signal reg_read_address_montgomery_unit_0_rst : STD_LOGIC;
constant reg_read_address_montgomery_unit_0_rst_value : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal reg_read_address_montgomery_unit_0_q : STD_LOGIC_VECTOR(1 downto 0);

signal reg_write_address_montgomery_unit_0_d : STD_LOGIC_VECTOR(1 downto 0);
signal reg_write_address_montgomery_unit_0_ce : STD_LOGIC;
signal reg_write_address_montgomery_unit_0_rst : STD_LOGIC;
constant reg_write_address_montgomery_unit_0_rst_value : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal reg_write_address_montgomery_unit_0_q : STD_LOGIC_VECTOR(1 downto 0);

signal reg_address_montgomery_unit_0_ce : STD_LOGIC;

signal reg_read_address_montgomery_unit_1_2_d : STD_LOGIC_VECTOR(1 downto 0);
signal reg_read_address_montgomery_unit_1_2_ce : STD_LOGIC;
signal reg_read_address_montgomery_unit_1_2_rst : STD_LOGIC;
constant reg_read_address_montgomery_unit_1_2_rst_value : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal reg_read_address_montgomery_unit_1_2_q : STD_LOGIC_VECTOR(1 downto 0);
    
signal reg_write_address_montgomery_unit_1_2_d : STD_LOGIC_VECTOR(1 downto 0);
signal reg_write_address_montgomery_unit_1_2_ce : STD_LOGIC;
signal reg_write_address_montgomery_unit_1_2_rst : STD_LOGIC;
constant reg_write_address_montgomery_unit_1_2_rst_value : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal reg_write_address_montgomery_unit_1_2_q : STD_LOGIC_VECTOR(1 downto 0);

signal reg_address_montgomery_unit_1_2_ce : STD_LOGIC;

signal ctr_address_montgomery_unit_ce : STD_LOGIC;
signal ctr_address_montgomery_unit_rst : STD_LOGIC;
constant ctr_address_montgomery_unit_rst_value : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 2) - 1) downto 0) := std_logic_vector(to_unsigned(0, (montgomery_multiplier_memory_size - 2)));
signal ctr_address_montgomery_unit_q : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 2) - 1) downto 0);
    
signal reg_address_variable_a_d : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
signal reg_address_variable_a_ce : STD_LOGIC;
signal reg_address_variable_a_rst : STD_LOGIC;
constant reg_address_variable_a_rst_value : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(0, internal_memory_size - (montgomery_multiplier_memory_size - 2)));
signal reg_address_variable_a_q : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
    
signal reg_address_variable_b_d : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
signal reg_address_variable_b_ce : STD_LOGIC;
signal reg_address_variable_b_rst : STD_LOGIC;
constant reg_address_variable_b_rst_value : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(0, internal_memory_size - (montgomery_multiplier_memory_size - 2)));
signal reg_address_variable_b_q : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);

signal ctr_address_variable_d : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 2) - 1) downto 0);
signal ctr_address_variable_ce : STD_LOGIC;
signal ctr_address_variable_load : STD_LOGIC;
signal ctr_address_variable_rst : STD_LOGIC;
constant ctr_address_variable_rst_value : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 2) - 1) downto 0) := std_logic_vector(to_unsigned(0, (montgomery_multiplier_memory_size - 2)));
signal ctr_address_variable_q : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 2) - 1) downto 0);

signal reg_prime_size_d : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 2) - 1) downto 0);
signal reg_prime_size_ce : STD_LOGIC;
signal reg_prime_size_rst : STD_LOGIC;
constant reg_prime_size_rst_value : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 2) - 1) downto 0) := std_logic_vector(to_unsigned(0, (montgomery_multiplier_memory_size - 2)));
signal reg_prime_size_q : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 2) - 1) downto 0);
    
signal ctr_scalar_size_d : STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0);
signal ctr_scalar_size_ce : STD_LOGIC;
signal ctr_scalar_size_rst : STD_LOGIC;
signal ctr_scalar_size_load : STD_LOGIC;
constant ctr_scalar_size_rst_value : STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0) := std_logic_vector(to_unsigned(0, scalar_max_size));
signal ctr_scalar_size_q : STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0);

signal reg_scalar_word_address_d : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 1) - 1) downto 0);
signal reg_scalar_word_address_ce : STD_LOGIC;
signal reg_scalar_word_address_rst : STD_LOGIC;
constant reg_scalar_word_address_rst_value : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 1) - 1) downto 0) := std_logic_vector(to_unsigned(0, (montgomery_multiplier_memory_size - 1)));
signal reg_scalar_word_address_q : STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 1) - 1) downto 0);

constant reg_scalar_word_increment :  STD_LOGIC_VECTOR(((montgomery_multiplier_memory_size - 2) - 1) downto 0) := (others => '1');

signal ctr_scalar_word_shifter_ce : STD_LOGIC;
signal ctr_scalar_word_shifter_rst : STD_LOGIC;
constant ctr_scalar_word_shifter_rst_value : STD_LOGIC_VECTOR((word_length_size - 1) downto 0) := std_logic_vector(to_unsigned(word_length, word_length_size));
signal ctr_scalar_word_shifter_limit : STD_LOGIC;

signal reg_comparison_a_d : STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0);
signal reg_comparison_a_ce : STD_LOGIC;
signal reg_comparison_a_rst : STD_LOGIC;
constant reg_comparison_a_rst_value : STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0) := std_logic_vector(to_unsigned(0, scalar_max_size));
signal reg_comparison_a_q : STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0);
    
signal reg_comparison_b_d : STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0);
signal reg_comparison_b_ce : STD_LOGIC;
signal reg_comparison_b_rst : STD_LOGIC;
constant reg_comparison_b_rst_value : STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0) := std_logic_vector(to_unsigned(0, scalar_max_size));
signal reg_comparison_b_q : STD_LOGIC_VECTOR((scalar_max_size - 1) downto 0);

signal reg_comparison_a_equal_b_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_comparison_a_equal_b_ce : STD_LOGIC;
signal reg_comparison_a_equal_b_rst : STD_LOGIC;
constant reg_comparison_a_equal_b_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_comparison_a_equal_b_q : STD_LOGIC_VECTOR(0 downto 0);

signal memory_tranfer_unit_instruction : STD_LOGIC_VECTOR(1 downto 0);
signal memory_tranfer_unit_continue_transfering : STD_LOGIC;
signal memory_tranfer_unit_montgomery_unit_0_enable : STD_LOGIC;
signal memory_tranfer_unit_montgomery_unit_1_enable : STD_LOGIC;
signal memory_tranfer_unit_montgomery_unit_2_enable : STD_LOGIC;
signal memory_tranfer_unit_enable_internal_memory_a : STD_LOGIC;
signal memory_tranfer_unit_enable_internal_memory_b : STD_LOGIC;
signal memory_tranfer_unit_enable_value_injection_a : STD_LOGIC;
signal memory_tranfer_unit_enable_value_injection_b : STD_LOGIC;
signal memory_tranfer_unit_value_injection_a : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal memory_tranfer_unit_value_injection_b : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal memory_tranfer_unit_internal_memory_address_a : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
signal memory_tranfer_unit_internal_memory_address_b : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
signal memory_tranfer_unit_montomery_unit_0_address : STD_LOGIC_VECTOR(1 downto 0);
signal memory_tranfer_unit_montomery_unit_1_2_address : STD_LOGIC_VECTOR(1 downto 0);

signal memory_transfer_unit_free : STD_LOGIC;

signal state_machine_internal_memory_rw_a : STD_LOGIC;
signal state_machine_internal_memory_rw_b : STD_LOGIC;
signal state_machine_internal_memory_address_variable_a : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
signal state_machine_internal_memory_address_variable_b : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);


signal value_injection_mem : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal sel_value_injection_mem : STD_LOGIC;

signal value_injection_data_a : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal sel_value_injection_a : STD_LOGIC;

signal value_injection_data_b : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal sel_value_injection_b : STD_LOGIC;

signal sel_read_montgomery_processor_1 : STD_LOGIC;

signal sel_comparison_scalar : STD_LOGIC;
signal sel_inversion_mode : STD_LOGIC;

signal state_machine_free : STD_LOGIC;


begin

state_machine : control_small_weierstrass_processor_2
    Generic Map(
        internal_memory_size => internal_memory_size,
        word_length => word_length,
        montgomery_multiplier_memory_size => montgomery_multiplier_memory_size
    )
    Port Map(
        clk => clk,
        rst => rst,
        start => start,
        montgomery_processor_0_processor_free => montgomery_processor_0_processor_free,
        montgomery_processor_1_processor_free => montgomery_processor_1_processor_free,
        montgomery_processor_2_processor_free => montgomery_processor_2_processor_free,
        reg_comparison_a_equal_b => reg_comparison_a_equal_b_q(0),
        ctr_scalar_word_shifter_limit => ctr_scalar_word_shifter_limit,
        memory_transfer_unit_free => memory_transfer_unit_free,
        scalar_bit => local_shifter_q(0),
        state_machine_free => state_machine_free,
        state_machine_finish_pre_processing => finish_pre_processing,
        state_machine_finish_point_addition => finish_point_addition,
        state_machine_finish_scalar_multiplication => finish_scalar_multiplication,
        state_machine_finish_final_processing => finish_final_processing,
        memory_tranfer_unit_instruction => memory_tranfer_unit_instruction,
        memory_tranfer_unit_continue_transfering => memory_tranfer_unit_continue_transfering,
        memory_tranfer_unit_montgomery_unit_0_enable => memory_tranfer_unit_montgomery_unit_0_enable,
        memory_tranfer_unit_montgomery_unit_1_enable => memory_tranfer_unit_montgomery_unit_1_enable,
        memory_tranfer_unit_montgomery_unit_2_enable => memory_tranfer_unit_montgomery_unit_2_enable,
        memory_tranfer_unit_enable_internal_memory_a => memory_tranfer_unit_enable_internal_memory_a,
        memory_tranfer_unit_enable_internal_memory_b => memory_tranfer_unit_enable_internal_memory_b,
        memory_tranfer_unit_enable_value_injection_a => memory_tranfer_unit_enable_value_injection_a,
        memory_tranfer_unit_enable_value_injection_b => memory_tranfer_unit_enable_value_injection_b,
        memory_tranfer_unit_value_injection_a => memory_tranfer_unit_value_injection_a,
        memory_tranfer_unit_value_injection_b => memory_tranfer_unit_value_injection_b,
        memory_tranfer_unit_internal_memory_address_a => memory_tranfer_unit_internal_memory_address_a,
        memory_tranfer_unit_internal_memory_address_b => memory_tranfer_unit_internal_memory_address_b,
        memory_tranfer_unit_montomery_unit_0_address => memory_tranfer_unit_montomery_unit_0_address,
        memory_tranfer_unit_montomery_unit_1_2_address => memory_tranfer_unit_montomery_unit_1_2_address,
        montgomery_processor_0_start => montgomery_processor_0_start,
        montgomery_processor_0_instruction => montgomery_processor_0_instruction,
        montgomery_processor_0_variable_a_position => montgomery_processor_0_variable_a_position,
        montgomery_processor_0_variable_b_position => montgomery_processor_0_variable_b_position,
        montgomery_processor_0_variable_p_position => montgomery_processor_0_variable_p_position,
        montgomery_processor_1_start => montgomery_processor_1_start,
        montgomery_processor_1_instruction => montgomery_processor_1_instruction,
        montgomery_processor_1_variable_a_position => montgomery_processor_1_variable_a_position,
        montgomery_processor_1_variable_b_position => montgomery_processor_1_variable_b_position,
        montgomery_processor_1_variable_p_position => montgomery_processor_1_variable_p_position,
        montgomery_processor_2_start => montgomery_processor_2_start,
        montgomery_processor_2_instruction => montgomery_processor_2_instruction,
        montgomery_processor_2_variable_a_position => montgomery_processor_2_variable_a_position,
        montgomery_processor_2_variable_b_position => montgomery_processor_2_variable_b_position,
        montgomery_processor_2_variable_p_position => montgomery_processor_2_variable_p_position,
        local_shifter_ce => local_shifter_ce,
        local_shifter_load => local_shifter_load,
        reg_prime_size_ce => reg_prime_size_ce,
        ctr_scalar_size_ce => ctr_scalar_size_ce,
        ctr_scalar_size_load => ctr_scalar_size_load,
        reg_scalar_word_address_ce => reg_scalar_word_address_ce,
        reg_scalar_word_address_rst => reg_scalar_word_address_rst,
        ctr_scalar_word_shifter_ce => ctr_scalar_word_shifter_ce,
        ctr_scalar_word_shifter_rst => ctr_scalar_word_shifter_rst,
        reg_comparison_a_rst => reg_comparison_a_rst,
        reg_comparison_b_rst => reg_comparison_b_rst,
        sel_comparison_scalar => sel_comparison_scalar,
        sel_inversion_mode => sel_inversion_mode
    );
    
memory_tranfer_unit : memory_tranfer_unit_small_weierstrass_processor
    Generic Map(
        internal_memory_size => internal_memory_size,
        word_length => word_length,
        montgomery_multiplier_memory_size => montgomery_multiplier_memory_size
    )
    Port Map(
        clk => clk,
        rst => rst,
        instruction => memory_tranfer_unit_instruction,
        continue_transfering => memory_tranfer_unit_continue_transfering,
        montgomery_unit_0_enable => memory_tranfer_unit_montgomery_unit_0_enable,
        montgomery_unit_1_enable => memory_tranfer_unit_montgomery_unit_1_enable,
        montgomery_unit_2_enable => memory_tranfer_unit_montgomery_unit_2_enable,
        enable_internal_memory_a => memory_tranfer_unit_enable_internal_memory_a,
        enable_internal_memory_b => memory_tranfer_unit_enable_internal_memory_b,
        enable_value_injection_a => memory_tranfer_unit_enable_value_injection_a,
        enable_value_injection_b => memory_tranfer_unit_enable_value_injection_b,
        value_injection_a => memory_tranfer_unit_value_injection_a,
        value_injection_b => memory_tranfer_unit_value_injection_b,
        internal_memory_address_a => memory_tranfer_unit_internal_memory_address_a,
        internal_memory_address_b => memory_tranfer_unit_internal_memory_address_b,
        montomery_unit_0_address => memory_tranfer_unit_montomery_unit_0_address,
        montomery_unit_1_2_address => memory_tranfer_unit_montomery_unit_1_2_address,
        reg_comparison_a_equal_b => reg_comparison_a_equal_b_q(0),
        montgomery_processor_0_processor_free => montgomery_processor_0_processor_free,
        montgomery_processor_1_processor_free => montgomery_processor_1_processor_free,
        montgomery_processor_2_processor_free => montgomery_processor_2_processor_free,
        memory_transfer_unit_free => memory_transfer_unit_free,
        internal_memory_rw_a => state_machine_internal_memory_rw_a,
        internal_memory_rw_b => state_machine_internal_memory_rw_b,
        montgomery_processor_0_write_enable_value => montgomery_processor_0_write_enable_value,
        montgomery_processor_1_write_enable_value => montgomery_processor_1_write_enable_value,
        montgomery_processor_2_write_enable_value => montgomery_processor_2_write_enable_value,
        value_injection_mem => value_injection_mem,
        sel_value_injection_mem => sel_value_injection_mem,
        value_injection_data_a => value_injection_data_a,
        sel_value_injection_a => sel_value_injection_a,
        value_injection_data_b => value_injection_data_b,
        sel_value_injection_b => sel_value_injection_b,
        state_machine_internal_memory_address_variable_a => state_machine_internal_memory_address_variable_a,
        reg_address_variable_a_ce => reg_address_variable_a_ce,
        state_machine_internal_memory_address_variable_b => state_machine_internal_memory_address_variable_b,
        reg_address_variable_b_ce => reg_address_variable_b_ce,
        ctr_address_variable_ce => ctr_address_variable_ce,
        ctr_address_variable_load => ctr_address_variable_load,
        ctr_address_variable_rst => ctr_address_variable_rst,
        reg_read_address_montgomery_unit_0_d => reg_read_address_montgomery_unit_0_d,
        reg_write_address_montgomery_unit_0_d => reg_write_address_montgomery_unit_0_d,
        reg_address_montgomery_unit_0_ce => reg_address_montgomery_unit_0_ce,
        reg_read_address_montgomery_unit_1_2_d => reg_read_address_montgomery_unit_1_2_d,
        reg_write_address_montgomery_unit_1_2_d => reg_write_address_montgomery_unit_1_2_d,
        reg_address_montgomery_unit_1_2_ce => reg_address_montgomery_unit_1_2_ce,
        ctr_address_montgomery_unit_ce => ctr_address_montgomery_unit_ce,
        ctr_address_montgomery_unit_rst => ctr_address_montgomery_unit_rst,
        sel_read_montgomery_processor_1 => sel_read_montgomery_processor_1
    );

internal_memory : synth_double_ram
    Generic Map(
        ram_address_size => internal_memory_size,
        ram_word_size => word_length
    )
    Port Map(
        data_in_a => internal_memory_data_in_a,
        data_in_b => internal_memory_data_in_b,
        rw_a => internal_memory_rw_a,
        rw_b => internal_memory_rw_b,
        clk => clk,
        address_a => internal_memory_address_a,
        address_b => internal_memory_address_b,
        data_out_a => internal_memory_data_out_a,
        data_out_b => internal_memory_data_out_b
    );

montgomery_processor_0 : small_montgomery_processor_3_with_mem
    Generic Map(
        memory_size => montgomery_multiplier_memory_size - 1,
        multiplication_word_length => word_length,
        accumulation_word_length => montgomery_accumulation_word_length
    )
    Port Map(
        rst => rst,
        start => montgomery_processor_0_start,
        clk => clk,
        instruction => montgomery_processor_0_instruction,
        operands_size => montgomery_processor_0_operands_size,
        variable_a_position => montgomery_processor_0_variable_a_position,
        variable_b_position => montgomery_processor_0_variable_b_position,
        variable_p_position => montgomery_processor_0_variable_p_position,
        write_value => montgomery_processor_0_write_value,
        address_write_value => montgomery_processor_0_address_write_value,
        address_read_value => montgomery_processor_0_address_read_value,
        write_enable_value => montgomery_processor_0_write_enable_value,
        processor_free => montgomery_processor_0_processor_free,
        read_value => montgomery_processor_0_read_value
    );
    
montgomery_processor_1 : small_montgomery_processor_3_with_mem
    Generic Map(
        memory_size => montgomery_multiplier_memory_size - 1,
        multiplication_word_length => word_length,
        accumulation_word_length => montgomery_accumulation_word_length
    )
    Port Map(
        rst => rst,
        start => montgomery_processor_1_start,
        clk => clk,
        instruction => montgomery_processor_1_instruction,
        operands_size => montgomery_processor_1_operands_size,
        variable_a_position => montgomery_processor_1_variable_a_position,
        variable_b_position => montgomery_processor_1_variable_b_position,
        variable_p_position => montgomery_processor_1_variable_p_position,
        write_value => montgomery_processor_1_write_value,
        address_write_value => montgomery_processor_1_address_write_value,
        address_read_value => montgomery_processor_1_address_read_value,
        write_enable_value => montgomery_processor_1_write_enable_value,
        processor_free => montgomery_processor_1_processor_free,
        read_value => montgomery_processor_1_read_value
    );
    
montgomery_processor_2 : small_montgomery_processor_3_with_mem
    Generic Map(
        memory_size => montgomery_multiplier_memory_size - 1,
        multiplication_word_length => word_length,
        accumulation_word_length => montgomery_accumulation_word_length
    )
    Port Map(
        rst => rst,
        start => montgomery_processor_2_start,
        clk => clk,
        instruction => montgomery_processor_2_instruction,
        operands_size => montgomery_processor_2_operands_size,
        variable_a_position => montgomery_processor_2_variable_a_position,
        variable_b_position => montgomery_processor_2_variable_b_position,
        variable_p_position => montgomery_processor_2_variable_p_position,
        write_value => montgomery_processor_2_write_value,
        address_write_value => montgomery_processor_2_address_write_value,
        address_read_value => montgomery_processor_2_address_read_value,
        write_enable_value => montgomery_processor_2_write_enable_value,
        processor_free => montgomery_processor_2_processor_free,
        read_value => montgomery_processor_2_read_value
    );
    
reg_internal_memory_in_a : register_rst_nbits
    Generic Map (size => word_length)
    Port Map(
        d => reg_internal_memory_in_a_d,
        clk => clk,
        ce => reg_internal_memory_in_a_ce,
        rst => reg_internal_memory_in_a_rst,
        rst_value => reg_internal_memory_in_a_rst_value,
        q  => reg_internal_memory_in_a_q
    );

reg_internal_memory_in_b : register_rst_nbits
    Generic Map (size => word_length)
    Port Map(
        d => reg_internal_memory_in_b_d,
        clk => clk,
        ce => reg_internal_memory_in_b_ce,
        rst => reg_internal_memory_in_b_rst,
        rst_value => reg_internal_memory_in_b_rst_value,
        q  => reg_internal_memory_in_b_q
    );
    
reg_internal_memory_out_a : register_rst_nbits
    Generic Map (size => word_length)
    Port Map(
        d => reg_internal_memory_out_a_d,
        clk => clk,
        ce => reg_internal_memory_out_a_ce,
        rst => reg_internal_memory_out_a_rst,
        rst_value => reg_internal_memory_out_a_rst_value,
        q  => reg_internal_memory_out_a_q
    );

reg_internal_memory_out_b : register_rst_nbits
    Generic Map (size => word_length)
    Port Map(
        d => reg_internal_memory_out_b_d,
        clk => clk,
        ce => reg_internal_memory_out_b_ce,
        rst => reg_internal_memory_out_b_rst,
        rst_value => reg_internal_memory_out_b_rst_value,
        q  => reg_internal_memory_out_b_q
    );
    
local_shifter : shift_register_load_nbits
    Generic Map (size => word_length)
    Port Map(
        d => local_shifter_d,
        data_in => local_shifter_data_in,
        clk => clk,
        ce => local_shifter_ce,
        load => local_shifter_load,
        q => local_shifter_q
    );
    
reg_address_variable_a : register_rst_nbits
    Generic Map (size => internal_memory_size - (montgomery_multiplier_memory_size - 2))
    Port Map(
        d => reg_address_variable_a_d,
        clk => clk,
        ce => reg_address_variable_a_ce,
        rst => reg_address_variable_a_rst,
        rst_value => reg_address_variable_a_rst_value,
        q  => reg_address_variable_a_q
    );
    
reg_address_variable_b : register_rst_nbits
    Generic Map (size => internal_memory_size - (montgomery_multiplier_memory_size - 2))
    Port Map(
        d => reg_address_variable_b_d,
        clk => clk,
        ce => reg_address_variable_b_ce,
        rst => reg_address_variable_b_rst,
        rst_value => reg_address_variable_b_rst_value,
        q  => reg_address_variable_b_q
    );

ctr_address_variable : counter_load_rst_nbits
    Generic Map(
        size => (montgomery_multiplier_memory_size - 2),
        increment_value => 1
    )
    Port Map(
        d => ctr_address_variable_d,
        clk => clk,
        ce => ctr_address_variable_ce,
        load => ctr_address_variable_load,
        rst => ctr_address_variable_rst,
        rst_value => ctr_address_variable_rst_value,
        q => ctr_address_variable_q
    );
    
reg_read_address_montgomery_unit_0 : register_rst_nbits
    Generic Map (size => 2)
    Port Map(
        d => reg_read_address_montgomery_unit_0_d,
        clk => clk,
        ce => reg_read_address_montgomery_unit_0_ce,
        rst => reg_read_address_montgomery_unit_0_rst,
        rst_value => reg_read_address_montgomery_unit_0_rst_value,
        q  => reg_read_address_montgomery_unit_0_q
    );

reg_write_address_montgomery_unit_0 : register_rst_nbits
    Generic Map (size => 2)
    Port Map(
        d => reg_write_address_montgomery_unit_0_d,
        clk => clk,
        ce => reg_write_address_montgomery_unit_0_ce,
        rst => reg_write_address_montgomery_unit_0_rst,
        rst_value => reg_write_address_montgomery_unit_0_rst_value,
        q  => reg_write_address_montgomery_unit_0_q
    );

reg_read_address_montgomery_unit_1_2 : register_rst_nbits
    Generic Map (size => 2)
    Port Map(
        d => reg_read_address_montgomery_unit_1_2_d,
        clk => clk,
        ce => reg_read_address_montgomery_unit_1_2_ce,
        rst => reg_read_address_montgomery_unit_1_2_rst,
        rst_value => reg_read_address_montgomery_unit_1_2_rst_value,
        q  => reg_read_address_montgomery_unit_1_2_q
    );
    
reg_write_address_montgomery_unit_1_2 : register_rst_nbits
    Generic Map (size => 2)
    Port Map(
        d => reg_write_address_montgomery_unit_1_2_d,
        clk => clk,
        ce => reg_write_address_montgomery_unit_1_2_ce,
        rst => reg_write_address_montgomery_unit_1_2_rst,
        rst_value => reg_write_address_montgomery_unit_1_2_rst_value,
        q  => reg_write_address_montgomery_unit_1_2_q
    );

ctr_address_montgomery_unit : counter_rst_nbits
    Generic Map(
        size => (montgomery_multiplier_memory_size - 2),
        increment_value => 1
    )
    Port Map(
        clk => clk,
        ce => ctr_address_montgomery_unit_ce,
        rst => ctr_address_montgomery_unit_rst,
        rst_value => ctr_address_montgomery_unit_rst_value,
        q => ctr_address_montgomery_unit_q
    );
        
reg_prime_size : register_rst_nbits
    Generic Map (size => (montgomery_multiplier_memory_size - 2))
    Port Map(
        d => reg_prime_size_d,
        clk => clk,
        ce => reg_prime_size_ce,
        rst => reg_prime_size_rst,
        rst_value => reg_prime_size_rst_value,
        q  => reg_prime_size_q
    );
    
ctr_scalar_size : counter_decrement_load_rst_nbits
    Generic Map (
        size => scalar_max_size,
        decrement_value => 1
    )
    Port Map(
        d => ctr_scalar_size_d,
        clk => clk,
        ce => ctr_scalar_size_ce,
        rst => ctr_scalar_size_rst,
        load => ctr_scalar_size_load,
        rst_value => ctr_scalar_size_rst_value,
        q  => ctr_scalar_size_q
    );

reg_scalar_word_address : register_rst_nbits
    Generic Map(
        size => (montgomery_multiplier_memory_size - 1)
    )
    Port Map(
        d => reg_scalar_word_address_d,
        clk => clk,
        ce => reg_scalar_word_address_ce,
        rst => reg_scalar_word_address_rst,
        rst_value => reg_scalar_word_address_rst_value,
        q => reg_scalar_word_address_q
    );
    
ctr_scalar_word_shifter : counter_rst_limit_nbits
    Generic Map(
        size => word_length_size,
        decrement_value => 1
    )
    Port Map(
        clk => clk,
        ce => ctr_scalar_word_shifter_ce,
        rst => ctr_scalar_word_shifter_rst,
        rst_value => ctr_scalar_word_shifter_rst_value,
        limit => ctr_scalar_word_shifter_limit
    );

reg_comparison_a : register_rst_nbits
    Generic Map(
        size => scalar_max_size
    )
    Port Map(
        d => reg_comparison_a_d,
        clk => clk,
        ce => reg_comparison_a_ce,
        rst => reg_comparison_a_rst,
        rst_value => reg_comparison_a_rst_value,
        q => reg_comparison_a_q
    );
    
reg_comparison_b : register_rst_nbits
    Generic Map(
        size => scalar_max_size
    )
    Port Map(
        d => reg_comparison_b_d,
        clk => clk,
        ce => reg_comparison_b_ce,
        rst => reg_comparison_b_rst,
        rst_value => reg_comparison_b_rst_value,
        q => reg_comparison_b_q
    );

reg_comparison_a_equal_b : register_rst_nbits
    Generic Map(
        size => 1
    )
    Port Map(
        d => reg_comparison_a_equal_b_d,
        clk => clk,
        ce => reg_comparison_a_equal_b_ce,
        rst => reg_comparison_a_equal_b_rst,
        rst_value => reg_comparison_a_equal_b_rst_value,
        q => reg_comparison_a_equal_b_q
    );    
     
read_value <= reg_internal_memory_out_a_q;

processor_free <= state_machine_free;

internal_memory_data_in_a <= reg_internal_memory_in_a_q;
internal_memory_data_in_b <= reg_internal_memory_in_b_q;
internal_memory_rw_a <= write_enable_value when state_machine_free = '1' else
                                state_machine_internal_memory_rw_a;
internal_memory_rw_b <= state_machine_internal_memory_rw_b;
internal_memory_address_a <= address_value when state_machine_free = '1' else 
                                        reg_address_variable_a_q & ctr_address_variable_q;
internal_memory_address_b <= reg_address_variable_b_q & ctr_address_variable_q;

montgomery_processor_0_operands_size <= reg_prime_size_q;
montgomery_processor_0_write_value <= reg_internal_memory_out_a_q;
montgomery_processor_0_address_write_value <= reg_write_address_montgomery_unit_0_q & ctr_address_montgomery_unit_q;
montgomery_processor_0_address_read_value <= reg_read_address_montgomery_unit_0_q & ctr_address_montgomery_unit_q;

montgomery_processor_1_operands_size <= reg_prime_size_q;
montgomery_processor_1_write_value <= reg_internal_memory_out_b_q;
montgomery_processor_1_address_write_value <= reg_write_address_montgomery_unit_1_2_q & ctr_address_montgomery_unit_q;
montgomery_processor_1_address_read_value <= reg_read_address_montgomery_unit_1_2_q & ctr_address_montgomery_unit_q;
    
montgomery_processor_2_operands_size <= reg_prime_size_q;
montgomery_processor_2_write_value <= reg_internal_memory_out_b_q;
montgomery_processor_2_address_write_value <= reg_write_address_montgomery_unit_1_2_q & ctr_address_montgomery_unit_q;
montgomery_processor_2_address_read_value <= reg_read_address_montgomery_unit_1_2_q & ctr_address_montgomery_unit_q;
    
reg_internal_memory_in_a_d <= value_injection_mem when sel_value_injection_mem = '1' else
                                        write_value when state_machine_free = '1' else
                                        montgomery_processor_0_read_value;
reg_internal_memory_in_a_ce <= '1';
reg_internal_memory_in_a_rst <= rst;

reg_internal_memory_in_b_d <= montgomery_processor_1_read_value when sel_read_montgomery_processor_1 = '1' else
                                        montgomery_processor_2_read_value;
reg_internal_memory_in_b_ce <= '1';
reg_internal_memory_in_b_rst <= rst;
    
reg_internal_memory_out_a_d <= value_injection_data_a when sel_value_injection_a = '1' else
                                            internal_memory_data_out_a;
reg_internal_memory_out_a_ce <= '1';
reg_internal_memory_out_a_rst <= rst;

reg_internal_memory_out_b_d <=  value_injection_data_b when sel_value_injection_b = '1' else
                                            internal_memory_data_out_b;
reg_internal_memory_out_b_ce <= '1';
reg_internal_memory_out_b_rst <= rst;

reg_scalar_word_address_d <= ('1' & not (reg_scalar_word_increment)) when (ctr_address_variable_q = reg_scalar_word_increment) else
                                     ('0' & ctr_address_variable_q);

local_shifter_d <= reg_internal_memory_out_a_q;
local_shifter_data_in <= '0';

reg_address_variable_a_rst <= rst;

reg_address_variable_b_rst <= rst;

reg_address_variable_a_d(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 1) <= state_machine_internal_memory_address_variable_a(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 1);
reg_address_variable_a_d(0) <= reg_scalar_word_address_q(montgomery_multiplier_memory_size - 2) when (ctr_address_variable_load = '1') else
                                        state_machine_internal_memory_address_variable_a(0);

reg_address_variable_b_d <= state_machine_internal_memory_address_variable_b;

ctr_address_variable_d <= reg_scalar_word_address_q(((montgomery_multiplier_memory_size - 2) - 1) downto 0);

reg_read_address_montgomery_unit_0_ce <= reg_address_montgomery_unit_0_ce;
reg_read_address_montgomery_unit_0_rst <= rst;
reg_write_address_montgomery_unit_0_ce <= reg_address_montgomery_unit_0_ce;
reg_write_address_montgomery_unit_0_rst <= rst;

reg_read_address_montgomery_unit_1_2_ce <= reg_address_montgomery_unit_1_2_ce;
reg_read_address_montgomery_unit_1_2_rst <= rst;
reg_write_address_montgomery_unit_1_2_ce <= reg_address_montgomery_unit_1_2_ce;
reg_write_address_montgomery_unit_1_2_rst <= rst;

reg_prime_size_d <= prime_size;
reg_prime_size_rst <= rst;

ctr_scalar_size_d((scalar_max_size - 1) downto (montgomery_multiplier_memory_size - 2)) <= (others => '0') when sel_inversion_mode = '1' else
                        scalar_size((scalar_max_size - 1) downto (montgomery_multiplier_memory_size - 2));
ctr_scalar_size_d((montgomery_multiplier_memory_size - 3) downto 0) <= reg_prime_size_q when sel_inversion_mode = '1' else
                        scalar_size((montgomery_multiplier_memory_size - 3) downto 0);
ctr_scalar_size_rst <= rst;

reg_comparison_a_d((scalar_max_size - 1) downto (montgomery_multiplier_memory_size - 2)) <= (others => '0');
reg_comparison_a_d((montgomery_multiplier_memory_size - 3) downto 0) <= ctr_address_variable_q;
reg_comparison_a_ce <= '1';


reg_comparison_b_d((scalar_max_size - 1) downto (montgomery_multiplier_memory_size - 2)) <= ctr_scalar_size_q((scalar_max_size - 1) downto (montgomery_multiplier_memory_size - 2)) when sel_comparison_scalar = '1' else
                                                                                            (others => '0');
reg_comparison_b_d((montgomery_multiplier_memory_size - 3) downto 0) <= ctr_scalar_size_q((montgomery_multiplier_memory_size - 3) downto 0) when sel_comparison_scalar = '1' else
                                                                        std_logic_vector(unsigned(reg_prime_size_q) - to_unsigned(3, (montgomery_multiplier_memory_size - 2)));
reg_comparison_b_ce <= '1';

reg_comparison_a_equal_b_d(0) <= '1' when (reg_comparison_b_q = reg_comparison_a_q) else
                                    '0';
reg_comparison_a_equal_b_ce <= '1';
reg_comparison_a_equal_b_rst <= rst;
                                    

end Behavioral;