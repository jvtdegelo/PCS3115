library ieee;
use ieee.numeric_bit.all;

entity fd_A_tb is
end entity;

architecture test of fd_A_tb is
    component fd_A is
        generic(
            word_size: positive
        );
        port (
            clock: in bit;
            loadA, loadR, clearA, clearR: in bit;
            A: in bit_vector(word_size-1 downto 0);
            resultado: out bit_vector(2*word_size-1 downto 0)
        );
    end component;

    constant pc : time := 10 ns;
    signal clock, loadA, loadR, clearA, clearR, simula: bit;
    signal A: bit_vector(3 downto 0);
    signal resultado: bit_vector (7 downto 0);
begin
    dut: fd_A generic map (word_size => 4)
              port map (clock => clock, loadA=> loadA, loadR=> loadR, clearA => clearA, clearR => clearR, A=> A, resultado => resultado);

    clock <= (simula and not clock) after pc/2;

    process
    begin
        report "BOT";
        simula <= '1';
        A <= "0110";
        loadA <= '1';
        clearR <= '1'; 
        wait until rising_edge(clock);
        clearR <= '0';
        assert resultado = "00000000" report "Nao ta com zero";

        loadR <= '1';
        wait until rising_edge(clock);
        wait for pc/2;
        assert resultado = "00000110" report "passo 1";

        wait until rising_edge(clock);
        wait for pc/2;
        assert resultado = "00010010" report "passo 2";

        wait until rising_edge(clock);
        wait for pc/2;
        assert resultado = "00010010" report "passo 3";


        simula <= '0';
        report "EOT";
        wait;
    end process;
end architecture test;
