----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    control_small_weierstrass_processor_2
-- Module Name:    control_small_weierstrass_processor_2
-- Project Name:   Weierstrass processor
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- The state machine for the Weierstrass processor.
-- The unit is able to perform a scalar multiplication in a projective coordinate Point.
-- And returns in the affine coordinate.
-- When using, it is necessary to rewrite all curve constants between calls, since 
-- the processor does not distinguish if a constant is on the Montgomery domain or not.
--
--
-- circuit parameters:
--
-- internal_memory_size :
--
-- The size of the internal memory that holds all values in the Weierstrass processor.
--
-- word_length :
--
-- The length of the word in the Weierstrass processor memory system.
-- This value is the same as word used in the Montgomery processor unit.
--
-- montgomery_multiplier_memory_size :
--
-- The Montgomery processor internal memory size.
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
--
-- register_rst_nbits Rev 1.0
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

entity control_small_weierstrass_processor_2 is
    Generic (
        internal_memory_size : integer;
        word_length : integer;
        montgomery_multiplier_memory_size : integer
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
end control_small_weierstrass_processor_2;

architecture Behavioral of control_small_weierstrass_processor_2 is

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


type State is (reset, idle_state,
-- Pre Processing
-- Transform a, b into a*r mod n and b*r mod n
-- Transform Px, Py and Pz into Px*r mod n, Py*r mod n, Pz*r mod n
-- Writes into sPx = 0, sPz = 0, sPy = r mod n
start_pre_processing,
load_n_pre_processing,
load_special_n_pre_processing,
load_r2_pre_processing,
load_a_1_pre_processing,
start_multiplication_ar_1r_pre_processing,
load_b_pre_processing,
load_b_again_pre_processing,
start_2b_addition_pre_processing,
wait_2b_addition_1_pre_processing,
wait_2b_addition_2_pre_processing,
start_3b_addition_pre_processing,
wait_3b_addition_1_pre_processing,
wait_3b_addition_2_pre_processing,
start_multiplication_3br_pre_processing,
insert_zero_sPx_pre_processing,
insert_zero_sPz_pre_processing,
store_ar_1r_pre_processing,
load_Px_Py_pre_processing,
store_3br_multiplication_pre_processing,
start_Px_Py_multiplication_pre_processing,
load_Pz_pre_processing,
store_Pxr_Pyr_multiplication_pre_processing,
start_multiplication_Pz_pre_processing,
store_Pzr_multiplication_pre_processing,
finish_store_Pzr_multiplication_pre_processing,
finish_pre_processing,
-- Load scalar word
prepare_load_new_scalar_word,
load_new_scalar_word,
-- Point Addition
-- Can do the folliwing operations :
-- sP <- sP + P (in case is not doubling and scalar bit is 1)
-- fP <- sP + P (in case is not doubling and scalar bit is 0)
-- P  <- P  + P (in case is doubling)
prepare_point_addition,
-- Round 1
load_Px_Py_mm0_mm1_round_1_point_addition,
load_Px_Py_mm0_mm1_round_1_point_doubling,
load_sPx_sPy_or_Px_Py_mm0_mm1_round_1_point_addition,
start_multiplication_t0_t1_mm0_mm1_round_1_point_addition,
load_Pz_mm2_round_1_point_addition,
load_Pz_mm2_round_1_point_doubling,
load_sPz_or_Pz_mm2_round_1_point_addition,
start_multiplication_t2_mm2_round_1_point_addition,
-- Round 2
store_t0_t1_mm0_mm1_round_2_point_addition,
store_t0_t1_mm0_mm1_round_2_point_doubling,
load_sPy_or_Py_Px_mm0_mm1_round_2_point_addition,
start_addition_t3_t4_mm0_mm1_round_2_point_addition,
store_t2_mm2_round_2_point_addition,
store_t2_mm2_round_2_point_doubling,
load_sPy_or_Py_mm2_round_2_point_addition,
start_addition_t5_mm2_round_2_point_addition,
-- Round 3
store_t3_t4_mm0_mm1_round_3_point_addition,
store_t3_t4_mm0_mm1_round_3_point_doubling,
load_sPz_or_Pz_Pz_mm0_mm1_round_3_point_addition,
start_addition_t8_t7_mm0_mm1_round_3_point_addition,
store_t5_mm2_round_3_point_addition,
load_Py_mm2_round_3_point_addition,
load_Pz_mm2_round_3_point_addition,
start_addition_t6_mm2_round_3_point_addition,
-- Round 4
store_t7_t8_mm0_mm1_round_4_point_addition,
load_t3_t7_mm0_mm1_round_4_point_addition,
load_t4_mm0_round_4_point_addition,
start_multiplication_t9_t11_mm0_mm1_round_4_point_addition,
store_t6_mm2_round_4_point_addition,
load_t5_mm2_round_4_point_addition,
start_multiplication_t10_mm2_round_4_point_addition,
-- Round 5
store_t9_t11_mm0_mm1_round_5_point_addition,
load_t2_mm0_mm1_round_5_point_addition,
load_t1_t0_mm0_mm1_round_5_point_addition,
start_addition_t4_t5_mm0_mm1_round_5_point_addition,
store_t10_mm2_round_5_point_addition,
load_t0_mm2_round_5_point_addition,
load_t1_mm2_round_5_point_addition,
start_addition_t3_mm2_round_5_point_addition,
-- Round 6, 7 and 8
store_t4_t5_mm0_mm1_round_6_7_8_point_addition,
load_3b_a_mm0_mm1_round_6_7_8_point_addition,
start_multiplication_t6_t8_mm0_mm1_round_6_7_8_point_addition,
load_t9_mm2_round_6_7_8_point_addition,
start_subtraction_t2_mm2_round_6_7_8_point_addition,
wait_subtraction_t2_mm2_round_6_7_8_point_addition,
store_t2_mm2_round_6_7_8_point_addition,
load_t10_mm2_round_6_7_8_point_addition,
load_t4_mm2_round_6_7_8_point_addition,
start_subtraction_t3_mm2_round_6_7_8_point_addition,
wait_subtraction_t3_mm2_round_6_7_8_point_addition,
store_t3_mm2_round_6_7_8_point_addition,
load_t11_mm2_round_6_7_8_point_addition,
load_t5_mm2_round_6_7_8_point_addition,
start_subtraction_t4_mm2_round_6_7_8_point_addition,
wait_subtraction_t4_mm2_round_6_7_8_point_addition,
store_t4_mm2_round_6_7_8_point_addition,
load_t0_mm2_round_6_7_8_point_addition,
load_t0_again_mm2_round_6_7_8_point_addition,
start_addition_t10_mm2_round_6_7_8_point_addition,
wait_addition_1_t10_mm2_round_6_7_8_point_addition,
wait_addition_2_t10_mm2_round_6_7_8_point_addition,
start_addition_again_t10_mm2_round_6_7_8_point_addition,
wait_addition_again_t10_mm2_round_6_7_8_point_addition,
store_t10_mm2_round_6_7_8_point_addition,
-- Round 9
store_t6_t8_mm0_mm1_round_9_point_addition,
load_t4_mm0_mm1_round_9_point_addition,
start_multiplication_mm0_mm1_round_9_point_addition,
load_t8_mm2_round_9_point_addition,
load_a_mm2_round_9_point_addition,
start_subtraction_t7_mm2_round_9_point_addition,
wait_subtraction_1_t7_mm2_round_9_point_addition,
wait_subtraction_2_t7_mm2_round_9_point_addition,
start_multiplication_t9_mm2_round_9_point_addition,
-- Round 10
store_t5_mm0_round_10_point_addition,
load_t8_t6_mm0_mm1_round_10_point_addition,
load_t10_mm0_round_10_point_addition,
start_addition_t0_t4_mm0_mm1_round_10_point_addition,
load_t5_mm2_round_10_point_addition,
start_addition_t7_mm2_round_10_point_addition,
-- Round 11
store_t0_t4_mm0_mm1_round_11_point_addition,
load_t4_mm0_round_11_point_addition,
load_t1_mm0_mm1_round_11_point_addition,
start_subtraction_addition_t5_t6_mm0_mm1_round_11_point_addition,
store_t7_mm2_round_11_point_addition,
-- Round 12
store_t5_t6_mm0_mm1_round_12_point_addition,
load_t7_t5_mm0_mm1_round_12_point_addition,
start_multiplication_t4_t1_mm0_mm1_round_12_point_addition,
load_t3_mm2_round_12_point_addition,
start_multiplication_t8_mm2_round_12_point_addition,
-- Round 13
store_t4_t1_mm0_mm1_round_13_point_addition,
load_t2_mm0_mm1_round_13_point_addition,
start_multiplication_t11_t9_mm0_mm1_round_13_point_addition,
store_t8_mm2_round_13_point_addition,
load_t6_mm2_round_13_point_addition,
start_multiplication_t10_mm2_round_13_point_addition,
-- Round 14
store_t11_t9_mm0_mm1_round_14_point_addition,
load_t1_t8_mm0_mm1_round_14_point_addition,
load_t4_mm0_round_14_point_addition,
start_addition_subtraction_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_addition,
load_t11_mm2_round_14_point_addition,
load_t11_mm2_round_14_point_doubling,
start_addition_sPz_or_fPz_or_Pz_mm2_round_14_point_addition,
store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_addition,
store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_doubling,
store_sPz_or_fPz_or_Pz_mm2_round_14_point_addition,
-- Finish
finish_point_addition,
wait_scalar_inner_loop_final_comparison,
finish_scalar_inner_loop,
-- Remove Point values from Montgomery Domain and transform to Affine
start_final_processing,
load_2_mm0_inversion_final_processing,
load_n_mm0_inversion_final_processing,
start_n_subtraction_final_processing,
wait_n_subtraction_1_final_processing,
wait_n_subtraction_2_final_processing,
store_inversion_expoent_final_processing,
load_1_sPz_mm0_mm1_final_processing,
store_1_sPz_mm0_mm1_final_processing,
store_1_mm0_mm1_final_processing,
finish_store_1_mm0_mm1_final_processing,
prepare_load_new_inversion_exponent_word_final_processing,
load_new_inversion_exponent_word_final_processing,
load_t0_mm0_mm1_final_processing,
load_t1_t0_mm0_mm1_final_processing,
start_multiplication_t1_t0_mm0_mm1_final_processing,
wait_multiplication_1_t1_t0_mm0_mm1_final_processing,
wait_multiplication_2_t1_t0_mm0_mm1_final_processing,
store_t1_or_t2_t0_mm0_mm1_final_processing,
prepare_update_internal_scalar_inversion_final_processing,
update_internal_scalar_inversion_final_processing,
finish_step_scalar_inversion_final_processing,
prepare_load_sPx_sPy_mm0_mm1_final_processing,
load_sPx_sPy_mm0_mm1_final_processing,
load_t1_mm0_mm1_final_processing,
start_multiplication_t1_sPx_sPy_mm0_mm1_final_processing,
wait_multiplication_1_t1_sPx_sPy_mm0_mm1_final_processing,
wait_multiplication_2_t1_sPx_sPy_mm0_mm1_final_processing,
store_multiplication_t1_sPx_sPy_mm0_mm1_final_processing,
finish_scalar_multiplication
);

signal actual_state, next_state : State;

constant memory_position_n : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(0, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_r2 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(1, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_a : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(2, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_b : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(3, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_scalar : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(4, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_Px : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(6, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_Py : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(7, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_Pz : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(8, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_sPx : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(9, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_sPy : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(10, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_sPz : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(11, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_fPx : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(12, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_fPy : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(13, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_fPz : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(14, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t0 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(15, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t1 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(16, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t2 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(17, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t3 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(18, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t4 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(19, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t5 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(20, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t6 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(21, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t7 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(22, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t8 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(23, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t9 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(24, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t10 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(25, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t11 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(26, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t12 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(27, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t13 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(28, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t14 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(29, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t15 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(30, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));
constant memory_position_t16 : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := std_logic_vector(to_unsigned(31, (internal_memory_size - (montgomery_multiplier_memory_size - 2))));

constant montgomery_processor_instruction_multiplication : STD_LOGIC_VECTOR(2 downto 0) := "000";
constant montgomery_processor_instruction_addition : STD_LOGIC_VECTOR(2 downto 0) := "001";
constant montgomery_processor_instruction_subtraction : STD_LOGIC_VECTOR(2 downto 0) := "010";
constant montgomery_processor_instruction_subtraction_no_normalization : STD_LOGIC_VECTOR(2 downto 0) := "011";
constant montgomery_processor_instruction_no_operation_memory_available : STD_LOGIC_VECTOR(2 downto 0) := "111";

signal internal_output_ce : STD_LOGIC;

signal internal_state_machine_free : STD_LOGIC;
signal internal_state_machine_finish_pre_processing : STD_LOGIC;
signal internal_state_machine_finish_point_addition : STD_LOGIC;
signal internal_state_machine_finish_scalar_multiplication : STD_LOGIC;
signal internal_state_machine_finish_final_processing : STD_LOGIC;
signal internal_reg_mode_point_addition_doubling_ce : STD_LOGIC;
signal internal_reg_mode_point_addition_doubling_rst : STD_LOGIC;
signal internal_memory_tranfer_unit_instruction : STD_LOGIC_VECTOR(1 downto 0);
signal internal_memory_tranfer_unit_continue_transfering : STD_LOGIC;
signal internal_memory_tranfer_unit_montgomery_unit_0_enable : STD_LOGIC;
signal internal_memory_tranfer_unit_montgomery_unit_1_enable : STD_LOGIC;
signal internal_memory_tranfer_unit_montgomery_unit_2_enable : STD_LOGIC;
signal internal_memory_tranfer_unit_enable_internal_memory_a : STD_LOGIC;
signal internal_memory_tranfer_unit_enable_internal_memory_b : STD_LOGIC;
signal internal_memory_tranfer_unit_enable_value_injection_a : STD_LOGIC;
signal internal_memory_tranfer_unit_enable_value_injection_b : STD_LOGIC;
signal internal_memory_tranfer_unit_value_injection_a : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal internal_memory_tranfer_unit_value_injection_b : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal internal_memory_tranfer_unit_internal_memory_address_a : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
signal internal_memory_tranfer_unit_internal_memory_address_b : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
signal internal_memory_tranfer_unit_montomery_unit_0_address : STD_LOGIC_VECTOR(1 downto 0);
signal internal_memory_tranfer_unit_montomery_unit_1_2_address : STD_LOGIC_VECTOR(1 downto 0);
signal internal_montgomery_processor_0_start : STD_LOGIC;
signal internal_montgomery_processor_0_instruction : STD_LOGIC_VECTOR(2 downto 0);
signal internal_montgomery_processor_0_variable_a_position : STD_LOGIC_VECTOR(1 downto 0);
signal internal_montgomery_processor_0_variable_b_position : STD_LOGIC_VECTOR(1 downto 0);
signal internal_montgomery_processor_0_variable_p_position : STD_LOGIC_VECTOR(1 downto 0);
signal internal_montgomery_processor_1_start : STD_LOGIC;
signal internal_montgomery_processor_1_instruction : STD_LOGIC_VECTOR(2 downto 0);
signal internal_montgomery_processor_1_variable_a_position : STD_LOGIC_VECTOR(1 downto 0);
signal internal_montgomery_processor_1_variable_b_position : STD_LOGIC_VECTOR(1 downto 0);
signal internal_montgomery_processor_1_variable_p_position : STD_LOGIC_VECTOR(1 downto 0);
signal internal_montgomery_processor_2_start : STD_LOGIC;
signal internal_montgomery_processor_2_instruction : STD_LOGIC_VECTOR(2 downto 0);
signal internal_montgomery_processor_2_variable_a_position : STD_LOGIC_VECTOR(1 downto 0);
signal internal_montgomery_processor_2_variable_b_position : STD_LOGIC_VECTOR(1 downto 0);
signal internal_montgomery_processor_2_variable_p_position : STD_LOGIC_VECTOR(1 downto 0);
signal internal_local_shifter_ce : STD_LOGIC;
signal internal_local_shifter_load : STD_LOGIC;
signal internal_reg_prime_size_ce : STD_LOGIC;
signal internal_ctr_scalar_size_ce : STD_LOGIC;
signal internal_ctr_scalar_size_load : STD_LOGIC;
signal internal_reg_scalar_word_address_ce : STD_LOGIC;
signal internal_reg_scalar_word_address_rst : STD_LOGIC;
signal internal_ctr_scalar_word_shifter_ce : STD_LOGIC;
signal internal_ctr_scalar_word_shifter_rst : STD_LOGIC;
signal internal_reg_comparison_a_rst : STD_LOGiC;
signal internal_reg_comparison_b_rst : STD_LOGiC;
signal internal_sel_comparison_scalar : STD_LOGIC;
signal internal_sel_inversion_mode : STD_LOGIC;


signal reg_mode_point_addition_doubling_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_mode_point_addition_doubling_ce : STD_LOGIC;
signal reg_mode_point_addition_doubling_rst : STD_LOGIC;
constant reg_mode_point_addition_doubling_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_mode_point_addition_doubling_q : STD_LOGIC_VECTOR(0 downto 0);

begin

Clock : process (clk)
begin
    if (rising_edge(clk)) then
        if(rst = '0') then
            actual_state <= reset;
            state_machine_free <= '0';
            state_machine_finish_pre_processing <= '1';
            state_machine_finish_point_addition <= '1';
            state_machine_finish_scalar_multiplication <= '1';
            state_machine_finish_final_processing <= '1';
            reg_mode_point_addition_doubling_ce <= '0';
            reg_mode_point_addition_doubling_rst <= '0';
            memory_tranfer_unit_instruction <= "11";
            memory_tranfer_unit_continue_transfering <= '0';
            memory_tranfer_unit_montgomery_unit_0_enable <= '0';
            memory_tranfer_unit_montgomery_unit_1_enable <= '0';
            memory_tranfer_unit_montgomery_unit_2_enable <= '0';
            memory_tranfer_unit_enable_internal_memory_a <= '0';
            memory_tranfer_unit_enable_internal_memory_b <= '0';
            memory_tranfer_unit_enable_value_injection_a <= '0';
            memory_tranfer_unit_enable_value_injection_b <= '0';
            memory_tranfer_unit_value_injection_a <= std_logic_vector(to_unsigned(0, word_length));
            memory_tranfer_unit_value_injection_b <= std_logic_vector(to_unsigned(0, word_length));
            memory_tranfer_unit_internal_memory_address_a <= memory_position_n;
            memory_tranfer_unit_internal_memory_address_b <= memory_position_n;
            memory_tranfer_unit_montomery_unit_0_address <= "00";
            memory_tranfer_unit_montomery_unit_1_2_address <= "00";
            montgomery_processor_0_start <= '0';
            montgomery_processor_0_instruction <= montgomery_processor_instruction_no_operation_memory_available;
            montgomery_processor_0_variable_a_position <= "00";
            montgomery_processor_0_variable_b_position <= "00";
            montgomery_processor_0_variable_p_position <= "00";
            montgomery_processor_1_start <= '0';
            montgomery_processor_1_instruction <= montgomery_processor_instruction_no_operation_memory_available;
            montgomery_processor_1_variable_a_position <= "00";
            montgomery_processor_1_variable_b_position <= "00";
            montgomery_processor_1_variable_p_position <= "00";
            montgomery_processor_2_start <= '0';
            montgomery_processor_2_instruction <= montgomery_processor_instruction_no_operation_memory_available;
            montgomery_processor_2_variable_a_position <= "00";
            montgomery_processor_2_variable_b_position <= "00";
            montgomery_processor_2_variable_p_position <= "00";
            local_shifter_ce <= '0';
            local_shifter_load <= '0';
            reg_prime_size_ce <= '0';
            ctr_scalar_size_ce <= '0';
            ctr_scalar_size_load <= '0';
            reg_scalar_word_address_ce <= '0';
            reg_scalar_word_address_rst <= '0';
            ctr_scalar_word_shifter_ce <= '0';
            ctr_scalar_word_shifter_rst <= '0';
            reg_comparison_a_rst <= '0';
            reg_comparison_b_rst <= '0';
            sel_comparison_scalar <= '0';
            sel_inversion_mode <= '0';
        else
            actual_state <= next_state;
            if(internal_output_ce = '1') then
                state_machine_free <= internal_state_machine_free;
                state_machine_finish_pre_processing <= internal_state_machine_finish_pre_processing;
                state_machine_finish_point_addition <= internal_state_machine_finish_point_addition;
                state_machine_finish_scalar_multiplication <= internal_state_machine_finish_scalar_multiplication;
                state_machine_finish_final_processing <= internal_state_machine_finish_final_processing;
                reg_mode_point_addition_doubling_ce <= internal_reg_mode_point_addition_doubling_ce;
                reg_mode_point_addition_doubling_rst <= internal_reg_mode_point_addition_doubling_rst;
                memory_tranfer_unit_instruction <= internal_memory_tranfer_unit_instruction;
                memory_tranfer_unit_continue_transfering <= internal_memory_tranfer_unit_continue_transfering;
                memory_tranfer_unit_montgomery_unit_0_enable <= internal_memory_tranfer_unit_montgomery_unit_0_enable;
                memory_tranfer_unit_montgomery_unit_1_enable <= internal_memory_tranfer_unit_montgomery_unit_1_enable;
                memory_tranfer_unit_montgomery_unit_2_enable <= internal_memory_tranfer_unit_montgomery_unit_2_enable;
                memory_tranfer_unit_enable_internal_memory_a <= internal_memory_tranfer_unit_enable_internal_memory_a;
                memory_tranfer_unit_enable_internal_memory_b <= internal_memory_tranfer_unit_enable_internal_memory_b;
                memory_tranfer_unit_enable_value_injection_a <= internal_memory_tranfer_unit_enable_value_injection_a;
                memory_tranfer_unit_enable_value_injection_b <= internal_memory_tranfer_unit_enable_value_injection_b;
                memory_tranfer_unit_value_injection_a <= internal_memory_tranfer_unit_value_injection_a;
                memory_tranfer_unit_value_injection_b <= internal_memory_tranfer_unit_value_injection_b;
                memory_tranfer_unit_internal_memory_address_a <= internal_memory_tranfer_unit_internal_memory_address_a;
                memory_tranfer_unit_internal_memory_address_b <= internal_memory_tranfer_unit_internal_memory_address_b;
                memory_tranfer_unit_montomery_unit_0_address <= internal_memory_tranfer_unit_montomery_unit_0_address;
                memory_tranfer_unit_montomery_unit_1_2_address <= internal_memory_tranfer_unit_montomery_unit_1_2_address;
                montgomery_processor_0_start <= internal_montgomery_processor_0_start;
                montgomery_processor_0_instruction <= internal_montgomery_processor_0_instruction;
                montgomery_processor_0_variable_a_position <= internal_montgomery_processor_0_variable_a_position;
                montgomery_processor_0_variable_b_position <= internal_montgomery_processor_0_variable_b_position;
                montgomery_processor_0_variable_p_position <= internal_montgomery_processor_0_variable_p_position;
                montgomery_processor_1_start <= internal_montgomery_processor_1_start;
                montgomery_processor_1_instruction <= internal_montgomery_processor_1_instruction;
                montgomery_processor_1_variable_a_position <= internal_montgomery_processor_1_variable_a_position;
                montgomery_processor_1_variable_b_position <= internal_montgomery_processor_1_variable_b_position;
                montgomery_processor_1_variable_p_position <= internal_montgomery_processor_1_variable_p_position;
                montgomery_processor_2_start <= internal_montgomery_processor_2_start;
                montgomery_processor_2_instruction <= internal_montgomery_processor_2_instruction;
                montgomery_processor_2_variable_a_position <= internal_montgomery_processor_2_variable_a_position;
                montgomery_processor_2_variable_b_position <= internal_montgomery_processor_2_variable_b_position;
                montgomery_processor_2_variable_p_position <= internal_montgomery_processor_2_variable_p_position;
                local_shifter_ce <= internal_local_shifter_ce;
                local_shifter_load <= internal_local_shifter_load;
                reg_prime_size_ce <= internal_reg_prime_size_ce;
                ctr_scalar_size_ce <= internal_ctr_scalar_size_ce;
                ctr_scalar_size_load <= internal_ctr_scalar_size_load;
                reg_scalar_word_address_ce <= internal_reg_scalar_word_address_ce;
                reg_scalar_word_address_rst <= internal_reg_scalar_word_address_rst;
                ctr_scalar_word_shifter_ce <= internal_ctr_scalar_word_shifter_ce;
                ctr_scalar_word_shifter_rst <= internal_ctr_scalar_word_shifter_rst;
                reg_comparison_a_rst <= internal_reg_comparison_a_rst;
                reg_comparison_b_rst <= internal_reg_comparison_b_rst;
                sel_comparison_scalar <= internal_sel_comparison_scalar;
                sel_inversion_mode <= internal_sel_inversion_mode;
            end if;
        end if;
    else
        null;
    end if;
end process;

Update_State : process (actual_state, start, reg_comparison_a_equal_b, montgomery_processor_0_processor_free, montgomery_processor_1_processor_free, montgomery_processor_2_processor_free, memory_transfer_unit_free, ctr_scalar_word_shifter_limit, reg_mode_point_addition_doubling_q(0))
begin
    case (actual_state) is
        when reset =>
            next_state <= idle_state;
        when idle_state =>
            if(start = '1') then
                next_state <= start_pre_processing;
            else
                next_state <= idle_state;
            end if;
        when start_pre_processing =>
            next_state <= load_n_pre_processing;
        when load_n_pre_processing =>
            if(reg_comparison_a_equal_b = '1') then
                next_state <= load_special_n_pre_processing;
            else
                next_state <= load_n_pre_processing;
            end if;
        when load_special_n_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_r2_pre_processing;
            else
                next_state <= load_special_n_pre_processing;
            end if;
        when load_r2_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_a_1_pre_processing;               
            else
                next_state <= load_r2_pre_processing;
            end if;
        when load_a_1_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_ar_1r_pre_processing;
            else
                next_state <= load_a_1_pre_processing;               
            end if;
        when start_multiplication_ar_1r_pre_processing =>
            next_state <= load_b_pre_processing;
        when load_b_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_b_again_pre_processing;
            else
                next_state <= load_b_pre_processing;
            end if;
        when load_b_again_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_2b_addition_pre_processing;
            else
                next_state <= load_b_again_pre_processing;
            end if;
        when start_2b_addition_pre_processing =>
            next_state <= wait_2b_addition_1_pre_processing;        
        when wait_2b_addition_1_pre_processing =>
            next_state <= wait_2b_addition_2_pre_processing;
        when wait_2b_addition_2_pre_processing =>
            if(montgomery_processor_1_processor_free = '1') then
                next_state <= start_3b_addition_pre_processing;
            else
                next_state <= wait_2b_addition_2_pre_processing;
            end if;
        when start_3b_addition_pre_processing =>
            next_state <= wait_3b_addition_1_pre_processing;
        when wait_3b_addition_1_pre_processing =>
            next_state <= wait_3b_addition_2_pre_processing;
        when wait_3b_addition_2_pre_processing =>
            if(montgomery_processor_1_processor_free = '1') then
                next_state <= start_multiplication_3br_pre_processing;
            else
                next_state <= wait_3b_addition_2_pre_processing;
            end if;
        when start_multiplication_3br_pre_processing =>
            next_state <= insert_zero_sPx_pre_processing;
        when insert_zero_sPx_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= insert_zero_sPz_pre_processing;
            else
                next_state <= insert_zero_sPx_pre_processing;
            end if;
        when insert_zero_sPz_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= store_ar_1r_pre_processing;
            else
                next_state <= insert_zero_sPz_pre_processing;
            end if;
        when store_ar_1r_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_Px_Py_pre_processing;
            else
                next_state <= store_ar_1r_pre_processing;
            end if;
        when load_Px_Py_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_Px_Py_multiplication_pre_processing;
            else
                next_state <= load_Px_Py_pre_processing;
            end if;
        when start_Px_Py_multiplication_pre_processing =>
            next_state <= store_3br_multiplication_pre_processing;
        when store_3br_multiplication_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_Pz_pre_processing;
            else
                next_state <= store_3br_multiplication_pre_processing;
            end if;
        when load_Pz_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_Pz_pre_processing;
            else
                next_state <= load_Pz_pre_processing;
            end if;
        when start_multiplication_Pz_pre_processing =>
            next_state <= store_Pxr_Pyr_multiplication_pre_processing;
        when store_Pxr_Pyr_multiplication_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= store_Pzr_multiplication_pre_processing;
            else
                next_state <= store_Pxr_Pyr_multiplication_pre_processing;
            end if;
        when store_Pzr_multiplication_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= finish_store_Pzr_multiplication_pre_processing;
            else
                next_state <= store_Pzr_multiplication_pre_processing;
            end if;
        when finish_store_Pzr_multiplication_pre_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= finish_pre_processing;
            else
                next_state <= finish_store_Pzr_multiplication_pre_processing;
            end if;
        when finish_pre_processing =>
            next_state <= prepare_load_new_scalar_word;
        when prepare_load_new_scalar_word =>
            next_state <= load_new_scalar_word;
        when load_new_scalar_word =>
            if(memory_transfer_unit_free = '1') then
                next_state <= prepare_point_addition;
            else
                next_state <= load_new_scalar_word;
            end if;
        when prepare_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                next_state <= load_Px_Py_mm0_mm1_round_1_point_doubling;
            else
                next_state <= load_Px_Py_mm0_mm1_round_1_point_addition;
            end if;
        when load_Px_Py_mm0_mm1_round_1_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPx_sPy_or_Px_Py_mm0_mm1_round_1_point_addition;
            else
                next_state <= load_Px_Py_mm0_mm1_round_1_point_addition;
            end if;
        when load_Px_Py_mm0_mm1_round_1_point_doubling =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPx_sPy_or_Px_Py_mm0_mm1_round_1_point_addition;
            else
                next_state <= load_Px_Py_mm0_mm1_round_1_point_doubling;
            end if;
        when load_sPx_sPy_or_Px_Py_mm0_mm1_round_1_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t0_t1_mm0_mm1_round_1_point_addition;
            else
                next_state <= load_sPx_sPy_or_Px_Py_mm0_mm1_round_1_point_addition;
            end if;
        when start_multiplication_t0_t1_mm0_mm1_round_1_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                next_state <= load_Pz_mm2_round_1_point_doubling;
            else
                next_state <= load_Pz_mm2_round_1_point_addition;
            end if;
        when load_Pz_mm2_round_1_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPz_or_Pz_mm2_round_1_point_addition;
            else
                next_state <= load_Pz_mm2_round_1_point_addition;
            end if;
        when load_Pz_mm2_round_1_point_doubling =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPz_or_Pz_mm2_round_1_point_addition;
            else
                next_state <= load_Pz_mm2_round_1_point_doubling;
            end if; 
        when load_sPz_or_Pz_mm2_round_1_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t2_mm2_round_1_point_addition;
            else
                next_state <= load_sPz_or_Pz_mm2_round_1_point_addition;
            end if; 
        when start_multiplication_t2_mm2_round_1_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                next_state <= store_t0_t1_mm0_mm1_round_2_point_doubling;
            else
                next_state <= store_t0_t1_mm0_mm1_round_2_point_addition;
            end if;
        when store_t0_t1_mm0_mm1_round_2_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPy_or_Py_Px_mm0_mm1_round_2_point_addition;
            else
                next_state <= store_t0_t1_mm0_mm1_round_2_point_addition;
            end if;
        when store_t0_t1_mm0_mm1_round_2_point_doubling =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPy_or_Py_Px_mm0_mm1_round_2_point_addition;
            else
                next_state <= store_t0_t1_mm0_mm1_round_2_point_doubling;
            end if; 
        when load_sPy_or_Py_Px_mm0_mm1_round_2_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_t3_t4_mm0_mm1_round_2_point_addition;
            else
                next_state <= load_sPy_or_Py_Px_mm0_mm1_round_2_point_addition;
            end if; 
        when start_addition_t3_t4_mm0_mm1_round_2_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                next_state <= store_t2_mm2_round_2_point_doubling;
            else
                next_state <= store_t2_mm2_round_2_point_addition;
            end if;
        when store_t2_mm2_round_2_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPy_or_Py_mm2_round_2_point_addition;
            else
                next_state <= store_t2_mm2_round_2_point_addition;
            end if; 
        when store_t2_mm2_round_2_point_doubling =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPy_or_Py_mm2_round_2_point_addition;
            else
                next_state <= store_t2_mm2_round_2_point_doubling;
            end if; 
        when load_sPy_or_Py_mm2_round_2_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_t5_mm2_round_2_point_addition;
            else
                next_state <= load_sPy_or_Py_mm2_round_2_point_addition;
            end if; 
        when start_addition_t5_mm2_round_2_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                next_state <= store_t3_t4_mm0_mm1_round_3_point_doubling;
            else
                next_state <= store_t3_t4_mm0_mm1_round_3_point_addition;
            end if;
        when store_t3_t4_mm0_mm1_round_3_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPz_or_Pz_Pz_mm0_mm1_round_3_point_addition;
            else
                next_state <= store_t3_t4_mm0_mm1_round_3_point_addition;
            end if;
        when store_t3_t4_mm0_mm1_round_3_point_doubling =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_sPz_or_Pz_Pz_mm0_mm1_round_3_point_addition;
            else
                next_state <= store_t3_t4_mm0_mm1_round_3_point_doubling;
            end if;
        when load_sPz_or_Pz_Pz_mm0_mm1_round_3_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_t8_t7_mm0_mm1_round_3_point_addition;
            else
                next_state <= load_sPz_or_Pz_Pz_mm0_mm1_round_3_point_addition;
            end if;
        when start_addition_t8_t7_mm0_mm1_round_3_point_addition =>
            next_state <= store_t5_mm2_round_3_point_addition;
        when store_t5_mm2_round_3_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_Py_mm2_round_3_point_addition;
            else
                next_state <= store_t5_mm2_round_3_point_addition;
            end if;
        when load_Py_mm2_round_3_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_Pz_mm2_round_3_point_addition;
            else
                next_state <= load_Py_mm2_round_3_point_addition;
            end if;
        when load_Pz_mm2_round_3_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_t6_mm2_round_3_point_addition;
            else
                next_state <= load_Pz_mm2_round_3_point_addition;
            end if;
        when start_addition_t6_mm2_round_3_point_addition =>
            next_state <= store_t7_t8_mm0_mm1_round_4_point_addition;
        when store_t7_t8_mm0_mm1_round_4_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t3_t7_mm0_mm1_round_4_point_addition;
            else
                next_state <= store_t7_t8_mm0_mm1_round_4_point_addition;
            end if;
        when load_t3_t7_mm0_mm1_round_4_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t4_mm0_round_4_point_addition;
            else
                next_state <= load_t3_t7_mm0_mm1_round_4_point_addition;
            end if;
        when load_t4_mm0_round_4_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t9_t11_mm0_mm1_round_4_point_addition;
            else
                next_state <= load_t4_mm0_round_4_point_addition;
            end if;
        when start_multiplication_t9_t11_mm0_mm1_round_4_point_addition =>
            next_state <= store_t6_mm2_round_4_point_addition;
        when store_t6_mm2_round_4_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t5_mm2_round_4_point_addition;
            else
                next_state <= store_t6_mm2_round_4_point_addition;
            end if;
        when load_t5_mm2_round_4_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t10_mm2_round_4_point_addition;
            else
                next_state <= load_t5_mm2_round_4_point_addition;
            end if;
        when start_multiplication_t10_mm2_round_4_point_addition =>
            next_state <= store_t9_t11_mm0_mm1_round_5_point_addition;
        when store_t9_t11_mm0_mm1_round_5_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t2_mm0_mm1_round_5_point_addition;
            else
                next_state <= store_t9_t11_mm0_mm1_round_5_point_addition;
            end if;
        when load_t2_mm0_mm1_round_5_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t1_t0_mm0_mm1_round_5_point_addition;
            else
                next_state <= load_t2_mm0_mm1_round_5_point_addition;
            end if;
        when load_t1_t0_mm0_mm1_round_5_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_t4_t5_mm0_mm1_round_5_point_addition;
            else
                next_state <= load_t1_t0_mm0_mm1_round_5_point_addition;
            end if;
        when start_addition_t4_t5_mm0_mm1_round_5_point_addition =>
            next_state <= store_t10_mm2_round_5_point_addition;
        when store_t10_mm2_round_5_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t0_mm2_round_5_point_addition;
            else
                next_state <= store_t10_mm2_round_5_point_addition;
            end if;
        when load_t0_mm2_round_5_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t1_mm2_round_5_point_addition;
            else
                next_state <= load_t0_mm2_round_5_point_addition;
            end if;
        when load_t1_mm2_round_5_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_t3_mm2_round_5_point_addition;
            else
                next_state <= load_t1_mm2_round_5_point_addition;
            end if;
        when start_addition_t3_mm2_round_5_point_addition =>
            next_state <= store_t4_t5_mm0_mm1_round_6_7_8_point_addition;
        when store_t4_t5_mm0_mm1_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_3b_a_mm0_mm1_round_6_7_8_point_addition;
            else
                next_state <= store_t4_t5_mm0_mm1_round_6_7_8_point_addition;
            end if;
        when load_3b_a_mm0_mm1_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t6_t8_mm0_mm1_round_6_7_8_point_addition;
            else
                next_state <= load_3b_a_mm0_mm1_round_6_7_8_point_addition;
            end if;
        when start_multiplication_t6_t8_mm0_mm1_round_6_7_8_point_addition =>
            next_state <= load_t9_mm2_round_6_7_8_point_addition;
        when load_t9_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_subtraction_t2_mm2_round_6_7_8_point_addition;
            else
                next_state <= load_t9_mm2_round_6_7_8_point_addition;
            end if;
        when start_subtraction_t2_mm2_round_6_7_8_point_addition =>
            next_state <= wait_subtraction_t2_mm2_round_6_7_8_point_addition;
        when wait_subtraction_t2_mm2_round_6_7_8_point_addition =>
            next_state <= store_t2_mm2_round_6_7_8_point_addition;
        when store_t2_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t10_mm2_round_6_7_8_point_addition;
            else
                next_state <= store_t2_mm2_round_6_7_8_point_addition;
            end if;
        when load_t10_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t4_mm2_round_6_7_8_point_addition;
            else
                next_state <= load_t10_mm2_round_6_7_8_point_addition;
            end if;
        when load_t4_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_subtraction_t3_mm2_round_6_7_8_point_addition;
            else
                next_state <= load_t4_mm2_round_6_7_8_point_addition;
            end if;
        when start_subtraction_t3_mm2_round_6_7_8_point_addition =>
            next_state <= wait_subtraction_t3_mm2_round_6_7_8_point_addition;
        when wait_subtraction_t3_mm2_round_6_7_8_point_addition =>
            next_state <= store_t3_mm2_round_6_7_8_point_addition;
        when store_t3_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t11_mm2_round_6_7_8_point_addition;
            else
                next_state <= store_t3_mm2_round_6_7_8_point_addition;
            end if;
        when load_t11_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t5_mm2_round_6_7_8_point_addition;
            else
                next_state <= load_t11_mm2_round_6_7_8_point_addition;
            end if;
        when load_t5_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_subtraction_t4_mm2_round_6_7_8_point_addition;
            else
                next_state <= load_t5_mm2_round_6_7_8_point_addition;
            end if;
        when start_subtraction_t4_mm2_round_6_7_8_point_addition =>
            next_state <= wait_subtraction_t4_mm2_round_6_7_8_point_addition;
        when wait_subtraction_t4_mm2_round_6_7_8_point_addition =>
            next_state <= store_t4_mm2_round_6_7_8_point_addition;
        when store_t4_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t0_mm2_round_6_7_8_point_addition;
            else
                next_state <= store_t4_mm2_round_6_7_8_point_addition;
            end if;
        when load_t0_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t0_again_mm2_round_6_7_8_point_addition;
            else
                next_state <= load_t0_mm2_round_6_7_8_point_addition;
            end if;
        when load_t0_again_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_t10_mm2_round_6_7_8_point_addition;
            else
                next_state <= load_t0_again_mm2_round_6_7_8_point_addition;
            end if;
        when start_addition_t10_mm2_round_6_7_8_point_addition =>
            next_state <= wait_addition_1_t10_mm2_round_6_7_8_point_addition;       
        when wait_addition_1_t10_mm2_round_6_7_8_point_addition =>
            next_state <= wait_addition_2_t10_mm2_round_6_7_8_point_addition;
        when wait_addition_2_t10_mm2_round_6_7_8_point_addition =>
            if(montgomery_processor_2_processor_free = '1') then
                next_state <= start_addition_again_t10_mm2_round_6_7_8_point_addition;
            else
                next_state <= wait_addition_2_t10_mm2_round_6_7_8_point_addition;
            end if;
        when start_addition_again_t10_mm2_round_6_7_8_point_addition =>
            next_state <= wait_addition_again_t10_mm2_round_6_7_8_point_addition;
            when wait_addition_again_t10_mm2_round_6_7_8_point_addition =>
            next_state <= store_t10_mm2_round_6_7_8_point_addition;
        when store_t10_mm2_round_6_7_8_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= store_t6_t8_mm0_mm1_round_9_point_addition;
            else
                next_state <= store_t10_mm2_round_6_7_8_point_addition;
            end if;
        when store_t6_t8_mm0_mm1_round_9_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t4_mm0_mm1_round_9_point_addition;
            else
                next_state <= store_t6_t8_mm0_mm1_round_9_point_addition;
            end if;
        when load_t4_mm0_mm1_round_9_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_mm0_mm1_round_9_point_addition;
            else
                next_state <= load_t4_mm0_mm1_round_9_point_addition;
            end if;
        when start_multiplication_mm0_mm1_round_9_point_addition =>
            next_state <= load_t8_mm2_round_9_point_addition;
        when load_t8_mm2_round_9_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_a_mm2_round_9_point_addition;
            else
                next_state <= load_t8_mm2_round_9_point_addition;
            end if;
        when load_a_mm2_round_9_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_subtraction_t7_mm2_round_9_point_addition;
            else
                next_state <= load_a_mm2_round_9_point_addition;
            end if;
        when start_subtraction_t7_mm2_round_9_point_addition =>
            next_state <= wait_subtraction_1_t7_mm2_round_9_point_addition;
        when wait_subtraction_1_t7_mm2_round_9_point_addition =>
            next_state <= wait_subtraction_2_t7_mm2_round_9_point_addition;
        when wait_subtraction_2_t7_mm2_round_9_point_addition =>
            if(montgomery_processor_2_processor_free = '1') then
                next_state <= start_multiplication_t9_mm2_round_9_point_addition;
            else
                next_state <= wait_subtraction_2_t7_mm2_round_9_point_addition;
            end if;
        when start_multiplication_t9_mm2_round_9_point_addition =>
            next_state <= store_t5_mm0_round_10_point_addition;
        when store_t5_mm0_round_10_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t8_t6_mm0_mm1_round_10_point_addition;
            else
                next_state <= store_t5_mm0_round_10_point_addition;
            end if;
        when load_t8_t6_mm0_mm1_round_10_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t10_mm0_round_10_point_addition;
            else
                next_state <= load_t8_t6_mm0_mm1_round_10_point_addition;
            end if;
        when load_t10_mm0_round_10_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_t0_t4_mm0_mm1_round_10_point_addition;
            else
                next_state <= load_t10_mm0_round_10_point_addition;
            end if;
        when start_addition_t0_t4_mm0_mm1_round_10_point_addition =>
            next_state <= load_t5_mm2_round_10_point_addition;
        when load_t5_mm2_round_10_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_t7_mm2_round_10_point_addition;
            else
                next_state <= load_t5_mm2_round_10_point_addition;
            end if;
        when start_addition_t7_mm2_round_10_point_addition =>
            next_state <= store_t0_t4_mm0_mm1_round_11_point_addition;
        when store_t0_t4_mm0_mm1_round_11_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t4_mm0_round_11_point_addition;
            else
                next_state <= store_t0_t4_mm0_mm1_round_11_point_addition;
            end if;
        when load_t4_mm0_round_11_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t1_mm0_mm1_round_11_point_addition;
            else
                next_state <= load_t4_mm0_round_11_point_addition;
            end if;
        when load_t1_mm0_mm1_round_11_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_subtraction_addition_t5_t6_mm0_mm1_round_11_point_addition;
            else
                next_state <= load_t1_mm0_mm1_round_11_point_addition;
            end if;
        when start_subtraction_addition_t5_t6_mm0_mm1_round_11_point_addition =>
            next_state <= store_t7_mm2_round_11_point_addition;
        when store_t7_mm2_round_11_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= store_t5_t6_mm0_mm1_round_12_point_addition;
            else
                next_state <= store_t7_mm2_round_11_point_addition;
            end if;
        when store_t5_t6_mm0_mm1_round_12_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t7_t5_mm0_mm1_round_12_point_addition;
            else
                next_state <= store_t5_t6_mm0_mm1_round_12_point_addition;
            end if;
        when load_t7_t5_mm0_mm1_round_12_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t4_t1_mm0_mm1_round_12_point_addition;
            else
                next_state <= load_t7_t5_mm0_mm1_round_12_point_addition;
            end if;
        when start_multiplication_t4_t1_mm0_mm1_round_12_point_addition =>
            next_state <= load_t3_mm2_round_12_point_addition;
        when load_t3_mm2_round_12_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t8_mm2_round_12_point_addition;
            else
                next_state <= load_t3_mm2_round_12_point_addition;
            end if;
        when start_multiplication_t8_mm2_round_12_point_addition =>
            next_state <= store_t4_t1_mm0_mm1_round_13_point_addition;
        when store_t4_t1_mm0_mm1_round_13_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t2_mm0_mm1_round_13_point_addition;
            else
                next_state <= store_t4_t1_mm0_mm1_round_13_point_addition;
            end if;
        when load_t2_mm0_mm1_round_13_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t11_t9_mm0_mm1_round_13_point_addition;
            else
                next_state <= load_t2_mm0_mm1_round_13_point_addition;
            end if;
        when start_multiplication_t11_t9_mm0_mm1_round_13_point_addition =>
            next_state <= store_t8_mm2_round_13_point_addition;
        when store_t8_mm2_round_13_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t6_mm2_round_13_point_addition;
            else
                next_state <= store_t8_mm2_round_13_point_addition;
            end if;
        when load_t6_mm2_round_13_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t10_mm2_round_13_point_addition;
            else
                next_state <= load_t6_mm2_round_13_point_addition;
            end if;
        when start_multiplication_t10_mm2_round_13_point_addition =>
            next_state <= store_t11_t9_mm0_mm1_round_14_point_addition;
        when store_t11_t9_mm0_mm1_round_14_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t1_t8_mm0_mm1_round_14_point_addition;
            else
                next_state <= store_t11_t9_mm0_mm1_round_14_point_addition;
            end if;
        when load_t1_t8_mm0_mm1_round_14_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t4_mm0_round_14_point_addition;
            else
                next_state <= load_t1_t8_mm0_mm1_round_14_point_addition;
            end if;
        when load_t4_mm0_round_14_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_subtraction_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_addition;
            else
                next_state <= load_t4_mm0_round_14_point_addition;
            end if;
        when start_addition_subtraction_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                next_state <= load_t11_mm2_round_14_point_doubling;
            else
                next_state <= load_t11_mm2_round_14_point_addition;
            end if;
        when load_t11_mm2_round_14_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_sPz_or_fPz_or_Pz_mm2_round_14_point_addition;
            else
                next_state <= load_t11_mm2_round_14_point_addition;
            end if;
        when load_t11_mm2_round_14_point_doubling =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_addition_sPz_or_fPz_or_Pz_mm2_round_14_point_addition;
            else
                next_state <= load_t11_mm2_round_14_point_doubling;
            end if;
        when start_addition_sPz_or_fPz_or_Pz_mm2_round_14_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                next_state <= store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_doubling;
            else
                next_state <= store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_addition;
            end if;
        when store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= store_sPz_or_fPz_or_Pz_mm2_round_14_point_addition;
            else
                next_state <= store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_addition;
            end if;
        when store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_doubling =>
            if(memory_transfer_unit_free = '1') then
                next_state <= store_sPz_or_fPz_or_Pz_mm2_round_14_point_addition;
            else
                next_state <= store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_doubling;
            end if;
        when store_sPz_or_fPz_or_Pz_mm2_round_14_point_addition =>
            if(memory_transfer_unit_free = '1') then
                next_state <= finish_point_addition;
            else
                next_state <= store_sPz_or_fPz_or_Pz_mm2_round_14_point_addition;
            end if;
        when finish_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                next_state <= wait_scalar_inner_loop_final_comparison;
            else
                next_state <= prepare_point_addition;
            end if;
        when wait_scalar_inner_loop_final_comparison =>
            next_state <= finish_scalar_inner_loop;
        when finish_scalar_inner_loop =>
            if(reg_comparison_a_equal_b = '1') then
                next_state <= start_final_processing;
            elsif(ctr_scalar_word_shifter_limit = '1') then
                next_state <= prepare_load_new_scalar_word;
            else
                next_state <= prepare_point_addition;
            end if;
        when start_final_processing =>
            next_state <= load_2_mm0_inversion_final_processing;
        when load_2_mm0_inversion_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_n_mm0_inversion_final_processing;
            else
                next_state <= load_2_mm0_inversion_final_processing;
            end if;         
        when load_n_mm0_inversion_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_n_subtraction_final_processing;
            else
                next_state <= load_n_mm0_inversion_final_processing;
            end if;  
        when start_n_subtraction_final_processing =>
            next_state <= wait_n_subtraction_1_final_processing;
        when wait_n_subtraction_1_final_processing =>
            next_state <= wait_n_subtraction_2_final_processing;
        when wait_n_subtraction_2_final_processing =>
            if(montgomery_processor_0_processor_free = '1') then
                next_state <= store_inversion_expoent_final_processing;
            else
                next_state <= wait_n_subtraction_2_final_processing;
            end if;
        when store_inversion_expoent_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_1_sPz_mm0_mm1_final_processing;
            else
                next_state <= store_inversion_expoent_final_processing;
            end if;  
        when load_1_sPz_mm0_mm1_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= store_1_sPz_mm0_mm1_final_processing;
            else
                next_state <= load_1_sPz_mm0_mm1_final_processing;
            end if;         
        when store_1_sPz_mm0_mm1_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= store_1_mm0_mm1_final_processing;
            else
                next_state <= store_1_sPz_mm0_mm1_final_processing;
            end if;        
        when store_1_mm0_mm1_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= finish_store_1_mm0_mm1_final_processing;
            else
                next_state <= store_1_mm0_mm1_final_processing;
            end if; 
        when finish_store_1_mm0_mm1_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= prepare_load_new_inversion_exponent_word_final_processing;
            else
                next_state <= finish_store_1_mm0_mm1_final_processing;
            end if; 
        when prepare_load_new_inversion_exponent_word_final_processing =>
            next_state <= load_new_inversion_exponent_word_final_processing;
        when load_new_inversion_exponent_word_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t0_mm0_mm1_final_processing;
            else
                next_state <= load_new_inversion_exponent_word_final_processing;
            end if; 
        when load_t0_mm0_mm1_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t1_t0_mm0_mm1_final_processing;
            else
                next_state <= load_t0_mm0_mm1_final_processing;
            end if; 
        when load_t1_t0_mm0_mm1_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t1_t0_mm0_mm1_final_processing;
            else
                next_state <= load_t1_t0_mm0_mm1_final_processing;
            end if; 
        when start_multiplication_t1_t0_mm0_mm1_final_processing =>
            next_state <= wait_multiplication_1_t1_t0_mm0_mm1_final_processing;
        when wait_multiplication_1_t1_t0_mm0_mm1_final_processing =>
            next_state <= wait_multiplication_2_t1_t0_mm0_mm1_final_processing;
        when wait_multiplication_2_t1_t0_mm0_mm1_final_processing =>
            if(montgomery_processor_0_processor_free = '1') then
                next_state <= store_t1_or_t2_t0_mm0_mm1_final_processing;
            else
                next_state <= wait_multiplication_2_t1_t0_mm0_mm1_final_processing;
            end if;
        when store_t1_or_t2_t0_mm0_mm1_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= prepare_update_internal_scalar_inversion_final_processing;
            else
                next_state <= store_t1_or_t2_t0_mm0_mm1_final_processing;
            end if; 
        when prepare_update_internal_scalar_inversion_final_processing =>
            next_state <= update_internal_scalar_inversion_final_processing;
        when update_internal_scalar_inversion_final_processing =>
            next_state <= finish_step_scalar_inversion_final_processing;
        when finish_step_scalar_inversion_final_processing =>
            if(ctr_scalar_word_shifter_limit = '1' and reg_comparison_a_equal_b = '1') then
                next_state <= prepare_load_sPx_sPy_mm0_mm1_final_processing;
            elsif(ctr_scalar_word_shifter_limit = '1') then
                next_state <= prepare_load_new_inversion_exponent_word_final_processing;
            else
                next_state <= load_new_inversion_exponent_word_final_processing;
            end if;
        when prepare_load_sPx_sPy_mm0_mm1_final_processing =>
            next_state <= load_sPx_sPy_mm0_mm1_final_processing;
        when load_sPx_sPy_mm0_mm1_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= load_t1_mm0_mm1_final_processing;
            else
                next_state <= load_sPx_sPy_mm0_mm1_final_processing;
            end if; 
        when load_t1_mm0_mm1_final_processing =>
            if(memory_transfer_unit_free = '1') then
                next_state <= start_multiplication_t1_sPx_sPy_mm0_mm1_final_processing;
            else
                next_state <= load_t1_mm0_mm1_final_processing;
            end if;
        when start_multiplication_t1_sPx_sPy_mm0_mm1_final_processing =>
            next_state <= wait_multiplication_1_t1_sPx_sPy_mm0_mm1_final_processing;
        when wait_multiplication_1_t1_sPx_sPy_mm0_mm1_final_processing =>
            next_state <= wait_multiplication_2_t1_sPx_sPy_mm0_mm1_final_processing;
        when wait_multiplication_2_t1_sPx_sPy_mm0_mm1_final_processing =>
            if(montgomery_processor_0_processor_free = '1') then
                next_state <= store_multiplication_t1_sPx_sPy_mm0_mm1_final_processing;
            else
                next_state <= wait_multiplication_2_t1_sPx_sPy_mm0_mm1_final_processing;
            end if;
        when store_multiplication_t1_sPx_sPy_mm0_mm1_final_processing =>            
            if(memory_transfer_unit_free = '1') then
                next_state <= finish_scalar_multiplication;
            else
                next_state <= store_multiplication_t1_sPx_sPy_mm0_mm1_final_processing;
            end if;
        when finish_scalar_multiplication =>
            next_state <= idle_state;
    end case;
end process;


Update_Output : process (actual_state, start, reg_comparison_a_equal_b, montgomery_processor_0_processor_free, montgomery_processor_1_processor_free, montgomery_processor_2_processor_free, memory_transfer_unit_free, ctr_scalar_word_shifter_limit, reg_mode_point_addition_doubling_q(0), scalar_bit)
begin
    internal_state_machine_free <= '0';
    internal_state_machine_finish_pre_processing <= '1';
    internal_state_machine_finish_point_addition <= '1';
    internal_state_machine_finish_scalar_multiplication <= '1';
    internal_state_machine_finish_final_processing <= '1';
    internal_reg_mode_point_addition_doubling_ce <= '0';
    internal_reg_mode_point_addition_doubling_rst <= '1';
    internal_memory_tranfer_unit_instruction <= "11";
    internal_memory_tranfer_unit_continue_transfering <= '0';
    internal_memory_tranfer_unit_montgomery_unit_0_enable <= '0';
    internal_memory_tranfer_unit_montgomery_unit_1_enable <= '0';
    internal_memory_tranfer_unit_montgomery_unit_2_enable <= '0';
    internal_memory_tranfer_unit_enable_internal_memory_a <= '0';
    internal_memory_tranfer_unit_enable_internal_memory_b <= '0';
    internal_memory_tranfer_unit_enable_value_injection_a <= '0';
    internal_memory_tranfer_unit_enable_value_injection_b <= '0';
    internal_memory_tranfer_unit_value_injection_a <= std_logic_vector(to_unsigned(0, word_length));
    internal_memory_tranfer_unit_value_injection_b <= std_logic_vector(to_unsigned(0, word_length));
    internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_n;
    internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_n;
    internal_memory_tranfer_unit_montomery_unit_0_address <= "00";
    internal_memory_tranfer_unit_montomery_unit_1_2_address <= "00";
    internal_montgomery_processor_0_start <= '0';
    internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_no_operation_memory_available;
    internal_montgomery_processor_0_variable_a_position <= "00";
    internal_montgomery_processor_0_variable_b_position <= "00";
    internal_montgomery_processor_0_variable_p_position <= "00";
    internal_montgomery_processor_1_start <= '0';
    internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_no_operation_memory_available;
    internal_montgomery_processor_1_variable_a_position <= "00";
    internal_montgomery_processor_1_variable_b_position <= "00";
    internal_montgomery_processor_1_variable_p_position <= "00";
    internal_montgomery_processor_2_start <= '0';
    internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_no_operation_memory_available;
    internal_montgomery_processor_2_variable_a_position <= "00";
    internal_montgomery_processor_2_variable_b_position <= "00";
    internal_montgomery_processor_2_variable_p_position <= "00";
    internal_local_shifter_ce <= '0';
    internal_local_shifter_load <= '0';
    internal_reg_prime_size_ce <= '0';
    internal_ctr_scalar_size_ce <= '0';
    internal_ctr_scalar_size_load <= '0';
    internal_reg_scalar_word_address_ce <= '0';
    internal_reg_scalar_word_address_rst <= '1';
    internal_ctr_scalar_word_shifter_ce <= '0';
    internal_ctr_scalar_word_shifter_rst <= '1';
    internal_reg_comparison_a_rst <= '1';
    internal_reg_comparison_b_rst <= '1';
    internal_sel_comparison_scalar <= '0';
    internal_sel_inversion_mode <= '0';

    internal_output_ce <= '1';
    case (actual_state) is
        when reset =>
            internal_state_machine_free <= '1';
            internal_reg_prime_size_ce <= '1';
            internal_ctr_scalar_size_ce <= '1';
            internal_ctr_scalar_size_load <= '1';
        when idle_state =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_reg_mode_point_addition_doubling_rst <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_reg_scalar_word_address_rst <= '0';
            internal_ctr_scalar_word_shifter_rst <= '0';
            if(start = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_continue_transfering <= '1';
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_r2;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_r2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
        when load_n_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_r2;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_r2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            if(reg_comparison_a_equal_b = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_special_n_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_value_injection_b <= '1';
            internal_memory_tranfer_unit_value_injection_b <= std_logic_vector(to_unsigned(1, word_length));
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_a;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            if(memory_transfer_unit_free = '1') then
                null;  
            else
                internal_output_ce <= '0';
            end if;
        when load_r2_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";  
            if(memory_transfer_unit_free = '1') then
                null;          
            else
                internal_output_ce <= '0';
            end if;
        when load_a_1_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_ar_1r_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when load_b_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_b_again_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_2b_addition_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when wait_2b_addition_1_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when wait_2b_addition_2_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(montgomery_processor_1_processor_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_3b_addition_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "11";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when wait_3b_addition_1_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "11";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when wait_3b_addition_2_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_value_injection_a <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_sPx;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(montgomery_processor_1_processor_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_3br_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_value_injection_a <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_sPz;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when insert_zero_sPx_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';       
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_a;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_sPy;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when insert_zero_sPz_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_ar_1r_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_Px_Py_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_b;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_Px_Py_multiplication_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when store_3br_multiplication_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_Pz_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_Pz_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when store_Pxr_Pyr_multiplication_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_Pzr_multiplication_pre_processing =>
            internal_state_machine_finish_pre_processing <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when finish_store_Pzr_multiplication_pre_processing =>
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when finish_pre_processing =>
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "00";
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_scalar;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_reg_scalar_word_address_rst <= '0';
        when prepare_load_new_scalar_word =>
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_scalar;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_local_shifter_ce <= '1';
            internal_local_shifter_load <= '1';
            internal_reg_scalar_word_address_ce <= '1';
            internal_ctr_scalar_word_shifter_rst <= '0';
        when load_new_scalar_word =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when prepare_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            else
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_sPx;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_sPy;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            end if;
        when load_Px_Py_mm0_mm1_round_1_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_Px_Py_mm0_mm1_round_1_point_doubling =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_sPx_sPy_or_Px_Py_mm0_mm1_round_1_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t0_t1_mm0_mm1_round_1_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "11";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "11";
            else
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_sPz;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "11";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "11";
            end if;
        when load_Pz_mm2_round_1_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t0;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t1;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_Pz_mm2_round_1_point_doubling =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t0;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t1;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_sPz_or_Pz_mm2_round_1_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t0;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t1;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t2_mm2_round_1_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Px;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "11";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "11";
                internal_montgomery_processor_2_variable_a_position <= "01";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "11";
            else
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_sPy;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Px;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "11";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "11";
                internal_montgomery_processor_2_variable_a_position <= "01";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "11";
            end if;
        when store_t0_t1_mm0_mm1_round_2_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_t0_t1_mm0_mm1_round_2_point_doubling =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_sPy_or_Py_Px_mm0_mm1_round_2_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_t3_t4_mm0_mm1_round_2_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
                internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "10";
                internal_montgomery_processor_2_variable_a_position <= "01";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "10";
            else
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
                internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_sPy;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "10";
                internal_montgomery_processor_2_variable_a_position <= "01";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "10";
            end if;
        when store_t2_mm2_round_2_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t3;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_t2_mm2_round_2_point_doubling =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t3;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_sPy_or_Py_mm2_round_2_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t3;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_t5_mm2_round_2_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Pz;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "10";
                internal_montgomery_processor_2_variable_a_position <= "01";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "10";
            else
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_sPz;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "10";
                internal_montgomery_processor_2_variable_a_position <= "01";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "10";
            end if;
        when store_t3_t4_mm0_mm1_round_3_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Pz;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_t3_t4_mm0_mm1_round_3_point_doubling =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Pz;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_sPz_or_Pz_Pz_mm0_mm1_round_3_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Pz;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_t8_t7_mm0_mm1_round_3_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Pz;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
        when store_t5_mm2_round_3_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t8;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_Py_mm2_round_3_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t7;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_Pz_mm2_round_3_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t7;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_t6_mm2_round_3_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t3;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t7;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
        when store_t7_t8_mm0_mm1_round_4_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t3_t7_mm0_mm1_round_4_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t6;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t4_mm0_round_4_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t6;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t9_t11_mm0_mm1_round_4_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
        when store_t6_mm2_round_4_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t9;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t11;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
               null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t5_mm2_round_4_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t9;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t11;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t10_mm2_round_4_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t2;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when store_t9_t11_mm0_mm1_round_5_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t2_mm0_mm1_round_5_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t10;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t1_t0_mm0_mm1_round_5_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t10;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_t4_t5_mm0_mm1_round_5_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when store_t10_mm2_round_5_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t1;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t0_mm2_round_5_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t1_mm2_round_5_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_t3_mm2_round_5_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_a;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
        when store_t4_t5_mm0_mm1_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t9;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_3b_a_mm0_mm1_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t9;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t6_t8_mm0_mm1_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
        when load_t9_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_subtraction;
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_subtraction_t2_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when wait_subtraction_t2_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t10;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when store_t2_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";   
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t10_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t3;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t4_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t3;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_subtraction;
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_subtraction_t3_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t3;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when wait_subtraction_t3_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t11;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when store_t3_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";    
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t11_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t5_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_subtraction;
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_subtraction_t4_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when wait_subtraction_t4_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
        when store_t4_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t0_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t0_again_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_t10_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when wait_addition_1_t10_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when wait_addition_2_t10_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t10;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(montgomery_processor_2_processor_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_again_t10_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_b;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t10;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "10";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when wait_addition_again_t10_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t6;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when store_t10_mm2_round_6_7_8_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_t6_t8_mm0_mm1_round_9_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t4_mm0_mm1_round_9_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_mm0_mm1_round_9_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_a;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when load_t8_mm2_round_9_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_a;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_a_mm2_round_9_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_a;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_subtraction;
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_subtraction_t7_mm2_round_9_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_a;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when wait_subtraction_1_t7_mm2_round_9_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_a;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when wait_subtraction_2_t7_mm2_round_9_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t5;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_a;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(montgomery_processor_2_processor_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t9_mm2_round_9_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t8;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t6;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when store_t5_mm0_round_10_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t10;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t6;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t8_t6_mm0_mm1_round_10_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t10;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t10_mm0_round_10_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t10;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "01";
            internal_montgomery_processor_1_variable_p_position <= "01";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_t0_t4_mm0_mm1_round_10_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t0;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "01";
            internal_montgomery_processor_1_variable_p_position <= "01";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when load_t5_mm2_round_10_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t0;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "01";
            internal_montgomery_processor_1_variable_p_position <= "01";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_t7_mm2_round_10_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t4;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "01";
            internal_montgomery_processor_1_variable_p_position <= "01";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when store_t0_t4_mm0_mm1_round_11_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t1;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "01";
            internal_montgomery_processor_1_variable_p_position <= "01";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t4_mm0_round_11_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t7;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "11";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "01";
            internal_montgomery_processor_1_variable_p_position <= "01";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t1_mm0_mm1_round_11_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t7;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_subtraction;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "11";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "01";
            internal_montgomery_processor_1_variable_p_position <= "01";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_subtraction_addition_t5_t6_mm0_mm1_round_11_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t5;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t6;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "11";
            internal_montgomery_processor_0_variable_b_position <= "01";
            internal_montgomery_processor_0_variable_p_position <= "01";
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "01";
            internal_montgomery_processor_1_variable_p_position <= "01";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
        when store_t7_mm2_round_11_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t7;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t5;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "01";
            internal_montgomery_processor_2_variable_p_position <= "01";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_t5_t6_mm0_mm1_round_12_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t7;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t3;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t7_t5_mm0_mm1_round_12_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t7;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t3;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t4_t1_mm0_mm1_round_12_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t1;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when load_t3_mm2_round_12_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t1;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t8_mm2_round_12_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t2;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when store_t4_t1_mm0_mm1_round_13_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t2;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t2_mm0_mm1_round_13_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t2;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t11_t9_mm0_mm1_round_13_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t2;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t6;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when store_t8_mm2_round_13_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t11;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t9;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t6_mm2_round_13_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t11;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t9;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t10_mm2_round_13_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
        when store_t11_t9_mm0_mm1_round_14_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t8;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t1_t8_mm0_mm1_round_14_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t11;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "11";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t4_mm0_round_14_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t4;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t11;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_subtraction;
            internal_montgomery_processor_1_variable_a_position <= "10";
            internal_montgomery_processor_1_variable_b_position <= "11";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_montgomery_processor_2_variable_a_position <= "01";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "11";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_subtraction_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "10";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
                internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Px;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_montgomery_processor_1_variable_a_position <= "11";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "10";
                internal_montgomery_processor_2_variable_a_position <= "01";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "11";
            else
                if(scalar_bit = '1') then
                    internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_sPy;
                    internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_sPx;
                else
                    internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_fPy;
                    internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_fPx;
                end if;                             
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "10";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
                internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_montgomery_processor_1_variable_a_position <= "10";
                internal_montgomery_processor_1_variable_b_position <= "11";
                internal_montgomery_processor_1_variable_p_position <= "11";
                internal_montgomery_processor_2_variable_a_position <= "01";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "11";
            end if;
        when load_t11_mm2_round_14_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Px;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t11_mm2_round_14_point_doubling =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Px;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_start <= '1';
            internal_montgomery_processor_2_instruction <= montgomery_processor_instruction_addition;
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_addition_sPz_or_fPz_or_Pz_mm2_round_14_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "10";
                internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
                internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_montgomery_processor_1_variable_a_position <= "11";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "10";
                internal_montgomery_processor_2_variable_a_position <= "11";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "10";
            else
                if(scalar_bit = '1') then
                    internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_sPz;
                else
                    internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_fPz;
                end if;
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "10";
                internal_memory_tranfer_unit_montgomery_unit_2_enable <= '1';
                internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_montgomery_processor_1_variable_a_position <= "11";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "10";
                internal_montgomery_processor_2_variable_a_position <= "11";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "10";
            end if;
        when store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_addition =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_sPy_sPx_or_fPy_fPx_or_Py_Px_mm0_mm1_round_14_point_doubling =>
            internal_state_machine_finish_point_addition <= '0';
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_sPz_or_fPz_or_Pz_mm2_round_14_point_addition =>
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_reg_mode_point_addition_doubling_ce <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            internal_reg_comparison_a_rst <= '0';
            internal_sel_comparison_scalar <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when finish_point_addition =>
            if(reg_mode_point_addition_doubling_q(0) = '1') then
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_montgomery_processor_1_variable_a_position <= "11";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "10";
                internal_montgomery_processor_2_variable_a_position <= "11";
                internal_montgomery_processor_2_variable_b_position <= "10";
                internal_montgomery_processor_2_variable_p_position <= "10";
                internal_local_shifter_ce <= '1';
                internal_ctr_scalar_size_ce <= '1';
                internal_ctr_scalar_word_shifter_ce <= '1';
                internal_sel_comparison_scalar <= '1'; 
            else
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            end if;
        when wait_scalar_inner_loop_final_comparison =>
            internal_state_machine_finish_scalar_multiplication <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Py;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Pz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_montgomery_processor_1_variable_a_position <= "11";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "10";
            internal_montgomery_processor_2_variable_a_position <= "11";
            internal_montgomery_processor_2_variable_b_position <= "10";
            internal_montgomery_processor_2_variable_p_position <= "10";
            internal_sel_comparison_scalar <= '1'; 
        when finish_scalar_inner_loop =>
            if(reg_comparison_a_equal_b = '1') then
                internal_state_machine_finish_final_processing <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_enable_value_injection_a <= '1';
                internal_memory_tranfer_unit_value_injection_a <= std_logic_vector(to_unsigned(2, word_length));
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_n;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_n;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "10";
                internal_reg_scalar_word_address_rst <= '0';
            elsif(ctr_scalar_word_shifter_limit = '1') then
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "00";
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_scalar;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            else
                internal_state_machine_finish_point_addition <= '0';
                internal_state_machine_finish_scalar_multiplication <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_Px;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_Py;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            end if;
        when start_final_processing =>            
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_value_injection_a <= std_logic_vector(to_unsigned(2, word_length));
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_n;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_n;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_sel_inversion_mode <= '1';
        when load_2_mm0_inversion_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_sel_inversion_mode <= '1';
            internal_ctr_scalar_size_ce <= '1';
            internal_ctr_scalar_size_load <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_n_mm0_inversion_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_subtraction_no_normalization;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_n_subtraction_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_sel_inversion_mode <= '1';
        when wait_n_subtraction_1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_scalar;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "10";
            internal_sel_inversion_mode <= '1';            
        when wait_n_subtraction_2_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_value_injection_a <= '1';
            internal_memory_tranfer_unit_value_injection_a <= std_logic_vector(to_unsigned(1, word_length));
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_sPz;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_sel_inversion_mode <= '1';     
            if(montgomery_processor_0_processor_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_inversion_expoent_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_1_sPz_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t2;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_1_sPz_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_scalar;
            internal_reg_scalar_word_address_rst <= '0';
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;    
        when store_1_mm0_mm1_final_processing =>   
            internal_state_machine_finish_final_processing <= '0';
            internal_sel_inversion_mode <= '1';  
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;    
        when finish_store_1_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "00";
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_scalar;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_sel_inversion_mode <= '1';  
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;            
        when prepare_load_new_inversion_exponent_word_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';            
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t0;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_local_shifter_ce <= '1';
            internal_local_shifter_load <= '1';
            internal_reg_scalar_word_address_ce <= '1';
            internal_ctr_scalar_word_shifter_rst <= '0';
            internal_sel_inversion_mode <= '1';            
        when load_new_inversion_exponent_word_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';            
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;    
        when load_t0_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if; 
        when load_t1_t0_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if; 
        when start_multiplication_t1_t0_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11"; 
            internal_sel_inversion_mode <= '1';
        when wait_multiplication_1_t1_t0_mm0_mm1_final_processing =>
            if(scalar_bit = '1') then
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            else
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t2;
            end if;
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_sel_inversion_mode <= '1';    
        when wait_multiplication_2_t1_t0_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_sel_inversion_mode <= '1';
            if(montgomery_processor_0_processor_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if; 
        when store_t1_or_t2_t0_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_local_shifter_ce <= '1';
            internal_ctr_scalar_word_shifter_ce <= '1';
            internal_sel_comparison_scalar <= '1'; 
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;     
        when prepare_update_internal_scalar_inversion_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_sel_comparison_scalar <= '1'; 
            internal_sel_inversion_mode <= '1';
        when update_internal_scalar_inversion_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_sel_comparison_scalar <= '1'; 
            internal_sel_inversion_mode <= '1';
        when finish_step_scalar_inversion_final_processing =>
            if(ctr_scalar_word_shifter_limit = '1' and reg_comparison_a_equal_b = '1') then
                internal_state_machine_finish_final_processing <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';            
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_sPx;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_sPy;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "11";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "11";
                internal_sel_inversion_mode <= '1';
            elsif(ctr_scalar_word_shifter_limit = '1') then
                internal_state_machine_finish_final_processing <= '0';
                internal_memory_tranfer_unit_instruction <= "00";
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_scalar;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
                internal_ctr_scalar_size_ce <= '1';
                internal_sel_inversion_mode <= '1';  
            else
                internal_state_machine_finish_final_processing <= '0';
                internal_memory_tranfer_unit_instruction <= "01";
                internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
                internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';            
                internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t0;
                internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t0;
                internal_memory_tranfer_unit_montomery_unit_0_address <= "01";
                internal_memory_tranfer_unit_montomery_unit_1_2_address <= "01";
                internal_montgomery_processor_0_variable_a_position <= "01";
                internal_montgomery_processor_0_variable_b_position <= "10";
                internal_montgomery_processor_0_variable_p_position <= "11";
                internal_montgomery_processor_1_variable_a_position <= "01";
                internal_montgomery_processor_1_variable_b_position <= "10";
                internal_montgomery_processor_1_variable_p_position <= "11";
                internal_sel_inversion_mode <= '1';
            end if;
        when prepare_load_sPx_sPy_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "01";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';            
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_t1;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_t1;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "10";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "10";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_sel_comparison_scalar <= '1'; 
            internal_sel_inversion_mode <= '1';    
        when load_sPx_sPy_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when load_t1_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_montgomery_processor_0_start <= '1';
            internal_montgomery_processor_0_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_start <= '1';
            internal_montgomery_processor_1_instruction <= montgomery_processor_instruction_multiplication;
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when start_multiplication_t1_sPx_sPy_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_sel_inversion_mode <= '1';
        when wait_multiplication_1_t1_sPx_sPy_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_memory_tranfer_unit_instruction <= "10";
            internal_memory_tranfer_unit_montgomery_unit_0_enable <= '1';
            internal_memory_tranfer_unit_montgomery_unit_1_enable <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_a <= '1';
            internal_memory_tranfer_unit_enable_internal_memory_b <= '1';
            internal_memory_tranfer_unit_internal_memory_address_a <= memory_position_sPx;
            internal_memory_tranfer_unit_internal_memory_address_b <= memory_position_sPy;
            internal_memory_tranfer_unit_montomery_unit_0_address <= "11";
            internal_memory_tranfer_unit_montomery_unit_1_2_address <= "11";
            internal_montgomery_processor_0_variable_a_position <= "01";
            internal_montgomery_processor_0_variable_b_position <= "10";
            internal_montgomery_processor_0_variable_p_position <= "11";
            internal_montgomery_processor_1_variable_a_position <= "01";
            internal_montgomery_processor_1_variable_b_position <= "10";
            internal_montgomery_processor_1_variable_p_position <= "11";
            internal_sel_inversion_mode <= '1';
        when wait_multiplication_2_t1_sPx_sPy_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_sel_inversion_mode <= '1';
            if(montgomery_processor_0_processor_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when store_multiplication_t1_sPx_sPy_mm0_mm1_final_processing =>
            internal_state_machine_finish_final_processing <= '0';
            internal_sel_inversion_mode <= '1';
            if(memory_transfer_unit_free = '1') then
                null;
            else
                internal_output_ce <= '0';
            end if;
        when finish_scalar_multiplication =>
            internal_state_machine_free <= '1';
            internal_reg_prime_size_ce <= '1';
            internal_ctr_scalar_size_ce <= '1';
            internal_ctr_scalar_size_load <= '1';
    end case;
end process;

reg_mode_point_addition_doubling : register_rst_nbits
    Generic Map(
        size => 1
    )
    Port Map(
        d => reg_mode_point_addition_doubling_d,
        clk => clk,
        ce => reg_mode_point_addition_doubling_ce,
        rst => reg_mode_point_addition_doubling_rst,
        rst_value => reg_mode_point_addition_doubling_rst_value,
        q => reg_mode_point_addition_doubling_q
    );

reg_mode_point_addition_doubling_d <= not reg_mode_point_addition_doubling_q;

end Behavioral;