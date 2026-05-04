library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity display_driver is
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        ce_refresh : in  STD_LOGIC;
        data       : in  STD_LOGIC_VECTOR(15 downto 0);
        seg        : out STD_LOGIC_VECTOR(6 downto 0);
        anode      : out STD_LOGIC_VECTOR(7 downto 0)
    );
end display_driver;

architecture Behavioral of display_driver is

    signal active_digit : integer range 0 to 3 := 0;
    signal hex_digit    : STD_LOGIC_VECTOR(3 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                active_digit <= 0;
            else
                if ce_refresh = '1' then
                    if active_digit = 3 then
                        active_digit <= 0;
                    else
                        active_digit <= active_digit + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    process(active_digit, data)
    begin
        case active_digit is
            when 0 =>
                hex_digit <= data(15 downto 12);
                anode <= "11110111";
            when 1 =>
                hex_digit <= data(11 downto 8);
                anode <= "11111011";
            when 2 =>
                hex_digit <= data(7 downto 4);
                anode <= "11111101";
            when 3 =>
                hex_digit <= data(3 downto 0);
                anode <= "11111110";
            when others =>
                hex_digit <= "0000";
                anode <= "11111111";
        end case;
    end process;

    process(hex_digit)
begin
    case hex_digit is
        when "0000" => seg <= "0000001"; -- 0
        when "0001" => seg <= "1001111"; -- 1
        when "0010" => seg <= "0010010"; -- 2
        when "0011" => seg <= "0000110"; -- 3
        when "0100" => seg <= "1001100"; -- 4
        when "0101" => seg <= "0100100"; -- 5
        when "0110" => seg <= "0100000"; -- 6
        when "0111" => seg <= "0001111"; -- 7
        when "1000" => seg <= "0000000"; -- 8
        when "1001" => seg <= "0000100"; -- 9
        when others => seg <= "1111111"; -- vypnuté
    end case;
end process;

end Behavioral;