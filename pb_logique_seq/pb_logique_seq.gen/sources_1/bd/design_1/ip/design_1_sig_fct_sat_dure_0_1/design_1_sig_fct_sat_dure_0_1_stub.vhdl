-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Sat Jan 27 20:58:50 2024
-- Host        : MSI running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               d:/Gabriel/Documents/Universite/S4/APP2/pb_logique_seq/pb_logique_seq.gen/sources_1/bd/design_1/ip/design_1_sig_fct_sat_dure_0_1/design_1_sig_fct_sat_dure_0_1_stub.vhdl
-- Design      : design_1_sig_fct_sat_dure_0_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z010clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_sig_fct_sat_dure_0_1 is
  Port ( 
    i_ech : in STD_LOGIC_VECTOR ( 23 downto 0 );
    o_ech_fct : out STD_LOGIC_VECTOR ( 23 downto 0 )
  );

end design_1_sig_fct_sat_dure_0_1;

architecture stub of design_1_sig_fct_sat_dure_0_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "i_ech[23:0],o_ech_fct[23:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "sig_fct_sat_dure,Vivado 2020.2";
begin
end;
