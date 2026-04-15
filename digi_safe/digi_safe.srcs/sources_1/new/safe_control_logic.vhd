library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity safe_control_logic is
    Port (
        clk           : in  STD_LOGIC;
        rst           : in  STD_LOGIC;
        btn_press     : in  STD_LOGIC; -- Puls z debounceru
        sw            : in  STD_LOGIC_VECTOR (3 downto 0);
        secret_code   : in  STD_LOGIC_VECTOR (15 downto 0);
        -- Výstupy
        shift_reg     : out STD_LOGIC_VECTOR (15 downto 0);
        led_green     : out STD_LOGIC;
        led_red       : out STD_LOGIC
    );
end safe_control_logic;

architecture Behavioral of safe_control_logic is
    signal s_shift_reg : std_logic_vector(15 downto 0) := (others => '0');
    signal s_cnt       : integer range 0 to 4 := 0;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_shift_reg <= (others => '0');
                s_cnt <= 0;
                led_green <= '0';
                led_red   <= '0';
            else
                -- Logika zápisu a posuvu
                if btn_press = '1' and s_cnt < 4 then
                    s_shift_reg <= s_shift_reg(11 downto 0) & sw;
                    s_cnt <= s_cnt + 1;
                end if;

                -- Logika vyhodnocení (Comparator)
                if s_cnt = 4 then
                    if s_shift_reg = secret_code then
                        led_green <= '1';
                        led_red   <= '0';
                    else
                        led_green <= '0';
                        led_red   <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;

    shift_reg <= s_shift_reg;
end Behavioral;