----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    tb_extensive_small_montgomery_processor_3_with_mem
-- Module Name:    tb_extensive_small_montgomery_processor_3_with_mem
-- Project Name:   Montgomery processor
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- Testbench for the small Montgomery processor version 3 with the memory attached that 
-- can repeat several times. This is done by having all test files in a folder, an each 
-- file test has the same name, except they are different on the counter number.
--
-- Testbench parameters
--
-- PERIOD :
--
-- The clock PERIOD used during the test.
--
-- verification_results_enabled : 
--
-- Enable or disable the verification of the results. This is useful 
-- in case the testbench is used for power simulations, so there is disturbance 
-- with the comparisons. 
-- 
-- number_of_tests :
--
-- The number of tests to be performed.
--
-- file_name_max_size :
--
-- The maximum size of a file name location (includes directory)
--
-- processor_memory_size :
--
-- The size of the two memories together that is going to be used together in
-- the circuit.
-- In the processor in the size is the for each memory, while in the outside is for
-- both memories. 
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
-- operands_size : 
--
-- The size of each operand to be processed, in number of multiplication words.
-- For example, if the operands are 256 bits and the multiplication word is 17,
-- therefore the operands size is 256/17 = 15,05 -> 16 (ceiling)
--
-- external_memory_size : 
--
-- The size of the external memory that is going to load all testbench values and 
-- constants.
--
-- external_memory_base_address_n : 
--
-- The address of the prime, also known as 'n' in the external memory.
--
-- external_memory_base_address_n_line : 
--
-- The address of the n' constant that is related with n.
-- This constant has the size of only 1 multiplication word.
-- The constant is computed by solving the equation:
-- n'= -n^(-1) mod r
-- or this equation:
-- r*r^(-1) - n*n' = 1
-- 
-- external_memory_base_address_r2 : 
--
-- The address of the constant r*r mod n.
-- Where r is the Montgomery constant that is 2^(chosen number of bits).
-- The chosen number of bits should be the first multiple of the multiplication word
-- that is bigger than the number of bits in the prime plus 5.
--
-- external_memory_base_address_1 : 
--
-- The address of the constant 1 that is used during the Montgomery multiplication process.
--
-- external_memory_base_address_a : 
--
-- The address of the operand a.
--
-- external_memory_base_address_b : 
--
-- The address of the operand b.
--
-- external_memory_base_address_c : 
--
-- The address of the operand c.
--
-- external_memory_base_address_d : 
--
-- The address of the operand d.
--
-- external_memory_base_address_ar2 : 
--
-- The address of the operand a*r mod n.
--
-- external_memory_base_address_br2 : 
--
-- The address of the operand b*r mod n.
--
-- external_memory_base_address_cr2 : 
--
-- The address of the operand c*r mod n.
--
-- external_memory_base_address_dr2 : 
--
-- The address of the operand d*r mod n.
--
-- external_memory_base_address_ar2_br2 : 
--
-- The address of the operand (a*r + b*r) mod n.
--
-- external_memory_base_address_cr2_dr2 : 
--
-- The address of the operand (c*r - d*r) mod n.
--
-- external_memory_base_address_or2 : 
--
-- The address of the operand (a*r + b*r)*(c*r - d*r) mod n.
--
-- external_memory_base_address_o : 
--
-- The address of the operand (a + b)*(c - d) mod n.
--
-- external_memory_base_address_y : 
--
-- The address of the operand cr - dr.
--
-- tests_folder_name :
--
-- The name of the folder where the all file tests are located.
--
-- tests_begin_file_name :
--
-- The beginning of the name of each file test
--
-- tests_end_file_name :
--
-- The end of the name of each file test.
--
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
--
-- small_montgomery_processor_3_with_mem Rev 1.0
-- ram Rev 1.0
-- 
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_extensive_small_montgomery_processor_3_with_mem is
    Generic(
        PERIOD : time := 5000 ps;
        verification_results_enabled : boolean := true;
        number_of_tests : integer := 100;
        file_name_max_size : integer := 200;

        processor_memory_size : integer := 7;
        multiplication_word_length : integer := 17;
        accumulation_word_length : integer := 44;

-- Field Test 98 to 114
--      operands_size : integer := 7;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 7;
--      external_memory_base_address_r2 : integer := 8;
--      external_memory_base_address_1 : integer := 15;
--      external_memory_base_address_a : integer := 22;
--      external_memory_base_address_b : integer := 29;
--      external_memory_base_address_c : integer := 36;
--      external_memory_base_address_d : integer := 43;
--      external_memory_base_address_ar2 : integer := 50;
--      external_memory_base_address_br2 : integer := 57;
--      external_memory_base_address_cr2 : integer := 64;
--      external_memory_base_address_dr2 : integer := 71;
--      external_memory_base_address_ar2_br2 : integer := 78;
--      external_memory_base_address_cr2_dr2 : integer := 85;
--      external_memory_base_address_or2 : integer := 92;
--      external_memory_base_address_o : integer := 99;
--      external_memory_base_address_y : integer := 106;        
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_98_to_114_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_98_to_114_test_";
--      tests_end_file_name : string := ".dat"      
        
-- Field Test 115 to 131
--      operands_size : integer := 8;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 8;
--      external_memory_base_address_r2 : integer := 9;
--      external_memory_base_address_1 : integer := 17;
--      external_memory_base_address_a : integer := 25;
--      external_memory_base_address_b : integer := 33;
--      external_memory_base_address_c : integer := 41;
--      external_memory_base_address_d : integer := 49;
--      external_memory_base_address_ar2 : integer := 57;
--      external_memory_base_address_br2 : integer := 65;
--      external_memory_base_address_cr2 : integer := 73;
--      external_memory_base_address_dr2 : integer := 81;
--      external_memory_base_address_ar2_br2 : integer := 89;
--      external_memory_base_address_cr2_dr2 : integer := 97;
--      external_memory_base_address_or2 : integer := 105;
--      external_memory_base_address_o : integer := 113;
--      external_memory_base_address_y : integer := 121;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_115_to_131_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_115_to_131_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 132 to 148
--      operands_size : integer := 9;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 9;
--      external_memory_base_address_r2 : integer := 10;
--      external_memory_base_address_1 : integer := 19;
--      external_memory_base_address_a : integer := 28;
--      external_memory_base_address_b : integer := 37;
--      external_memory_base_address_c : integer := 46;
--      external_memory_base_address_d : integer := 55;
--      external_memory_base_address_ar2 : integer := 64;
--      external_memory_base_address_br2 : integer := 73;
--      external_memory_base_address_cr2 : integer := 82;
--      external_memory_base_address_dr2 : integer := 91;
--      external_memory_base_address_ar2_br2 : integer := 100;
--      external_memory_base_address_cr2_dr2 : integer := 109;
--      external_memory_base_address_or2 : integer := 118;
--      external_memory_base_address_o : integer := 127;
--      external_memory_base_address_y : integer := 136;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_132_to_148_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_132_to_148_test_";
--      tests_end_file_name : string := ".dat"

-- Field Test 149 to 165
--      operands_size : integer := 10;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 10;
--      external_memory_base_address_r2 : integer := 11;
--      external_memory_base_address_1 : integer := 21;
--      external_memory_base_address_a : integer := 31;
--      external_memory_base_address_b : integer := 41;
--      external_memory_base_address_c : integer := 51;
--      external_memory_base_address_d : integer := 61;
--      external_memory_base_address_ar2 : integer := 71;
--      external_memory_base_address_br2 : integer := 81;
--      external_memory_base_address_cr2 : integer := 91;
--      external_memory_base_address_dr2 : integer := 101;
--      external_memory_base_address_ar2_br2 : integer := 111;
--      external_memory_base_address_cr2_dr2 : integer := 121;
--      external_memory_base_address_or2 : integer := 131;
--      external_memory_base_address_o : integer := 141;
--      external_memory_base_address_y : integer := 151;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_149_to_165_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_149_to_165_test_";
--      tests_end_file_name : string := ".dat"

-- Field Test 166 to 182
--      operands_size : integer := 11;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 11;
--      external_memory_base_address_r2 : integer := 12;
--      external_memory_base_address_1 : integer := 23;
--      external_memory_base_address_a : integer := 34;
--      external_memory_base_address_b : integer := 45;
--      external_memory_base_address_c : integer := 56;
--      external_memory_base_address_d : integer := 67;
--      external_memory_base_address_ar2 : integer := 78;
--      external_memory_base_address_br2 : integer := 89;
--      external_memory_base_address_cr2 : integer := 100;
--      external_memory_base_address_dr2 : integer := 111;
--      external_memory_base_address_ar2_br2 : integer := 122;
--      external_memory_base_address_cr2_dr2 : integer := 133;
--      external_memory_base_address_or2 : integer := 144;
--      external_memory_base_address_o : integer := 155;
--      external_memory_base_address_y : integer := 166;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_166_to_182_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_166_to_182_test_";
--      tests_end_file_name : string := ".dat"

-- Field Test 183 to 199
--      operands_size : integer := 12;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 12;
--      external_memory_base_address_r2 : integer := 13;
--      external_memory_base_address_1 : integer := 25;
--      external_memory_base_address_a : integer := 37;
--      external_memory_base_address_b : integer := 49;
--      external_memory_base_address_c : integer := 61;
--      external_memory_base_address_d : integer := 73;
--      external_memory_base_address_ar2 : integer := 85;
--      external_memory_base_address_br2 : integer := 97;
--      external_memory_base_address_cr2 : integer := 109;
--      external_memory_base_address_dr2 : integer := 121;
--      external_memory_base_address_ar2_br2 : integer := 133;
--      external_memory_base_address_cr2_dr2 : integer := 145;
--      external_memory_base_address_or2 : integer := 157;
--      external_memory_base_address_o : integer := 169;
--      external_memory_base_address_y : integer := 181;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_183_to_199_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_183_to_199_test_";
--      tests_end_file_name : string := ".dat"

-- Field Test 200 to 216
--      operands_size : integer := 13;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_r2 : integer := 14;
--      external_memory_base_address_1 : integer := 28;
--      external_memory_base_address_a : integer := 42;
--      external_memory_base_address_b : integer := 56;
--      external_memory_base_address_c : integer := 70;
--      external_memory_base_address_d : integer := 84;
--      external_memory_base_address_ar2 : integer := 98;
--      external_memory_base_address_br2 : integer := 112;
--      external_memory_base_address_cr2 : integer := 126;
--      external_memory_base_address_dr2 : integer := 140;
--      external_memory_base_address_ar2_br2 : integer := 154;
--      external_memory_base_address_cr2_dr2 : integer := 168;      
--      external_memory_base_address_or2 : integer := 182;
--      external_memory_base_address_o : integer := 196;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_200_to_216_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_200_to_216_test_";
--      tests_end_file_name : string := ".dat"

-- Field Test 217 to 233
--      operands_size : integer := 14;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 14;
--      external_memory_base_address_r2 : integer := 15;
--      external_memory_base_address_1 : integer := 29;
--      external_memory_base_address_a : integer := 43;
--      external_memory_base_address_b : integer := 57;
--      external_memory_base_address_c : integer := 71;
--      external_memory_base_address_d : integer := 85;
--      external_memory_base_address_ar2 : integer := 99;
--      external_memory_base_address_br2 : integer := 113;
--      external_memory_base_address_cr2 : integer := 127;
--      external_memory_base_address_dr2 : integer := 141;
--      external_memory_base_address_ar2_br2 : integer := 155;
--      external_memory_base_address_cr2_dr2 : integer := 169;
--      external_memory_base_address_or2 : integer := 183;
--      external_memory_base_address_o : integer := 197;
--      external_memory_base_address_y : integer := 211;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_217_to_233_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_217_to_233_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 234 to 250
--      operands_size : integer := 15;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 15;
--      external_memory_base_address_r2 : integer := 16;
--      external_memory_base_address_1 : integer := 31;
--      external_memory_base_address_a : integer := 46;
--      external_memory_base_address_b : integer := 61;
--      external_memory_base_address_c : integer := 76;
--      external_memory_base_address_d : integer := 91;
--      external_memory_base_address_ar2 : integer := 106;
--      external_memory_base_address_br2 : integer := 121;
--      external_memory_base_address_cr2 : integer := 136;
--      external_memory_base_address_dr2 : integer := 151;
--      external_memory_base_address_ar2_br2 : integer := 166;
--      external_memory_base_address_cr2_dr2 : integer := 181;
--      external_memory_base_address_or2 : integer := 196;
--      external_memory_base_address_o : integer := 211;
--      external_memory_base_address_y : integer := 226;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_234_to_250_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_234_to_250_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 251 to 267
      operands_size : integer := 16;
      external_memory_size : integer := 14;
      external_memory_base_address_n : integer := 0;
      external_memory_base_address_n_line : integer := 16;
      external_memory_base_address_r2 : integer := 17;
      external_memory_base_address_1 : integer := 33;
      external_memory_base_address_a : integer := 49;
      external_memory_base_address_b : integer := 65;
      external_memory_base_address_c : integer := 81;
      external_memory_base_address_d : integer := 97;
      external_memory_base_address_ar2 : integer := 113;
      external_memory_base_address_br2 : integer := 129;
      external_memory_base_address_cr2 : integer := 145;
      external_memory_base_address_dr2 : integer := 161;
      external_memory_base_address_ar2_br2 : integer := 177;
      external_memory_base_address_cr2_dr2 : integer := 193;
      external_memory_base_address_or2 : integer := 209;
      external_memory_base_address_o : integer := 225;
      external_memory_base_address_y : integer := 241;
      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_251_to_267_extensive_tests/";
      tests_begin_file_name : string := "finite_field_251_to_267_test_";
      tests_end_file_name : string := ".dat"
        
-- Field Test 268 to 284
--      operands_size : integer := 17;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 17;
--      external_memory_base_address_r2 : integer := 18;
--      external_memory_base_address_1 : integer := 35;
--      external_memory_base_address_a : integer := 52;
--      external_memory_base_address_b : integer := 69;
--      external_memory_base_address_c : integer := 86;
--      external_memory_base_address_d : integer := 103;
--      external_memory_base_address_ar2 : integer := 120;
--      external_memory_base_address_br2 : integer := 137;
--      external_memory_base_address_cr2 : integer := 154;
--      external_memory_base_address_dr2 : integer := 171;
--      external_memory_base_address_ar2_br2 : integer := 188;
--      external_memory_base_address_cr2_dr2 : integer := 205;
--      external_memory_base_address_or2 : integer := 222;
--      external_memory_base_address_o : integer := 239;
--      external_memory_base_address_y : integer := 256;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_268_to_284_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_268_to_284_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 285 to 301
--      operands_size : integer := 18;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 18;
--      external_memory_base_address_r2 : integer := 19;
--      external_memory_base_address_1 : integer := 37;
--      external_memory_base_address_a : integer := 55;
--      external_memory_base_address_b : integer := 73;
--      external_memory_base_address_c : integer := 91;
--      external_memory_base_address_d : integer := 109;
--      external_memory_base_address_ar2 : integer := 127;
--      external_memory_base_address_br2 : integer := 145;
--      external_memory_base_address_cr2 : integer := 163;
--      external_memory_base_address_dr2 : integer := 181;
--      external_memory_base_address_ar2_br2 : integer := 199;
--      external_memory_base_address_cr2_dr2 : integer := 217;
--      external_memory_base_address_or2 : integer := 235;
--      external_memory_base_address_o : integer := 253;
--      external_memory_base_address_y : integer := 271;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_285_to_301_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_285_to_301_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 302 to 318
--      operands_size : integer := 19;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 19;
--      external_memory_base_address_r2 : integer := 20;
--      external_memory_base_address_1 : integer := 39;
--      external_memory_base_address_a : integer := 58;
--      external_memory_base_address_b : integer := 77;
--      external_memory_base_address_c : integer := 96;
--      external_memory_base_address_d : integer := 115;
--      external_memory_base_address_ar2 : integer := 134;
--      external_memory_base_address_br2 : integer := 153;
--      external_memory_base_address_cr2 : integer := 172;
--      external_memory_base_address_dr2 : integer := 191;
--      external_memory_base_address_ar2_br2 : integer := 210;
--      external_memory_base_address_cr2_dr2 : integer := 229;
--      external_memory_base_address_or2 : integer := 248;
--      external_memory_base_address_o : integer := 267;
--      external_memory_base_address_y : integer := 286;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_302_to_318_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_302_to_318_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 319 to 335
--      operands_size : integer := 20;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 20;
--      external_memory_base_address_r2 : integer := 21;
--      external_memory_base_address_1 : integer := 41;
--      external_memory_base_address_a : integer := 61;
--      external_memory_base_address_b : integer := 81;
--      external_memory_base_address_c : integer := 101;
--      external_memory_base_address_d : integer := 121;
--      external_memory_base_address_ar2 : integer := 141;
--      external_memory_base_address_br2 : integer := 161;
--      external_memory_base_address_cr2 : integer := 181;
--      external_memory_base_address_dr2 : integer := 201;
--      external_memory_base_address_ar2_br2 : integer := 221;
--      external_memory_base_address_cr2_dr2 : integer := 241;
--      external_memory_base_address_or2 : integer := 261;
--      external_memory_base_address_o : integer := 281;
--      external_memory_base_address_y : integer := 301;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_319_to_335_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_319_to_335_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 336 to 352
--      operands_size : integer := 21;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 21;
--      external_memory_base_address_r2 : integer := 22;
--      external_memory_base_address_1 : integer := 43;
--      external_memory_base_address_a : integer := 64;
--      external_memory_base_address_b : integer := 85;
--      external_memory_base_address_c : integer := 106;
--      external_memory_base_address_d : integer := 127;
--      external_memory_base_address_ar2 : integer := 148;
--      external_memory_base_address_br2 : integer := 169;
--      external_memory_base_address_cr2 : integer := 190;
--      external_memory_base_address_dr2 : integer := 211;
--      external_memory_base_address_ar2_br2 : integer := 232;
--      external_memory_base_address_cr2_dr2 : integer := 253;
--      external_memory_base_address_or2 : integer := 274;
--      external_memory_base_address_o : integer := 295;
--      external_memory_base_address_y : integer := 316;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_336_to_352_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_336_to_352_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 353 to 369
--      operands_size : integer := 22;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 22;
--      external_memory_base_address_r2 : integer := 23;
--      external_memory_base_address_1 : integer := 45;
--      external_memory_base_address_a : integer := 67;
--      external_memory_base_address_b : integer := 89;
--      external_memory_base_address_c : integer := 111;
--      external_memory_base_address_d : integer := 133;
--      external_memory_base_address_ar2 : integer := 155;
--      external_memory_base_address_br2 : integer := 177;
--      external_memory_base_address_cr2 : integer := 199;
--      external_memory_base_address_dr2 : integer := 221;
--      external_memory_base_address_ar2_br2 : integer := 243;
--      external_memory_base_address_cr2_dr2 : integer := 265;
--      external_memory_base_address_or2 : integer := 287;
--      external_memory_base_address_o : integer := 309;
--      external_memory_base_address_y : integer := 331;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_353_to_369_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_353_to_369_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 370 to 386
--      operands_size : integer := 23;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 23;
--      external_memory_base_address_r2 : integer := 24;
--      external_memory_base_address_1 : integer := 47;
--      external_memory_base_address_a : integer := 70;
--      external_memory_base_address_b : integer := 93;
--      external_memory_base_address_c : integer := 116;
--      external_memory_base_address_d : integer := 139;
--      external_memory_base_address_ar2 : integer := 162;
--      external_memory_base_address_br2 : integer := 185;
--      external_memory_base_address_cr2 : integer := 208;
--      external_memory_base_address_dr2 : integer := 231;
--      external_memory_base_address_ar2_br2 : integer := 254;
--      external_memory_base_address_cr2_dr2 : integer := 277;
--      external_memory_base_address_or2 : integer := 300;
--      external_memory_base_address_o : integer := 323;
--      external_memory_base_address_y : integer := 346;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_370_to_386_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_370_to_386_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 387 to 403
--      operands_size : integer := 24;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 24;
--      external_memory_base_address_r2 : integer := 25;
--      external_memory_base_address_1 : integer := 49;
--      external_memory_base_address_a : integer := 73;
--      external_memory_base_address_b : integer := 97;
--      external_memory_base_address_c : integer := 121;
--      external_memory_base_address_d : integer := 145;
--      external_memory_base_address_ar2 : integer := 169;
--      external_memory_base_address_br2 : integer := 193;
--      external_memory_base_address_cr2 : integer := 217;
--      external_memory_base_address_dr2 : integer := 241;
--      external_memory_base_address_ar2_br2 : integer := 265;
--      external_memory_base_address_cr2_dr2 : integer := 289;
--      external_memory_base_address_or2 : integer := 313;
--      external_memory_base_address_o : integer := 337;
--      external_memory_base_address_y : integer := 361;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_387_to_403_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_387_to_403_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 404 to 420
--      operands_size : integer := 25;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 25;
--      external_memory_base_address_r2 : integer := 26;
--      external_memory_base_address_1 : integer := 51;
--      external_memory_base_address_a : integer := 76;
--      external_memory_base_address_b : integer := 101;
--      external_memory_base_address_c : integer := 126;
--      external_memory_base_address_d : integer := 151;
--      external_memory_base_address_ar2 : integer := 176;
--      external_memory_base_address_br2 : integer := 201;
--      external_memory_base_address_cr2 : integer := 226;
--      external_memory_base_address_dr2 : integer := 251;
--      external_memory_base_address_ar2_br2 : integer := 276;
--      external_memory_base_address_cr2_dr2 : integer := 301;
--      external_memory_base_address_or2 : integer := 326;
--      external_memory_base_address_o : integer := 351;
--      external_memory_base_address_y : integer := 376;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_404_to_420_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_404_to_420_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 421 to 437
--      operands_size : integer := 26;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 26;
--      external_memory_base_address_r2 : integer := 27;
--      external_memory_base_address_1 : integer := 53;
--      external_memory_base_address_a : integer := 79;
--      external_memory_base_address_b : integer := 105;
--      external_memory_base_address_c : integer := 131;
--      external_memory_base_address_d : integer := 157;
--      external_memory_base_address_ar2 : integer := 183;
--      external_memory_base_address_br2 : integer := 209;
--      external_memory_base_address_cr2 : integer := 235;
--      external_memory_base_address_dr2 : integer := 261;
--      external_memory_base_address_ar2_br2 : integer := 287;
--      external_memory_base_address_cr2_dr2 : integer := 313;
--      external_memory_base_address_or2 : integer := 339;
--      external_memory_base_address_o : integer := 365;
--      external_memory_base_address_y : integer := 391;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_421_to_437_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_421_to_437_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 438 to 454
--      operands_size : integer := 27;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 27;
--      external_memory_base_address_r2 : integer := 28;
--      external_memory_base_address_1 : integer := 55;
--      external_memory_base_address_a : integer := 82;
--      external_memory_base_address_b : integer := 109;
--      external_memory_base_address_c : integer := 136;
--      external_memory_base_address_d : integer := 163;
--      external_memory_base_address_ar2 : integer := 190;
--      external_memory_base_address_br2 : integer := 217;
--      external_memory_base_address_cr2 : integer := 244;
--      external_memory_base_address_dr2 : integer := 271;
--      external_memory_base_address_ar2_br2 : integer := 298;
--      external_memory_base_address_cr2_dr2 : integer := 325;
--      external_memory_base_address_or2 : integer := 352;
--      external_memory_base_address_o : integer := 379;
--      external_memory_base_address_y : integer := 406;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_438_to_454_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_438_to_454_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 455 to 471
--      operands_size : integer := 28;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 28;
--      external_memory_base_address_r2 : integer := 29;
--      external_memory_base_address_1 : integer := 57;
--      external_memory_base_address_a : integer := 85;
--      external_memory_base_address_b : integer := 113;
--      external_memory_base_address_c : integer := 141;
--      external_memory_base_address_d : integer := 169;
--      external_memory_base_address_ar2 : integer := 197;
--      external_memory_base_address_br2 : integer := 225;
--      external_memory_base_address_cr2 : integer := 253;
--      external_memory_base_address_dr2 : integer := 281;
--      external_memory_base_address_ar2_br2 : integer := 309;
--      external_memory_base_address_cr2_dr2 : integer := 337;
--      external_memory_base_address_or2 : integer := 365;
--      external_memory_base_address_o : integer := 393;
--      external_memory_base_address_y : integer := 421;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_455_to_471_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_455_to_471_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 472 to 488
--      operands_size : integer := 29;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 29;
--      external_memory_base_address_r2 : integer := 30;
--      external_memory_base_address_1 : integer := 59;
--      external_memory_base_address_a : integer := 88;
--      external_memory_base_address_b : integer := 117;
--      external_memory_base_address_c : integer := 146;
--      external_memory_base_address_d : integer := 175;
--      external_memory_base_address_ar2 : integer := 204;
--      external_memory_base_address_br2 : integer := 233;
--      external_memory_base_address_cr2 : integer := 262;
--      external_memory_base_address_dr2 : integer := 291;
--      external_memory_base_address_ar2_br2 : integer := 320;
--      external_memory_base_address_cr2_dr2 : integer := 349;
--      external_memory_base_address_or2 : integer := 378;
--      external_memory_base_address_o : integer := 407;
--      external_memory_base_address_y : integer := 436;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_472_to_488_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_472_to_488_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 489 to 505
--      operands_size : integer := 30;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 30;
--      external_memory_base_address_r2 : integer := 31;
--      external_memory_base_address_1 : integer := 61;
--      external_memory_base_address_a : integer := 91;
--      external_memory_base_address_b : integer := 121;
--      external_memory_base_address_c : integer := 151;
--      external_memory_base_address_d : integer := 181;
--      external_memory_base_address_ar2 : integer := 211;
--      external_memory_base_address_br2 : integer := 241;
--      external_memory_base_address_cr2 : integer := 271;
--      external_memory_base_address_dr2 : integer := 301;
--      external_memory_base_address_ar2_br2 : integer := 331;
--      external_memory_base_address_cr2_dr2 : integer := 361;
--      external_memory_base_address_or2 : integer := 391;
--      external_memory_base_address_o : integer := 421;
--      external_memory_base_address_y : integer := 451;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_489_to_505_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_489_to_505_test_";
--      tests_end_file_name : string := ".dat"
        
-- Field Test 506 to 522
--      operands_size : integer := 31;
--      external_memory_size : integer := 14;
--      external_memory_base_address_n : integer := 0;
--      external_memory_base_address_n_line : integer := 31;
--      external_memory_base_address_r2 : integer := 32;
--      external_memory_base_address_1 : integer := 63;
--      external_memory_base_address_a : integer := 94;
--      external_memory_base_address_b : integer := 125;
--      external_memory_base_address_c : integer := 156;
--      external_memory_base_address_d : integer := 187;
--      external_memory_base_address_ar2 : integer := 218;
--      external_memory_base_address_br2 : integer := 249;
--      external_memory_base_address_cr2 : integer := 280;
--      external_memory_base_address_dr2 : integer := 311;
--      external_memory_base_address_ar2_br2 : integer := 342;
--      external_memory_base_address_cr2_dr2 : integer := 373;
--      external_memory_base_address_or2 : integer := 404;
--      external_memory_base_address_o : integer := 435;
--      external_memory_base_address_y : integer := 466;
--      tests_folder_name : string := "finite_field_tests_add_5_bits/finite_field_506_to_522_extensive_tests/";
--      tests_begin_file_name : string := "finite_field_506_to_522_test_";
--      tests_end_file_name : string := ".dat"

    );
end tb_extensive_small_montgomery_processor_3_with_mem;

architecture Behavioral of tb_extensive_small_montgomery_processor_3_with_mem is

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

component reloadable_ram
    Generic (
        ram_address_size : integer;
        ram_word_size : integer;
        file_ram_word_size : integer;
        file_name_size : integer
    );
    Port (
        data_in : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        rw : in STD_LOGIC;
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        load : in STD_LOGIC;
        dump : in STD_LOGIC; 
        address : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        load_file_name : string(1 to file_name_size);
        dump_file_name : string(1 to file_name_size);
        data_out : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
    );
end component;

signal test_rst : STD_LOGIC;
signal test_start : STD_LOGIC;
signal test_instruction : STD_LOGIC_VECTOR(2 downto 0);
signal test_operands_size : STD_LOGIC_VECTOR((processor_memory_size - 3) downto 0);
signal test_variable_a_position : STD_LOGIC_VECTOR(1 downto 0);
signal test_variable_b_position : STD_LOGIC_VECTOR(1 downto 0);
signal test_variable_p_position : STD_LOGIC_VECTOR(1 downto 0);
signal test_write_value : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal test_address_read_value : STD_LOGIC_VECTOR((processor_memory_size - 1) downto 0);
signal test_address_write_value : STD_LOGIC_VECTOR((processor_memory_size - 1) downto 0);
signal test_write_enable_value : STD_LOGIC;
signal test_processor_free : STD_LOGIC;
signal test_read_value : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal test_ram_data_in : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
signal test_ram_rw : STD_LOGIC;
signal test_ram_rst : STD_LOGIC;
signal test_ram_load : STD_LOGIC;
signal test_ram_dump : STD_LOGIC;
signal test_ram_address : STD_LOGIC_VECTOR((external_memory_size - 1) downto 0);
constant test_ram_rst_value : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0) := (others => '-');
signal test_ram_load_file_name : string(1 to file_name_max_size);
signal test_ram_data_out : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal true_ram_load : STD_LOGIC;
signal true_ram_address : STD_LOGIC_VECTOR((external_memory_size - 1) downto 0);
signal true_ram_load_file_name : string(1 to file_name_max_size);
signal true_ram_data_out : STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);

signal clk : STD_LOGIC := '0';
signal test_bench_finish : STD_LOGIC := '0';
signal test_error : STD_LOGIC := '0'; 
signal cycle_count : integer range 0 to 2000000000 := 0;

constant tb_delay : time := (2*PERIOD/4);

constant instruction_multiplication : STD_LOGIC_VECTOR(2 downto 0) := "000";
constant instruction_addition : STD_LOGIC_VECTOR(2 downto 0) := "001";
constant instruction_subtraction : STD_LOGIC_VECTOR(2 downto 0) := "010";
constant instruction_subtraction_no_normalization : STD_LOGIC_VECTOR(2 downto 0) := "011";
constant instruction_no_operation_memory_available : STD_LOGIC_VECTOR(2 downto 0) := "111";

procedure load_processor(
    test_load_memory_base_address : in integer;
    montgomery_processor_internal_memory_base_address : in STD_LOGIC_VECTOR(1 downto 0);
    load_operand_size : in integer;
    signal load_memory_address : out STD_LOGIC_VECTOR((external_memory_size - 1) downto 0);
    signal montgomery_processor_instruction : out STD_LOGIC_VECTOR(2 downto 0);
    signal montgomery_processor_address_read_value : out STD_LOGIC_VECTOR((processor_memory_size - 1) downto 0);
    signal montgomery_processor_address_write_value : out STD_LOGIC_VECTOR((processor_memory_size - 1) downto 0);
    signal montgomery_processor_internal_memory_write_enable : out STD_LOGIC) is
    variable j : integer;
begin
    montgomery_processor_instruction <= instruction_no_operation_memory_available;
    load_memory_address <= std_logic_vector(to_unsigned(test_load_memory_base_address + 0, external_memory_size));
    wait for PERIOD;
    load_memory_address <= std_logic_vector(to_unsigned(test_load_memory_base_address + 1, external_memory_size));
    wait for PERIOD;
    j := 0;
    montgomery_processor_address_read_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(2**(processor_memory_size - 2)- 1, processor_memory_size - 2));
    montgomery_processor_address_write_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j, processor_memory_size - 2));
    load_memory_address <= std_logic_vector(to_unsigned(test_load_memory_base_address + (j + 2), external_memory_size));
    montgomery_processor_internal_memory_write_enable <= '1';
    wait for PERIOD;
    j := 1;
    while (j < (load_operand_size)) loop
        montgomery_processor_address_read_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j - 1, processor_memory_size - 2));
        montgomery_processor_address_write_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j, processor_memory_size - 2));
        load_memory_address <= std_logic_vector(to_unsigned(test_load_memory_base_address + (j + 2), external_memory_size));
        montgomery_processor_internal_memory_write_enable <= '1';
        wait for PERIOD;
        j := j + 1;
    end loop;
    montgomery_processor_internal_memory_write_enable <= '0';
    montgomery_processor_address_read_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j - 1, processor_memory_size - 2));
    montgomery_processor_address_write_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j, processor_memory_size - 2));
    wait for PERIOD;
end load_processor;

procedure store_memory(
    test_store_memory_base_address : in integer;
    montgomery_processor_internal_memory_base_address : in STD_LOGIC_VECTOR(1 downto 0);
    store_operand_size : in integer;
    signal store_memory_address : out STD_LOGIC_VECTOR((external_memory_size - 1) downto 0);
    signal store_memory_rw : out STD_LOGIC;
    signal montgomery_processor_instruction : out STD_LOGIC_VECTOR(2 downto 0);
    signal montgomery_processor_address_read_value : out STD_LOGIC_VECTOR((processor_memory_size - 1) downto 0);
    signal montgomery_processor_address_write_value : out STD_LOGIC_VECTOR((processor_memory_size - 1) downto 0);
    signal montgomery_processor_internal_memory_write_enable : out STD_LOGIC) is
variable j: integer;
begin
    montgomery_processor_instruction <= instruction_no_operation_memory_available;
    j := 0;
    montgomery_processor_address_write_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(2**(processor_memory_size - 2)- 1, processor_memory_size - 2));
    montgomery_processor_address_read_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j, processor_memory_size - 2));
    wait for PERIOD;
    j := j + 1;
    montgomery_processor_address_write_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j - 1, processor_memory_size - 2));
    montgomery_processor_address_read_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j, processor_memory_size - 2));
    wait for PERIOD;
    j := j + 1;
    while (j < (store_operand_size)) loop
        montgomery_processor_address_write_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j - 1, processor_memory_size - 2));
        montgomery_processor_address_read_value <= montgomery_processor_internal_memory_base_address & std_logic_vector(to_unsigned(j, processor_memory_size - 2));
        store_memory_address <= std_logic_vector(to_unsigned(test_store_memory_base_address + j - 2, external_memory_size));
        montgomery_processor_internal_memory_write_enable <= '0';
        store_memory_rw <= '1';
        wait for PERIOD;
        j := j + 1;
    end loop;
    store_memory_address <= std_logic_vector(to_unsigned(test_store_memory_base_address + j - 2, external_memory_size));
    wait for PERIOD;
    j := j + 1;
    store_memory_address <= std_logic_vector(to_unsigned(test_store_memory_base_address + j - 2, external_memory_size));
    wait for PERIOD;
    store_memory_rw <= '0';
end store_memory;


procedure verify_memories(
    memory_base_address : in integer;
    error_message : in string;
    verify_operands_size : in integer;
    signal test_memory_data_out : in STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
    signal true_memory_data_out : in STD_LOGIC_VECTOR((multiplication_word_length - 1) downto 0);
    signal test_memory_address : out STD_LOGIC_VECTOR((external_memory_size - 1) downto 0);
    signal true_memory_address : out STD_LOGIC_VECTOR((external_memory_size - 1) downto 0);
    signal test_memory_rw : out STD_LOGIC;
    signal verification_wrong : out STD_LOGIC) is
variable j: integer;
begin
    test_memory_rw <= '0';
    verification_wrong <= '0';
    j := 0;
    while (j < (verify_operands_size)) loop
        true_memory_address <= std_logic_vector(to_unsigned(memory_base_address + j, external_memory_size));
        test_memory_address <= std_logic_vector(to_unsigned(memory_base_address + j, external_memory_size));
        wait for PERIOD*2;
        if (true_memory_data_out = test_memory_data_out) then
            verification_wrong <= '0';
        else
            verification_wrong <= '1';
            report error_message;
        end if;
        wait for PERIOD;
        verification_wrong <= '0';
        wait for PERIOD;
        j := j + 1;
    end loop;
    wait for PERIOD;
end verify_memories;


begin

clock : process
begin
while ( test_bench_finish /= '1') loop
    clk <= not clk;
    wait for PERIOD/2;
    clk <= not clk;
    wait for PERIOD/2;
    cycle_count <= cycle_count+1;
end loop;
wait;
end process;

test_ram : reloadable_ram
    Generic Map(
        ram_address_size => external_memory_size,
        ram_word_size => multiplication_word_length,
        file_ram_word_size => multiplication_word_length,
        file_name_size => file_name_max_size
    )
    Port Map(
        data_in => test_ram_data_in,
        rw => test_ram_rw,
        clk => clk,
        rst => test_ram_rst,
        dump => test_ram_dump,
        load => test_ram_load,
        address => test_ram_address,
        rst_value => test_ram_rst_value,
        load_file_name => test_ram_load_file_name,
        dump_file_name => (others=>'0'),
        data_out => test_ram_data_out
    );
    
true_ram : reloadable_ram
    Generic Map(
        ram_address_size => external_memory_size,
        ram_word_size => multiplication_word_length,
        file_ram_word_size => multiplication_word_length,
        file_name_size => file_name_max_size
    )
    Port Map(
        data_in => (others => '0'),
        rw => '0',
        clk => clk,
        rst => '1',
        dump => '0',
        load => true_ram_load,
        address => true_ram_address,
        rst_value => (others => '0'),
        load_file_name => true_ram_load_file_name,
        dump_file_name => (others=>'0'),        
        data_out => true_ram_data_out
    );

test : small_montgomery_processor_3_with_mem
    Generic Map(
        memory_size => processor_memory_size - 1,
        multiplication_word_length => multiplication_word_length,
        accumulation_word_length => accumulation_word_length
    )
    Port Map(
        rst => test_rst,
        start => test_start,
        clk => clk,
        instruction => test_instruction,
        operands_size => test_operands_size,
        variable_a_position => test_variable_a_position,
        variable_b_position => test_variable_b_position,
        variable_p_position => test_variable_p_position,
        write_value => test_write_value,
        address_read_value => test_address_read_value,
        address_write_value => test_address_write_value,
        write_enable_value => test_write_enable_value,
        processor_free => test_processor_free,
        read_value => test_read_value
    );
    
test_ram_data_in <= test_read_value;

test_write_value <= test_ram_data_out after (tb_delay);

process
    variable i : integer;
    variable j : integer;
    variable file_name_real_size : integer;
    begin
-- Reset stage
        wait for tb_delay;
        
        test_ram_rw <= '0';
        test_ram_rst <= '0';
        test_ram_dump <= '0';
        test_ram_address <= std_logic_vector(to_unsigned(0, external_memory_size));
        true_ram_address <= std_logic_vector(to_unsigned(0, external_memory_size));
        
        test_rst <= '0';
        test_start <= '0';
        test_instruction <= instruction_no_operation_memory_available;
        test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
        test_variable_a_position <= std_logic_vector(to_unsigned(1, 2));
        test_variable_b_position <= std_logic_vector(to_unsigned(2, 2));
        test_variable_p_position <= std_logic_vector(to_unsigned(3, 2));
        test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
        test_address_write_value <= std_logic_vector(to_unsigned(2**processor_memory_size - 1, processor_memory_size));
        test_write_enable_value <= '0';

        test_error <= '0';
        wait for PERIOD;
        test_rst <= '1';
        test_ram_rst <= '1';
        j := 0;
        wait for PERIOD;
        while(j < number_of_tests)  loop
            test_ram_load <= '1';
            true_ram_load <= '1';
            file_name_real_size := tests_folder_name'length;
            file_name_real_size := file_name_real_size + tests_begin_file_name'length;
            file_name_real_size := file_name_real_size + integer'image(j)'length;
            file_name_real_size := file_name_real_size + tests_end_file_name'length;
            
            assert (file_name_real_size < file_name_max_size) report "file_name_real_size " & integer'image(file_name_real_size) severity failure;
            
            test_ram_load_file_name(1 to file_name_real_size) <= tests_folder_name & tests_begin_file_name & integer'image(j) & tests_end_file_name;
            test_ram_load_file_name((file_name_real_size + 1) to file_name_max_size) <= (others => NUL);
            true_ram_load_file_name(1 to file_name_real_size) <= tests_folder_name & tests_begin_file_name & integer'image(j) & tests_end_file_name;
            true_ram_load_file_name((file_name_real_size + 1) to file_name_max_size) <= (others => NUL);
            wait for PERIOD;
            test_ram_load <= '0';
            true_ram_load <= '0';
            wait for PERIOD;
-- Load modulus n
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            load_processor(external_memory_base_address_n, "00", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Load constant n_line
            test_instruction <= instruction_no_operation_memory_available;
            test_ram_address <= std_logic_vector(to_unsigned(external_memory_base_address_n_line, external_memory_size));
            wait for PERIOD*2;
            test_address_read_value <= "00" & std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_address_write_value <= "00" & std_logic_vector(to_unsigned(operands_size, processor_memory_size - 2));
            test_write_enable_value <= '1';
            wait for PERIOD;
            test_address_read_value <= "00" & std_logic_vector(to_unsigned(operands_size, processor_memory_size - 2));
            test_address_write_value <= "00" & std_logic_vector(to_unsigned(operands_size+1, processor_memory_size - 2));
            test_write_enable_value <= '0';
            wait for PERIOD;
-- Load value r^2 mod n
            load_processor(external_memory_base_address_r2, "10", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Load value a mod n       
            load_processor(external_memory_base_address_a, "01", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Compute (a * r^2)/r mod n
            test_start <= '1';
            test_instruction <= instruction_multiplication;
            test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_variable_a_position <= "01";
            test_variable_b_position <= "10";
            test_variable_p_position <= "11";
            test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_address_write_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_write_enable_value <= '0';
            wait for PERIOD;
            test_start <= '0';
            test_instruction <= instruction_no_operation_memory_available;
            wait for PERIOD;
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            wait for PERIOD;
---- Store and Verify n
            if(verification_results_enabled) then
                store_memory(external_memory_base_address_n, "00", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_n, "Memory transfer of n did not worked", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;     
-- Store result ar2 = (a * r^2)/r mod n
            store_memory(external_memory_base_address_ar2, "11", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Verify ar2
            if(verification_results_enabled) then
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_ar2, "Computation of ar2 do not match expected ones", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;
-- Load b mod n     
            load_processor(external_memory_base_address_b, "01", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Compute (b * r^2)/r mod n
            test_start <= '1';
            test_instruction <= instruction_multiplication;
            test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_variable_a_position <= "01";
            test_variable_b_position <= "10";
            test_variable_p_position <= "11";
            test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_address_write_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_write_enable_value <= '0';
            wait for PERIOD;
            test_start <= '0';
            test_instruction <= instruction_no_operation_memory_available;
            wait for PERIOD;
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            wait for PERIOD;
-- Store result br2 = (b * r^2)/r mod n 
            store_memory(external_memory_base_address_br2, "11", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Verify br2       
            if(verification_results_enabled) then
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_br2, "Computation of br2 do not match expected ones", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;
-- Load c mod n
            load_processor(external_memory_base_address_c, "01", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Compute (c * r^2)/r mod n
            test_start <= '1';
            test_instruction <= instruction_multiplication;
            test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_variable_a_position <= "01";
            test_variable_b_position <= "10";
            test_variable_p_position <= "11";
            test_address_write_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_write_enable_value <= '0';
            wait for PERIOD;
            test_start <= '0';
            test_instruction <= instruction_no_operation_memory_available;
            wait for PERIOD;
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            wait for PERIOD;
-- Store result cr2 = (c * r^2)/r mod n
            store_memory(external_memory_base_address_cr2, "11", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Verify cr2
            if(verification_results_enabled) then
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_cr2, "Computation of cr2 do not match expected ones", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;
-- Load d mod n
            load_processor(external_memory_base_address_d, "01", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Compute (d * r^2)/r mod n
            test_start <= '1';
            test_instruction <= instruction_multiplication;
            test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_variable_a_position <= "01";
            test_variable_b_position <= "10";
            test_variable_p_position <= "11";
            test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_address_write_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_write_enable_value <= '0';
            wait for PERIOD;
            test_start <= '0';
            test_instruction <= instruction_no_operation_memory_available;
            wait for PERIOD;
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            wait for PERIOD;
-- Store result dr2 = (d * r^2)/r mod n
            store_memory(external_memory_base_address_dr2, "11", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Verify dr2
            if(verification_results_enabled) then
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_dr2, "Computation of dr2 do not match expected ones", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;
-- Load cr2
            load_processor(external_memory_base_address_cr2, "01", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Compute cr^2 - dr^2
            test_start <= '1';
            test_instruction <= instruction_subtraction;
            test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_variable_a_position <= "11";
            test_variable_b_position <= "01";
            test_variable_p_position <= "01";
            test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_address_write_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_write_enable_value <= '0';
            wait for PERIOD;
            test_start <= '0';
            test_instruction <= instruction_no_operation_memory_available;
            wait for PERIOD;
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            wait for PERIOD;
-- Store result cr2_dr2 = cr^2 - dr^2
            store_memory(external_memory_base_address_cr2_dr2, "01", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Verify cr2_dr2
            if(verification_results_enabled) then
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_cr2_dr2, "Subtraction of cr2 - dr2 is not correct", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;
-- Load ar2
            load_processor(external_memory_base_address_ar2, "11", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Load br2
            load_processor(external_memory_base_address_br2, "10", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Compute ar^2 + br^2
            test_start <= '1';
            test_instruction <= instruction_addition;
            test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_variable_a_position <= "10";
            test_variable_b_position <= "11";
            test_variable_p_position <= "11";
            test_address_write_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_write_enable_value <= '0';
            wait for PERIOD;
            test_start <= '0';
            test_instruction <= instruction_no_operation_memory_available;
            wait for PERIOD;
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            wait for PERIOD;
-- Store result ar2_br2 = ar^2 + br^2
            store_memory(external_memory_base_address_ar2_br2, "11", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Verify ar2_br2
            if(verification_results_enabled) then
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_ar2_br2, "Computation of ar2 + br2 do not match expected ones", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;
-- Compute (ar2_br2 * cr2_dr2)/r mod n
            test_start <= '1';
            test_instruction <= instruction_multiplication;
            test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_variable_a_position <= "01";
            test_variable_b_position <= "11";
            test_variable_p_position <= "10";
            test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_address_write_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_write_enable_value <= '0';
            wait for PERIOD;
            test_start <= '0';
            test_instruction <= instruction_no_operation_memory_available;
            wait for PERIOD;
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            wait for PERIOD;
-- Store result or2 = (ar2_br2 * cr2_dr2)/r mod n
            store_memory(external_memory_base_address_or2, "10", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Verify or2
            if(verification_results_enabled) then
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_or2, "Computation of or2 do not match expected ones", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;
-- Load 1
            load_processor(external_memory_base_address_1, "01", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Compute (or^2 * 1)/r mod n
            test_start <= '1';
            test_instruction <= instruction_multiplication;
            test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_variable_a_position <= "01";
            test_variable_b_position <= "10";
            test_variable_p_position <= "11";
            test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_address_write_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_write_enable_value <= '0';
            wait for PERIOD;
            test_start <= '0';
            test_instruction <= instruction_no_operation_memory_available;
            wait for PERIOD;
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            wait for PERIOD;
-- Store result o = ( or^2 * 1 ) /  r mod n
            store_memory(external_memory_base_address_o, "11", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Verify o
            if(verification_results_enabled) then
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_o, "Computation of o do not match expected ones", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;
-- Load cr2
            load_processor(external_memory_base_address_cr2, "01", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Load dr2
            load_processor(external_memory_base_address_dr2, "10", operands_size, test_ram_address, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Compute y = cr2 - dr2
            test_start <= '1';
            test_instruction <= instruction_subtraction_no_normalization;
            test_operands_size <= std_logic_vector(to_unsigned(operands_size - 1, processor_memory_size - 2));
            test_variable_a_position <= "10";
            test_variable_b_position <= "01";
            test_variable_p_position <= "01";
            test_address_read_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_address_write_value <= std_logic_vector(to_unsigned(0, processor_memory_size));
            test_write_enable_value <= '0';
            wait for PERIOD;
            test_start <= '0';
            test_instruction <= instruction_no_operation_memory_available;
            wait for PERIOD;
            wait until (test_processor_free = '1' and rising_edge(clk));
            wait for tb_delay;
            wait for PERIOD;
-- Store result y = cr2 - dr2
            store_memory(external_memory_base_address_y, "01", operands_size, test_ram_address, test_ram_rw, test_instruction, test_address_read_value, test_address_write_value, test_write_enable_value);
-- Verify y
            if(verification_results_enabled) then
                test_instruction <= instruction_no_operation_memory_available;
                verify_memories(external_memory_base_address_y, "Computation of y do not match expected ones", operands_size, test_ram_data_out, true_ram_data_out, test_ram_address, true_ram_address, test_ram_rw, test_error);
            end if;                   
            j := j + 1;
        end loop;
        test_bench_finish <= '1';
        wait;
end process;

end Behavioral;
