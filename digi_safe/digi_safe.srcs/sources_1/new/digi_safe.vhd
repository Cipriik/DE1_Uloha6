library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digi_safe is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        sw        : in  STD_LOGIC_VECTOR (3 downto 0);
        btn_in    : in  STD_LOGIC;
        led_green : out STD_LOGIC;
        led_red   : out STD_LOGIC;
        seg       : out STD_LOGIC_VECTOR (6 downto 0);
        an        : out STD_LOGIC_VECTOR (7 downto 0)
    );
end digi_safe;

architecture Structural of digi_safe is

    -- 1. VNITŘNÍ SIGNÁLY (Propojovací dráty mezi komponentami)
    signal s_btn_press   : std_logic;
    signal s_shift_reg   : std_logic_vector(15 downto 0);
    signal s_ce_refresh  : std_logic;
    signal s_hex_digit   : std_logic_vector(3 downto 0);

    -- Heslo (můžeš ho definovat tady a poslat do komponenty)
    constant C_SECRET : std_logic_vector(15 downto 0) := x"6967";

begin

    -- INSTANCE 1: Debounce (Ošetření tlačítka)
    debounce : entity work.debounce
        port map (
            clk       => clk,
            rst       => rst,
            btn_in    => btn_in,
            btn_press => s_btn_press
        );

    -- INSTANCE 2: Safe Control Logic (Mozek trezoru)
    safe_control_logic : entity work.safe_control_logic
        port map (
            clk           => clk,
            rst           => rst,
            btn_press   => s_btn_press,
            sw          => sw,
            secret_code => C_SECRET,
            shift_reg   => s_shift_reg,
            led_green   => led_green,
            led_red     => led_red
        );

    -- INSTANCE 3: Clock Enable (Časování displeje)
    clk_en : entity work.clk_en
        generic map ( G_MAX => 100_000 ) -- Pro 100MHz hodiny na Nexys
        port map (
            clk => clk,
            rst => rst,
            ce  => s_ce_refresh
        );

    -- INSTANCE 4: Display Mux Logic (Výběr cifry a anody)
    display_driver : entity work.display_driver
        port map (
            clk          => clk,
            rst          => rst,
            ce_refresh => s_ce_refresh,
            data       => s_shift_reg,
            hex_digit  => s_hex_digit,
            anode     => an
        );

    -- INSTANCE 5: Bin2Seg (Převodník na segmenty)
    bin2seg : entity work.bin2seg
        port map (
            bin => s_hex_digit,
            seg    => seg
        );

end Structural;

