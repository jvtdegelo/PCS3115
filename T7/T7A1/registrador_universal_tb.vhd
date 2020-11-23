library ieee;
use ieee.numeric_bit.rising_edge;

entity registrador_universal_tb is
end entity;

architecture test of registrador_universal_tb is
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

    signal clock, clear, set, enable, simula: bit;
    signal control: bit_vector (1 downto 0);
    signal serial_input: bit;
    signal parallel_input: bit_vector(7 downto 0);
    signal parallel_output: bit_vector(7 downto 0);

begin
    dut : registrador_universal generic map(word_size => 8)
                                port map(clock=> clock, clear=>clear, set=> set, enable=> enable, control=> control, serial_input => serial_input, parallel_input=> parallel_input, parallel_output=>parallel_output);
    clock <= (simula and not clock) after 1 ns;

    tb : process
    begin 
        simula <= '1';
        report "BOT";

        clear <= '1';
        wait for 1 ns;
        assert parallel_output = "00000000" report "BO no reset";
        wait for 1 ns;
        clear<= '0';
        wait for 1 ns;
        set <= '1';
        wait for 1 ns;
        assert parallel_output = "11111111" report "BO no set";
        wait for 1 ns;
        set <= '0';
        wait for 1 ns;


        report "EOT";
        simula <= '0';
        wait;
    end process;
end architecture test; 