entity rom_arquivo_tb is
end entity;

architecture test of rom_arquivo_tb is
    component rom_arquivo is
        port (
            addr : in bit_vector (3 downto 0);
            data : out bit_vector (7 downto 0)
        );
    end component; 

    signal addr:bit_vector(3 downto 0);
    signal data: bit_vector(7 downto 0);

begin
    dut: rom_arquivo port map(addr => addr, data => data);

    process begin
        report "BOT";
        addr <= "0000";
        wait for 1 ns;
        assert data = "00000000" report "addr : 0";
        wait for 1 ns;

        addr <= "0010";
        wait for 1 ns;
        assert data = "11000000" report "addr : 2";
        wait for 1 ns;

        addr <= "1111";
        wait for 1 ns;
        assert data = "00001111" report "addr : 15";
        wait for 1 ns;

        report "EOT";
        wait;
    end process;
end architecture test;