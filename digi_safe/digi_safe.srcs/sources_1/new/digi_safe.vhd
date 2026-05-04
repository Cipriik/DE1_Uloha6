library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity digi_safe is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;

        btnu      : in  STD_LOGIC;
        btnd      : in  STD_LOGIC;
        btnl      : in  STD_LOGIC;
        btnr      : in  STD_LOGIC;
        btnc      : in  STD_LOGIC;

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

    component digit_editor is
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;

            btnu     : in  std_logic;
            btnd     : in  std_logic;
            btnl     : in  std_logic;
            btnr     : in  std_logic;

            code_out : out std_logic_vector(15 downto 0);
            selected : out integer range 0 to 3;
            blink_on : out std_logic
        );
    end component;

    component safe_control_logic is
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            btn_press    : in  std_logic;
            entered_code : in  std_logic_vector(15 downto 0);
            secret_code  : in  std_logic_vector(15 downto 0);
            led_green    : out std_logic;
            led_red      : out std_logic
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
            seg        : out std_logic_vector(6 downto 0);
            anode      : out std_logic_vector(7 downto 0)
        );
    end component;

    signal s_btn_press  : std_logic;
    signal s_ce_refresh : std_logic;

    signal s_code       : std_logic_vector(15 downto 0);
    signal s_pos        : integer range 0 to 3;
    signal s_blink_on   : std_logic;

    signal s_an_raw     : std_logic_vector(7 downto 0);

    signal s_rst_clean : std_logic;
    
    signal s_btnu_press : std_logic;
    signal s_btnd_press : std_logic;
    signal s_btnl_press : std_logic;
    signal s_btnr_press : std_logic;
    
    constant C_SECRET : std_logic_vector(15 downto 0) := x"1234";

begin
    
    debounce_btnu_0 : debounce
        port map (
            clk       => clk,
            rst       => rst,
            btn_in    => btnu,
            btn_press => s_btnu_press
        );

    debounce_btnd_0 : debounce
        port map (
            clk       => clk,
            rst       => rst,
            btn_in    => btnd,
            btn_press => s_btnd_press
        );

    debounce_btnl_0 : debounce
        port map (
            clk       => clk,
            rst       => rst,
            btn_in    => btnl,
            btn_press => s_btnl_press
        );

    debounce_btnr_0 : debounce
        port map (
            clk       => clk,
            rst       => rst,
            btn_in    => btnr,
            btn_press => s_btnr_press
        );
    
    debounce_btnc_0 : debounce
        port map (
            clk       => clk,
            rst       => rst,
            btn_in    => btnc,
            btn_press => s_btn_press
        );

    digit_editor_0 : digit_editor
        port map (
            clk      => clk,
            rst      => rst,
            btnu => s_btnu_press,
            btnd => s_btnd_press,
            btnl => s_btnl_press,
            btnr => s_btnr_press,
            code_out => s_code,
            selected => s_pos,
            blink_on => s_blink_on
        );

    safe_control_logic_0 : safe_control_logic
        port map (
            clk          => clk,
            rst          => rst,
            btn_press    => s_btn_press,
            entered_code => s_code,
            secret_code  => C_SECRET,
            led_green    => led_green,
            led_red      => led_red
        );

    clk_en_0 : clk_en
        generic map (
            G_MAX => 2
        )
        port map (
            clk => clk,
            rst => rst,
            ce  => s_ce_refresh
        );

    display_driver_0 : display_driver
        port map (
            clk        => clk,
            rst        => rst,
            ce_refresh => s_ce_refresh,
            data       => s_code,
            seg        => seg,
            anode      => s_an_raw
        );

    process(s_an_raw, s_pos, s_blink_on)
    begin
        an <= s_an_raw;

        if s_blink_on = '0' then
            case s_pos is
                when 0 => an(3) <= '1';
                when 1 => an(2) <= '1';
                when 2 => an(1) <= '1';
                when 3 => an(0) <= '1';
                when others => an <= s_an_raw;
            end case;
        end if;
    end process;

end Structural;