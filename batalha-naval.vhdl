LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY batalha_naval IS
PORT (
	CLOCK: IN std_logic_vector(3 downto 0);
	navio: IN std_logic_vector(9 downto 0);
    -- 0: vertical = 0 | horizontal = 1
    -- 1: navio1 = 0 | navio2 = 1
    -- 2, 3, 4, 5: Posicionamento do navio
    -- 6, 7, 8, 9: Código do tiro (códificado)
	ledr: out STD_LOGIC_VECTOR(9 downto 0); -- saída errada
	ledg: out STD_LOGIC_VECTOR(9 downto 0) -- saída correta
	);
END batalha_naval ;

-- ------------------------------- ARCHITECTURE ---------------------------------------
ARCHITECTURE Behavior OF batalha_naval IS
TYPE Tipo_estado IS (ini, n1, n2, jogando, acerto1, acerto2, ganhou, perdeu);
    SIGNAL estado_atual : Tipo_estado := ini;
    SIGNAL contador : INTEGER := 0;
BEGIN
    PROCESS ( CLOCK(0), navio, ledr, ledg, KEY(0) )
    BEGIN
        
    END PROCESS;
end Behavior;
