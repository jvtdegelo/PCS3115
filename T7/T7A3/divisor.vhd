library ieee;
use ieee.numeric_bit.rising_edge;

entity registrador_universal is
    generic (
        word_size: positive := 4
    );
    port (
        clock, clear, set, enable: in bit;
        control: in bit_vector(1 downto 0);
        serial_input: in bit;
        parallel_input: in bit_vector(word_size-1 downto 0);
        parallel_output: out bit_vector(word_size-1 downto 0)
    );
end entity;

architecture arch of registrador_universal is
    signal saida, prox_saida: bit_vector(word_size-1 downto 0);
begin
    process(clock, clear, set, enable)
    begin
        if clear = '1' then 
            saida <= (others => '0');
        elsif set = '1' then
            saida <= (others => '1');
        elsif rising_edge(clock) then
            if enable = '1' then
                saida <= prox_saida;
            end if;
        end if;
    end process;
    parallel_output <= saida;
    prox_saida <= 
        saida when control = "00" else
        serial_input & saida (word_size-1 downto 1) when control = "01" else
        saida (word_size-2 downto 0) & serial_input when control = "10" else 
        parallel_input when control = "11" else
        saida;
end arch;

--------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity uc is
    port (
        clock, reset, vai: in bit;
        pronto: out bit;
        fim : in bit;
        loadB, loadR, clearB, clearR, enableC, clearC: out bit
    );
end entity;
architecture arch_uc of uc is
    type st_t is (s0, s1, s2, s3, s4);
    signal ea, pe: st_t;
begin
    sincrono: process (clock, reset)
    begin
        if reset = '1' then
            ea <= s0;
        elsif rising_edge(clock) then
            ea <= pe;
        end if;
    end process; 

    pe <=
        s1 when ea = s0 and vai = '1' else
        s2 when ea = s1 else
        s3 when ea = s2 and fim = '0' else
        s4 when ea = s2 and fim = '1' else
        s2 when ea = s3 else
        s0 when ea = s4 else
        s0;

    pronto <= '1' when ea = s4 else '0';
    loadB <= '1' when ea = s1 else '0';
    clearR <= '1' when ea = s1 else '0';
    clearC <= '1' when ea = s1 else '0';
    enableC <= '1' when ea = s3 else '0';
    loadR <= '1' when ea = s3 else '0';
end architecture arch_uc;

---------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;
entity fd_AB is
    generic(
        word_size: positive
    );
    port (
        clock: in bit;
        loadB, loadR, clearB, clearR: in bit;
        A, B: in bit_vector(word_size-1 downto 0);
        resto: out bit_vector(word_size-1 downto 0);
        fim: out bit
    );
end entity;

architecture arch_fd_AB of fd_AB is
    component registrador_universal is
        generic (
            word_size: positive := 4
        );
        port (
            clock, clear, set, enable: in bit;
            control: in bit_vector(1 downto 0);
            serial_input: in bit;
            parallel_input: in bit_vector(word_size-1 downto 0);
            parallel_output: out bit_vector(word_size-1 downto 0)
        );
    end component;

    signal controlB, controlR : bit_vector(1 downto 0);
    signal numR, num_resto : natural;
    signal inR, outR, outB: bit_vector(word_size-1 downto 0);

begin
    controlB <= loadB & loadB;
    controlR <= loadR & loadR;
    regB : registrador_universal generic map(word_size => word_size)
                                 port map (clock => clock, clear => clearB, set => '0', enable => '1', control => controlB, serial_input => '0', parallel_input => B, parallel_output => outB);
    regR: registrador_universal generic map(word_size => word_size)
                                 port map (clock => clock, clear => clearR, set => '0', enable => '1', control => controlR, serial_input => '0', parallel_input => inR, parallel_output => outR);
    numR <= to_integer(unsigned(outR)) + to_integer(unsigned(outB));
    inR <= bit_vector(to_unsigned(numR, inR'length));
    num_resto <=to_integer(unsigned(A)) - to_integer(unsigned(outR));
    resto <= bit_vector(to_unsigned(num_resto, resto'length));
    fim <= '1' when num_resto < to_integer(unsigned(B)) else '0';

end architecture arch_fd_AB;

-----------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity fd_contador is
    generic(
        word_size: positive
    );
    port (
        clock: in bit;
        enableC, clearC: in bit;
        resultado: out bit_vector(word_size-1 downto 0)
    );
end entity;

architecture arch_fd_contador of fd_contador is
    signal num, prox : natural;
begin
    process (clock, enableC, clearC)
    begin
        if clearC = '1' then 
            num <= 0;
        elsif rising_edge(clock) then
            if enableC = '1' then
                num <= prox;
            end if;
        end if;
    end process;
    prox <= num + 1;
    resultado <= bit_vector(to_unsigned(num, resultado'length));
end architecture arch_fd_contador;

-------------------------------------------------------

library ieee;
use ieee.numeric_bit.all;

entity divisor is
    generic(
        word_size: positive
    );
    port (
        clock, reset, vai: in bit;
        pronto: out bit;
        A, B: in bit_vector(word_size-1 downto 0);
        resultado, resto: out bit_vector(word_size-1 downto 0)
    );
end entity;
architecture arch of divisor is 
    component uc is
        port (
            clock, reset, vai: in bit;
            pronto: out bit;
            fim : in bit;
            loadB, loadR, clearB, clearR, enableC, clearC: out bit
        );
    end component;
    component fd_AB is
        generic(
            word_size: positive
        );
        port (
            clock: in bit;
            loadB, loadR, clearB, clearR: in bit;
            A, B: in bit_vector(word_size-1 downto 0);
            resto: out bit_vector(word_size-1 downto 0);
            fim: out bit
        );
    end component;
    component fd_contador is
        generic(
            word_size: positive
        );
        port (
            clock: in bit;
            enableC, clearC: in bit;
            resultado: out bit_vector(word_size-1 downto 0)
        );
    end component;

    signal loadB, loadR, clearB, clearR, enableC, clearC, fim: bit;
begin
    fluxoAB: fd_AB generic map(word_size => word_size)
                   port map(clock => clock, loadB => loadB, loadR => loadR, clearB => clearB, clearR => clearR, A => A, B => B, resto => resto, fim => fim);

    fluxo_contador: fd_contador generic map(word_size=> word_size)
                                port map (clock => clock, enableC => enableC, clearC => clearC, resultado => resultado);

    unidade_de_controle: uc port map (clock => clock, reset => reset, vai => vai, pronto => pronto, fim => fim, loadB => loadB, loadR => loadR, clearB => clearB, clearR => clearR, enableC => enableC, clearC => clearC);
end architecture arch;