library IEEE;
use IEEE.numeric_bit.ALL; 

entity secded_dec16_tb is
end secded_dec16_tb;

architecture tb of secded_dec16_tb is
    component secded_dec16 is
        port (
        mem_data: in bit_vector(21 downto 0);
        u_data: out bit_vector(15 downto 0);
        syndrome: out natural;
        two_errors: out bit;
        one_error: out bit
        );
    end component;
    signal mem_data: bit_vector(21 downto 0);
    signal u_data: bit_vector(15 downto 0);
    signal syndrome: natural;
    signal one_error: bit;
    signal two_errors: bit;
begin
    t: secded_dec16 port map(mem_data=>mem_data, u_data=>u_data, syndrome=>syndrome, two_errors=>two_errors, one_error=>one_error);
    process begin
        mem_data<="1110011100110111100001";
        wait for 1 ns;
        assert u_data = "1100110011001100" report "deu ruim no u_data";
        assert syndrome = 9 report "deu ruim na sindrome";
        assert one_error = '1' report "deu ruim no one_error";
        assert two_errors = '0' report "deu ruim no two_errors";
        assert false report "acabou";
        wait;
    end process;
end tb;
