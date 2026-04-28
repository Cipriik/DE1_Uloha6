library ieee;
use ieee.std_logic_1164.all;

entity tb_safe_control_logic is
end tb_safe_control_logic;

architecture tb of tb_safe_control_logic is

    component safe_control_logic
        port (clk         : in std_logic;
              rst         : in std_logic;
              btn_press   : in std_logic;
              sw          : in std_logic_vector (3 downto 0);
              secret_code : in std_logic_vector (15 downto 0);
              shift_reg   : out std_logic_vector (15 downto 0);
              led_green   : out std_logic;
              led_red     : out std_logic);
    end component;

    signal clk         : std_logic;
    signal rst         : std_logic;
    signal btn_press   : std_logic;
    signal sw          : std_logic_vector (3 downto 0);
    signal secret_code : std_logic_vector (15 downto 0);
    signal shift_reg   : std_logic_vector (15 downto 0);
    signal led_green   : std_logic;
    signal led_red     : std_logic;

    constant TbPeriod : time := 100 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : safe_control_logic
    port map (clk         => clk,
              rst         => rst,
              btn_press   => btn_press,
              sw          => sw,
              secret_code => secret_code,
              shift_reg   => shift_reg,
              led_green   => led_green,
              led_red     => led_red);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        btn_press <= '0';
        sw <= (others => '0');
        secret_code <= (others => '0');

        -- Reset generation
        -- ***EDIT*** Check that rst is really your reset signal
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

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_safe_control_logic of tb_safe_control_logic is
    for tb
    end for;
end cfg_tb_safe_control_logic;