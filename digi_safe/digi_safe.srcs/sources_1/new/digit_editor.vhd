library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity digit_editor is
    Port (
        clk        : in  STD_LOGIC;
        rst        : in  STD_LOGIC;

        btnu       : in  STD_LOGIC;
        btnd       : in  STD_LOGIC;
        btnl       : in  STD_LOGIC;
        btnr       : in  STD_LOGIC;

        code_out   : out STD_LOGIC_VECTOR(15 downto 0);
        selected   : out INTEGER range 0 to 3;
        blink_on   : out STD_LOGIC
    );
end digit_editor;

architecture Behavioral of digit_editor is

    signal s_code : STD_LOGIC_VECTOR(15 downto 0) := x"0000";
    signal s_pos  : INTEGER range 0 to 3 := 0;

    signal btnu_old : STD_LOGIC := '0';
    signal btnd_old : STD_LOGIC := '0';
    signal btnl_old : STD_LOGIC := '0';
    signal btnr_old : STD_LOGIC := '0';

    signal blink_counter : unsigned(25 downto 0) := (others => '0');
    signal blink_state   : STD_LOGIC := '1';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_code <= x"0000";
                s_pos  <= 0;

                btnu_old <= '0';
                btnd_old <= '0';
                btnl_old <= '0';
                btnr_old <= '0';

                blink_counter <= (others => '0');
                blink_state   <= '1';

            else
                blink_counter <= blink_counter + 1;

                if blink_counter = 50_000_000 then
                    blink_counter <= (others => '0');
                    blink_state <= not blink_state;
                end if;

                if btnu = '1' and btnu_old = '0' then
                    case s_pos is
                        when 0 =>
                            if s_code(15 downto 12) = "1001" then
                                s_code(15 downto 12) <= "0000";
                            else
                                s_code(15 downto 12) <= std_logic_vector(unsigned(s_code(15 downto 12)) + 1);
                            end if;

                        when 1 =>
                            if s_code(11 downto 8) = "1001" then
                                s_code(11 downto 8) <= "0000";
                            else
                                s_code(11 downto 8) <= std_logic_vector(unsigned(s_code(11 downto 8)) + 1);
                            end if;

                        when 2 =>
                            if s_code(7 downto 4) = "1001" then
                                s_code(7 downto 4) <= "0000";
                            else
                                s_code(7 downto 4) <= std_logic_vector(unsigned(s_code(7 downto 4)) + 1);
                            end if;

                        when 3 =>
                            if s_code(3 downto 0) = "1001" then
                                s_code(3 downto 0) <= "0000";
                            else
                                s_code(3 downto 0) <= std_logic_vector(unsigned(s_code(3 downto 0)) + 1);
                            end if;
                    end case;
                end if;

                if btnd = '1' and btnd_old = '0' then
                    case s_pos is
                        when 0 =>
                            if s_code(15 downto 12) = "0000" then
                                s_code(15 downto 12) <= "1001";
                            else
                                s_code(15 downto 12) <= std_logic_vector(unsigned(s_code(15 downto 12)) - 1);
                            end if;

                        when 1 =>
                            if s_code(11 downto 8) = "0000" then
                                s_code(11 downto 8) <= "1001";
                            else
                                s_code(11 downto 8) <= std_logic_vector(unsigned(s_code(11 downto 8)) - 1);
                            end if;

                        when 2 =>
                            if s_code(7 downto 4) = "0000" then
                                s_code(7 downto 4) <= "1001";
                            else
                                s_code(7 downto 4) <= std_logic_vector(unsigned(s_code(7 downto 4)) - 1);
                            end if;

                        when 3 =>
                            if s_code(3 downto 0) = "0000" then
                                s_code(3 downto 0) <= "1001";
                            else
                                s_code(3 downto 0) <= std_logic_vector(unsigned(s_code(3 downto 0)) - 1);
                            end if;
                    end case;
                end if;

                if btnr = '1' and btnr_old = '0' then
                    if s_pos = 3 then
                        s_pos <= 0;
                    else
                        s_pos <= s_pos + 1;
                    end if;
                end if;

                if btnl = '1' and btnl_old = '0' then
                    if s_pos = 0 then
                        s_pos <= 3;
                    else
                        s_pos <= s_pos - 1;
                    end if;
                end if;

                btnu_old <= btnu;
                btnd_old <= btnd;
                btnl_old <= btnl;
                btnr_old <= btnr;
            end if;
        end if;
    end process;

    code_out <= s_code;
    selected <= s_pos;
    blink_on <= blink_state;

end Behavioral;