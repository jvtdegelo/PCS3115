entity gray2bin is
    generic (
    size: natural := 3
    );
    port (
    gray: in bit_vector(size-1 downto 0);
    bin: out bit_vector(size-1 downto 0)
    );
end entity;


architecture behave of gray2bin is
    signal b : bit_vector(size-1 downto 0);

begin
    b(size-1)<= gray(size-1);
    bin(size-1)<= b(size-1);
    conv: for i in size-2 downto 0 generate
        b(i)<=(b(i+1)and(not gray(i)))or((not b(i+1))and gray(i));
        bin(i) <= b(i);
    end generate conv;

end behave;