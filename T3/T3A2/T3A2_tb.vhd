entity incinerador_tb is
end incinerador_tb;

architecture test of  incinerador_tb is
    component incinerador 
        port (
            S: in bit_vector(2 downto 0);
            P: out bit
        );
    end component;

    signal s: bit_vector(2 downto 0);
    signal p: bit;
begin
    test_incinerador: incinerador port map(S => s, P => p);
    process begin
        s <= "111";
        wait for 1 ns;
        assert p = '1' report "Deu ruim";

        s<="001";
        wait for 1 ns;
        assert p='0' report "Deu ruim";

        s <= "101";
        wait for 1 ns;
        assert p = '1' report "Deu ruim";

        s<="010";
        wait for 1 ns;
        assert p='0' report "Deu ruim";

        assert false report "deitou";
        wait;
    end process;
end test; 