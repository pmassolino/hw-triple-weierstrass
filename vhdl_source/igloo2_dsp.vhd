----------------------------------------------------------------------------------
-- Engineer: Pedro Maat C. Massolino
-- 
-- Create Date:    11/11/2016
-- Design Name:    Generic_dsp
-- Module Name:    igloo2_dsp
-- Project Name:   Essentials
-- Target Devices: IGLOO2/Smart Fusion 2
-- Tool versions:  Microsemi Libero 11.7
--
-- Description: 
--
-- This circuit is the DIRECT mapping of the generic_dsp into the igloo2 DSP.
-- It is strictly possible to use the generic_dsp in the Microsemi tool, but
-- the generated circuit will be bigger than the direct mapping. 
--
--
-- Dependencies:
-- VHDL-93
-- IEEE.NUMERIC_STD.ALL;
-- SMARTFUSION2.ALL;
--
-- Revision: 
-- Revision 1.0
-- Additional Comments: 
--
----------------------------------------------------------------------------------


library smartfusion2;
use smartfusion2.all;

architecture IGLOO2 of generic_dsp is

 component MACC
    port( 
          CLK               : in    std_logic_vector(1 downto 0) := (others => 'U');
          A                 : in    std_logic_vector(17 downto 0) := (others => 'U');
          A_EN              : in    std_logic_vector(1 downto 0) := (others => 'U');
          A_ARST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          A_SRST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          B                 : in    std_logic_vector(17 downto 0) := (others => 'U');
          B_EN              : in    std_logic_vector(1 downto 0) := (others => 'U');
          B_ARST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          B_SRST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          C                 : in    std_logic_vector(43 downto 0) := (others => 'U');
          C_EN              : in    std_logic_vector(1 downto 0) := (others => 'U');
          C_ARST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          C_SRST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          P_EN              : in    std_logic_vector(1 downto 0) := (others => 'U');
          P_ARST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          P_SRST_N          : in    std_logic_vector(1 downto 0) := (others => 'U');
          FDBKSEL           : in    std_logic := 'U';
          FDBKSEL_EN        : in    std_logic := 'U';
          FDBKSEL_AL_N      : in    std_logic := 'U';
          FDBKSEL_SL_N      : in    std_logic := 'U';
          CDSEL             : in    std_logic := 'U';
          CDSEL_EN          : in    std_logic := 'U';
          CDSEL_AL_N        : in    std_logic := 'U';
          CDSEL_SL_N        : in    std_logic := 'U';
          ARSHFT17          : in    std_logic := 'U';
          ARSHFT17_EN       : in    std_logic := 'U';
          ARSHFT17_AL_N     : in    std_logic := 'U';
          ARSHFT17_SL_N     : in    std_logic := 'U';
          SUB               : in    std_logic := 'U';
          SUB_EN            : in    std_logic := 'U';
          SUB_AL_N          : in    std_logic := 'U';
          SUB_SL_N          : in    std_logic := 'U';
          CARRYIN           : in    std_logic := 'U';
          SIMD              : in    std_logic := 'U';
          DOTP              : in    std_logic := 'U';
          OVFL_CARRYOUT_SEL : in    std_logic := 'U';
          A_BYPASS          : in    std_logic_vector(1 downto 0) := (others => 'U');
          B_BYPASS          : in    std_logic_vector(1 downto 0) := (others => 'U');
          C_BYPASS          : in    std_logic_vector(1 downto 0) := (others => 'U');
          P_BYPASS          : in    std_logic_vector(1 downto 0) := (others => 'U');
          FDBKSEL_BYPASS    : in    std_logic := 'U';
          FDBKSEL_AD        : in    std_logic := 'U';
          FDBKSEL_SD_N      : in    std_logic := 'U';
          CDSEL_BYPASS      : in    std_logic := 'U';
          CDSEL_AD          : in    std_logic := 'U';
          CDSEL_SD_N        : in    std_logic := 'U';
          ARSHFT17_BYPASS   : in    std_logic := 'U';
          ARSHFT17_AD       : in    std_logic := 'U';
          ARSHFT17_SD_N     : in    std_logic := 'U';
          SUB_BYPASS        : in    std_logic := 'U';
          SUB_AD            : in    std_logic := 'U';
          SUB_SD_N          : in    std_logic := 'U';
          CDIN              : in    std_logic_vector(43 downto 0) := (others => 'U');
          CDOUT             : out   std_logic_vector(43 downto 0);
          P                 : out   std_logic_vector(43 downto 0);
          OVFL_CARRYOUT     : out   std_logic
        );
  end component;

begin

dsp : MACC
    port map( 
          CLK(0)  => clk,
		  CLK(1)  => clk,
          A(17) => '0',
          A(16 downto 0) => a,
          A_EN(0) => a_en,
          A_EN(1) => a_en,
          A_ARST_N(0) => '1',
          A_ARST_N(1) => '1',
          A_SRST_N(0) => a_rst,
	      A_SRST_N(1) => a_rst,
          B(17) => '0',
          B(16 downto 0) => b,
          B_EN(0) => b_en, 
          B_EN(1) => b_en, 
          B_ARST_N(0) => '1',
          B_ARST_N(1) => '1',
          B_SRST_N(0) => b_rst,
          B_SRST_N(1) => b_rst,
          C(43 downto 0) => c,
          C_EN(0) => c_en,
          C_EN(1) => c_en,
          C_ARST_N(0) => '1',
          C_ARST_N(1) => '1',
          C_SRST_N(0) => c_rst,
          C_SRST_N(1) => c_rst,
          P_EN(0) => p_en,
          P_EN(1) => p_en,
          P_ARST_N(0) => '1',
          P_ARST_N(1) => '1',
          P_SRST_N(0) => p_rst,
          P_SRST_N(1) => p_rst,
          FDBKSEL => accumulation_mode,
          FDBKSEL_EN => reg_accumulation_mode_ce,
          FDBKSEL_AL_N => '1',
          FDBKSEL_SL_N => reg_mode_rst,
          CDSEL => external_carry_in_mode,
          CDSEL_EN => reg_external_carry_in_mode_ce,
          CDSEL_AL_N => '1',
          CDSEL_SL_N => reg_mode_rst,
          ARSHFT17 => arshift_mode,
          ARSHFT17_EN => reg_arshift_mode_ce,
          ARSHFT17_AL_N => '1',
          ARSHFT17_SL_N => reg_mode_rst,
          SUB => add_sub_mode,
          SUB_EN => reg_add_sub_mode_ce,
          SUB_AL_N => '1',
          SUB_SL_N => reg_mode_rst,
          CARRYIN => '0',
          SIMD => '0',
          DOTP => '0',
          OVFL_CARRYOUT_SEL => '0',
          A_BYPASS(0) => a_bypass,
          A_BYPASS(1) => a_bypass,
          B_BYPASS(0) => b_bypass,
          B_BYPASS(1) => b_bypass,
          C_BYPASS(0) => c_bypass,
          C_BYPASS(1) => c_bypass,
          P_BYPASS(0) => '0',
          P_BYPASS(1) => '0',
          FDBKSEL_BYPASS => '0',
          FDBKSEL_AD => '0',
          FDBKSEL_SD_N => '0',
          CDSEL_BYPASS => '0',
          CDSEL_AD => '0',
          CDSEL_SD_N => '0',
          ARSHFT17_BYPASS => '0',
          ARSHFT17_AD => '0',
          ARSHFT17_SD_N => '0',
          SUB_BYPASS => '0',
          SUB_AD => '0',
          SUB_SD_N => '0',
          CDIN => external_carry_in,
          CDOUT => open,
          P => product,
          OVFL_CARRYOUT => open
        );
		  
end IGLOO2;