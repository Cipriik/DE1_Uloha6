library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity safe_control_logic is
    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        btn_press    : in  STD_LOGIC;
        entered_code : in  STD_LOGIC_VECTOR (15 downto 0);
        secret_code  : in  STD_LOGIC_VECTOR (15 downto 0);
        led_green    : out STD_LOGIC;
        led_red      : out STD_LOGIC
    );
end safe_control_logic;

architecture Behavioral of safe_control_logic is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                led_green <= '0';
                led_red   <= '0';
            else
                if btn_press = '1' then
                    if entered_code = secret_code then
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
end Behavioral;