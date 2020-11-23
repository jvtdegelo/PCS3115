library ieee;
use ieee.numeric_bit.rising_edge;
entity zumbi is
    port(
    clock, reset: in bit;
    x: in bit_vector(1 downto 0);
    z: out bit
    );
end entity;
architecture fsm of zumbi is
    type estados_t is (A,B,C,D);
    signal estado_atual, proximo_estado: estados_t;
begin
    sincrono: process(clock, reset)
    begin   
        if reset = '1' then
            estado_atual <= A;
        elsif rising_edge(clock) then
            estado_atual <= proximo_estado;
        end if;
    end process;

    proximo_estado <= 
    A when x="00" else
    D when x="10" else
    B when x="01" else
    A when x="11" and estado_atual=A else
    C when x="11" and estado_atual=B else
    B when x="11" and estado_atual=C else
    D when x="11" and estado_atual=D else
    A;
    
    z <= '1' when estado_atual = C or estado_atual = D else '0';
end architecture;
    