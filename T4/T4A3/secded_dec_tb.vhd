--Judge could not find your grade. Check garbage printed on screen before
library ieee;
use ieee.numeric_bit.all;
use ieee.math_real.all;
library work;
use work.secded.secded_message_size;

entity secded_dec_tb is
end entity;

architecture testbench of secded_dec_tb is
    component secded_dec is
        generic(
                 data_size: positive := 16
               );
        port(
          mem_data: in bit_vector(secded_message_size(data_size)-1 downto 0);
          u_data: out bit_vector(data_size-1 downto 0);
          uncorrectable_error: out bit
        );
    end component;
    signal mem_data: bit_vector(71 downto 0);
    signal u_data: bit_vector(63 downto 0);
    signal u:bit;
begin
    test: secded_dec generic map (data_size => 64)
                     port map (u_data => u_data, mem_data => mem_data, uncorrectable_error=> u);
    
    process begin
        mem_data <="000000000000000000010000000000000000010000000000000000000000000000000000";
        wait for 1 ns;
        assert u_data="0000000000000000000000000000000000000000000000000000000000000000" report "deu BO no u_data";
        --assert u_data(2)='0' report "deu BO no u_data";
        assert u ='0' report "deu BO no uncorrectable";
        assert false report "acabou";
        wait;
    end process;
end testbench;