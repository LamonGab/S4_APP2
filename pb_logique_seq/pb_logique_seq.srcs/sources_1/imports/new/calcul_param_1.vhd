
---------------------------------------------------------------------------------------------
--    calcul_param_1.vhd
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
entity calcul_param_1 is
    Port (
    i_bclk    : in   std_logic; -- bit clock (I2S)
    i_reset   : in   std_logic;
    i_en      : in   std_logic; -- un echantillon present a l'entrée
    i_ech     : in   std_logic_vector (23 downto 0); -- echantillon en entrée
    o_param   : out  std_logic_vector (7 downto 0)   -- paramètre calculé
    );
end calcul_param_1;

----------------------------------------------------------------------------------

architecture Behavioral of calcul_param_1 is

---------------------------------------------------------------------------------
-- Signaux
----------------------------------------------------------------------------------
    type State_type is (INIT, COMPTEUR, VERIF, TIMES_TWO);
    signal Sreg, Snext : State_type;
    signal temp_param : std_logic_vector (6 downto 0) := "0000000";
    
    signal reset_compteur : std_logic;
    signal compteur_en : std_logic;
    

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
    
    process (reset_compteur,compteur_en, i_bclk)
   begin
      if ( reset_compteur = '1') then
          temp_param <= (others =>'0');
      else
          if (compteur_en='1') then
              temp_param <= temp_param + 1;
          end if;
      end if;
   end process;
    
    process (Sreg, temp_param)
    begin
        case (Sreg) is
            when INIT =>
                reset_compteur <= '1';
                compteur_en <= '0';
            
            when COMPTEUR =>
                reset_compteur <= '0';
                compteur_en <= '1';
            
            when VERIF =>
                reset_compteur <= '0';
                compteur_en <= '0';
            
            when TIMES_TWO =>
                reset_compteur <= '0';
                compteur_en <= '0';
                o_param <= temp_param & "0";
            
            when others =>
                reset_compteur <= '1';
                compteur_en <= '0';
        end case;
    end process;
    
    process (Sreg, i_ech, i_en)
    begin
        case (Sreg) is
            when INIT =>
                if (i_en = '1' and i_ech(23) = '0') then
                    Snext <= COMPTEUR;
                else
                    Snext <= INIT;
                end if;
            
            when COMPTEUR =>
                if (i_ech(23) = '1') then
                    Snext <= VERIF;
                else
                    Snext <= COMPTEUR;
                end if;
            
            when VERIF =>
                if (temp_param = "0000011" or temp_param = "0000010" or temp_param = "0000001" or temp_param = "0000000") then
                    Snext <= INIT;
                else
                    Snext <= TIMES_TWO;
                end if;
            
            when TIMES_TWO =>
                Snext <= INIT;
            
            when others =>
                Snext <= INIT;
        end case;
    end process;
    
     --o_param <= x"01";    -- temporaire ...
end Behavioral;
