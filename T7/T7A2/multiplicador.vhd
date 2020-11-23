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

entity fd_A is
    generic(
        word_size: positive
    );
    port (
        clock: in bit;
        loadA, loadR, clearA, clearR: in bit;
        A: in bit_vector(word_size-1 downto 0);
        resultado: out bit_vector(2*word_size-1 downto 0)
    );
end entity;

architecture arch_fd_A of fd_A is
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
    signal outA: bit_vector(word_size-1 downto 0);
    signal outR, inR: bit_vector(2*word_size-1 downto 0);
    signal controlA, controlR : bit_vector (1 downto 0);
    signal numR: natural;
begin
    controlA <= loadA & loadA;
    controlR <= loadR & loadR;
    regA: registrador_universal generic map(word_size => word_size)
                                port map (clock => clock, clear => clearA, set => '0', enable => '1', control => controlA, serial_input => '0', parallel_input => A, parallel_output => outA);
    regR: registrador_universal generic map(word_size => 2*word_size)
                                port map (clock => clock, clear => clearR, set => '0', enable => '1', control => controlR, serial_input => '0', parallel_input => inR, parallel_output => outR);
    numR <= to_integer(unsigned(outR)) + to_integer(unsigned(outA));

    inR <= bit_vector(to_unsigned(numR, inR'length));
    
    resultado <= outR;

end architecture arch_fd_A;
---------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity fd_B is
    generic(
        word_size: positive
    );
    port (
        clock, reset, enableB: in bit;
        B: in bit_vector(word_size-1 downto 0);
        zero: out bit
    );
end entity;

architecture arch_fd_B of fd_B is
    signal numB, proxB: natural;
begin
    process(clock, enableB, reset)
    begin 
        if reset = '1' then
            numB <= 0;
        elsif rising_edge(clock) then
            if enableB = '1' then
                numB <= proxB;
            end if;
        end if;
    end process;
    zero <= '1' when numB = to_integer(unsigned(B)) else '0';
    proxB <= numB + 1;
end architecture arch_fd_B;

--------------------------------------------------------------
library ieee;
use ieee.numeric_bit.rising_edge;

entity uc is
    port (
        clock, reset, vai: in bit;
        pronto: out bit;
        zero: in bit;
        loadA, loadR, clearA, clearR, enableB, resetB: out bit
    );
end entity;

architecture arch_uc of uc is 
    type st_t is (S0, S1, S2, S3, S4);
    signal ea, pe:  st_t;
begin
    sincrono: process(clock, reset)
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
        s3 when ea = s2 and zero = '0' else
        s2 when ea = s3 else
        s4 when ea = s2 and zero = '1' else 
        s0 when ea = s4 else
        s0;
        
    pronto <= '1' when ea = s4 else '0';
    loadA <= '1' when ea = s1 else '0';
    clearR <= '1' when ea = s1 else '0';
    resetB <= '1' when ea = s1 else '0';
    enableB <= '1' when ea = s3 else '0';
    loadR <= '1' when ea = s3 else '0';
         
end architecture arch_uc;

--------------------------------------------------------------

entity multiplicador is
    generic(
        word_size: positive
    );
    port (
        clock, reset, vai: in bit;
        pronto: out bit;
        A, B: in bit_vector(word_size-1 downto 0);
        resultado: out bit_vector(2*word_size-1 downto 0)
    );
end entity;

architecture arch of multiplicador is 
    component uc is
        port (
            clock, reset, vai: in bit;
            pronto: out bit;
            zero : in bit;
            loadA, loadR, clearA, clearR, enableB, resetB: out bit
        );
    end component;
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
    component fd_B is
        generic(
            word_size: positive
        );
        port (
            clock, reset, enableB: in bit;
            B: in bit_vector(word_size-1 downto 0);
            zero: out bit
        );
    end component;

    signal loadA, loadR, clearA, clearR, enableB, zero, resetB: bit;
begin
    fluxoA: fd_A generic map(word_size => word_size)
                 port map(clock => clock, loadA => loadA, loadR=> loadR, clearA=> clearA, clearR=> clearR, A => A, resultado => resultado);

    fluxoB: fd_B generic map(word_size=> word_size)
                 port map (clock => clock, reset => resetB, enableB => enableB, B => B, zero => zero);

    unidade_de_controle: uc port map (clock => clock, reset => reset, vai=> vai, pronto => pronto, zero => zero, loadA => loadA, loadR => loadR, clearA => clearA, clearR=> clearR, enableB => enableB, resetB => resetB);
end architecture arch;