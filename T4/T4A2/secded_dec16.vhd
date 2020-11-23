library IEEE;
use IEEE.numeric_bit.ALL; 

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

library IEEE;
use IEEE.numeric_bit.ALL; 

entity secded_dec16 is
    port (
    mem_data: in bit_vector(21 downto 0);
    u_data: out bit_vector(15 downto 0);
    syndrome: out natural;
    two_errors: out bit;
    one_error: out bit
    );
end entity;

architecture decript of secded_dec16 is
    component secded_enc16 is
        port (
        u_data: in bit_vector(15 downto 0);
        mem_data: out bit_vector(21 downto 0)
        );
    end component; 
    signal data: bit_vector(15 downto 0);
    signal n_data: bit_vector(21 downto 0);
    signal p: bit_vector(4 downto 0);
    signal synd: natural;
    signal p5: bit;
begin
    data(0)<= mem_data(2);
    data(1)<= mem_data(4);
    data(2)<= mem_data(5);
    data(3)<= mem_data(6);
    data(4)<= mem_data(8);
    data(5)<= mem_data(9);
    data(6)<= mem_data(10);
    data(7)<= mem_data(11);
    data(8)<= mem_data(12);
    data(9)<= mem_data(13);
    data(10)<= mem_data(14);
    data(11)<= mem_data(16);
    data(12)<= mem_data(17);
    data(13)<= mem_data(18);
    data(14)<= mem_data(19);
    data(15)<= mem_data(20);

    cript_data: secded_enc16 port map(u_data=> data, mem_data=> n_data);

    p(0)<=n_data(0) xor mem_data(0);
    p(1)<=n_data(1) xor mem_data(1);
    p(2)<=n_data(3) xor mem_data(3);
    p(3)<=n_data(7) xor mem_data(7);
    p(4)<=n_data(15) xor mem_data(15);
    

    synd<=TO_INTEGER(unsigned(p));
    syndrome <= synd;    
    
    u_data(0) <= data(0) when synd /= 3 else not(data(0));
    u_data(1) <= data(1) when synd /= 5 else not(data(1));
    u_data(2) <= data(2) when synd /= 6 else not(data(2));  
    u_data(3) <= data(3) when synd /= 7 else not(data(3));
    u_data(4) <= data(4) when synd /= 9 else not(data(4));
    u_data(5) <= data(5) when synd /= 10 else not(data(5));
    u_data(6) <= data(6) when synd /= 11 else not(data(6));
    u_data(7) <= data(7) when synd /= 12 else not(data(7));
    u_data(8) <= data(8) when synd /= 13 else not(data(8));
    u_data(9) <= data(9) when synd /= 14 else not(data(9));
    u_data(10) <= data(10) when synd /= 15 else not(data(10));
    u_data(11) <= data(11) when synd /= 17 else not(data(11));
    u_data(12) <= data(12) when synd /= 18 else not(data(12));
    u_data(13) <= data(13) when synd /= 19 else not(data(13));
    u_data(14) <= data(14) when synd /= 20 else not(data(14));
    u_data(15) <= data(15) when synd /= 21 else not(data(15));
    


    p5  <= mem_data(20) xor mem_data(19) xor
           mem_data(18) xor mem_data(17) xor
           mem_data(16) xor mem_data(15) xor
           mem_data(14) xor mem_data(13) xor
           mem_data(12) xor mem_data(11) xor
           mem_data(10) xor mem_data(9) xor
           mem_data(8) xor mem_data(7) xor
           mem_data(6) xor mem_data(5) xor
           mem_data(4) xor mem_data(3) xor
           mem_data(2) xor mem_data(1) xor
           mem_data(0) xor mem_data(21);

    one_error <= '0' when synd = 0 and p5 = '0' else
                 '1' when p5 = '1' else
                 '0' when synd /= 0 and p5 = '0' else
                 '0';
    two_errors <= '0' when synd = 0 and p5 = '0' else
                  '0' when p5 = '1' else
                  '1' when synd /= 0 and p5 = '0' else
                  '0';
end decript;