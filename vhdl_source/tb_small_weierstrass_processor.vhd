----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    tb_small_weierstrass_processor
-- Module Name:    tb_small_weierstrass_processor
-- Project Name:   Weierstrass processor
-- Target Devices: Any
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- Testbench for the small Weierstrass processor.
--
-- Testbench parameters
--
-- PERIOD :
--
-- The clock PERIOD used during the test.
--
-- load_memory_size :
--
-- The size of the memory that will load all test data.
-- This value is only for testing, it does not affect the circuit.
--        
-- weierstrass_processor_internal_memory_size :
--
-- The internal memory size used by the processor.
--
-- weierstrass_processor_scalar_max_size :
--
-- The maximum scalar size accepted by the processor. 
-- It would be the maximum length in bits.
-- If the maximum size of scalar is 512 bits scalar, then this value is 9.
--
-- weierstrass_processor_word_length :
--
-- The word length of the processor.
-- This is also the word size of the DSP in the Montgomery multiplier.
--
-- weierstrass_processor_word_length_size :
--
-- The size of the word length. 
-- For example if it is 17 bits word length, then this value would be 5.
-- If it was 15 then it would be 4. 
--
-- weierstrass_processor_montgomery_multiplier_memory_size :
--
-- Montgomery multiplier memory size.
--
-- weierstrass_processor_montgomery_accumulation_word_length :
--
-- Montgomery processor accumulator size.
--
-- weierstrass_processor_internal_memory_base_address_n :
--
-- The position which has the value of the prime, aka 'n'.
--
-- weierstrass_processor_internal_memory_base_address_r2 :
--
-- The position which has the value of the r*r mod n.
--
-- weierstrass_processor_internal_memory_base_address_a :
--
-- The position which has the elliptic curve constant a from
-- the Weierstrass processor.
--
-- weierstrass_processor_internal_memory_base_address_b :
--
-- The position which has the elliptic curve constant b from
-- the Weierstrass processor.
--
-- weierstrass_processor_internal_memory_base_address_scalar :
--
-- The position which has the scalar to be used during the
-- scalar multiplication.
--
-- weierstrass_processor_internal_memory_base_address_Px :
--
-- The position which has the coordinate x of the elliptic curve point.
--
-- weierstrass_processor_internal_memory_base_address_Py :
--
-- The position which has the coordinate y of the elliptic curve point.
--
-- weierstrass_processor_internal_memory_base_address_Pz :
--
-- The position which has the coordinate z of the elliptic curve point.
--
-- weierstrass_processor_internal_memory_base_address_sPx :
--
-- The position which has the response from the scalar multiplication, 
-- in the coordinate x of the elliptic curve point.
--
-- weierstrass_processor_internal_memory_base_address_sPy :
--
-- The position which has the response from the scalar multiplication, 
-- in the coordinate y of the elliptic curve point.
--
-- weierstrass_processor_internal_memory_base_address_sPz :
--
-- The position which has the response from the scalar multiplication, 
-- in the coordinate z of the elliptic curve point.
--
-- weierstrass_processor_internal_memory_base_address_fPx :
--
-- The position which has the inverse of the scalar in the scalar multiplication, 
-- in the coordinate x of the elliptic curve point.
--
-- weierstrass_processor_internal_memory_base_address_fPy :
--
-- The position which has the inverse of the scalar in the scalar multiplication, 
-- in the coordinate y of the elliptic curve point.
--
-- weierstrass_processor_internal_memory_base_address_fPz :
--
-- The position which has the inverse of the scalar in the scalar multiplication, 
-- in the coordinate z of the elliptic curve point.
--
-- weierstrass_processor_internal_memory_base_address_t :
--
-- The temporary variables used by the processor.
--
-- weierstrass_prime_size :
--
-- The curve prime size in the number of processor words.
-- if the prime is 256 bits and the word size is 17 bits, then this values
-- is 16
--
-- weierstrass_scalar_size :
--
-- The size of the scalar used during the test in terms of bits.
--
-- weierstrass_load_memory_base_address_n :
--
-- The load test file position of the prime, aka 'n'. 
--
-- weierstrass_load_memory_base_address_n_line :
--
-- The load test file position of the constant n'.
--
-- weierstrass_load_memory_base_address_r2 :
--
-- The load test file position of the constant r2 = r*r mod n.
--
-- weierstrass_load_memory_base_address_curve_constant_0 :
--
-- The load test file position of the curve constant 0.
-- In this case it is the constant a from the Weierstrass curve.
-- For curve constant 1 it is b from the Weierstrass curve.
--
-- weierstrass_load_memory_base_address_curve_constant_0_in_r2 :
--
-- The load test file position of the curve constant 0 multiplied by r2.
-- In this case it is the constant a from the Weierstrass curve.
-- For curve constant 1 it is b from the Weierstrass curve.
--
-- weierstrass_load_memory_base_address_scalar_number :
--
-- The load test file position of the scalar.
--
-- weierstrass_load_memory_base_address_point_coordinate_0 :
--
-- The load test file position of the curve point coordinate 0.
-- In this case it is the coordinate x from the point.
-- While 1 and 2 are for coordinates 'y' and 'z' respectively.
--
-- weierstrass_load_memory_base_address_point_coordinate_0_in_r2 :
--
-- The load test file position of the curve point coordinate 0 multiplied by r2.
-- In this case it is the coordinate x from the point.
-- While 1 and 2 are for coordinates 'y' and 'z' respectively.
--
-- weierstrass_load_memory_base_address_scalar_point_coordinate_0 :
--
-- The load test file position of the response point coordinate 0.
-- In this case it is the coordinate x from the point.
-- While 1 and 2 are for coordinates 'y' and 'z' respectively.
--
-- weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 :
--
-- The load test file position of the response point coordinate 0 multiplied by r2.
-- In this case it is the coordinate x from the point.
-- While 1 and 2 are for coordinates 'y' and 'z' respectively.
--
--
-- weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 :
--
-- The load test file position of the response point coordinate 0 in affine.
-- In this case it is the coordinate x from the point.
-- While 1 is the coordinate 'y'.
--
-- weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 :
--
-- The load test file position of the response point coordinate 0 in affine multiplied by r2.
-- In this case it is the coordinate x from the point.
-- While 1 is the coordinate 'y'.
--
--
-- weierstrass_processor_load_file_name :
--
-- The test file name with all the constants and values to perform the test.
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

entity tb_small_weierstrass_processor is
    Generic(
        PERIOD : time := 20 ns;
        
        load_memory_size : integer := 12;
        
        weierstrass_processor_internal_memory_size : integer := 10;
        weierstrass_processor_scalar_max_size : integer := 10;
        weierstrass_processor_word_length : integer := 17;
        weierstrass_processor_word_length_size : integer := 5;
        weierstrass_processor_montgomery_multiplier_memory_size : integer := 7;
        weierstrass_processor_montgomery_accumulation_word_length : integer := 44;
        
        weierstrass_processor_internal_memory_base_address_n : integer := 0;
        weierstrass_processor_internal_memory_base_address_r2 : integer := 1;
        weierstrass_processor_internal_memory_base_address_a : integer := 2;
        weierstrass_processor_internal_memory_base_address_b : integer := 3;
        weierstrass_processor_internal_memory_base_address_scalar : integer := 4;
        weierstrass_processor_internal_memory_base_address_Px : integer := 6;
        weierstrass_processor_internal_memory_base_address_Py : integer := 7;
        weierstrass_processor_internal_memory_base_address_Pz : integer := 8;
        weierstrass_processor_internal_memory_base_address_sPx : integer := 9;
        weierstrass_processor_internal_memory_base_address_sPy : integer := 10;
        weierstrass_processor_internal_memory_base_address_sPz : integer := 11;
        weierstrass_processor_internal_memory_base_address_fPx : integer := 12;
        weierstrass_processor_internal_memory_base_address_fPy : integer := 13;
        weierstrass_processor_internal_memory_base_address_fPz : integer := 14;
        weierstrass_processor_internal_memory_base_address_t0 : integer := 15;
        weierstrass_processor_internal_memory_base_address_t1 : integer := 16;
        weierstrass_processor_internal_memory_base_address_t2 : integer := 17;
        weierstrass_processor_internal_memory_base_address_t3 : integer := 18;
        weierstrass_processor_internal_memory_base_address_t4 : integer := 19;
        weierstrass_processor_internal_memory_base_address_t5 : integer := 20;
        weierstrass_processor_internal_memory_base_address_t6 : integer := 21;
        weierstrass_processor_internal_memory_base_address_t7 : integer := 22;
        weierstrass_processor_internal_memory_base_address_t8 : integer := 23;
        weierstrass_processor_internal_memory_base_address_t9 : integer := 24;
        weierstrass_processor_internal_memory_base_address_t10 : integer := 25;
        weierstrass_processor_internal_memory_base_address_t11 : integer := 26;
        weierstrass_processor_internal_memory_base_address_t12 : integer := 27;
        weierstrass_processor_internal_memory_base_address_t13 : integer := 28;
        weierstrass_processor_internal_memory_base_address_t14 : integer := 29;
        weierstrass_processor_internal_memory_base_address_t15 : integer := 30;
        weierstrass_processor_internal_memory_base_address_t16 : integer := 31;
       
-- Test curve B
--        weierstrass_prime_size : integer := 8;
--        weierstrass_scalar_size : integer := 22;
--        weierstrass_load_memory_base_address_n : integer := 0;
--        weierstrass_load_memory_base_address_n_line : integer := 8;
--        weierstrass_load_memory_base_address_r2 : integer := 9;
--        weierstrass_load_memory_base_address_curve_constant_0 : integer := 17;
--        weierstrass_load_memory_base_address_curve_constant_0_in_r2 : integer := 25;
--        weierstrass_load_memory_base_address_curve_constant_1 : integer := 33;
--        weierstrass_load_memory_base_address_curve_constant_1_in_r2 : integer := 41;
--        weierstrass_load_memory_base_address_scalar_number : integer := 49;
--        weierstrass_load_memory_base_address_point_coordinate_0 : integer := 57;
--        weierstrass_load_memory_base_address_point_coordinate_0_in_r2 : integer := 65;
--        weierstrass_load_memory_base_address_point_coordinate_1 : integer := 73;
--        weierstrass_load_memory_base_address_point_coordinate_1_in_r2 : integer := 81;
--        weierstrass_load_memory_base_address_point_coordinate_2 : integer := 89;
--        weierstrass_load_memory_base_address_point_coordinate_2_in_r2 : integer := 97;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0 : integer := 105;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 : integer := 113;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1 : integer := 121;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1_in_r2 : integer := 129;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2 : integer := 137;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2_in_r2 : integer := 145;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 : integer := 153;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 : integer := 161;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1 : integer := 169;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1_in_r2 : integer := 177;
--        
--        weierstrass_processor_load_file_name : string := "ecc_tests/weierstrass_processor_Test_Curve_B_test.dat" 
        
-- Brainpool 160r1 test
--        weierstrass_prime_size : integer := 10;
--        weierstrass_scalar_size : integer := 160;
--        weierstrass_load_memory_base_address_n : integer := 0;
--        weierstrass_load_memory_base_address_n_line : integer := 10;
--        weierstrass_load_memory_base_address_r2 : integer := 11;
--        weierstrass_load_memory_base_address_curve_constant_0 : integer := 21;
--        weierstrass_load_memory_base_address_curve_constant_0_in_r2 : integer := 31;
--        weierstrass_load_memory_base_address_curve_constant_1 : integer := 41;
--        weierstrass_load_memory_base_address_curve_constant_1_in_r2 : integer := 51;
--        weierstrass_load_memory_base_address_scalar_number : integer := 61;
--        weierstrass_load_memory_base_address_point_coordinate_0 : integer := 71;
--        weierstrass_load_memory_base_address_point_coordinate_0_in_r2 : integer := 81;
--        weierstrass_load_memory_base_address_point_coordinate_1 : integer := 91;
--        weierstrass_load_memory_base_address_point_coordinate_1_in_r2 : integer := 101;
--        weierstrass_load_memory_base_address_point_coordinate_2 : integer := 111;
--        weierstrass_load_memory_base_address_point_coordinate_2_in_r2 : integer := 121;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0 : integer := 131;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 : integer := 141;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1 : integer := 151;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1_in_r2 : integer := 161;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2 : integer := 171;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2_in_r2 : integer := 181;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 : integer := 191;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 : integer := 201;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1 : integer := 211;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1_in_r2 : integer := 221;            
--        
--        weierstrass_processor_load_file_name : string := "ecc_tests/weierstrass_processor_BrainpoolP160r1_test.dat" 

-- Brainpool 320r1 test
--        weierstrass_prime_size : integer := 20;
--        weierstrass_scalar_size : integer := 320;
--        weierstrass_load_memory_base_address_n : integer := 0;
--        weierstrass_load_memory_base_address_n_line : integer := 20;
--        weierstrass_load_memory_base_address_r2 : integer := 21;
--        weierstrass_load_memory_base_address_curve_constant_0 : integer := 41;
--        weierstrass_load_memory_base_address_curve_constant_0_in_r2 : integer := 61;
--        weierstrass_load_memory_base_address_curve_constant_1 : integer := 81;
--        weierstrass_load_memory_base_address_curve_constant_1_in_r2 : integer := 101;
--        weierstrass_load_memory_base_address_scalar_number : integer := 121;
--        weierstrass_load_memory_base_address_point_coordinate_0 : integer := 141;
--        weierstrass_load_memory_base_address_point_coordinate_0_in_r2 : integer := 161;
--        weierstrass_load_memory_base_address_point_coordinate_1 : integer := 181;
--        weierstrass_load_memory_base_address_point_coordinate_1_in_r2 : integer := 201;
--        weierstrass_load_memory_base_address_point_coordinate_2 : integer := 221;
--        weierstrass_load_memory_base_address_point_coordinate_2_in_r2 : integer := 241;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0 : integer := 261;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 : integer := 281;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1 : integer := 301;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1_in_r2 : integer := 321;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2 : integer := 341;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2_in_r2 : integer := 361;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 : integer := 381;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 : integer := 401;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1 : integer := 421;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1_in_r2 : integer := 441;
--  
--        weierstrass_processor_load_file_name : string := "ecc_tests/weierstrass_processor_BrainpoolP320r1_test.dat" 

-- Brainpool 512r1 test
--        weierstrass_prime_size : integer := 31;
--        weierstrass_scalar_size : integer := 512;
--        weierstrass_load_memory_base_address_n : integer := 0;
--        weierstrass_load_memory_base_address_n_line : integer := 31;
--        weierstrass_load_memory_base_address_r2 : integer := 32;
--        weierstrass_load_memory_base_address_curve_constant_0 : integer := 63;
--        weierstrass_load_memory_base_address_curve_constant_0_in_r2 : integer := 94;
--        weierstrass_load_memory_base_address_curve_constant_1 : integer := 125;
--        weierstrass_load_memory_base_address_curve_constant_1_in_r2 : integer := 156;
--        weierstrass_load_memory_base_address_scalar_number : integer := 187;
--        weierstrass_load_memory_base_address_point_coordinate_0 : integer := 218;
--        weierstrass_load_memory_base_address_point_coordinate_0_in_r2 : integer := 249;
--        weierstrass_load_memory_base_address_point_coordinate_1 : integer := 280;
--        weierstrass_load_memory_base_address_point_coordinate_1_in_r2 : integer := 311;
--        weierstrass_load_memory_base_address_point_coordinate_2 : integer := 342;
--        weierstrass_load_memory_base_address_point_coordinate_2_in_r2 : integer := 373;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0 : integer := 404;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 : integer := 435;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1 : integer := 466;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1_in_r2 : integer := 497;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2 : integer := 528;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2_in_r2 : integer := 559;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 : integer := 590;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 : integer := 621;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1 : integer := 652;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1_in_r2 : integer := 683;
--
--        weierstrass_processor_load_file_name : string := "ecc_tests/weierstrass_processor_BrainpoolP512r1_test.dat" 

-- NIST P-192 test
--        weierstrass_prime_size : integer := 12;
--        weierstrass_scalar_size : integer := 192;
--        weierstrass_load_memory_base_address_n : integer := 0;
--        weierstrass_load_memory_base_address_n_line : integer := 12;
--        weierstrass_load_memory_base_address_r2 : integer := 13;
--        weierstrass_load_memory_base_address_curve_constant_0 : integer := 25;
--        weierstrass_load_memory_base_address_curve_constant_0_in_r2 : integer := 37;
--        weierstrass_load_memory_base_address_curve_constant_1 : integer := 49;
--        weierstrass_load_memory_base_address_curve_constant_1_in_r2 : integer := 61;
--        weierstrass_load_memory_base_address_scalar_number : integer := 73;
--        weierstrass_load_memory_base_address_point_coordinate_0 : integer := 85;
--        weierstrass_load_memory_base_address_point_coordinate_0_in_r2 : integer := 97;
--        weierstrass_load_memory_base_address_point_coordinate_1 : integer := 109;
--        weierstrass_load_memory_base_address_point_coordinate_1_in_r2 : integer := 121;
--        weierstrass_load_memory_base_address_point_coordinate_2 : integer := 133;
--        weierstrass_load_memory_base_address_point_coordinate_2_in_r2 : integer := 145;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0 : integer := 157;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 : integer := 169;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1 : integer := 181;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1_in_r2 : integer := 193;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2 : integer := 205;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2_in_r2 : integer := 217;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 : integer := 229;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 : integer := 241;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1 : integer := 253;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1_in_r2 : integer := 265;        
--        
--        weierstrass_processor_load_file_name : string := "ecc_tests/weierstrass_processor_NIST_P192_test.dat"

-- NIST P-224 test
--        weierstrass_prime_size : integer := 14;
--        weierstrass_scalar_size : integer := 224;
--        weierstrass_load_memory_base_address_n : integer := 0;
--        weierstrass_load_memory_base_address_n_line : integer := 14;
--        weierstrass_load_memory_base_address_r2 : integer := 15;
--        weierstrass_load_memory_base_address_curve_constant_0 : integer := 29;
--        weierstrass_load_memory_base_address_curve_constant_0_in_r2 : integer := 43;
--        weierstrass_load_memory_base_address_curve_constant_1 : integer := 57;
--        weierstrass_load_memory_base_address_curve_constant_1_in_r2 : integer := 71;
--        weierstrass_load_memory_base_address_scalar_number : integer := 85;
--        weierstrass_load_memory_base_address_point_coordinate_0 : integer := 99;
--        weierstrass_load_memory_base_address_point_coordinate_0_in_r2 : integer := 113;
--        weierstrass_load_memory_base_address_point_coordinate_1 : integer := 127;
--        weierstrass_load_memory_base_address_point_coordinate_1_in_r2 : integer := 141;
--        weierstrass_load_memory_base_address_point_coordinate_2 : integer := 155;
--        weierstrass_load_memory_base_address_point_coordinate_2_in_r2 : integer := 169;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0 : integer := 183;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 : integer := 197;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1 : integer := 211;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1_in_r2 : integer := 225;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2 : integer := 239;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2_in_r2 : integer := 253;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 : integer := 267;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 : integer := 281;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1 : integer := 295;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1_in_r2 : integer := 309;            
--        
--        weierstrass_processor_load_file_name : string := "ecc_tests/weierstrass_processor_NIST_P224_test.dat"   

-- NIST P-256 test
--        weierstrass_prime_size : integer := 16;
--        weierstrass_scalar_size : integer := 256;
--        weierstrass_load_memory_base_address_n : integer := 0;
--        weierstrass_load_memory_base_address_n_line : integer := 16;
--        weierstrass_load_memory_base_address_r2 : integer := 17;
--        weierstrass_load_memory_base_address_curve_constant_0 : integer := 33;
--        weierstrass_load_memory_base_address_curve_constant_0_in_r2 : integer := 49;
--        weierstrass_load_memory_base_address_curve_constant_1 : integer := 65;
--        weierstrass_load_memory_base_address_curve_constant_1_in_r2 : integer := 81;
--        weierstrass_load_memory_base_address_scalar_number : integer := 97;
--        weierstrass_load_memory_base_address_point_coordinate_0 : integer := 113;
--        weierstrass_load_memory_base_address_point_coordinate_0_in_r2 : integer := 129;
--        weierstrass_load_memory_base_address_point_coordinate_1 : integer := 145;
--        weierstrass_load_memory_base_address_point_coordinate_1_in_r2 : integer := 161;
--        weierstrass_load_memory_base_address_point_coordinate_2 : integer := 177;
--        weierstrass_load_memory_base_address_point_coordinate_2_in_r2 : integer := 193;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0 : integer := 209;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 : integer := 225;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1 : integer := 241;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1_in_r2 : integer := 257;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2 : integer := 273;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2_in_r2 : integer := 289;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 : integer := 305;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 : integer := 321;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1 : integer := 337;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1_in_r2 : integer := 353;          
--        
--        weierstrass_processor_load_file_name : string := "ecc_tests/weierstrass_processor_NIST_P256_test.dat"

-- NIST P-384 test
--        weierstrass_prime_size : integer := 23;
--        weierstrass_scalar_size : integer := 384;
--        weierstrass_load_memory_base_address_n : integer := 0;
--        weierstrass_load_memory_base_address_n_line : integer := 23;
--        weierstrass_load_memory_base_address_r2 : integer := 24;
--        weierstrass_load_memory_base_address_curve_constant_0 : integer := 47;
--        weierstrass_load_memory_base_address_curve_constant_0_in_r2 : integer := 70;
--        weierstrass_load_memory_base_address_curve_constant_1 : integer := 93;
--        weierstrass_load_memory_base_address_curve_constant_1_in_r2 : integer := 116;
--        weierstrass_load_memory_base_address_scalar_number : integer := 139;
--        weierstrass_load_memory_base_address_point_coordinate_0 : integer := 162;
--        weierstrass_load_memory_base_address_point_coordinate_0_in_r2 : integer := 185;
--        weierstrass_load_memory_base_address_point_coordinate_1 : integer := 208;
--        weierstrass_load_memory_base_address_point_coordinate_1_in_r2 : integer := 231;
--        weierstrass_load_memory_base_address_point_coordinate_2 : integer := 254;
--        weierstrass_load_memory_base_address_point_coordinate_2_in_r2 : integer := 277;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0 : integer := 300;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 : integer := 323;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1 : integer := 346;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_1_in_r2 : integer := 369;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2 : integer := 392;
--        weierstrass_load_memory_base_address_scalar_point_coordinate_2_in_r2 : integer := 415;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 : integer := 438;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 : integer := 461;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1 : integer := 484;
--        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1_in_r2 : integer := 507;         
--        
--        weierstrass_processor_load_file_name : string := "ecc_tests/weierstrass_processor_NIST_P384_test.dat"

-- NIST P-521 test
        weierstrass_prime_size : integer := 31;
        weierstrass_scalar_size : integer := 521;
        weierstrass_load_memory_base_address_n : integer := 0;
        weierstrass_load_memory_base_address_n_line : integer := 31;
        weierstrass_load_memory_base_address_r2 : integer := 32;
        weierstrass_load_memory_base_address_curve_constant_0 : integer := 63;
        weierstrass_load_memory_base_address_curve_constant_0_in_r2 : integer := 94;
        weierstrass_load_memory_base_address_curve_constant_1 : integer := 125;
        weierstrass_load_memory_base_address_curve_constant_1_in_r2 : integer := 156;
        weierstrass_load_memory_base_address_scalar_number : integer := 187;
        weierstrass_load_memory_base_address_point_coordinate_0 : integer := 218;
        weierstrass_load_memory_base_address_point_coordinate_0_in_r2 : integer := 249;
        weierstrass_load_memory_base_address_point_coordinate_1 : integer := 280;
        weierstrass_load_memory_base_address_point_coordinate_1_in_r2 : integer := 311;
        weierstrass_load_memory_base_address_point_coordinate_2 : integer := 342;
        weierstrass_load_memory_base_address_point_coordinate_2_in_r2 : integer := 373;
        weierstrass_load_memory_base_address_scalar_point_coordinate_0 : integer := 404;
        weierstrass_load_memory_base_address_scalar_point_coordinate_0_in_r2 : integer := 435;
        weierstrass_load_memory_base_address_scalar_point_coordinate_1 : integer := 466;
        weierstrass_load_memory_base_address_scalar_point_coordinate_1_in_r2 : integer := 497;
        weierstrass_load_memory_base_address_scalar_point_coordinate_2 : integer := 528;
        weierstrass_load_memory_base_address_scalar_point_coordinate_2_in_r2 : integer := 559;
        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0 : integer := 590;
        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0_in_r2 : integer := 621;
        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1 : integer := 652;
        weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1_in_r2 : integer := 683;            
        
        weierstrass_processor_load_file_name : string := "ecc_tests/weierstrass_processor_NIST_P521_test.dat"   
    );
end tb_small_weierstrass_processor;

architecture Behavioral of tb_small_weierstrass_processor is

component small_weierstrass_processor_2
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
end component;

component ram
    Generic (
        ram_address_size : integer;
        ram_word_size : integer;
        file_ram_word_size : integer;
        load_file_name : string := "ram.dat";
        dump_file_name : string := "ram.dat"
    );
    Port (
        data_in : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        rw : in STD_LOGIC;
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        dump : in STD_LOGIC; 
        address : in STD_LOGIC_VECTOR ((ram_address_size - 1) downto 0);
        rst_value : in STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0);
        data_out : out STD_LOGIC_VECTOR ((ram_word_size - 1) downto 0)
    );
end component;

signal clk : STD_LOGIC := '0';
signal rst : STD_LOGIC;
signal test_bench_finish : boolean := false;
signal test_error : STD_LOGIC := '0'; 
signal cycle_count : integer range 0 to 2000000000 := 0;

constant tb_delay : time := (2*PERIOD/4);

signal weierstrass_processor_start : STD_LOGIC;
signal weierstrass_processor_prime_size : STD_LOGIC_VECTOR((weierstrass_processor_montgomery_multiplier_memory_size - 3) downto 0);
signal weierstrass_processor_scalar_size : STD_LOGIC_VECTOR((weierstrass_processor_scalar_max_size - 1) downto 0);
signal weierstrass_processor_write_value : STD_LOGIC_VECTOR((weierstrass_processor_word_length - 1) downto 0);
signal weierstrass_processor_address_value : STD_LOGIC_VECTOR((weierstrass_processor_internal_memory_size - 1) downto 0);
signal weierstrass_processor_write_enable_value : STD_LOGIC;
signal weierstrass_processor_processor_free : STD_LOGIC;
signal weierstrass_processor_finish_pre_processing : STD_LOGIC;
signal weierstrass_processor_finish_point_addition : STD_LOGIC;
signal weierstrass_processor_finish_scalar_multiplication : STD_LOGIC;
signal weierstrass_processor_finish_final_processing : STD_LOGIC;
signal weierstrass_processor_read_value : STD_LOGIC_VECTOR((weierstrass_processor_word_length - 1) downto 0);

signal load_values_data_in : STD_LOGIC_VECTOR ((weierstrass_processor_word_length - 1) downto 0);
signal load_values_address : STD_LOGIC_VECTOR ((load_memory_size - 1) downto 0);
constant load_values_rst_value : STD_LOGIC_VECTOR ((weierstrass_processor_word_length - 1) downto 0) := std_logic_vector(to_unsigned(0, weierstrass_processor_word_length));
signal load_values_data_out : STD_LOGIC_VECTOR ((weierstrass_processor_word_length - 1) downto 0);


procedure load_weierstrass_processor(
    weierstrass_load_memory_base_address : in integer;
    weierstrass_processor_internal_memory_base_address : in integer;
    load_operand_size : in integer;
    signal load_memory_address : out STD_LOGIC_VECTOR((load_memory_size - 1) downto 0);
    signal weierstrass_processor_internal_memory_address : out STD_LOGIC_VECTOR((weierstrass_processor_internal_memory_size - 1) downto 0);
    signal weierstrass_processor_internal_memory_write_enable : out STD_LOGIC) is
    variable j : integer;
begin
    load_memory_address <= std_logic_vector(to_unsigned(weierstrass_load_memory_base_address + 0, load_memory_size));
    wait for PERIOD;
    load_memory_address <= std_logic_vector(to_unsigned(weierstrass_load_memory_base_address + 1, load_memory_size));
    wait for PERIOD;
    j := 0;
    while (j < (load_operand_size - 2)) loop
        load_memory_address <= std_logic_vector(to_unsigned(weierstrass_load_memory_base_address + (j+2), load_memory_size));
        weierstrass_processor_internal_memory_address <= std_logic_vector(to_unsigned(weierstrass_processor_internal_memory_base_address, 5)) & std_logic_vector(to_unsigned(j, weierstrass_processor_internal_memory_size - 5));
        weierstrass_processor_internal_memory_write_enable <= '1';
        wait for PERIOD;
        j := j + 1;
    end loop;
    weierstrass_processor_internal_memory_address <= std_logic_vector(to_unsigned(weierstrass_processor_internal_memory_base_address, 5)) & std_logic_vector(to_unsigned(j, weierstrass_processor_internal_memory_size - 5));
    weierstrass_processor_internal_memory_write_enable <= '1';
    j := j + 1;
    wait for PERIOD;
    weierstrass_processor_internal_memory_address <= std_logic_vector(to_unsigned(weierstrass_processor_internal_memory_base_address, 5)) & std_logic_vector(to_unsigned(j, weierstrass_processor_internal_memory_size - 5));
    weierstrass_processor_internal_memory_write_enable <= '1';
    wait for PERIOD;
    weierstrass_processor_internal_memory_write_enable <= '0';
    wait for PERIOD;
end load_weierstrass_processor;

procedure verify_weierstrass_processor_memory_value(
    weierstrass_load_memory_base_address : in integer;
    weierstrass_processor_internal_memory_base_address : in integer;
    load_operand_size : in integer;
    signal load_memory_value : in STD_LOGIC_VECTOR((weierstrass_processor_word_length - 1) downto 0);
    signal weierstrass_memory_value : in STD_LOGIC_VECTOR((weierstrass_processor_word_length - 1) downto 0);
    error_message : in string;
    success_message : in string;
    signal load_memory_address : out STD_LOGIC_VECTOR((load_memory_size - 1) downto 0);
    signal weierstrass_processor_internal_memory_address : out STD_LOGIC_VECTOR((weierstrass_processor_internal_memory_size - 1) downto 0);
    signal weierstrass_processor_internal_memory_write_enable : out STD_LOGIC;
    signal test_error : out STD_LOGIC) is
    variable j : integer;
    variable all_values_match : boolean;
begin
    weierstrass_processor_internal_memory_write_enable <= '0';
    wait for PERIOD;
    j := 0;
    all_values_match := true;
    while (j < (load_operand_size)) loop
        load_memory_address <= std_logic_vector(to_unsigned(weierstrass_load_memory_base_address + j, load_memory_size));
        weierstrass_processor_internal_memory_address <= std_logic_vector(to_unsigned(weierstrass_processor_internal_memory_base_address, 5)) & std_logic_vector(to_unsigned(j, weierstrass_processor_internal_memory_size - 5));   
        wait for PERIOD*3;
        if(load_memory_value = weierstrass_memory_value) then
            test_error <= '0';
        else
            report error_message & "   Error at position " & integer'image(j);
            test_error <= '1';
            all_values_match := false;
        end if;
        wait for PERIOD;
        test_error <= '0';
        wait for PERIOD;
        j := j + 1;
    end loop;   
    if(all_values_match) then
        report success_message;
    end if;
end verify_weierstrass_processor_memory_value;



begin

clock : process
begin
while (not test_bench_finish) loop
    clk <= not clk;
    wait for PERIOD/2;
    clk <= not clk;
    wait for PERIOD/2;
    cycle_count <= cycle_count+1;
end loop;
wait;
end process;

weierstrass_processor : small_weierstrass_processor_2
    Generic Map(
        internal_memory_size => weierstrass_processor_internal_memory_size,
        scalar_max_size => weierstrass_processor_scalar_max_size,
        word_length => weierstrass_processor_word_length,
        word_length_size => weierstrass_processor_word_length_size,
        montgomery_multiplier_memory_size => weierstrass_processor_montgomery_multiplier_memory_size,
        montgomery_accumulation_word_length => weierstrass_processor_montgomery_accumulation_word_length
    )
    Port Map(
        rst => rst,
        clk => clk,
        start => weierstrass_processor_start,
        prime_size => weierstrass_processor_prime_size,
        scalar_size => weierstrass_processor_scalar_size,
        write_value => weierstrass_processor_write_value,
        address_value => weierstrass_processor_address_value,
        write_enable_value => weierstrass_processor_write_enable_value,
        processor_free => weierstrass_processor_processor_free,
        finish_pre_processing => weierstrass_processor_finish_pre_processing,
        finish_point_addition => weierstrass_processor_finish_point_addition,
        finish_scalar_multiplication => weierstrass_processor_finish_scalar_multiplication,
        finish_final_processing => weierstrass_processor_finish_final_processing,
        read_value => weierstrass_processor_read_value
    );
    

load_values : entity work.ram(file_load)
    Generic Map(
        ram_address_size => load_memory_size,
        ram_word_size => weierstrass_processor_word_length,
        file_ram_word_size => weierstrass_processor_word_length,
        load_file_name => weierstrass_processor_load_file_name,
        dump_file_name => ""
    )
    Port Map(
        data_in => load_values_data_in,
        rw => '0',
        clk => clk,
        rst => rst,
        dump => '0',
        address => load_values_address,
        rst_value => load_values_rst_value,
        data_out => load_values_data_out
    );
    




load_values_data_in <= (others => '0');

weierstrass_processor_prime_size <= std_logic_vector(to_unsigned(weierstrass_prime_size - 1, weierstrass_processor_montgomery_multiplier_memory_size - 2));
weierstrass_processor_scalar_size <= std_logic_vector(to_unsigned(weierstrass_scalar_size - 1, weierstrass_processor_scalar_max_size));
weierstrass_processor_write_value <= load_values_data_out after tb_delay;


process
    variable i : integer;
    variable loading_cycle_count : integer range 0 to 2000000000 := 0;
    variable start_pre_processing_cycle_count : integer range 0 to 2000000000 := 0;
    variable pre_processing_cycle_count : integer range 0 to 2000000000 := 0;
    variable start_point_addition_cycle_count : integer range 0 to 2000000000 := 0;
    variable point_addition_cycle_count : integer range 0 to 2000000000 := 0;
    variable start_scalar_multiplication_cycle_count : integer range 0 to 2000000000 := 0;
    variable scalar_multiplication_cycle_count : integer range 0 to 2000000000 := 0;
    variable start_final_processing_cycle_count : integer range 0 to 2000000000 := 0;
    variable final_processing_cycle_count : integer range 0 to 2000000000 := 0;
    begin
-- Reset stage      
        rst <= '0';
        test_error <= '0';
        weierstrass_processor_start <= '0';
        weierstrass_processor_write_enable_value <= '0';
        load_values_address <= std_logic_vector(to_unsigned(0, load_memory_size));
        weierstrass_processor_address_value <= std_logic_vector(to_unsigned(0, weierstrass_processor_internal_memory_size));
        wait for tb_delay;
        wait for PERIOD;
        rst <= '1';
        wait until (weierstrass_processor_processor_free = '1' and rising_edge(clk));
        wait for tb_delay;
-- Load prime n and constant n'
        load_weierstrass_processor(weierstrass_load_memory_base_address_n, weierstrass_processor_internal_memory_base_address_n, weierstrass_prime_size + 1, load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value);
        wait for PERIOD;
-- Load prime r2
        load_weierstrass_processor(weierstrass_load_memory_base_address_r2, weierstrass_processor_internal_memory_base_address_r2, weierstrass_prime_size, load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value);
        wait for PERIOD;
-- Load Weierstrass Short Curve parameter a
        load_weierstrass_processor(weierstrass_load_memory_base_address_curve_constant_0, weierstrass_processor_internal_memory_base_address_a, weierstrass_prime_size, load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value);
        wait for PERIOD;
-- Load Weierstrass Short Curve parameter b
        load_weierstrass_processor(weierstrass_load_memory_base_address_curve_constant_1, weierstrass_processor_internal_memory_base_address_b, weierstrass_prime_size, load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value);
        wait for PERIOD;
-- Load Public Curve Base Point coordinate x
        load_weierstrass_processor(weierstrass_load_memory_base_address_point_coordinate_0, weierstrass_processor_internal_memory_base_address_Px, weierstrass_prime_size, load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value);
        wait for PERIOD;
-- Load Public Curve Base Point coordinate y
        load_weierstrass_processor(weierstrass_load_memory_base_address_point_coordinate_1, weierstrass_processor_internal_memory_base_address_Py, weierstrass_prime_size, load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value);
        wait for PERIOD;
-- Load Public Curve Base Point coordinate z
        load_weierstrass_processor(weierstrass_load_memory_base_address_point_coordinate_2, weierstrass_processor_internal_memory_base_address_Pz, weierstrass_prime_size, load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value);
        wait for PERIOD;
-- Load Private scalar
        load_weierstrass_processor(weierstrass_load_memory_base_address_scalar_number, weierstrass_processor_internal_memory_base_address_scalar, weierstrass_prime_size, load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value);
        wait for PERIOD;
-- Start processor
        weierstrass_processor_start <= '1';
        loading_cycle_count := cycle_count;
        wait for PERIOD;
        weierstrass_processor_start <= '0';
        wait until (weierstrass_processor_finish_pre_processing = '0' and rising_edge(clk));
        start_pre_processing_cycle_count := cycle_count;
        wait for PERIOD;
        wait until (weierstrass_processor_finish_pre_processing = '1' and rising_edge(clk));
        pre_processing_cycle_count := cycle_count - start_pre_processing_cycle_count;
        report "Pre Processing time = " & integer'image(pre_processing_cycle_count) & " cycles";
        report "Pre Processing time = " & time'image(PERIOD*(pre_processing_cycle_count));
        wait until (weierstrass_processor_finish_scalar_multiplication = '0' and rising_edge(clk));
        start_scalar_multiplication_cycle_count := cycle_count;
        wait until (weierstrass_processor_finish_point_addition = '0' and rising_edge(clk));
        start_point_addition_cycle_count := cycle_count;
        wait for PERIOD;
        wait until (weierstrass_processor_finish_point_addition = '1' and rising_edge(clk));
        point_addition_cycle_count := cycle_count - start_point_addition_cycle_count;
        report "Point addition time = " & integer'image(point_addition_cycle_count) & " cycles";
        report "Point addition time = " & time'image(PERIOD*(point_addition_cycle_count));
        wait for PERIOD;
        wait until (weierstrass_processor_finish_scalar_multiplication = '1' and rising_edge(clk));
        scalar_multiplication_cycle_count := cycle_count - start_scalar_multiplication_cycle_count;
        report "Scalar multiplication time = " & integer'image(scalar_multiplication_cycle_count) & " cycles";
        report "Scalar multiplication time = " & time'image(PERIOD*(scalar_multiplication_cycle_count));
        wait until (weierstrass_processor_finish_final_processing = '0' and rising_edge(clk));
        start_final_processing_cycle_count := cycle_count;
        wait for PERIOD;
        wait until (weierstrass_processor_finish_final_processing = '1' and rising_edge(clk));
        final_processing_cycle_count := cycle_count - start_final_processing_cycle_count;
        report "Final Processing time = " & integer'image(final_processing_cycle_count) & " cycles";
        report "Final Processing time = " & time'image(PERIOD*(final_processing_cycle_count));
        
        wait until (weierstrass_processor_processor_free = '1' and rising_edge(clk));
        wait for tb_delay;  
-- Verify loaded values prime n and n'
        verify_weierstrass_processor_memory_value(weierstrass_load_memory_base_address_n, weierstrass_processor_internal_memory_base_address_n, weierstrass_prime_size + 1, load_values_data_out, weierstrass_processor_read_value, "Loading of prime n and constant n' went wrong", "Loading of prime n and constant n' went okay", load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value, test_error);
        wait for PERIOD;        
-- Verify ar2
        verify_weierstrass_processor_memory_value(weierstrass_load_memory_base_address_curve_constant_0_in_r2, weierstrass_processor_internal_memory_base_address_a, weierstrass_prime_size, load_values_data_out, weierstrass_processor_read_value, "Computation of a*r2/r mod n does not match", "Computation of a*r2/r mod n went okay", load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value, test_error);
        wait for PERIOD;
-- Verify Private Curve Point coordinate x
        verify_weierstrass_processor_memory_value(weierstrass_load_memory_base_address_affine_scalar_point_coordinate_0, weierstrass_processor_internal_memory_base_address_sPx, weierstrass_prime_size, load_values_data_out, weierstrass_processor_read_value, "Computation of final Point x does not match", "Computation of final Point x went okay", load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value, test_error);
        wait for PERIOD;
-- Verify Private Curve Point coordinate y
        verify_weierstrass_processor_memory_value(weierstrass_load_memory_base_address_affine_scalar_point_coordinate_1, weierstrass_processor_internal_memory_base_address_sPy, weierstrass_prime_size, load_values_data_out, weierstrass_processor_read_value, "Computation of final Point y does not match", "Computation of final Point y went okay", load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value, test_error);
        wait for PERIOD;
-- Verify Private Curve Point coordinate z
--        verify_weierstrass_processor_memory_value(weierstrass_load_memory_base_address_scalar_point_coordinate_2, weierstrass_processor_internal_memory_base_address_sPz, weierstrass_prime_size, load_values_data_out, weierstrass_processor_read_value, "Computation of final Point z does not match", "Computation of final Point z went okay", load_values_address, weierstrass_processor_address_value, weierstrass_processor_write_enable_value, test_error);
        wait for PERIOD;
        test_bench_finish <= true;
        wait;
    end process;
end Behavioral;

