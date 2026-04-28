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


    component debounce is
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            btn_in    : in  std_logic;
            btn_press : out std_logic
        );
    end component;

    component safe_control_logic is
        port (
            clk         : in  std_logic;
            rst         : in  std_logic;
            btn_press   : in  std_logic;
            sw          : in  std_logic_vector(3 downto 0);
            secret_code : in  std_logic_vector(15 downto 0);
            shift_reg   : out std_logic_vector(15 downto 0);
            led_green   : out std_logic;
            led_red     : out std_logic
        );
    end component;

    component clk_en is
        generic (
            G_MAX : integer := 2
        );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component;

    component display_driver is
        port (
            clk        : in  std_logic;
            rst        : in  std_logic;
            ce_refresh : in  std_logic;
            data       : in  std_logic_vector(15 downto 0);
            hex_digit  : out std_logic_vector(3 downto 0);
            anode      : out std_logic_vector(7 downto 0)
        );
    end component;

    component bin2seg is
        port (
            bin : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

    signal s_btn_press   : std_logic;
    signal s_shift_reg   : std_logic_vector(15 downto 0);
    signal s_ce_refresh  : std_logic;
    signal s_hex_digit   : std_logic_vector(3 downto 0);

    constant C_SECRET : std_logic_vector(15 downto 0) := x"1234";

begin


    debounce_inst : debounce
        port map (
            clk       => clk,
            rst       => rst,
            btn_in    => btn_in,
            btn_press => s_btn_press
        );

    safe_control_logic_inst : safe_control_logic
        port map (
            clk         => clk,
            rst         => rst,
            btn_press   => s_btn_press,
            sw          => sw,
            secret_code => C_SECRET,
            shift_reg   => s_shift_reg,
            led_green   => led_green,
            led_red     => led_red
        );

    clk_en_inst : clk_en
        generic map ( G_MAX => 100_000 )
        port map (
            clk => clk,
            rst => rst,
            ce  => s_ce_refresh
        );

    display_driver_inst : display_driver
        port map (
            clk        => clk,
            rst        => rst,
            ce_refresh => s_ce_refresh,
            data       => s_shift_reg,
            hex_digit  => s_hex_digit,
            anode      => an
        );

    

end Structural;

