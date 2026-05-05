library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity safe_control_logic is
    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        btn_press    : in  STD_LOGIC;
        entered_code : in  STD_LOGIC_VECTOR (15 downto 0);
        secret_code  : in  STD_LOGIC_VECTOR (15 downto 0);
        ledm16       : out STD_LOGIC;
        ledn16       : out STD_LOGIC
    );
end safe_control_logic;

architecture Behavioral of safe_control_logic is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                ledm16 <= '0';
                ledn16   <= '0';
            else
                if btn_press = '1' then
                    if entered_code = secret_code then
                        ledm16 <= '1';
                        ledn16   <= '0';
                    else
                        ledm16 <= '0';
                        ledn16   <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;