library ieee;
use ieee.numeric_bit.rising_edge;

entity gcd_uc is
    port (
    clock, reset: in bit;
    vai, AigualB, AmaiorB: in bit;
    carregaA, carregaB, BmA, sub, fim: out bit
    );
end entity;

architecture asm of gcd_uc is
    type st_t is (ini, init, eq, agb, bga, inter);
    signal ea, pe : st_t;
begin
    sincrono: process(clock, reset)
    begin 
        if reset = '1' then
            ea <= ini;
        elsif rising_edge(clock) then
            ea <= pe;
        end if;
    end process;
    
    pe <= 
        init when ea = ini and vai = '1' else
        inter when ea = init or ea = agb or ea = bga else
        agb when ea = inter and AmaiorB = '1' else
        eq when ea = inter and AigualB = '1' else 
        bga when ea = inter and AmaiorB = '0' and AigualB = '0' else
        ini when ea = eq else
        ini;
    
    carregaA <= '1' when ea = agb or ea = init else '0';

    carregaB <= '1' when ea = bga or ea = init else '0';

    BmA <= '1' when ea = bga else '0';

    sub <= '0' when ea = init else '1';

    fim <= '1' when ea = eq else '0';
end; 