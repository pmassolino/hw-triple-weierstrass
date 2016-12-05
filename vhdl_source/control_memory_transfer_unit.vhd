----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    control_memory_tranfer_unit
-- Module Name:    control_memory_tranfer_unit
-- Project Name:   Weierstrass processor
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- This is the state machine that controls the memory transfer unit.
-- It can handle all main state machine instructions:
-- 
-- Load scalar (00)
-- Instruction to load one word of the scalar from the main memory to 
-- temporary scalar register.
--
-- Load value (01)
-- Loads any values from the main memory to one of the Montgomery processors.
--
-- Store value (10)
-- Stores one value from the Montgomery processor to the main memory.
--
-- Do nothing (11)
--
--
-- Dependencies:
-- VHDL-93
--
-- 
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_memory_transfer_unit is
    Port(
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        instruction : in STD_LOGIC_VECTOR(1 downto 0);
        actual_instruction_hold_execution : in STD_LOGIC;
        next_instruction_hold_execution : in STD_LOGIC;
        continue_transfering : in STD_LOGIC;
        reg_comparison_a_equal_b : in STD_LOGIC;
        control_memory_transfer_unit_free : out STD_LOGIC;
        internal_memory_write_enable : out STD_LOGIC;
        montgomery_memory_write_enable : out STD_LOGIC;
        first_value_injected : out STD_LOGIC;
        reg_address_variable_a_ce : out STD_LOGIC;
        reg_address_variable_b_ce : out STD_LOGIC;
        ctr_address_variable_ce : out STD_LOGIC;
        ctr_address_variable_load : out STD_LOGIC;
        ctr_address_variable_rst : out STD_LOGIC;
        reg_address_montgomery_unit_0_ce : out STD_LOGIC;
        reg_address_montgomery_unit_1_2_ce : out STD_LOGIC;
        ctr_address_montgomery_unit_ce : out STD_LOGIC;
        ctr_address_montgomery_unit_rst : out STD_LOGIC;
        reg_montgomery_unit_enable_ce : out STD_LOGIC;
        reg_enable_internal_memory_ce : out STD_LOGIC;
        reg_enable_value_injection_ce : out STD_LOGIC;
        reg_value_injection_ce : out STD_LOGIC;
        reg_internal_memory_address_ce : out STD_LOGIC;
        reg_montgomery_unit_address_ce : out STD_LOGIC;
        sel_montgomery_write : out STD_LOGIC
    );
end control_memory_transfer_unit;

architecture Behavioral of control_memory_transfer_unit is

type State is (reset, idle_state,
-- Load Scalar
prepare_load_scalar_word_1, prepare_load_scalar_word_2, prepare_load_scalar_word_3, load_scalar_word,
-- Load Instruction
prepare_load_values_1, wait_prepare_load_values_1, prepare_load_values_2, prepare_load_values_3, prepare_load_values_4, load_values, continue_transfering_load_values, finish_load_values_1, finish_load_values_2, finish_load_values_3, finish_load_values_4,
-- Store Instruction
prepare_store_values_1, wait_prepare_store_values_1, prepare_store_values_2, prepare_store_values_3, prepare_store_values_4, store_values, finish_store_values_1
);

signal actual_state, next_state : State;

signal internal_control_memory_transfer_unit_free : STD_LOGIC;
signal internal_internal_memory_write_enable : STD_LOGIC;
signal internal_montgomery_memory_write_enable : STD_LOGIC;
signal internal_first_value_injected : STD_LOGIC;
signal internal_reg_address_variable_a_ce : STD_LOGIC;
signal internal_reg_address_variable_b_ce : STD_LOGIC;
signal internal_ctr_address_variable_ce : STD_LOGIC;
signal internal_ctr_address_variable_load : STD_LOGIC;
signal internal_ctr_address_variable_rst : STD_LOGIC;
signal internal_reg_address_montgomery_unit_0_ce : STD_LOGIC;
signal internal_reg_address_montgomery_unit_1_2_ce : STD_LOGIC;
signal internal_ctr_address_montgomery_unit_ce : STD_LOGIC;
signal internal_ctr_address_montgomery_unit_rst : STD_LOGIC;
signal internal_reg_montgomery_unit_enable_ce : STD_LOGIC;
signal internal_reg_enable_internal_memory_ce : STD_LOGIC;
signal internal_reg_enable_value_injection_ce : STD_LOGIC;
signal internal_reg_value_injection_ce : STD_LOGIC;
signal internal_reg_internal_memory_address_ce : STD_LOGIC;
signal internal_reg_montgomery_unit_address_ce : STD_LOGIC;
signal internal_sel_montgomery_write : STD_LOGIC;

begin

Clock : process (clk)
begin
    if (rising_edge(clk)) then
        if(rst = '0') then
            actual_state <= reset;
            control_memory_transfer_unit_free <= '0';
            internal_memory_write_enable <= '0';
            montgomery_memory_write_enable <= '0';
            first_value_injected <= '0';
            reg_address_variable_a_ce <= '0';
            reg_address_variable_b_ce <= '0';
            ctr_address_variable_ce <= '0';
            ctr_address_variable_load <= '0';
            ctr_address_variable_rst <= '0';
            reg_address_montgomery_unit_0_ce <= '0';
            reg_address_montgomery_unit_1_2_ce <= '0';
            ctr_address_montgomery_unit_ce <= '0';
            ctr_address_montgomery_unit_rst <= '0';
            reg_montgomery_unit_enable_ce <= '0';
            reg_enable_internal_memory_ce <= '0';
            reg_enable_value_injection_ce <= '0';
            reg_value_injection_ce <= '0';
            reg_internal_memory_address_ce <= '0';
            reg_montgomery_unit_address_ce <= '0';
            sel_montgomery_write <= '0';
        else
            actual_state <= next_state;
            control_memory_transfer_unit_free <= internal_control_memory_transfer_unit_free;
            internal_memory_write_enable <= internal_internal_memory_write_enable;
            montgomery_memory_write_enable <= internal_montgomery_memory_write_enable;
            first_value_injected <= internal_first_value_injected;
            reg_address_variable_a_ce <= internal_reg_address_variable_a_ce;
            reg_address_variable_b_ce <= internal_reg_address_variable_b_ce;
            ctr_address_variable_ce <= internal_ctr_address_variable_ce;
            ctr_address_variable_load <= internal_ctr_address_variable_load;
            ctr_address_variable_rst <= internal_ctr_address_variable_rst;
            reg_address_montgomery_unit_0_ce <= internal_reg_address_montgomery_unit_0_ce;
            reg_address_montgomery_unit_1_2_ce <= internal_reg_address_montgomery_unit_1_2_ce;
            ctr_address_montgomery_unit_ce <= internal_ctr_address_montgomery_unit_ce;
            ctr_address_montgomery_unit_rst <= internal_ctr_address_montgomery_unit_rst;
            reg_montgomery_unit_enable_ce <= internal_reg_montgomery_unit_enable_ce;
            reg_enable_internal_memory_ce <= internal_reg_enable_internal_memory_ce;
            reg_enable_value_injection_ce <= internal_reg_enable_value_injection_ce;
            reg_value_injection_ce <= internal_reg_value_injection_ce;
            reg_internal_memory_address_ce <= internal_reg_internal_memory_address_ce;
            reg_montgomery_unit_address_ce <= internal_reg_montgomery_unit_address_ce;
            sel_montgomery_write <= internal_sel_montgomery_write;
        end if;
    else
        null;
    end if;
end process;

Update_State : process (actual_state, actual_instruction_hold_execution, next_instruction_hold_execution, instruction, continue_transfering, reg_comparison_a_equal_b)
begin
    case (actual_state) is
        when reset =>
            next_state <= idle_state;
        when idle_state =>
            if(instruction = "00") then
                next_state <= prepare_load_scalar_word_1;
            elsif(instruction = "01") then
                next_state <= prepare_load_values_1;
            elsif(instruction = "10") then
                next_state <= prepare_store_values_1;
            else
                next_state <= idle_state;
            end if;
        when prepare_load_scalar_word_1 =>
            next_state <= prepare_load_scalar_word_2;
        when prepare_load_scalar_word_2 =>
            next_state <= prepare_load_scalar_word_3;
        when prepare_load_scalar_word_3 =>
            next_state <= load_scalar_word;
        when load_scalar_word =>
            if(instruction = "00") then
                next_state <= prepare_load_scalar_word_1;
            elsif(instruction = "01") then
                next_state <= prepare_load_values_1;
            elsif(instruction = "10") then
                next_state <= prepare_store_values_1;
            else
                next_state <= idle_state;
            end if;        
        when prepare_load_values_1 =>
            if(next_instruction_hold_execution = '0') then
                next_state <= prepare_load_values_2;
            else
                next_state <= wait_prepare_load_values_1;
            end if;
        when wait_prepare_load_values_1 =>
            if(actual_instruction_hold_execution = '0') then
                next_state <= prepare_load_values_2;
            else
                next_state <= wait_prepare_load_values_1;
            end if;
        when prepare_load_values_2 =>
            next_state <= prepare_load_values_3;
        when prepare_load_values_3 =>
            next_state <= prepare_load_values_4;
        when prepare_load_values_4 =>
            next_state <= load_values;
        when load_values =>
            if(reg_comparison_a_equal_b = '1') then
                if(continue_transfering = '0') then
                    next_state <= finish_load_values_1;
                else
                    next_state <= continue_transfering_load_values;
                end if;
            else
                next_state <= load_values;
            end if;
        when continue_transfering_load_values =>
            if(continue_transfering = '0') then
                next_state <= finish_load_values_1;
            else
                next_state <= continue_transfering_load_values;
            end if;
        when finish_load_values_1 =>
            next_state <= finish_load_values_2;
        when finish_load_values_2 =>
            next_state <= finish_load_values_3;
        when finish_load_values_3 =>
            next_state <= finish_load_values_4;
        when finish_load_values_4 =>
            if(instruction = "00") then
                next_state <= prepare_load_scalar_word_1;
            elsif(instruction = "01") then
                if(next_instruction_hold_execution = '0') then
                    next_state <= load_values;
                else
                    next_state <= prepare_load_values_1;
                end if;
            elsif(instruction = "10") then
                next_state <= prepare_store_values_1;
            else
                next_state <= idle_state;
            end if;
        when prepare_store_values_1 =>
            if(actual_instruction_hold_execution = '0') then
                next_state <= prepare_store_values_2;
            else
                next_state <= wait_prepare_store_values_1;
            end if;
        when wait_prepare_store_values_1 =>
            if(actual_instruction_hold_execution = '0') then
                next_state <= prepare_store_values_2;
            else
                next_state <= wait_prepare_store_values_1;
            end if;
        when prepare_store_values_2 =>
            next_state <= prepare_store_values_3;
        when prepare_store_values_3 =>
            next_state <= prepare_store_values_4;
        when prepare_store_values_4 =>
            next_state <= store_values;
        when store_values =>
            if(reg_comparison_a_equal_b = '1') then
                next_state <= finish_store_values_1;
            else
                next_state <= store_values;
            end if;
        when finish_store_values_1 =>
            if(instruction = "00") then
                next_state <= prepare_load_scalar_word_1;
            elsif(instruction = "01") then
                if(next_instruction_hold_execution = '0') then
                    next_state <= prepare_load_values_2;
                else
                    next_state <= wait_prepare_load_values_1;
                end if;
            elsif(instruction = "10") then
                if(next_instruction_hold_execution = '0') then
                    next_state <= prepare_store_values_2;
                else
                    next_state <= wait_prepare_store_values_1;
                end if;
            else
                next_state <= idle_state;
            end if;
        end case;
end process;

Update_Output : process (actual_state, actual_instruction_hold_execution, next_instruction_hold_execution, instruction, continue_transfering, reg_comparison_a_equal_b)
begin
    internal_control_memory_transfer_unit_free <= '0';
    internal_internal_memory_write_enable <= '0';
    internal_montgomery_memory_write_enable <= '0';
    internal_first_value_injected <= '0';
    internal_reg_address_variable_a_ce <= '0';
    internal_reg_address_variable_b_ce <= '0';
    internal_ctr_address_variable_ce <= '0';
    internal_ctr_address_variable_load <= '0';
    internal_ctr_address_variable_rst <= '1';
    internal_reg_address_montgomery_unit_0_ce <= '0';
    internal_reg_address_montgomery_unit_1_2_ce <= '0';
    internal_ctr_address_montgomery_unit_ce <= '0';
    internal_ctr_address_montgomery_unit_rst <= '1';
    internal_reg_montgomery_unit_enable_ce <= '0';
    internal_reg_enable_internal_memory_ce <= '0';
    internal_reg_enable_value_injection_ce <= '0';
    internal_reg_value_injection_ce <= '0';
    internal_reg_internal_memory_address_ce <= '0';
    internal_reg_montgomery_unit_address_ce <= '0';
    internal_sel_montgomery_write <= '0';
    case (actual_state) is
        when reset =>
            internal_control_memory_transfer_unit_free <= '1';
            internal_reg_montgomery_unit_enable_ce <= '1';
            internal_reg_enable_internal_memory_ce <= '1';
            internal_reg_enable_value_injection_ce <= '1';
            internal_reg_value_injection_ce <= '1';
            internal_reg_internal_memory_address_ce <= '1';
            internal_reg_montgomery_unit_address_ce <= '1';
        when idle_state =>
            if(instruction = "00") then
                internal_reg_address_variable_a_ce <= '1';
                internal_ctr_address_variable_ce <= '1';
                internal_ctr_address_variable_load <= '1';
            elsif(instruction = "01") then
                internal_reg_address_variable_a_ce <= '1';
                internal_reg_address_variable_b_ce <= '1';
                internal_ctr_address_variable_rst <= '0';
                internal_reg_address_montgomery_unit_0_ce <= '1';
                internal_reg_address_montgomery_unit_1_2_ce <= '1';
                internal_ctr_address_montgomery_unit_rst <= '0';
            elsif(instruction = "10") then
                internal_reg_address_variable_a_ce <= '1';
                internal_reg_address_variable_b_ce <= '1';
                internal_ctr_address_variable_rst <= '0';
                internal_reg_address_montgomery_unit_0_ce <= '1';
                internal_reg_address_montgomery_unit_1_2_ce <= '1';
                internal_ctr_address_montgomery_unit_rst <= '0';
            else
                internal_control_memory_transfer_unit_free <= '1';
                internal_reg_montgomery_unit_enable_ce <= '1';
                internal_reg_enable_internal_memory_ce <= '1';
                internal_reg_enable_value_injection_ce <= '1';
                internal_reg_value_injection_ce <= '1';
                internal_reg_internal_memory_address_ce <= '1';
                internal_reg_montgomery_unit_address_ce <= '1';
            end if;
        when prepare_load_scalar_word_1 =>
            null;
        when prepare_load_scalar_word_2 =>
            internal_ctr_address_variable_ce <= '1';
        when prepare_load_scalar_word_3 =>
            internal_control_memory_transfer_unit_free <= '1';
            internal_reg_montgomery_unit_enable_ce <= '1';
            internal_reg_enable_internal_memory_ce <= '1';
            internal_reg_enable_value_injection_ce <= '1';
            internal_reg_value_injection_ce <= '1';
            internal_reg_internal_memory_address_ce <= '1';
            internal_reg_montgomery_unit_address_ce <= '1';
        when load_scalar_word =>
            if(instruction = "00") then
                internal_reg_address_variable_a_ce <= '1';
                internal_ctr_address_variable_ce <= '1';
                internal_ctr_address_variable_load <= '1';
            elsif(instruction = "01") then
                internal_reg_address_variable_a_ce <= '1';
                internal_reg_address_variable_b_ce <= '1';
                internal_ctr_address_variable_rst <= '0';
                internal_reg_address_montgomery_unit_0_ce <= '1';
                internal_reg_address_montgomery_unit_1_2_ce <= '1';
                internal_ctr_address_montgomery_unit_rst <= '0';
            elsif(instruction = "10") then
                internal_reg_address_variable_a_ce <= '1';
                internal_reg_address_variable_b_ce <= '1';
                internal_ctr_address_variable_rst <= '0';
                internal_reg_address_montgomery_unit_0_ce <= '1';
                internal_reg_address_montgomery_unit_1_2_ce <= '1';
                internal_ctr_address_montgomery_unit_rst <= '0';
            else
                internal_control_memory_transfer_unit_free <= '1';
                internal_ctr_address_variable_rst <= '0';
                internal_reg_montgomery_unit_enable_ce <= '1';
                internal_reg_enable_internal_memory_ce <= '1';
                internal_reg_enable_value_injection_ce <= '1';
                internal_reg_value_injection_ce <= '1';
                internal_reg_internal_memory_address_ce <= '1';
                internal_reg_montgomery_unit_address_ce <= '1';
            end if;        
        when prepare_load_values_1 =>
            if(next_instruction_hold_execution = '0') then
                internal_ctr_address_variable_ce <= '1';
                internal_reg_address_montgomery_unit_0_ce <= '1';
                internal_reg_address_montgomery_unit_1_2_ce <= '1';
                internal_sel_montgomery_write <= '1';
            else
                internal_sel_montgomery_write <= '1';
            end if;
        when wait_prepare_load_values_1 =>
            if(actual_instruction_hold_execution = '0') then
                internal_ctr_address_variable_ce <= '1';
                internal_reg_address_montgomery_unit_0_ce <= '1';
                internal_reg_address_montgomery_unit_1_2_ce <= '1';
                internal_sel_montgomery_write <= '1';
            else
                internal_sel_montgomery_write <= '1';
            end if;
        when prepare_load_values_2 =>
            internal_ctr_address_variable_ce <= '1';
            internal_sel_montgomery_write <= '1';
        when prepare_load_values_3 =>
            internal_first_value_injected <= '1';
            internal_ctr_address_variable_ce <= '1';
            internal_sel_montgomery_write <= '1';
        when prepare_load_values_4 =>
            internal_montgomery_memory_write_enable <= '1';
            internal_first_value_injected <= '1';
            internal_ctr_address_variable_ce <= '1';
            internal_ctr_address_montgomery_unit_ce <= '1';
            internal_reg_internal_memory_address_ce <= '1';
            internal_reg_montgomery_unit_address_ce <= '1';
            internal_sel_montgomery_write <= '1';
        when load_values =>
            if(reg_comparison_a_equal_b = '1') then
                if(continue_transfering = '0') then
                    internal_montgomery_memory_write_enable <= '1';
                    internal_first_value_injected <= '1';
                    internal_reg_address_variable_a_ce <= '1';
                    internal_reg_address_variable_b_ce <= '1';
                    internal_ctr_address_variable_rst <= '0';
                    internal_ctr_address_montgomery_unit_ce <= '1';
                    internal_sel_montgomery_write <= '1';
                else
                    internal_montgomery_memory_write_enable <= '1';
                    internal_first_value_injected <= '1';
                    internal_ctr_address_variable_ce <= '1';
                    internal_ctr_address_montgomery_unit_ce <= '1';
                    internal_reg_internal_memory_address_ce <= '1';
                    internal_reg_montgomery_unit_address_ce <= '1';
                    internal_sel_montgomery_write <= '1';
                end if;
            else
                internal_montgomery_memory_write_enable <= '1';
                internal_first_value_injected <= '1';
                internal_ctr_address_variable_ce <= '1';
                internal_ctr_address_montgomery_unit_ce <= '1';
                internal_reg_internal_memory_address_ce <= '1';
                internal_reg_montgomery_unit_address_ce <= '1';
                internal_sel_montgomery_write <= '1';
            end if;
        when continue_transfering_load_values =>
            if(continue_transfering = '0') then
                internal_montgomery_memory_write_enable <= '1';
                internal_first_value_injected <= '1';
                internal_reg_address_variable_a_ce <= '1';
                internal_reg_address_variable_b_ce <= '1';
                internal_ctr_address_variable_rst <= '0';
                internal_ctr_address_montgomery_unit_ce <= '1';
                internal_sel_montgomery_write <= '1';
            else
                internal_montgomery_memory_write_enable <= '1';
                internal_first_value_injected <= '1';
                internal_ctr_address_variable_ce <= '1';
                internal_ctr_address_montgomery_unit_ce <= '1';
                internal_reg_internal_memory_address_ce <= '1';
                internal_reg_montgomery_unit_address_ce <= '1';
                internal_sel_montgomery_write <= '1';
            end if;
        when finish_load_values_1 =>
            internal_montgomery_memory_write_enable <= '1';
            internal_first_value_injected <= '1';
            internal_ctr_address_variable_ce <= '1';
            internal_ctr_address_montgomery_unit_ce <= '1';
            internal_reg_enable_value_injection_ce <= '1';
            internal_reg_value_injection_ce <= '1';
            internal_sel_montgomery_write <= '1';
        when finish_load_values_2 =>
            internal_montgomery_memory_write_enable <= '1';
            internal_ctr_address_variable_ce <= '1';
            internal_ctr_address_montgomery_unit_ce <= '1';
            internal_sel_montgomery_write <= '1';
        when finish_load_values_3 =>
            internal_control_memory_transfer_unit_free <= '1';
            internal_montgomery_memory_write_enable <= '1';
            internal_first_value_injected <= '1';
            internal_reg_address_variable_a_ce <= '1';
            internal_reg_address_variable_b_ce <= '1';
            internal_ctr_address_variable_ce <= '1';
            internal_reg_address_montgomery_unit_0_ce <= '1';
            internal_reg_address_montgomery_unit_1_2_ce <= '1';
            internal_ctr_address_montgomery_unit_rst <= '0';
            internal_reg_montgomery_unit_enable_ce <= '1';
            internal_reg_enable_internal_memory_ce <= '1';
            internal_sel_montgomery_write <= '1';
        when finish_load_values_4 =>
            if(instruction = "00") then
                internal_reg_address_variable_a_ce <= '1';
                internal_ctr_address_variable_ce <= '1';
                internal_ctr_address_variable_load <= '1';
            elsif(instruction = "01") then
                if(next_instruction_hold_execution = '0') then
                    internal_montgomery_memory_write_enable <= '1';
                    internal_first_value_injected <= '1';
                    internal_ctr_address_variable_ce <= '1';
                    internal_ctr_address_montgomery_unit_ce <= '1';
                    internal_reg_internal_memory_address_ce <= '1';
                    internal_reg_montgomery_unit_address_ce <= '1';
                    internal_sel_montgomery_write <= '1';
                else
                    internal_reg_address_variable_a_ce <= '1';
                    internal_reg_address_variable_b_ce <= '1';
                    internal_ctr_address_variable_rst <= '0';
                    internal_reg_address_montgomery_unit_0_ce <= '1';
                    internal_reg_address_montgomery_unit_1_2_ce <= '1';
                    internal_ctr_address_montgomery_unit_rst <= '0';
                end if;
            elsif(instruction = "10") then
                internal_reg_address_variable_a_ce <= '1';
                internal_reg_address_variable_b_ce <= '1';
                internal_ctr_address_variable_rst <= '0';
                internal_reg_address_montgomery_unit_0_ce <= '1';
                internal_reg_address_montgomery_unit_1_2_ce <= '1';
                internal_ctr_address_montgomery_unit_rst <= '0';
            else
                internal_control_memory_transfer_unit_free <= '1';
                internal_ctr_address_variable_rst <= '0';
                internal_reg_montgomery_unit_enable_ce <= '1';
                internal_reg_enable_internal_memory_ce <= '1';
                internal_reg_enable_value_injection_ce <= '1';
                internal_reg_value_injection_ce <= '1';
                internal_reg_internal_memory_address_ce <= '1';
                internal_reg_montgomery_unit_address_ce <= '1';
            end if;
        when prepare_store_values_1 =>
            if(actual_instruction_hold_execution = '0') then
                internal_ctr_address_montgomery_unit_ce <= '1';
            else
                null;
            end if;
        when wait_prepare_store_values_1 =>
            if(actual_instruction_hold_execution = '0') then
                internal_ctr_address_montgomery_unit_ce <= '1';
            else
                null;
            end if;
        when prepare_store_values_2 =>
            internal_ctr_address_montgomery_unit_ce <= '1';
        when prepare_store_values_3 =>
            internal_first_value_injected <= '1';
            internal_ctr_address_montgomery_unit_ce <= '1';
        when prepare_store_values_4 =>
            internal_internal_memory_write_enable <= '1';
            internal_first_value_injected <= '1';
            internal_ctr_address_variable_ce <= '1';
            internal_ctr_address_montgomery_unit_ce <= '1';
            internal_reg_internal_memory_address_ce <= '1';
            internal_reg_montgomery_unit_address_ce <= '1';
        when store_values =>
            if(reg_comparison_a_equal_b = '1') then
                internal_control_memory_transfer_unit_free <= '1';
                internal_internal_memory_write_enable <= '1';
                internal_first_value_injected <= '1';
                internal_reg_address_variable_a_ce <= '1';
                internal_reg_address_variable_b_ce <= '1';
                internal_ctr_address_variable_rst <= '0';
                internal_reg_address_montgomery_unit_0_ce <= '1';
                internal_reg_address_montgomery_unit_1_2_ce <= '1';
                internal_ctr_address_montgomery_unit_rst <= '0';
                internal_reg_montgomery_unit_enable_ce <= '1';
                internal_reg_enable_internal_memory_ce <= '1';
                internal_reg_enable_value_injection_ce <= '1';
                internal_reg_value_injection_ce <= '1';
                internal_reg_internal_memory_address_ce <= '1';
                internal_reg_montgomery_unit_address_ce <= '1';
            else
                internal_internal_memory_write_enable <= '1';
                internal_first_value_injected <= '1';
                internal_ctr_address_variable_ce <= '1';
                internal_ctr_address_montgomery_unit_ce <= '1';
                internal_reg_internal_memory_address_ce <= '1';
                internal_reg_montgomery_unit_address_ce <= '1';
            end if;
        when finish_store_values_1 =>
            if(instruction = "00") then
                internal_reg_address_variable_a_ce <= '1';
                internal_ctr_address_variable_ce <= '1';
                internal_ctr_address_variable_load <= '1';
            elsif(instruction = "01") then
                if(next_instruction_hold_execution = '0') then
                    internal_ctr_address_variable_ce <= '1';
                    internal_reg_address_montgomery_unit_0_ce <= '1';
                    internal_reg_address_montgomery_unit_1_2_ce <= '1';
                    internal_sel_montgomery_write <= '1';
                else
                    internal_sel_montgomery_write <= '1';
                end if;
            elsif(instruction = "10") then
                if(next_instruction_hold_execution = '0') then
                    internal_ctr_address_montgomery_unit_ce <= '1';
                else
                    null;
                end if;
            else
                internal_control_memory_transfer_unit_free <= '1';
                internal_reg_montgomery_unit_enable_ce <= '1';
                internal_reg_enable_internal_memory_ce <= '1';
                internal_reg_enable_value_injection_ce <= '1';
                internal_reg_value_injection_ce <= '1';
                internal_reg_internal_memory_address_ce <= '1';
                internal_reg_montgomery_unit_address_ce <= '1';
            end if;
        end case;
end process;


end Behavioral;

