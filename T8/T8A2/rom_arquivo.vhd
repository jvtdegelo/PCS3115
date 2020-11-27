library ieee;
use ieee.numeric_bit.all;

entity rom_arquivo is
    port (
        addr : in bit_vector (3 downto 0);
        data : out bit_vector (7 downto 0)
    );
end rom_arquivo ;
architecture memory of rom_arquivo is
    
begin

end architecture;