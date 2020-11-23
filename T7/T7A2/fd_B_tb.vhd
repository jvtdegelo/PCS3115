library ieee;
use ieee.numeric_bit.all;

entity fd_B_tb is
end entity;

architecture test of fd_B_tb is
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

    constant pc : time := 10 ns;
    signal clock, reset, enableB, simula, zero: bit;
    signal B: bit_vector(3 downto 0);

begin
    dut: fd_B generic map (word_size => 4)
              port map (clock => clock, reset => reset, enableB => enableB, B => B, zero => zero);

    clock <= (not(clock) and simula) after pc/2;
    process
    begin
        simula <= '1'; 
        report "BOT";
        B <= "0000";
        enableB <= '1';
        reset <= '1';
        wait until rising_edge(clock);
        wait for pc/2;
        assert zero = '1' report "deu BO no primeiro";
        reset <= '0';
        
        simula <= '0';
        enableB <= '0';
        report "EOT";
        wait;
    end process;
end architecture test;