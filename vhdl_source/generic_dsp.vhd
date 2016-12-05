----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    Generic_dsp
-- Module Name:    Generic_dsp
-- Project Name:   Essentials
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- This circuit behaves closely to the igloo2 dsp.
-- This is done so it is possible to use the same circuit in other FPGA's.
-- The circuit does not behave exactly because of some differences in the control 
-- system regarding how the reset and the enable work together.
-- However, this difference does not affect the working of the Montgomery processor.
-- Since this condition is usually avoided. 
--
-- The circuits parameters
--
-- multiplication_word_length :
--
-- The number of bits the multiplication word has.
--
-- accumulation_word_length :
--
-- The number of bits the addition and accumulation unit has. 
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- 
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

entity generic_dsp is
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
end generic_dsp;

architecture Behavioral of generic_dsp is

component register_rst_nbits
    Generic (size : integer);
    Port (
        d : in  STD_LOGIC_VECTOR ((size - 1) downto 0);
        clk : in  STD_LOGIC;
        ce : in  STD_LOGIC;
        rst : in STD_LOGIC;
        rst_value : in STD_LOGIC_VECTOR ((size - 1) downto 0);
        q : out  STD_LOGIC_VECTOR ((size - 1) downto 0)
    );
end component;

signal reg_a_d : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal reg_a_ce : STD_LOGIC;
signal reg_a_rst : STD_LOGIC;
constant reg_a_rst_value : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, multiplication_word_length));
signal reg_a_q : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal reg_b_d : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal reg_b_ce : STD_LOGIC;
signal reg_b_rst : STD_LOGIC;
constant reg_b_rst_value : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, multiplication_word_length));
signal reg_b_q : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal reg_c_d : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);
signal reg_c_ce : STD_LOGIC;
signal reg_c_rst : STD_LOGIC;
constant reg_c_rst_value : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, accumulation_word_length));
signal reg_c_q : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);

signal reg_p_d : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);
signal reg_p_ce : STD_LOGIC;
signal reg_p_rst : STD_LOGIC;
constant reg_p_rst_value : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, accumulation_word_length));
signal reg_p_q : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);

signal reg_add_sub_mode_d : STD_LOGIC_VECTOR(0 downto 0);
constant reg_add_sub_mode_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_add_sub_mode_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_accumulation_mode_d : STD_LOGIC_VECTOR(0 downto 0);
constant reg_accumulation_mode_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_accumulation_mode_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_external_carry_in_mode_d : STD_LOGIC_VECTOR(0 downto 0);
constant reg_external_carry_in_mode_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_external_carry_in_mode_q : STD_LOGIC_VECTOR(0 downto 0);

signal reg_arshift_mode_d : STD_LOGIC_VECTOR(0 downto 0);
constant reg_arshift_mode_rst_value : STD_LOGIC_VECTOR(0 downto 0) := "0";
signal reg_arshift_mode_q : STD_LOGIC_VECTOR(0 downto 0);

signal value_a : UNSIGNED((multiplication_word_length - 1) downto 0);
signal value_b : UNSIGNED((multiplication_word_length - 1) downto 0);
signal value_c : UNSIGNED((accumulation_word_length - 1) downto 0);
signal value_p : STD_LOGIC_VECTOR((accumulation_word_length - 1) downto 0);

signal mult_a_b : UNSIGNED((2*multiplication_word_length - 1) downto 0);
signal acc : UNSIGNED((accumulation_word_length - 1) downto 0);
signal acc_arshift : UNSIGNED((accumulation_word_length - 1) downto 0);
signal result : UNSIGNED((accumulation_word_length - 1) downto 0);


begin

reg_a : register_rst_nbits
    Generic Map( size => multiplication_word_length )
    Port Map(
        d => reg_a_d,
        clk => clk,
        ce => reg_a_ce,
        rst => reg_a_rst,
        rst_value => reg_a_rst_value,
        q => reg_a_q
    );
    
reg_b : register_rst_nbits
    Generic Map( size => multiplication_word_length )
    Port Map(
        d => reg_b_d,
        clk => clk,
        ce => reg_b_ce,
        rst => reg_b_rst,
        rst_value => reg_b_rst_value,
        q => reg_b_q
    );
    
reg_c : register_rst_nbits
    Generic Map( size => accumulation_word_length )
    Port Map(
        d => reg_c_d,
        clk => clk,
        ce => reg_c_ce,
        rst => reg_c_rst,
        rst_value => reg_c_rst_value,
        q => reg_c_q
    );

reg_p : register_rst_nbits
    Generic Map( size => accumulation_word_length )
    Port Map(
        d => reg_p_d,
        clk => clk,
        ce => reg_p_ce,
        rst => reg_p_rst,
        rst_value => reg_p_rst_value,
        q => reg_p_q
    );
    
reg_add_sub_mode : register_rst_nbits
    Generic Map( size => 1 )
    Port Map(
        d => reg_add_sub_mode_d,
        clk => clk,
        ce => reg_add_sub_mode_ce,
        rst => reg_mode_rst,
        rst_value => reg_add_sub_mode_rst_value,
        q => reg_add_sub_mode_q
    );
    
reg_accumulation_mode : register_rst_nbits
    Generic Map( size => 1 )
    Port Map(
        d => reg_accumulation_mode_d,
        clk => clk,
        ce => reg_accumulation_mode_ce,
        rst => reg_mode_rst,
        rst_value => reg_accumulation_mode_rst_value,
        q => reg_accumulation_mode_q
    );
    
reg_external_carry_in_mode : register_rst_nbits
    Generic Map( size => 1 )
    Port Map(
        d => reg_external_carry_in_mode_d,
        clk => clk,
        ce => reg_external_carry_in_mode_ce,
        rst => reg_mode_rst,
        rst_value => reg_external_carry_in_mode_rst_value,
        q => reg_external_carry_in_mode_q
    );
    
reg_arshift_mode : register_rst_nbits
    Generic Map( size => 1 )
    Port Map(
        d => reg_arshift_mode_d,
        clk => clk,
        ce => reg_arshift_mode_ce,
        rst => reg_mode_rst,
        rst_value => reg_arshift_mode_rst_value,
        q => reg_arshift_mode_q
    );

reg_add_sub_mode_d(0) <= add_sub_mode;
reg_accumulation_mode_d(0) <= accumulation_mode;
reg_external_carry_in_mode_d(0) <= external_carry_in_mode;
reg_arshift_mode_d(0) <= arshift_mode;
reg_a_d <= a;
reg_b_d <= b;
reg_c_d <= c;

reg_a_ce <= (not a_bypass) and a_en;
reg_b_ce <= (not b_bypass) and b_en;
reg_c_ce <= (not c_bypass) and c_en;

reg_p_ce <= p_en;

reg_a_rst <= a_rst or (not a_en);
reg_b_rst <= b_rst or (not b_en);
reg_c_rst <= c_rst or (not c_en);
reg_p_rst <= p_rst or (not p_en);

value_a <= unsigned(a) when (a_bypass = '1' and a_en = '1') else 
                unsigned(reg_a_q);

value_b <= unsigned(b) when (b_bypass = '1' and b_en = '1') else 
                unsigned(reg_b_q);

value_c <= unsigned(c) when (c_bypass = '1' and c_en = '1') else 
                unsigned(reg_c_q);

mult_a_b <= value_a * value_b;

result <= value_c + acc_arshift - mult_a_b when reg_add_sub_mode_q = "1" else
             value_c + acc_arshift + mult_a_b;

reg_p_d <= std_logic_vector(result);

acc <= unsigned(external_carry_in) when (reg_external_carry_in_mode_q = "1") else
       unsigned(value_p) when (reg_accumulation_mode_q = "1") else 
       to_unsigned(0, accumulation_word_length);
        
acc_arshift((accumulation_word_length - 1) downto (accumulation_word_length - multiplication_word_length)) <= (others => acc(accumulation_word_length - 1)) when reg_arshift_mode_q = "1" else
                                                                                                acc((accumulation_word_length - 1) downto (accumulation_word_length - multiplication_word_length));

acc_arshift((accumulation_word_length - multiplication_word_length - 1) downto 0) <= acc((accumulation_word_length - 1) downto multiplication_word_length) when reg_arshift_mode_q = "1" else
                                                                                                            acc((accumulation_word_length - multiplication_word_length - 1) downto 0);
value_p <= reg_p_q;
    
product <= value_p;

end Behavioral;