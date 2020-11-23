entity inci_tb is
end inci_tb;

architecture test of inci_tb is
    component incinerador 
        port (
        led: out bit;
        S: in bit_vector(2 downto 0);
        P: out bit
        );
    end component;

    signal led, p: bit;
    signal s: bit_vector (2 downto 0);

begin
    test_incinerador: incinerador port map (led=>led, S=>s, P=>p);
    process begin
        s <= "111";
        wait for 1 ns;
        assert p = '1' and led = '1' report "Deu ruim";

        s<="001";
        wait for 1 ns;
        assert p='0' and led = '1' report "Deu ruim";

        s <= "101";
        wait for 1 ns;
        assert p = '1' and led = '1' report "Deu ruim";

        s<="010";
        wait for 1 ns;
        assert p='0' and led = '1' report "Deu ruim";

        assert false report "deitou";
        wait;
    end process;
end test;