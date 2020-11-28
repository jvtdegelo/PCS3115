library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity rom_arquivo is
    port (
        addr : in bit_vector (3 downto 0);
        data : out bit_vector (7 downto 0)
    );
end rom_arquivo ;
architecture memory of rom_arquivo is
    type mem_type is array (15 downto 0) of bit_vector(7 downto 0);

    impure function init_mem(mif_file_name : in string) return mem_type is
        file mif_file : text open read_mode is mif_file_name;
        variable mif_line : line;
        variable temp_bv : bit_vector(7 downto 0);
        variable temp_mem : mem_type;
    begin
        for i in mem_type'reverse_range loop
            readline(mif_file, mif_line);
            read(mif_line, temp_bv);
            temp_mem(i) := temp_bv;
        end loop;
        return temp_mem;
    end function;

    constant mem : mem_type := init_mem("conteudo_rom_ativ_02_carga.dat");
begin
    data <= mem(to_integer(unsigned(addr)));
end architecture;