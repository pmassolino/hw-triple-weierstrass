----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    memory_tranfer_unit_small_weierstrass_processor
-- Module Name:    memory_tranfer_unit_small_weierstrass_processor
-- Project Name:   Weierstrass processor
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- This unit handles most communication between the main memory and the 
-- Montgomery processors memories. This helps to alleviate the main state machine
-- and make the design easier to maintain. 
--
-- The circuits parameters
-- 
-- internal_memory_size :
--
-- The internal memory size of the Weierstrass processor. 
-- This memory is the main processor memory with all contents.
--
-- word_length :
--
-- The internal memory word length of the Weierstrass processor
-- and Montgomery processor.
--
-- montgomery_multiplier_memory_size :
--
-- The Montgomery processor memory size.
-- This is the memory for the internal arithmetic, where values are stored temporary.
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
--
-- control_memory_transfer_unit Rev 1.0
-- register_rst_nbits Rev 1.0
-- 
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory_tranfer_unit_small_weierstrass_processor is
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
end entity;

architecture Behavioral of memory_tranfer_unit_small_weierstrass_processor is

component control_memory_transfer_unit
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

signal reg_montgomery_unit_0_enable_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_montgomery_unit_0_enable_ce : STD_LOGIC;
signal reg_montgomery_unit_0_enable_rst : STD_LOGIC;
constant reg_montgomery_unit_0_enable_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_montgomery_unit_0_enable_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_montgomery_unit_1_enable_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_montgomery_unit_1_enable_ce : STD_LOGIC;
signal reg_montgomery_unit_1_enable_rst : STD_LOGIC;
constant reg_montgomery_unit_1_enable_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_montgomery_unit_1_enable_q : STD_LOGIC_VECTOR(0 downto 0);
    
signal reg_montgomery_unit_2_enable_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_montgomery_unit_2_enable_ce : STD_LOGIC;
signal reg_montgomery_unit_2_enable_rst : STD_LOGIC;
constant reg_montgomery_unit_2_enable_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_montgomery_unit_2_enable_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_enable_internal_memory_a_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_enable_internal_memory_a_ce : STD_LOGIC;
signal reg_enable_internal_memory_a_rst : STD_LOGIC;
constant reg_enable_internal_memory_a_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_enable_internal_memory_a_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_enable_internal_memory_b_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_enable_internal_memory_b_ce : STD_LOGIC;
signal reg_enable_internal_memory_b_rst : STD_LOGIC;
constant reg_enable_internal_memory_b_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_enable_internal_memory_b_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_enable_value_injection_a_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_enable_value_injection_a_ce : STD_LOGIC;
signal reg_enable_value_injection_a_rst : STD_LOGIC;
constant reg_enable_value_injection_a_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_enable_value_injection_a_q : STD_LOGIC_VECTOR(0 downto 0);
    
signal reg_enable_value_injection_b_d : STD_LOGIC_VECTOR(0 downto 0);
signal reg_enable_value_injection_b_ce : STD_LOGIC;
signal reg_enable_value_injection_b_rst : STD_LOGIC;
constant reg_enable_value_injection_b_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_enable_value_injection_b_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_value_injection_a_d : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal reg_value_injection_a_ce : STD_LOGIC;
signal reg_value_injection_a_rst : STD_LOGIC;
constant reg_value_injection_a_rst_value : STD_LOGIC_VECTOR((word_length - 1) downto 0) := (others => '0');
signal reg_value_injection_a_q : STD_LOGIC_VECTOR((word_length - 1) downto 0);
    
signal reg_value_injection_b_d : STD_LOGIC_VECTOR((word_length - 1) downto 0);
signal reg_value_injection_b_ce : STD_LOGIC;
signal reg_value_injection_b_rst : STD_LOGIC;
constant reg_value_injection_b_rst_value : STD_LOGIC_VECTOR((word_length - 1) downto 0) := (others => '0');
signal reg_value_injection_b_q : STD_LOGIC_VECTOR((word_length - 1) downto 0);

signal reg_internal_memory_address_a_d : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
signal reg_internal_memory_address_a_ce : STD_LOGIC;
signal reg_internal_memory_address_a_rst : STD_LOGIC;
constant reg_internal_memory_address_a_rst_value : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := (others => '0');
signal reg_internal_memory_address_a_q : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
    
signal reg_internal_memory_address_b_d : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);
signal reg_internal_memory_address_b_ce : STD_LOGIC;
signal reg_internal_memory_address_b_rst : STD_LOGIC;
constant reg_internal_memory_address_b_rst_value : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0) := (others => '0');
signal reg_internal_memory_address_b_q : STD_LOGIC_VECTOR(((internal_memory_size - (montgomery_multiplier_memory_size - 2)) - 1) downto 0);

signal reg_montgomery_unit_0_address_d : STD_LOGIC_VECTOR(1 downto 0);
signal reg_montgomery_unit_0_address_ce : STD_LOGIC;
signal reg_montgomery_unit_0_address_rst : STD_LOGIC;
constant reg_montgomery_unit_0_address_rst_value : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal reg_montgomery_unit_0_address_q : STD_LOGIC_VECTOR(1 downto 0);
signal inverse_reg_montgomery_unit_0_address_q : STD_LOGIC_VECTOR(1 downto 0);

signal reg_montgomery_unit_1_2_address_d : STD_LOGIC_VECTOR(1 downto 0);
signal reg_montgomery_unit_1_2_address_ce : STD_LOGIC;
signal reg_montgomery_unit_1_2_address_rst : STD_LOGIC;
constant reg_montgomery_unit_1_2_address_rst_value : STD_LOGIC_VECTOR(1 downto 0) := "00";
signal reg_montgomery_unit_1_2_address_q : STD_LOGIC_VECTOR(1 downto 0);
signal inverse_reg_montgomery_unit_1_2_address_q : STD_LOGIC_VECTOR(1 downto 0);

signal control_memory_transfer_unit_free : STD_LOGIC;
signal internal_memory_write_enable : STD_LOGIC;
signal montgomery_memory_write_enable : STD_LOGIC;
signal first_value_injected : STD_LOGIC;

signal reg_montgomery_unit_enable_ce : STD_LOGIC;
signal reg_enable_internal_memory_ce : STD_LOGIC;
signal reg_enable_value_injection_ce : STD_LOGIC;
signal reg_value_injection_ce : STD_LOGIC;
signal reg_internal_memory_address_ce : STD_LOGIC;
signal reg_montgomery_unit_address_ce : STD_LOGIC;

signal sel_montgomery_write : STD_LOGIC;

signal actual_instruction_hold_execution_montgomery_unit_0 : STD_LOGIC;
signal actual_instruction_hold_execution_montgomery_unit_1 : STD_LOGIC;
signal actual_instruction_hold_execution_montgomery_unit_2 : STD_LOGIC;
signal actual_instruction_hold_execution : STD_LOGIC;

signal next_instruction_hold_execution_montgomery_unit_0 : STD_LOGIC;
signal next_instruction_hold_execution_montgomery_unit_1 : STD_LOGIC;
signal next_instruction_hold_execution_montgomery_unit_2 : STD_LOGIC;
signal next_instruction_hold_execution : STD_LOGIC;

constant value_0 : STD_LOGIC_VECTOR((word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, word_length));

begin

control : control_memory_transfer_unit
    Port Map(
        clk => clk,
        rst => rst,
        instruction => instruction,
        actual_instruction_hold_execution => actual_instruction_hold_execution,
        next_instruction_hold_execution => next_instruction_hold_execution,
        continue_transfering => continue_transfering,
        reg_comparison_a_equal_b => reg_comparison_a_equal_b,
        control_memory_transfer_unit_free => control_memory_transfer_unit_free,
        internal_memory_write_enable => internal_memory_write_enable,
        montgomery_memory_write_enable => montgomery_memory_write_enable,
        first_value_injected => first_value_injected,
        reg_address_variable_a_ce => reg_address_variable_a_ce,
        reg_address_variable_b_ce => reg_address_variable_b_ce,
        ctr_address_variable_ce => ctr_address_variable_ce,
        ctr_address_variable_load => ctr_address_variable_load,
        ctr_address_variable_rst => ctr_address_variable_rst,
        reg_address_montgomery_unit_0_ce => reg_address_montgomery_unit_0_ce,
        reg_address_montgomery_unit_1_2_ce => reg_address_montgomery_unit_1_2_ce,
        ctr_address_montgomery_unit_ce => ctr_address_montgomery_unit_ce,
        ctr_address_montgomery_unit_rst => ctr_address_montgomery_unit_rst,
        reg_montgomery_unit_enable_ce => reg_montgomery_unit_enable_ce,
        reg_enable_internal_memory_ce => reg_enable_internal_memory_ce,
        reg_enable_value_injection_ce => reg_enable_value_injection_ce,
        reg_value_injection_ce => reg_value_injection_ce,
        reg_internal_memory_address_ce => reg_internal_memory_address_ce,
        reg_montgomery_unit_address_ce => reg_montgomery_unit_address_ce,
        sel_montgomery_write => sel_montgomery_write
    );

reg_montgomery_unit_0_enable : register_rst_nbits
    Generic Map(size => 1)
    Port Map(
        d => reg_montgomery_unit_0_enable_d,
        clk => clk,
        ce => reg_montgomery_unit_0_enable_ce,
        rst => reg_montgomery_unit_0_enable_rst,
        rst_value => reg_montgomery_unit_0_enable_rst_value,
        q => reg_montgomery_unit_0_enable_q
    );
    
reg_montgomery_unit_1_enable : register_rst_nbits
    Generic Map(size => 1)
    Port Map(
        d => reg_montgomery_unit_1_enable_d,
        clk => clk,
        ce => reg_montgomery_unit_1_enable_ce,
        rst => reg_montgomery_unit_1_enable_rst,
        rst_value => reg_montgomery_unit_1_enable_rst_value,
        q => reg_montgomery_unit_1_enable_q
    );
    
reg_montgomery_unit_2_enable : register_rst_nbits
    Generic Map(size => 1)
    Port Map(
        d => reg_montgomery_unit_2_enable_d,
        clk => clk,
        ce => reg_montgomery_unit_2_enable_ce,
        rst => reg_montgomery_unit_2_enable_rst,
        rst_value => reg_montgomery_unit_2_enable_rst_value,
        q => reg_montgomery_unit_2_enable_q
    );

reg_enable_internal_memory_a : register_rst_nbits
    Generic Map(size => 1)
    Port Map(
        d => reg_enable_internal_memory_a_d,
        clk => clk,
        ce => reg_enable_internal_memory_a_ce,
        rst => reg_enable_internal_memory_a_rst,
        rst_value => reg_enable_internal_memory_a_rst_value,
        q => reg_enable_internal_memory_a_q
    );
    
reg_enable_internal_memory_b : register_rst_nbits
    Generic Map(size => 1)
    Port Map(
        d => reg_enable_internal_memory_b_d,
        clk => clk,
        ce => reg_enable_internal_memory_b_ce,
        rst => reg_enable_internal_memory_b_rst,
        rst_value => reg_enable_internal_memory_b_rst_value,
        q => reg_enable_internal_memory_b_q
    );
    
reg_enable_value_injection_a : register_rst_nbits
    Generic Map(size => 1)
    Port Map(
        d => reg_enable_value_injection_a_d,
        clk => clk,
        ce => reg_enable_value_injection_a_ce,
        rst => reg_enable_value_injection_a_rst,
        rst_value => reg_enable_value_injection_a_rst_value,
        q => reg_enable_value_injection_a_q
    );
    
reg_enable_value_injection_b : register_rst_nbits
    Generic Map(size => 1)
    Port Map(
        d => reg_enable_value_injection_b_d,
        clk => clk,
        ce => reg_enable_value_injection_b_ce,
        rst => reg_enable_value_injection_b_rst,
        rst_value => reg_enable_value_injection_b_rst_value,
        q => reg_enable_value_injection_b_q
    );
    
reg_value_injection_a : register_rst_nbits
    Generic Map(size => word_length)
    Port Map(
        d => reg_value_injection_a_d,
        clk => clk,
        ce => reg_value_injection_a_ce,
        rst => reg_value_injection_a_rst,
        rst_value => reg_value_injection_a_rst_value,
        q => reg_value_injection_a_q
    );
    
reg_value_injection_b : register_rst_nbits
    Generic Map(size => word_length)
    Port Map(
        d => reg_value_injection_b_d,
        clk => clk,
        ce => reg_value_injection_b_ce,
        rst => reg_value_injection_b_rst,
        rst_value => reg_value_injection_b_rst_value,
        q => reg_value_injection_b_q
    );

reg_internal_memory_address_a : register_rst_nbits
    Generic Map(size => internal_memory_size - (montgomery_multiplier_memory_size - 2))
    Port Map(
        d => reg_internal_memory_address_a_d,
        clk => clk,
        ce => reg_internal_memory_address_a_ce,
        rst => reg_internal_memory_address_a_rst,
        rst_value => reg_internal_memory_address_a_rst_value,
        q => reg_internal_memory_address_a_q
    );
    
reg_internal_memory_address_b : register_rst_nbits
    Generic Map(size => internal_memory_size - (montgomery_multiplier_memory_size - 2))
    Port Map(
        d => reg_internal_memory_address_b_d,
        clk => clk,
        ce => reg_internal_memory_address_b_ce,
        rst => reg_internal_memory_address_b_rst,
        rst_value => reg_internal_memory_address_b_rst_value,
        q => reg_internal_memory_address_b_q
    );

reg_memory_transfer_unit_montomery_address_a : register_rst_nbits
    Generic Map(size => 2)
    Port Map(
        d => reg_montgomery_unit_0_address_d,
        clk => clk,
        ce => reg_montgomery_unit_0_address_ce,
        rst => reg_montgomery_unit_0_address_rst,
        rst_value => reg_montgomery_unit_0_address_rst_value,
        q => reg_montgomery_unit_0_address_q
    );

reg_memory_transfer_unit_montomery_address_b : register_rst_nbits
    Generic Map(size => 2)
    Port Map(
        d => reg_montgomery_unit_1_2_address_d,
        clk => clk,
        ce => reg_montgomery_unit_1_2_address_ce,
        rst => reg_montgomery_unit_1_2_address_rst,
        rst_value => reg_montgomery_unit_1_2_address_rst_value,
        q => reg_montgomery_unit_1_2_address_q
    );
    
reg_montgomery_unit_0_enable_d(0) <= montgomery_unit_0_enable;
reg_montgomery_unit_0_enable_ce <= reg_montgomery_unit_enable_ce;
reg_montgomery_unit_0_enable_rst <= rst;

reg_montgomery_unit_1_enable_d(0) <= montgomery_unit_1_enable;
reg_montgomery_unit_1_enable_ce <= reg_montgomery_unit_enable_ce;
reg_montgomery_unit_1_enable_rst <= rst;
    
reg_montgomery_unit_2_enable_d(0) <= montgomery_unit_2_enable;
reg_montgomery_unit_2_enable_ce <= reg_montgomery_unit_enable_ce;
reg_montgomery_unit_2_enable_rst <= rst;

reg_value_injection_a_d <= value_injection_a;
reg_value_injection_a_ce <= reg_value_injection_ce;
reg_value_injection_a_rst <= rst;
    
reg_value_injection_b_d <= value_injection_b;
reg_value_injection_b_ce <= reg_value_injection_ce;
reg_value_injection_b_rst <= rst;

reg_internal_memory_address_a_d <= internal_memory_address_a;
reg_internal_memory_address_a_ce <= reg_internal_memory_address_ce;
reg_internal_memory_address_a_rst <= rst;
    
reg_internal_memory_address_b_d <= internal_memory_address_b;
reg_internal_memory_address_b_ce <= reg_internal_memory_address_ce;
reg_internal_memory_address_b_rst <= rst;

reg_montgomery_unit_0_address_d <= montomery_unit_0_address;
reg_montgomery_unit_0_address_ce <= reg_montgomery_unit_address_ce;
reg_montgomery_unit_0_address_rst <= rst;

reg_montgomery_unit_1_2_address_d <= montomery_unit_1_2_address;
reg_montgomery_unit_1_2_address_ce <= reg_montgomery_unit_address_ce;
reg_montgomery_unit_1_2_address_rst <= rst;

reg_enable_internal_memory_a_d(0) <= enable_internal_memory_a;
reg_enable_internal_memory_a_ce <= reg_enable_internal_memory_ce;
reg_enable_internal_memory_a_rst <= rst;

reg_enable_internal_memory_b_d(0) <= enable_internal_memory_b;
reg_enable_internal_memory_b_ce <= reg_enable_internal_memory_ce;
reg_enable_internal_memory_b_rst <= rst;

reg_enable_value_injection_a_d(0) <= enable_value_injection_a;
reg_enable_value_injection_a_ce <= reg_enable_value_injection_ce;
reg_enable_value_injection_a_rst <= rst;

reg_enable_value_injection_b_d(0) <= enable_value_injection_b;
reg_enable_value_injection_b_ce <= reg_enable_value_injection_ce;
reg_enable_value_injection_b_rst <= rst;

inverse_reg_montgomery_unit_0_address_q <= not reg_montgomery_unit_0_address_q;
inverse_reg_montgomery_unit_1_2_address_q <= not reg_montgomery_unit_1_2_address_q;

memory_transfer_unit_free <= control_memory_transfer_unit_free;
        
value_injection_mem <= reg_value_injection_a_q;

value_injection_data_a <= value_0 when (first_value_injected = '1') else
                                    reg_value_injection_a_q;
value_injection_data_b <= value_0 when (first_value_injected = '1') else
                                    reg_value_injection_b_q;
                                    
state_machine_internal_memory_address_variable_a <= reg_internal_memory_address_a_q;
state_machine_internal_memory_address_variable_b <= reg_internal_memory_address_b_q;

reg_read_address_montgomery_unit_0_d <= inverse_reg_montgomery_unit_0_address_q when (sel_montgomery_write = '1') else
                                                     reg_montgomery_unit_0_address_q; 
reg_write_address_montgomery_unit_0_d <= inverse_reg_montgomery_unit_0_address_q when (sel_montgomery_write = '0') else
                                                         reg_montgomery_unit_0_address_q; 
reg_read_address_montgomery_unit_1_2_d <= inverse_reg_montgomery_unit_1_2_address_q when (sel_montgomery_write = '1') else
                                                         reg_montgomery_unit_1_2_address_q; 
reg_write_address_montgomery_unit_1_2_d <= inverse_reg_montgomery_unit_1_2_address_q when (sel_montgomery_write = '0') else
                                                         reg_montgomery_unit_1_2_address_q; 

sel_value_injection_mem <= reg_enable_value_injection_a_q(0);
sel_value_injection_a <= reg_enable_value_injection_a_q(0);
sel_value_injection_b <= reg_enable_value_injection_b_q(0);

sel_read_montgomery_processor_1 <= reg_montgomery_unit_1_enable_q(0);

internal_memory_rw_a <= internal_memory_write_enable and reg_enable_internal_memory_a_q(0);
internal_memory_rw_b <= internal_memory_write_enable and reg_enable_internal_memory_b_q(0);

montgomery_processor_0_write_enable_value <= montgomery_memory_write_enable and reg_montgomery_unit_0_enable_q(0);
montgomery_processor_1_write_enable_value <= montgomery_memory_write_enable and reg_montgomery_unit_1_enable_q(0);
montgomery_processor_2_write_enable_value <= montgomery_memory_write_enable and reg_montgomery_unit_2_enable_q(0);

actual_instruction_hold_execution_montgomery_unit_0 <= (not montgomery_processor_0_processor_free) and reg_montgomery_unit_0_enable_q(0);
actual_instruction_hold_execution_montgomery_unit_1 <= (not montgomery_processor_1_processor_free) and reg_montgomery_unit_1_enable_q(0);
actual_instruction_hold_execution_montgomery_unit_2 <= (not montgomery_processor_2_processor_free) and reg_montgomery_unit_2_enable_q(0);
actual_instruction_hold_execution <= actual_instruction_hold_execution_montgomery_unit_0 or actual_instruction_hold_execution_montgomery_unit_1 or actual_instruction_hold_execution_montgomery_unit_2;

next_instruction_hold_execution_montgomery_unit_0 <= (not montgomery_processor_0_processor_free) and montgomery_unit_0_enable;
next_instruction_hold_execution_montgomery_unit_1 <= (not montgomery_processor_1_processor_free) and montgomery_unit_1_enable;
next_instruction_hold_execution_montgomery_unit_2 <= (not montgomery_processor_2_processor_free) and montgomery_unit_2_enable;
next_instruction_hold_execution <= next_instruction_hold_execution_montgomery_unit_0 or next_instruction_hold_execution_montgomery_unit_1 or next_instruction_hold_execution_montgomery_unit_2;


end Behavioral;