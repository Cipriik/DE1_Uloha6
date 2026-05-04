library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_digi_safe is
end tb_digi_safe;

architecture tb of tb_digi_safe is

    -- Deklaracia komponenty (vstupy/vystupy podla tvojho digi_safe)
    component digi_safe
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            btnu      : in  std_logic;
            btnd      : in  std_logic;
            btnl      : in  std_logic;
            btnr      : in  std_logic;
            btnc      : in  std_logic;
            led_green : out std_logic;
            led_red   : out std_logic;
            seg       : out std_logic_vector (6 downto 0);
            an        : out std_logic_vector (7 downto 0)
        );
    end component;

    -- Lokalne signaly pre testbench
    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal btnu      : std_logic := '0';
    signal btnd      : std_logic := '0';
    signal btnl      : std_logic := '0';
    signal btnr      : std_logic := '0';
    signal btnc      : std_logic := '0';
    signal led_green : std_logic;
    signal led_red   : std_logic;
    signal seg       : std_logic_vector (6 downto 0);
    signal an        : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; -- 100 MHz
    signal TbSimEnded : std_logic := '0';

begin

    -- Instancia tvojho top-level modulu
    dut : digi_safe
    port map (
        clk       => clk,
        rst       => rst,
        btnu      => btnu,
        btnd      => btnd,
        btnl      => btnl,
        btnr      => btnr,
        btnc      => btnc,
        led_green => led_green,
        led_red   => led_red,
        seg       => seg,
        an        => an
    );

    -- Generovanie hodin
    clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- Proces stimulov
    stimuli : process
    begin
        -- 1. RESET (vzdy dolezity na zaciatku)
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- POZNAMKA: Pred spustenim v debounce.vhd zmen C_MAX na 2!
        
        -- KROK 1: Nastavime '1' na prvej pozicii (s_pos = 0)
        btnu <= '1'; wait for 100 ns; btnu <= '0';
        wait for 200 ns;

        -- KROK 2: Posun na druhu poziciu (s_pos = 1)
        btnr <= '1'; wait for 100 ns; btnr <= '0';
        wait for 200 ns;

        -- KROK 3: Nastavime '2' na druhej pozicii (2x UP)
        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0';
        wait for 200 ns;

        -- KROK 4: Posun na tretiu poziciu (s_pos = 2)
        btnr <= '1'; wait for 100 ns; btnr <= '0';
        wait for 200 ns;

        -- KROK 5: Nastavime '3' na tretej pozicii (3x UP)
        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0';
        wait for 200 ns;

        -- KROK 6: Posun na stvrtu poziciu (s_pos = 3)
        btnr <= '1'; wait for 100 ns; btnr <= '0';
        wait for 200 ns;

        -- KROK 7: Nastavime '4' na stvrtej pozicii (4x UP)
        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0';
        wait for 200 ns;

        -- KROK 8: POTVRDENIE (Center button)
        -- V tomto momente musi byt v s_code hodnota x"1234"
        btnc <= '1'; wait for 100 ns; btnc <= '0';

        -- Cakaj na vysledok
        wait for 1 us;

        -- Koniec simulacie
        TbSimEnded <= '1';
        wait;
    end process;

end tb;