library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debounce_counter_top is
    Port ( 
        clk     : in  STD_LOGIC;                         -- Hlavné hodiny (100 MHz)
        btnu    : in  STD_LOGIC;                         -- Reset (Horné tlačidlo)
        btnd    : in  STD_LOGIC;                         -- Inkrementácia (Dolné tlačidlo)
        -- Výstupy pre LED
        led     : out STD_LOGIC_VECTOR (7 downto 0);      -- 8-bit hodnota na LED
        led16_b : out STD_LOGIC;                         -- Modrá LED (stav tlačidla)
        -- Výstupy pre 7-segmentový displej
        seg     : out STD_LOGIC_VECTOR (6 downto 0);      -- Segmenty A-G
        an      : out STD_LOGIC_VECTOR (7 downto 0);      -- Anódy (výber číslice)
        dp      : out STD_LOGIC                          -- Desatinná bodka
    );
end debounce_counter_top;

architecture Behavioral of debounce_counter_top is

    -- 1. Komponent: Debouncer (odstránenie zákmitov)
    component debounce is
        Port ( 
            clk       : in  STD_LOGIC;
            rst       : in  STD_LOGIC;
            btn_in    : in  STD_LOGIC;
            btn_state : out STD_LOGIC;
            btn_press : out STD_LOGIC
        );
    end component debounce;

    -- 2. Komponent: Binárny čítač
    component counter is
        generic ( G_BITS : positive := 8 );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            en  : in  std_logic;
            cnt : out std_logic_vector(G_BITS - 1 downto 0)
        );
    end component counter;

    -- 3. Komponent: Budič displeja (zobrazuje 8-bit hodnotu na 2 cifry)
    component display_driver is
        Port ( 
            clk   : in  STD_LOGIC;
            rst   : in  STD_LOGIC;
            data  : in  STD_LOGIC_VECTOR (7 downto 0);
            seg   : out STD_LOGIC_VECTOR (6 downto 0);
            anode : out STD_LOGIC_VECTOR (1 downto 0)
        );
    end component display_driver;

    -- Vnútorné signály na prepojenie modulov
    signal sig_cnt_en  : std_logic;                     -- Impulz z debounceru
    signal sig_cnt_val : std_logic_vector(7 downto 0);  -- Aktuálna hodnota čítača

begin

    ------------------------------------------------------------------------
    -- Debouncer: Spracuje stlačenie BTND
    ------------------------------------------------------------------------
    debounce_0 : debounce
        port map (
            clk       => clk,
            rst       => btnu,
            btn_in    => btnd,
            btn_press => sig_cnt_en, -- Generuje 1-taktový impulz pre čítač
            btn_state => led16_b     -- Svieti, kým držíš BTND
        );

    ------------------------------------------------------------------------
    -- Čítač: Inkrementuje sa pri každom platnom stlačení
    ------------------------------------------------------------------------
    counter_0 : counter
        generic map ( G_BITS => 8 )
        port map (
            clk => clk,
            rst => btnu,
            en  => sig_cnt_en,
            cnt => sig_cnt_val       -- Hodnota sa posiela ďalej
        );

    ------------------------------------------------------------------------
    -- Budič displeja: Zobrazí hodnotu sig_cnt_val na displeji
    ------------------------------------------------------------------------
    display_0 : display_driver
        port map (
            clk   => clk,
            rst   => btnu,
            data  => sig_cnt_val,
            seg   => seg,
            anode => an(1 downto 0)  -- Ovláda prvé dve cifry (vpravo)
        );

    ------------------------------------------------------------------------
    -- Logika pre zvyšné výstupy
    ------------------------------------------------------------------------
    -- Prepojenie hodnoty čítača priamo na 8 LED diód
    led <= sig_cnt_val;

    -- Vypnutie zvyšných 6 anód (pre Nexys A7, kde je anóda aktívna v nule)
    an(7 downto 2) <= b"11_1111";
    
    -- Vypnutie desatinnej bodky
    dp <= '1';

end Behavioral;
