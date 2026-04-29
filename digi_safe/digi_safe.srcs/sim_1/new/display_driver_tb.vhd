library ieee;
use ieee.std_logic_1164.all;

entity tb_display_driver is
end tb_display_driver;

architecture tb of tb_display_driver is

    component display_driver
        port (clk        : in std_logic;
              rst        : in std_logic;
              ce_refresh : in std_logic;
              data       : in std_logic_vector (15 downto 0);
              hex_digit  : out std_logic_vector (3 downto 0);
              anode      : out std_logic_vector (7 downto 0);
              seg        : out std_logic_vector (6 downto 0);
              dp         : out std_logic);
    end component;

    signal clk        : std_logic;
    signal rst        : std_logic;
    signal ce_refresh : std_logic;
    signal data       : std_logic_vector (15 downto 0);
    signal hex_digit  : std_logic_vector (3 downto 0);
    signal anode      : std_logic_vector (7 downto 0);
    signal seg        : std_logic_vector (6 downto 0);
    signal dp         : std_logic;

    constant TbPeriod : time := 100 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : display_driver
    port map (clk        => clk,
              rst        => rst,
              ce_refresh => ce_refresh,
              data       => data,
              hex_digit  => hex_digit,
              anode      => anode,
              seg        => seg,
              dp         => dp);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        ce_refresh <= '0';
        data <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        wait for 10 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;


configuration cfg_tb_display_driver of tb_display_driver is
    for tb
    end for;
end cfg_tb_display_driver;