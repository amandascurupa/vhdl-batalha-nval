LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY batalha_naval IS
PORT (
	CLOCK: IN std_logic_vector(3 downto 0);
	entradas: IN std_logic_vector(9 downto 0);
    -- 0: vertical = 0 | horizontal = 1
    -- 1: navio1 = 0 | navio2 = 1
    -- 2, 3, 4, 5: Posicionamento do navio
    -- 6, 7, 8, 9: Código do tiro (codificado)
	ledr: out STD_LOGIC_VECTOR(9 downto 0); -- saída errada
	ledg: out STD_LOGIC_VECTOR(9 downto 0); -- saída correta
    Reset: IN std_logic
	);
END batalha_naval ;

-- ------------------------------- ARCHITECTURE ---------------------------------------
ARCHITECTURE Behavior OF batalha_naval IS
-- declaração de variáveis
TYPE Tipo_estado IS (ini, n1, n2, jogando, acerto1, acerto2, ganhou, perdeu);
    SIGNAL estado_atual : Tipo_estado := ini;
    SIGNAL contador : INTEGER := 0;
    SIGNAL navio1 : std_logic_vector(3 downto 0);
    SIGNAL navio2 : std_logic_vector(7 downto 0);

-- declaração da função
function salvarNavio(entradasNavio : std_logic_vector) return std_logic_vector IS
    variable auxiliar : std_logic_vector(3 downto 0);
BEGIN
    auxiliar(0) := entradasNavio(2);
    auxiliar(1) := entradasNavio(3);
    auxiliar(2) := entradasNavio(4);
    auxiliar(3) := entradasNavio(5);

    return auxiliar;
end salvarNavio;

function salvarNavio2(entradasNavio : std_logic_vector) return std_logic_vector IS
    variable auxiliar : std_logic_vector(7 downto 0);
BEGIN
    auxiliar(0) := entradasNavio(2);
    auxiliar(1) := entradasNavio(3);
    auxiliar(2) := entradasNavio(4);
    auxiliar(3) := entradasNavio(5);
    auxiliar(4) := entradasNavio(2);
    auxiliar(5) := entradasNavio(3);
    auxiliar(6) := entradasNavio(4);
    auxiliar(7) := entradasNavio(5);

    -- Se a posição for horizontal
    IF entradasNavio(0) = '1' THEN
        IF auxiliar(6) =  '0' THEN
            auxiliar(6) := '1';
        END IF;
        IF auxiliar(7) = '1' THEN
            auxiliar(7) := '1';
        END IF;
    ELSIF entradasNavio(0) = '0' THEN
        IF auxiliar(6) =  '0' THEN
        auxiliar(6) := '1';
        END IF;
        IF auxiliar(7) = '1' THEN
            auxiliar(7) := '1';
        END IF;
    END IF;
    return auxiliar;
END salvarNavio2;

function processaDisparo(disparo : std_logic_vector; pos_navio1 : std_logic_vector; pos_navio2 : std_logic_vector) return std_logic IS
BEGIN
    IF disparo(9 downto 6) = pos_navio1 or disparo(9 downto 6) = pos_navio2(3 downto 0) or disparo(9 downto 6) = pos_navio2(7 downto 4) THEN
        CASE disparo IS
            WHEN "0000" => disparo <= "0010";
            WHEN "0001" => disparo <= "1111";
            WHEN "0010" => disparo <= "1011";
            WHEN "0011" => disparo <= "0110";
            WHEN "0100" => disparo <= "1001";
            WHEN "0101" => disparo <= "0111";
            WHEN "0110" => disparo <= "0101";
            WHEN "0111" => disparo <= "1000";
            WHEN "1000" => disparo <= "0000";
            WHEN "1001" => disparo <= "0001";
            WHEN "1010" => disparo <= "0100";
            WHEN "1011" => disparo <= "0011";
            WHEN "1100" => disparo <= "1101";
            WHEN "1101" => disparo <= "1110";
            WHEN "1110" => disparo <= "1010";
            WHEN "1111" => disparo <= "1100";
            WHEN OTHERS => NULL; 
        END CASE;
        return '1'; -- Acertou
    ELSE 
        return '0'; -- Errou
    END if;
END processaDisparo;

BEGIN
    PROCESS ( CLOCK(0), entradas, ledr, ledg )
    BEGIN
        IF Reset = '1' THEN
            ledr(0) <= '0';
            ledg(0) <= '0';
	        estado_atual <= ini;
            contador <= 0;
        ELSIF CLOCK(0)'EVENT AND CLOCK(0) = '1' THEN
            CASE estado_atual IS
            WHEN ini =>
                ledr(0) <= '0';
                ledg(0) <= '0';
                estado_atual <= n1;
            WHEN n1 =>
                IF entradas(1) = '0' THEN
                    navio1 <= salvarNavio(entradas);
                ELSIF entradas(1) = '1' THEN
                    navio2 <= salvarNavio(entradas);
                END IF;
                estado_atual <= n2;
            WHEN n2 =>
                IF entradas(1) = '0' THEN
                    navio1 <= salvarNavio(entradas);
                ELSIF entradas(1) = '1' THEN
                    navio2 <= salvarNavio(entradas);
                END IF;
                estado_atual <= n2;
            WHEN jogando =>
                contador <= contador + 1;
                IF (processaDisparo(entradas, navio1, navio2)) = '1' THEN
                    estado_atual <= acerto1;
                END if;
            WHEN acerto1 =>
                contador <= contador + 1;
                IF (processaDisparo(entradas, navio1, navio2)) THEN
                    estado_atual <= acerto2;
                END if;
            WHEN acerto2 =>
                contador <= contador + 1;
                IF (processaDisparo(entradas, navio1, navio2)) THEN
                    estado_atual <= ganhou;
                END if;
            WHEN ganhou =>
                ledr(0) <= '0';
                ledg(0) <= '1';
                contador <= 0;
            WHEN perdeu =>
                ledr(0) <= '1';
                ledg(0) <= '0';
                contador <= 0;
            END CASE;
        END IF;
    END PROCESS;
end Behavior;
