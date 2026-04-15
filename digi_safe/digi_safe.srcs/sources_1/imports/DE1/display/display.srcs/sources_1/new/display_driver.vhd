library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_driver is
    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        ce_refresh : in  STD_LOGIC; -- Puls z clk_en
        data       : in  STD_LOGIC_VECTOR (15 downto 0); -- Celý kód ze safe
        -- Výstupy
        hex_digit  : out STD_LOGIC_VECTOR (3 downto 0); -- Cifra pro bin2seg
        anode     : out STD_LOGIC_VECTOR (7 downto 0)  -- Anody displeje
    );
end display_driver;

architecture Behavioral of display_driver is
    signal s_mux_cnt : unsigned(1 downto 0) := "00";
begin
    -- 2-bit čítač pro přepínání displejů
    p_mux_cnt : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_mux_cnt <= "00";
            elsif ce_refresh = '1' then
                s_mux_cnt <= s_mux_cnt + 1;
            end if;
        end if;
    end process;

    -- Multiplexer a dekodér anod
    p_mux_select : process(s_mux_cnt, data)
    begin
        anode <= (others => '1'); -- Všechny displeje vypnuté (log. 1)
        case s_mux_cnt is
            when "00" =>
                hex_digit <= data(3 downto 0);
                anode(0) <= '0';
            when "01" =>
                hex_digit <= data(7 downto 4);
                anode(1) <= '0';
            when "10" =>
                hex_digit <= data(11 downto 8);
                anode(2) <= '0';
            when "11" =>
                hex_digit <= data(15 downto 12);
                anode(3) <= '0';
            when others =>
                hex_digit <= x"0";
        end case;
    end process;
end Behavioral;
