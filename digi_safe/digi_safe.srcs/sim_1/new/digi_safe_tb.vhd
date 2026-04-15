library ieee;
use ieee.std_logic_1164.all;

entity tb_digi_safe is
end tb_digi_safe;

architecture tb of tb_digi_safe is

    component digi_safe
        port (clk       : in std_logic;
              rst       : in std_logic;
              sw        : in std_logic_vector (3 downto 0);
              btn_in    : in std_logic;
              led_green : out std_logic;
              led_red   : out std_logic;
              seg       : out std_logic_vector (6 downto 0);
              an        : out std_logic_vector (7 downto 0));
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal sw        : std_logic_vector (3 downto 0);
    signal btn_in    : std_logic;
    signal led_green : std_logic;
    signal led_red   : std_logic;
    signal seg       : std_logic_vector (6 downto 0);
    signal an        : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 100 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : digi_safe
    port map (clk       => clk,
              rst       => rst,
              sw        => sw,
              btn_in    => btn_in,
              led_green => led_green,
              led_red   => led_red,
              seg       => seg,
              an        => an);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        sw <= (others => '0');
        btn_in <= '0';

        -- Reset generation
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        -- ***EDIT*** Add stimuli here
        wait for 100 * TbPeriod;

        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

configuration cfg_tb_digi_safe of tb_digi_safe is
    for tb
    end for;
end cfg_tb_digi_safe;