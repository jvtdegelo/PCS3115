entity secded_enc16 is
    port (
    u_data: in bit_vector(15 downto 0);
    mem_data: out bit_vector(21 downto 0)
    );
end entity;

architecture cript of secded_enc16 is
    signal p0,p1,p2,p3,p4: bit;
begin
    p0<= u_data(15) xor u_data(13) xor
                  u_data(11) xor u_data(10) xor
                  u_data(8) xor u_data(6) xor 
                  u_data(4) xor u_data(3) xor
                  u_data(1) xor u_data(0);
    mem_data(0)<=p0; 
    p1<= u_data(13) xor u_data(12) xor
                  u_data(10) xor u_data(9) xor
                  u_data(6) xor u_data(5) xor 
                  u_data(3) xor u_data(2) xor
                  u_data(0); 
    mem_data(1)<=p1;
    mem_data(2)<=u_data(0);
    p2<=u_data(15) xor u_data(14) xor
                 u_data(10) xor u_data(9) xor
                 u_data(8) xor u_data(7) xor 
                 u_data(3) xor u_data(2) xor
                 u_data(1); 
    mem_data(3)<= p2;
    mem_data(4)<=u_data(1);
    mem_data(5)<=u_data(2);
    mem_data(6)<=u_data(3);
    p3<=u_data(10) xor u_data(9) xor
                 u_data(8) xor u_data(7) xor
                 u_data(6) xor u_data(5) xor 
                 u_data(4); 
    mem_data(7)<= p3;

    mem_data(8)<=u_data(4);
    mem_data(9)<=u_data(5);
    mem_data(10)<=u_data(6);
    mem_data(11)<=u_data(7);
    mem_data(12)<=u_data(8);
    mem_data(13)<=u_data(9);
    mem_data(14)<=u_data(10);
    p4<=u_data(15) xor u_data(14) xor
                 u_data(13) xor u_data(12) xor
                 u_data(11);
                 
    mem_data(15)<=p4;
    mem_data(16)<=u_data(11);
    mem_data(17)<=u_data(12);
    mem_data(18)<=u_data(13);
    mem_data(19)<=u_data(14);
    mem_data(20)<=u_data(15);
    mem_data(21)<= u_data(15) xor u_data(14) xor
                   u_data(13) xor u_data(12) xor
                   u_data(11) xor u_data(10) xor
                   u_data(9) xor u_data(8) xor
                   u_data(7) xor u_data(6) xor
                   u_data(5) xor u_data(4) xor
                   u_data(3) xor u_data(2) xor
                   u_data(1) xor u_data(0) xor
                   p4 xor p3 xor
                   p2 xor p1 xor
                   p0;

end cript;
