library ieee;
use ieee.numeric_bit.all;

entity divisor_tb is
end entity;

architecture test of divisor_tb is
    component divisor is
        generic(
            word_size: positive
        );
        port (
            clock, reset, vai: in bit;
            pronto: out bit;
            A, B: in bit_vector(word_size-1 downto 0);
            resultado, resto: out bit_vector(word_size-1 downto 0)
        );
    end component;

    constant pc : time := 10 ns;
    signal clock, reset, vai, simula, pronto: bit;
    signal A, B: bit_vector (3 downto 0);
    signal resultado, resto: bit_vector (3 downto 0);
begin 
    dut: divisor generic map (word_size => 4)
                 port map (clock => clock, reset => reset, vai => vai, pronto => pronto, A => A, B => B, resultado => resultado, resto => resto);
    clock <= (simula and not(clock)) after pc/2;
    process
    begin
        simula <= '1';
        report "BOT";
        reset <= '1';
        wait for pc/2;
        assert pronto = '0' report "deu ruim no reset";
        reset <= '0';

        A <= "1111";
        B <= "0011";
        wait until rising_edge(clock);
        vai <= '1';
        wait for pc; 
        vai <= '0';
        wait until pronto = '1'; 
        assert resultado = "0101" report "deu ruim no quociente";
        assert resto = "0000" report "deu ruim no resto"; 


        simula <= '0';
        report "EOT";
        wait;
    end process;
end architecture test;     