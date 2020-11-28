library ieee;
use ieee.numeric_bit.all;

entity ram is
    generic (
        addressSize : natural := 4;
        wordSize : natural := 8
    );
    port (
        ck , wr : in bit ;
        addr : in bit_vector ( addressSize -1 downto 0);
        data_i : in bit_vector ( wordSize -1 downto 0);
        data_o : out bit_vector ( wordSize -1 downto 0)
    );
end ram ;

architecture arch of ram is
    type mem_type is array (2**addressSize-1 downto 0) of bit_vector(wordSize-1 downto 0);
    signal mem: mem_type;
begin
    process (ck)
    begin
        if rising_edge(ck) then
            if wr = '1' then
                mem(to_integer(unsigned(addr))) <= data_i;
            end if;
        end if;
    end process;
    data_o <= mem(to_integer(unsigned(addr)));
end arch;