entity gray2bin is
    port (
    gray2, gray1, gray0: in bit;
    bin2, bin1, bin0: out bit
    );
end entity;

architecture behave of gray2bin is
    signal b1,b2: bit;
begin
    b2 <= gray2;
    bin2 <= b2;
    
    b1 <= (b2 and (not gray1)) or ((not b2) and gray1);
    bin1 <= b1;

    bin0<=(b1 and (not gray0)) or ((not b1) and gray0);
end behave;