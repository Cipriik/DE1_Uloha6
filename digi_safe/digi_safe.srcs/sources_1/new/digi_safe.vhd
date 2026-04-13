library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity digi_safe is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sw : in STD_LOGIC_VECTOR (3 downto 0);
           btn_in : in STD_LOGIC;
           led_green : out STD_LOGIC;
           led_red : out STD_LOGIC;
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0));
end digi_safe;

architecture Behavioral of digi_safe is
   component debounce is
    Port(
            clk         : in STD_LOGIC;
            rst         : in STD_LOGIC;
            btn_in      : in STD_LOGIC;
            btn_state   : out STD_LOGIC;
            btn_press   : out STD_LOGIC
         );
   end component;

  component clk_en is
        generic ( G_MAX : positive );
        port (
            clk : in  std_logic;
            rst : in  std_logic;
            ce  : out std_logic
        );
    end component;

  component bin2seg is 
	port(
           binary: in std_logic_vector(3 downto 0);
           seg   : out std_logic_vector(6 downto 0)
	);
    end component;






         -- Signals
         signal s_btn_press : STD_LOGIC;
         signal s_shift_reg : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
         signal s_cnt       : integer range 0 to 4 := 0;

	 --For display
	 signal s_ce_refresh : std_logic;
    	 signal s_mux_cnt    : unsigned(1 downto 0) := "00";
    	 signal s_hex_digit  : std_logic_vector(3 downto 0);
         --Password
         constant SECRET_CODE : STD_LOGIC_VECTOR(15 downto 0) := x"6967";
         
begin
       debounce_0: debounce
            Port map(
                        clk         => clk,
                        rst         => rst,
                        btn_in      => btn_in,
                        btn_state   => open,
                        btn_press   => s_btn_press
                     );
               
process(clk, rst)
begin
    if rst = '1' then
        s_shift_reg <= (others => '0');
        s_cnt <= 0;
        led_green <= '0';
        led_red <= '0';
      elsif rising_edge(clk) then
        if s_btn_press = '1' and s_cnt < 4 then
            s_shift_reg <= s_shift_reg(11 downto 0) & sw;
            s_cnt <= s_cnt + 1;
         end if;
         
            if s_cnt = 4 then
                if s_shift_reg = SECRET_CODE then
                    led_green <= '1';
                    led_red   <= '0';
                else
                    led_green <= '0';
                    led_red   <= '1';
                end if;
             end if;
          end if;
       end process;




--Multiplexer
--slow switching nums
clk_en_display: clk_en
     generic map (G_MAX =>2) --for sim
     port map(clk => clk,
	      rst => rst,
              ce  => s_ce_refresh);


--Counter of multiplexer
p_mux_cnt : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                s_mux_cnt <= "00";
            elsif s_ce_refresh = '1' then
                s_mux_cnt <= s_mux_cnt + 1;
            end if;
        end if;
    end process;


p_mux_select : process(s_mux_cnt, s_shift_reg)
    begin
----
----
----
----
end process;


end Behavioral;

