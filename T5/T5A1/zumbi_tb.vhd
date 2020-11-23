library ieee;
use ieee.numeric_bit.rising_edge;

entity zumbi_tb is
end entity;

architecture test_arch of zumbi_tb is
    component zumbi is
        port(
        clock, reset: in bit;
        x: in bit_vector(1 downto 0);
        z: out bit
        );
    end component;
    constant periodoDeClock: time := 1 ns;
    signal simulando: bit := '0';
    signal clk, rst, z: bit;
    signal x: bit_vector(1 downto 0);
begin
    clk <= (simulando and not clk) after periodoDeClock/2;

    dut: zumbi port map(clk, rst, x, z);

    stim: process
        constant vetorx: bit_vector := B"00_01_11_11_11_10_11_00_10_01_11";
        constant vetorz: bit_vector := B"0_0_1_0_1_1_1_0_1_0_1";
    begin
        simulando <= '1';
        report "BOT";

    x(1) <= '0'; x(0) <= '1'; rst <= '1'; wait for 5 ns; rst<='0';
    assert z = '0' report "reset";

    teste: for i in 0 to vetorz'length-1 loop
        x(1)<=vetorx(2*i);
        x(0)<=vetorx(2*i+1);
        -- wait until clk'event and clk='1';
        wait until rising_edge(clk);
        wait for periodoDeClock/10;
        -- wait until falling_edge(clk);
        assert z=vetorz(i)
        report integer'image(i) & ") falhou! " 
        severity note;
      end loop;

    report "EOT";
    simulando <= '0';
    wait;
    end process;
end test_arch;