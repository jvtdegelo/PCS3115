entity gray2bin_tb is
end gray2bin_tb;

architecture test of gray2bin_tb is
    component gray2bin 
        port (
            gray2, gray1, gray0: in bit;
            bin2, bin1, bin0: out bit
        );
    end component;
    signal gray2,gray1,gray0,bin2,bin1,bin0: bit;
begin
    pm : gray2bin port map (gray2,gray1,gray0,bin2,bin1,bin0);

    process begin 
        gray2 <= '0';
        gray1 <= '0';
        gray0 <= '0';
        wait for 1 ns;

        assert bin2 = '0' report "erro 1 no bin2";
        assert bin1 = '0' report "erro 1 no bin1";
        assert bin0 = '0' report "erro 1 no bin0";
 
        gray2 <= '0';
        gray1 <= '0';
        gray0 <= '1';
        wait for 1 ns;

        assert bin2 = '0' report "erro 2 no bin2";
        assert bin1 = '0' report "erro 2 no bin1";
        assert bin0 = '1' report "erro 2 no bin0";
        
        gray2 <= '0';
        gray1 <= '1';
        gray0 <= '0';
        wait for 1 ns;

        assert bin2 = '0' report "erro 3 no bin2";
        assert bin1 = '1' report "erro 3 no bin1";
        assert bin0 = '1' report "erro 3 no bin0";
        
        gray2 <= '0';
        gray1 <= '1';
        gray0 <= '1';
        wait for 1 ns;

        assert bin2 = '0' report "erro 4 no bin2";
        assert bin1 = '1' report "erro 4 no bin1";
        assert bin0 = '0' report "erro 4 no bin0";
        
        gray2 <= '1';
        gray1 <= '0';
        gray0 <= '0';
        wait for 1 ns;

        assert bin2 = '1' report "erro 5 no bin2";
        assert bin1 = '1' report "erro 5 no bin1";
        assert bin0 = '1' report "erro 5 no bin0";
         
        gray2 <= '1';
        gray1 <= '0';
        gray0 <= '1';
        wait for 1 ns;

        assert bin2 = '1' report "erro 6 no bin2";
        assert bin1 = '1' report "erro 6 no bin1";
        assert bin0 = '0' report "erro 6 no bin0";
        
        gray2 <= '1';
        gray1 <= '1';
        gray0 <= '0';
        wait for 1 ns;

        assert bin2 = '1' report "erro 7 no bin2";
        assert bin1 = '0' report "erro 7 no bin1";
        assert bin0 = '0' report "erro 7 no bin0";
        
        gray2 <= '1';
        gray1 <= '1';
        gray0 <= '1';
        wait for 1 ns;

        assert bin2 = '1' report "erro 8 no bin2";
        assert bin1 = '0' report "erro 8 no bin1";
        assert bin0 = '1' report "erro 8 no bin0";

        assert false report "end";

        wait;
    end process;
end test;
