----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    small_montgomery_processor_3
-- Module Name:    small_montgomery_processor_3
-- Project Name:   Montgomery processor
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- Montgomery multiplication processor circuit version number 3.
-- This circuit performs Montgomery multiplication, addition, subtraction 
-- and other related operations. 
-- The circuit to work needs to be connected with two memories module.
-- Those memories modules need to have one input port and two outputs port. 
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
-- generic_dsp Rev 1.0
-- register_rst_nbits Rev 1.0
-- counter_rst_nbits Rev 1.0
-- counter_load_rst_nbits Rev 1.0
-- counter_decrement_load_rst_nbits Rev 1.0
-- controller_small_montgomery_processor_3 Rev 1.0
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

entity small_montgomery_processor_3 is
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
end small_montgomery_processor_3;

architecture Behavioral of small_montgomery_processor_3 is

component generic_dsp
    Generic (
        multiplication_word_length : integer := 17;
        accumulation_word_length : integer := 44
    );
    Port(
        a : in STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
        a_bypass : in STD_LOGIC;
        a_en : in STD_LOGIC;
        a_rst : in STD_LOGIC;
        b : in STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
        b_bypass : in STD_LOGIC;
        b_en : in STD_LOGIC;
        b_rst : in STD_LOGIC;
        c : in STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);
        c_bypass : in STD_LOGIC;
        c_en : in STD_LOGIC;
        c_rst : in STD_LOGIC;
        external_carry_in : in STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);
        add_sub_mode : in STD_LOGIC;
        reg_add_sub_mode_ce : in STD_LOGIC;
        accumulation_mode : in STD_LOGIC;
        reg_accumulation_mode_ce : in STD_LOGIC;
        external_carry_in_mode : in STD_LOGIC;
        reg_external_carry_in_mode_ce : in STD_LOGIC;
        arshift_mode : in STD_LOGIC;
        reg_arshift_mode_ce : in STD_LOGIC;
        reg_mode_rst : in STD_LOGIC;
        clk : in STD_LOGIC;
        p_en : in STD_LOGIC;
        p_rst : in STD_LOGIC;
        product : out STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0)
    );
end component;

component register_rst_nbits
    Generic (size : integer);
    Port (
        d : in STD_LOGIC_VECTOR ((size - 1) downto 0);
        clk : in STD_LOGIC;
        ce : in STD_LOGIC;
        rst : in STD_LOGIC;
        rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
        q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
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

component controller_small_montgomery_processor_3
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        start : in STD_LOGIC;
        counters_limit : in STD_LOGIC;
        instruction : in STD_LOGIC_VECTOR(2 downto 0);
        mem_write_enable_new_value : out STD_LOGIC;
        reg_processor_free_d : out STD_LOGIC;
        reg_operands_size_ce : out STD_LOGIC;
        reg_variables_ce : out STD_LOGIC;
        counter_a_j_ce : out STD_LOGIC;
        counter_a_j_rst : out STD_LOGIC;
        counter_b_i_ce : out STD_LOGIC;
        counter_b_i_rst : out STD_LOGIC;
        address_n_ce : out STD_LOGIC;
        address_n_load : out STD_LOGIC;
        address_n_rst : out STD_LOGIC;
        address_new_p_ce : out STD_LOGIC;
        address_new_p_rst : out STD_LOGIC;
        dsp1_a_en : out STD_LOGIC;
        dsp1_a_rst : out STD_LOGIC;
        reg_b_ce : out STD_LOGIC;
        reg_b_rst : out STD_LOGIC;
        dsp1_c_en : out STD_LOGIC;
        dsp1_c_rst : out STD_LOGIC;
        dsp1_add_sub_mode : out STD_LOGIC;
        dsp1_reg_add_sub_mode_ce : out STD_LOGIC;
        dsp1_accumulation_mode : out STD_LOGIC;
        dsp1_reg_accumulation_mode_ce : out STD_LOGIC;
        dsp1_external_carry_in_mode : out STD_LOGIC;
        dsp1_reg_external_carry_in_mode_ce : out STD_LOGIC;
        dsp1_arshift_mode : out STD_LOGIC;
        dsp1_reg_arshift_mode_ce : out STD_LOGIC;
        dsp1_p_en : out STD_LOGIC;
        dsp1_p_rst : out STD_LOGIC;
        reg_m_ce : out STD_LOGIC;
        reg_m_rst : out STD_LOGIC;
        dsp2_b_en : out STD_LOGIC;
        dsp2_b_rst : out STD_LOGIC;
        dsp2_c_en : out STD_LOGIC;
        dsp2_c_rst : out STD_LOGIC;
        dsp2_add_sub_mode : out STD_LOGIC;
        dsp2_reg_add_sub_mode_ce : out STD_LOGIC;
        dsp2_accumulation_mode : out STD_LOGIC;
        dsp2_reg_accumulation_mode_ce : out STD_LOGIC;
        dsp2_external_carry_in_mode : out STD_LOGIC;
        dsp2_reg_external_carry_in_mode_ce : out STD_LOGIC;
        dsp2_arshift_mode : out STD_LOGIC;
        dsp2_reg_arshift_mode_ce : out STD_LOGIC;
        dsp2_p_en : out STD_LOGIC;
        dsp2_p_rst : out STD_LOGIC;
        sel_load_b_i : out STD_LOGIC;
        sel_value_m : out STD_LOGIC;
        sel_compare_counter_b_i : out STD_LOGIC
    );
end component;

signal dsp1_a : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal dsp1_a_bypass : STD_LOGIC;
signal dsp1_a_en : STD_LOGIC;
signal dsp1_a_rst : STD_LOGIC;
signal dsp1_b : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal dsp1_b_bypass : STD_LOGIC;
signal dsp1_b_en : STD_LOGIC;
signal dsp1_b_rst : STD_LOGIC;
signal dsp1_c : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);
signal dsp1_c_bypass : STD_LOGIC;
signal dsp1_c_en : STD_LOGIC;
signal dsp1_c_rst : STD_LOGIC;
signal dsp1_external_carry_in : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);
signal dsp1_add_sub_mode : STD_LOGIC;
signal dsp1_reg_add_sub_mode_ce : STD_LOGIC;
signal dsp1_accumulation_mode : STD_LOGIC;
signal dsp1_reg_accumulation_mode_ce : STD_LOGIC;
signal dsp1_external_carry_in_mode : STD_LOGIC;
signal dsp1_reg_external_carry_in_mode_ce : STD_LOGIC;
signal dsp1_arshift_mode : STD_LOGIC;
signal dsp1_reg_arshift_mode_ce : STD_LOGIC;
signal dsp1_reg_mode_rst : STD_LOGIC;
signal dsp1_p_en : STD_LOGIC;
signal dsp1_p_rst : STD_LOGIC;
signal dsp1_product : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);

signal dsp2_a : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal dsp2_a_bypass : STD_LOGIC;
signal dsp2_a_en : STD_LOGIC;
signal dsp2_a_rst : STD_LOGIC;
signal dsp2_b : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal dsp2_b_bypass : STD_LOGIC;
signal dsp2_b_en : STD_LOGIC;
signal dsp2_b_rst : STD_LOGIC;
signal dsp2_c : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);
signal dsp2_c_bypass : STD_LOGIC;
signal dsp2_c_en : STD_LOGIC;
signal dsp2_c_rst : STD_LOGIC;
signal dsp2_external_carry_in : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);
signal dsp2_add_sub_mode : STD_LOGIC;
signal dsp2_reg_add_sub_mode_ce : STD_LOGIC;
signal dsp2_accumulation_mode : STD_LOGIC;
signal dsp2_reg_accumulation_mode_ce : STD_LOGIC;
signal dsp2_external_carry_in_mode : STD_LOGIC;
signal dsp2_reg_external_carry_in_mode_ce : STD_LOGIC;
signal dsp2_arshift_mode : STD_LOGIC;
signal dsp2_reg_arshift_mode_ce : STD_LOGIC;
signal dsp2_reg_mode_rst : STD_LOGIC;
signal dsp2_p_en : STD_LOGIC;
signal dsp2_p_rst : STD_LOGIC;
signal dsp2_product : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);

signal reg_b_d : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal reg_b_ce : STD_LOGIC;
signal reg_b_rst : STD_LOGIC;
constant reg_b_rst_value : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0) := std_logic_vector(to_unsigned(1, multiplication_word_length));
signal reg_b_q : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal reg_m_d : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal reg_m_ce : STD_LOGIC;
signal reg_m_rst : STD_LOGIC;
constant reg_m_rst_value : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0) := std_logic_vector(to_unsigned(4, multiplication_word_length));
signal reg_m_q : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal reg_operands_size_d : STD_LOGIC_VECTOR((memory_size - 2) downto 0);
signal reg_operands_size_ce : STD_LOGIC;
signal reg_operands_size_rst : STD_LOGIC;
constant reg_operands_size_rst_value : STD_LOGIC_VECTOR((memory_size - 2) downto 0) := std_logic_vector(to_unsigned(0, memory_size - 1));
signal reg_operands_size_q : STD_LOGIC_VECTOR((memory_size - 2) downto 0);

signal reg_variable_a_d : STD_LOGIC_VECTOR(1 downto 0);
signal reg_variable_a_ce : STD_LOGIC;
signal reg_variable_a_rst : STD_LOGIC;
constant reg_variable_a_rst_value : STD_LOGIC_VECTOR(1 downto 0) := "10";
signal reg_variable_a_q : STD_LOGIC_VECTOR(1 downto 0);
    
signal reg_variable_b_d : STD_LOGIC_VECTOR(1 downto 0);
signal reg_variable_b_ce : STD_LOGIC;
signal reg_variable_b_rst : STD_LOGIC;
constant reg_variable_b_rst_value : STD_LOGIC_VECTOR(1 downto 0) := "11";
signal reg_variable_b_q : STD_LOGIC_VECTOR(1 downto 0);
    
signal reg_variable_p_d : STD_LOGIC_VECTOR(1 downto 0);
signal reg_variable_p_ce : STD_LOGIC;
signal reg_variable_p_rst : STD_LOGIC;
constant reg_variable_p_rst_value : STD_LOGIC_VECTOR(1 downto 0) := "01";
signal reg_variable_p_q : STD_LOGIC_VECTOR(1 downto 0);

signal reg_variables_ce : STD_LOGIC;

signal counter_a_j_ce : STD_LOGIC;
signal counter_a_j_rst : STD_LOGIC;
constant counter_a_j_rst_value : STD_LOGIC_VECTOR((memory_size - 2) downto 0) := std_logic_vector(to_unsigned(0, memory_size - 1));
signal counter_a_j_q : STD_LOGIC_VECTOR((memory_size - 2) downto 0);

signal counter_b_i_ce : STD_LOGIC;
signal counter_b_i_rst : STD_LOGIC;
constant counter_b_i_rst_value : STD_LOGIC_VECTOR((memory_size - 2) downto 0) := std_logic_vector(to_unsigned(0, memory_size - 1));
signal counter_b_i_q : STD_LOGIC_VECTOR((memory_size - 2) downto 0);

signal address_n_d : STD_LOGIC_VECTOR((memory_size - 2) downto 0);
signal address_n_load : STD_LOGIC;
signal address_n_ce : STD_LOGIC;
signal address_n_rst : STD_LOGIC;
constant address_n_rst_value : STD_LOGIC_VECTOR((memory_size - 2) downto 0) := std_logic_vector(to_unsigned(0, memory_size - 1));
signal address_n_q : STD_LOGIC_VECTOR((memory_size - 2) downto 0);

signal address_new_p_ce : STD_LOGIC;
signal address_new_p_rst : STD_LOGIC;
constant address_new_p_rst_value : STD_LOGIC_VECTOR((memory_size - 2) downto 0) := std_logic_vector(to_signed(-1, memory_size - 1));
signal address_new_p_q : STD_LOGIC_VECTOR((memory_size - 2) downto 0);

signal reg_processor_free_d : STD_LOGIC;
signal reg_processor_free_ce : STD_LOGIC;
signal reg_processor_free_rst : STD_LOGIC;
constant reg_processor_free_rst_value : STD_LOGIC := '0';
signal reg_processor_free_q : STD_LOGIC;

signal mem_write_enable_new_value : STD_LOGIC;

signal load_address_a_b : STD_LOGIC_VECTOR((memory_size - 2) downto 0);

signal compared_counter : STD_LOGIC_VECTOR((memory_size - 2) downto 0);

signal sel_load_b_i : STD_LOGIC;
signal sel_compare_counter_b_i : STD_LOGIC;

signal sel_value_a : STD_LOGIC;
signal sel_value_b : STD_LOGIC;
signal sel_value_p : STD_LOGIC;
signal sel_value_m : STD_LOGIC;

signal counters_limit : STD_LOGIC;

signal dsp1_product_small_word : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal dsp2_product_small_word : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

begin

controller : controller_small_montgomery_processor_3
    Port Map(
        clk => clk,
        rst => rst,
        start => start,
        counters_limit => counters_limit,
        instruction => instruction,
        mem_write_enable_new_value => mem_write_enable_new_value,
        reg_processor_free_d => reg_processor_free_d,
        reg_operands_size_ce => reg_operands_size_ce,
        reg_variables_ce => reg_variables_ce,
        counter_a_j_ce => counter_a_j_ce,
        counter_a_j_rst => counter_a_j_rst,
        counter_b_i_ce => counter_b_i_ce,
        counter_b_i_rst => counter_b_i_rst,
        address_n_ce => address_n_ce,
        address_n_load => address_n_load,
        address_n_rst => address_n_rst,
        address_new_p_ce => address_new_p_ce,
        address_new_p_rst => address_new_p_rst,     
        dsp1_a_en => dsp1_a_en,
        dsp1_a_rst => dsp1_a_rst,
        reg_b_ce => reg_b_ce,
        reg_b_rst => reg_b_rst,
        dsp1_c_en => dsp1_c_en,
        dsp1_c_rst => dsp1_c_rst,
        dsp1_add_sub_mode => dsp1_add_sub_mode,
        dsp1_reg_add_sub_mode_ce => dsp1_reg_add_sub_mode_ce,
        dsp1_accumulation_mode => dsp1_accumulation_mode,
        dsp1_reg_accumulation_mode_ce => dsp1_reg_accumulation_mode_ce,
        dsp1_external_carry_in_mode => dsp1_external_carry_in_mode,
        dsp1_reg_external_carry_in_mode_ce => dsp1_reg_external_carry_in_mode_ce,
        dsp1_arshift_mode => dsp1_arshift_mode,
        dsp1_reg_arshift_mode_ce => dsp1_reg_arshift_mode_ce,
        dsp1_p_en => dsp1_p_en,
        dsp1_p_rst => dsp1_p_rst,
        reg_m_ce => reg_m_ce,
        reg_m_rst => reg_m_rst,
        dsp2_b_en => dsp2_b_en,
        dsp2_b_rst => dsp2_b_rst,
        dsp2_c_en => dsp2_c_en,
        dsp2_c_rst => dsp2_c_rst,
        dsp2_add_sub_mode => dsp2_add_sub_mode,
        dsp2_reg_add_sub_mode_ce => dsp2_reg_add_sub_mode_ce,
        dsp2_accumulation_mode => dsp2_accumulation_mode,
        dsp2_reg_accumulation_mode_ce => dsp2_reg_accumulation_mode_ce,
        dsp2_external_carry_in_mode => dsp2_external_carry_in_mode,
        dsp2_reg_external_carry_in_mode_ce => dsp2_reg_external_carry_in_mode_ce,
        dsp2_arshift_mode => dsp2_arshift_mode,
        dsp2_reg_arshift_mode_ce => dsp2_reg_arshift_mode_ce,
        dsp2_p_en => dsp2_p_en,
        dsp2_p_rst => dsp2_p_rst,
        sel_load_b_i => sel_load_b_i,
        sel_value_m => sel_value_m,
        sel_compare_counter_b_i => sel_compare_counter_b_i
    );

dsp1 : entity work.generic_dsp(IGLOO2)
    Generic Map(
        multiplication_word_length => multiplication_word_length,
        accumulation_word_length => accumulation_word_length
    )
    Port Map(
        a => dsp1_a,
        a_bypass => dsp1_a_bypass,
        a_en => dsp1_a_en,
        a_rst => dsp1_a_rst,
        b => dsp1_b,
        b_bypass => dsp1_b_bypass,
        b_en => dsp1_b_en,
        b_rst => dsp1_b_rst,
        c => dsp1_c,
        c_bypass => dsp1_c_bypass,
        c_en => dsp1_c_en,
        c_rst => dsp1_c_rst,
        external_carry_in => dsp1_external_carry_in,
        add_sub_mode => dsp1_add_sub_mode,
        reg_add_sub_mode_ce => dsp1_reg_add_sub_mode_ce,
        accumulation_mode => dsp1_accumulation_mode,
        reg_accumulation_mode_ce => dsp1_reg_accumulation_mode_ce,
        external_carry_in_mode => dsp1_external_carry_in_mode,
        reg_external_carry_in_mode_ce => dsp1_reg_external_carry_in_mode_ce,
        arshift_mode => dsp1_arshift_mode,
        reg_arshift_mode_ce => dsp1_reg_arshift_mode_ce,
        reg_mode_rst => dsp1_reg_mode_rst,
        clk => clk,
        p_en => dsp1_p_en,
        p_rst => dsp1_p_rst,
        product => dsp1_product
    );
    
dsp2 : entity work.generic_dsp(IGLOO2)
    Generic Map(
        multiplication_word_length => multiplication_word_length,
        accumulation_word_length => accumulation_word_length
    )
    Port Map(
        a => dsp2_a,
        a_bypass => dsp2_a_bypass,
        a_en => dsp2_a_en,
        a_rst => dsp2_a_rst,
        b => dsp2_b,
        b_bypass => dsp2_b_bypass,
        b_en => dsp2_b_en,
        b_rst => dsp2_b_rst,
        c => dsp2_c,
        c_bypass => dsp2_c_bypass,
        c_en => dsp2_c_en,
        c_rst => dsp2_c_rst,
        external_carry_in => dsp2_external_carry_in,
        add_sub_mode => dsp2_add_sub_mode,
        reg_add_sub_mode_ce => dsp2_reg_add_sub_mode_ce,
        accumulation_mode => dsp2_accumulation_mode,
        reg_accumulation_mode_ce => dsp2_reg_accumulation_mode_ce,
        external_carry_in_mode => dsp2_external_carry_in_mode,
        reg_external_carry_in_mode_ce => dsp2_reg_external_carry_in_mode_ce,
        arshift_mode => dsp2_arshift_mode,
        reg_arshift_mode_ce => dsp2_reg_arshift_mode_ce,
        reg_mode_rst => dsp2_reg_mode_rst,
        clk => clk,
        p_en => dsp2_p_en,
        p_rst => dsp2_p_rst,
        product => dsp2_product
    );
    
reg_b : register_rst_nbits
    Generic Map(
        size => multiplication_word_length
    )
    Port Map(
        d => reg_b_d,
        clk => clk,
        ce => reg_b_ce,
        rst => reg_b_rst,
        rst_value => reg_b_rst_value,
        q => reg_b_q
    );
    
reg_m : register_rst_nbits
    Generic Map(
        size => multiplication_word_length
    )
    Port Map(
        d => reg_m_d,
        clk => clk,
        ce => reg_m_ce,
        rst => reg_m_rst,
        rst_value => reg_m_rst_value,
        q => reg_m_q
    );

reg_operands_size : register_rst_nbits
    Generic Map(size => memory_size - 1)
    Port Map(
        d => reg_operands_size_d,
        clk => clk,
        ce => reg_operands_size_ce,
        rst => reg_operands_size_rst,
        rst_value => reg_operands_size_rst_value,       
        q => reg_operands_size_q
    );
    
reg_variable_a : register_rst_nbits
    Generic Map(size => 2)
    Port Map(
        d => reg_variable_a_d,
        clk => clk,
        ce => reg_variable_a_ce,
        rst => reg_variable_a_rst,
        rst_value => reg_variable_a_rst_value,
        q => reg_variable_a_q
    );
    
reg_variable_b : register_rst_nbits
    Generic Map(size => 2)
    Port Map(
        d => reg_variable_b_d,
        clk => clk,
        ce => reg_variable_b_ce,
        rst => reg_variable_b_rst,
        rst_value => reg_variable_b_rst_value,
        q => reg_variable_b_q
    );
    
reg_variable_p : register_rst_nbits
    Generic Map(size => 2)
    Port Map(
        d => reg_variable_p_d,
        clk => clk,
        ce => reg_variable_p_ce,
        rst => reg_variable_p_rst,
        rst_value => reg_variable_p_rst_value,
        q => reg_variable_p_q
    );
    
counter_a_j : counter_rst_nbits
    Generic Map(
        size => memory_size - 1,
        increment_value => 1
    )
    Port Map(
        clk => clk,
        ce => counter_a_j_ce,
        rst => counter_a_j_rst,
        rst_value => counter_a_j_rst_value,
        q => counter_a_j_q
    );

counter_b_i : counter_rst_nbits
    Generic Map(
        size => memory_size - 1,
        increment_value => 1
    )
    Port Map(
        clk => clk,
        ce => counter_b_i_ce,
        rst => counter_b_i_rst,
        rst_value => counter_b_i_rst_value,
        q => counter_b_i_q
    );

address_n : counter_load_rst_nbits
    Generic Map(
        size => memory_size - 1,
        increment_value => 1
    )
    Port Map(
        d => address_n_d,
        clk => clk,
        load => address_n_load,
        ce => address_n_ce,
        rst => address_n_rst,
        rst_value => address_n_rst_value,
        q => address_n_q
    );

address_new_p : counter_rst_nbits
    Generic Map(
        size => memory_size - 1,
        increment_value => 1
    )
    Port Map(
        clk => clk,
        ce => address_new_p_ce,
        rst => address_new_p_rst,
        rst_value => address_new_p_rst_value,
        q => address_new_p_q
    );
    
reg_processor_free : register_rst_nbits
    Generic Map(
        size => 1
    )
    Port Map(
        d(0) => reg_processor_free_d,
        clk => clk,
        ce => reg_processor_free_ce,
        rst => reg_processor_free_rst,
        rst_value(0) => reg_processor_free_rst_value,
        q(0) => reg_processor_free_q
    );
    
reg_variable_a_ce <= reg_variables_ce;
reg_variable_a_rst <= rst;

reg_variable_b_ce <= reg_variables_ce;
reg_variable_b_rst <= rst;

reg_variable_p_ce <= reg_variables_ce;
reg_variable_p_rst <= rst;
    
reg_operands_size_d <= operands_size;
reg_operands_size_rst <= rst;

reg_variable_a_d <= variable_a_position;

reg_variable_b_d <= variable_b_position;

reg_variable_p_d <= variable_p_position;

address_n_d <= reg_operands_size_q;

dsp1_a <= mem1_value_a when sel_value_a = '1' else
             mem2_value_a;

dsp1_a_bypass <= '0';
    
reg_b_d <= mem1_value_a when sel_value_b = '1' else
              mem2_value_a;

dsp1_b <= reg_b_q;
dsp1_b_bypass <= '1';
dsp1_b_en <= '1';
dsp1_b_rst <= '1';

dsp1_c((accumulation_word_length - 1) downto multiplication_word_length) <= (others => '0');        
dsp1_c((multiplication_word_length - 1) downto 0) <= mem1_value_a when sel_value_p = '1' else
                                                                        mem2_value_b;
             
dsp1_c_bypass <= '0';


dsp1_reg_mode_rst <= rst;

reg_m_d <= dsp2_product((multiplication_word_length - 1) downto 0) when sel_value_m = '1' else
             dsp1_product((multiplication_word_length - 1) downto 0);
             
dsp2_a <= reg_m_q;
dsp2_a_bypass <= '1';
dsp2_a_en <= '1';
dsp2_a_rst <= '1';

dsp2_b <= mem1_value_b;

dsp2_b_bypass <= '0';

dsp2_c((accumulation_word_length - 1) downto multiplication_word_length) <= (others => '0');        
dsp2_c((multiplication_word_length - 1) downto 0) <= dsp1_product((multiplication_word_length - 1) downto 0);
dsp2_c_bypass <= '0';

dsp2_reg_mode_rst <= '1';

sel_value_p <= '1' when (reg_variable_p_q(1) = '0') else
                    '0';

sel_value_a <= '1' when (reg_variable_a_q(1) = '0') else
                    '0';

sel_value_b <= '1' when (reg_variable_b_q(1) = '0') else
                    '0';

load_address_a_b <= counter_b_i_q when sel_load_b_i = '1' else
                          counter_a_j_q;

mem1_write_enable_new_value <= mem_write_enable_new_value when (reg_variable_p_q(1) = '0') else
                                        '0';
mem2_write_enable_new_value <= mem_write_enable_new_value when (reg_variable_p_q(1) = '1') else
                                        '0';

mem1_address_value_a(memory_size - 1) <= '1';
mem1_address_value_b(memory_size - 1) <= '0';
mem2_address_value_a(memory_size - 1) <= reg_variable_b_q(0) when sel_load_b_i = '1' else
                                                        reg_variable_a_q(0);
mem2_address_value_b(memory_size - 1) <= reg_variable_p_q(0);

mem1_address_value_a((memory_size - 2) downto 0) <= counter_a_j_q when sel_value_p = '1' else
                                                                     load_address_a_b;
mem1_address_value_b((memory_size - 2) downto 0) <= address_n_q;
mem2_address_value_a((memory_size - 2) downto 0) <= load_address_a_b;
mem2_address_value_b((memory_size - 2) downto 0) <= counter_a_j_q;

address_new_value(memory_size - 1) <= reg_variable_p_q(0);
address_new_value((memory_size - 2) downto 0) <= address_new_p_q;

new_value <= dsp2_product((multiplication_word_length - 1) downto 0);

reg_processor_free_ce <= '1';
reg_processor_free_rst <= rst;
processor_free <= reg_processor_free_q;

compared_counter <= counter_b_i_q when (sel_compare_counter_b_i = '1') else
                            counter_a_j_q;

counters_limit <= '1' when (compared_counter = reg_operands_size_q) else
                        '0';

dsp1_product_small_word <= dsp1_product((multiplication_word_length - 1) downto 0);
dsp2_product_small_word <= dsp2_product((multiplication_word_length - 1) downto 0);

dsp1_external_carry_in <= (others => '0');
dsp2_external_carry_in <= (others => '0');

end Behavioral;