entity incinerador is
    port (
    S: in bit_vector(2 downto 0);
    P: out bit
    );
end entity;
architecture arch of incinerador is
begin
    P <= (S(0) and S(1)) or (S(0) and S(2)) or (S(1) and S(2));
end arch ; -- arch