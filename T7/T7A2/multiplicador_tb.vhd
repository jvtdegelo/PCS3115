library ieee;
use ieee.numeric_bit.all;

entity multiplicador_tb is
end entity;

architecture test of multiplicador_tb is
    component multiplicador is
        generic(
            word_size: positive
        );
        port (
            clock, reset, vai: in bit;
            pronto: out bit;
            A, B: in bit_vector(word_size-1 downto 0);
            resultado: out bit_vector(2*word_size-1 downto 0)
        );
    end component;

    constant pc : time := 10 ns;
    signal clock, reset, vai, simula, pronto: bit;
    signal A, B: bit_vector (3 downto 0);
    signal resultado: bit_vector (7 downto 0);

begin 
    dut: multiplicador generic map (word_size => 4)
                       port map (clock => clock, reset => reset, vai => vai, pronto => pronto, A => A, B => B, resultado => resultado);
    clock <= (simula and not (clock)) after pc/2;
    process 
    begin
        simula <= '1';
        report "BOT";
        reset <= '1';
        wait for pc/2;
        assert pronto = '0' report "deu ruim no reset";
        reset <= '0';
        
        A <= "0110";
        B <= "0110";

        wait until rising_edge(clock);

        vai <= '1';
        wait for pc;
        vai <= '0';

        wait until pronto = '1'; 
        assert resultado = "00100100" report "deu ruim na mult"; 

        simula <= '0';
        report "EOT";
        wait;
    end process;
end architecture test;