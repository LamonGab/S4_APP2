
---------------------------------------------------------------------------------------------
--    calcul_param_2.vhd   (temporaire)
---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------
--    Université de Sherbrooke - Département de GEGI
--
--    Version         : 5.0
--    Nomenclature    : inspiree de la nomenclature 0.2 GRAMS
--    Date            : 16 janvier 2020, 4 mai 2020
--    Auteur(s)       : 
--    Technologie     : ZYNQ 7000 Zybo Z7-10 (xc7z010clg400-1) 
--    Outils          : vivado 2019.1 64 bits
--
---------------------------------------------------------------------------------------------
--    Description (sur une carte Zybo)
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------
-- À FAIRE: 
-- Voir le guide de la problématique
---------------------------------------------------------------------------------------------
--
---------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- pour les additions dans les compteurs
USE ieee.numeric_std.ALL;
Library UNISIM;
use UNISIM.vcomponents.all;

----------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------
entity calcul_param_2 is
    Port (
    i_bclk    : in   std_logic;   -- bit clock
    i_reset   : in   std_logic;
    i_en      : in   std_logic;   -- un echantillon present
    i_ech     : in   std_logic_vector (23 downto 0);
    o_param   : out  std_logic_vector (7 downto 0)                                     
    );
end calcul_param_2;

----------------------------------------------------------------------------------

architecture Behavioral of calcul_param_2 is

---------------------------------------------------------------------------------
-- Signaux
----------------------------------------------------------------------------------
    type State_type is (INIT, SQUARE, CALCUL, RESULT);
    signal Sreg, Snext : State_type;
    signal x : std_logic_vector (47 downto 0) := (others => '0');
    signal y : std_logic_vector (47 downto 0) := (others => '0');
    signal a : std_logic_vector (52 downto 0) := (others => '0');

---------------------------------------------------------------------------------------------
--    Description comportementale
---------------------------------------------------------------------------------------------
begin
    -- Assignation du prochain état
    process(i_bclk, i_reset)
    begin
        if (i_reset ='1') then
            Sreg <= INIT;
        else
            if rising_edge(i_bclk) then
                  Sreg <= Snext;
            end if;
        end if;
    end process;
    
    process (Sreg, i_en, i_ech)
    begin
        case Sreg is
            when INIT =>
                if (i_en = '1') then
                    Snext <= SQUARE;
                else
                    Snext <= INIT;
                end if;
            
            when SQUARE =>
                Snext <= CALCUL;
            
            when CALCUL =>
                Snext <= RESULT;
            
            when RESULT =>
                if (i_en = '1' and i_en' event) then
                    Snext <= SQUARE;
                end if;
            when others =>
                Snext <= INIT;
        end case;
    end process;
    
    process (Sreg)
    begin
        case Sreg is
            when INIT =>
                x <= (others => '0');
                y <= (others => '0');
                a <= (others => '0');
                o_param <= (others => '0');
            
            when SQUARE =>
                x <= std_logic_vector(signed(i_ech) * signed(i_ech));
                a <= y * "11111";
            
            when CALCUL =>
                y <= x + a(52 downto 5);
            
            when RESULT =>
                o_param <= y(47 downto 40);
            
            when others =>
                x <= (others => '0');
                y <= (others => '0');
                a <= (others => '0');
                o_param <= (others => '0');
        end case;
    end process;

    --o_param <= x"02";    -- temporaire ...

end Behavioral;
