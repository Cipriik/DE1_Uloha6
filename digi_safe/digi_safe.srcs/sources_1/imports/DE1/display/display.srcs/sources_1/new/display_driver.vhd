library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_driver is
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;
        ce_refresh : in  STD_LOGIC;
        data       : in  STD_LOGIC_VECTOR (15 downto 0);
        -- Výstupy
        hex_digit  : out STD_LOGIC_VECTOR (3 downto 0);
        anode      : out STD_LOGIC_VECTOR (7 downto 0);
        seg        : out std_logic_vector(6 downto 0);
        dp         : out std_logic
    );
end display_driver;

architecture Behavioral of display_driver is

    component bin2seg is
        port (
            bin : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

    signal s_mux_cnt   : unsigned(1 downto 0) := "00";
    signal s_hex_digit : std_logic_vector(3 downto 0); -- Tento signál spája proces s dekodérom

begin
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
        anode <= (others => '1'); 
        case s_mux_cnt is
            when "00" =>
                s_hex_digit <= data(3 downto 0);
                anode(0)    <= '0';
            when "01" =>
                s_hex_digit <= data(7 downto 4);
                anode(1)    <= '0';
            when "10" =>
                s_hex_digit <= data(11 downto 8);
                anode(2)    <= '0';
            when "11" =>
                s_hex_digit <= data(15 downto 12);
                anode(3)    <= '0';
            when others =>
                s_hex_digit <= x"0";
        end case;
    end process;

    hex_digit <= s_hex_digit;

    bin2seg_0 : bin2seg
        port map (
            bin => s_hex_digit,
            seg => seg
        );

    dp <= '1';
end Behavioral;
