library ieee;
use ieee.std_logic_1164.all;

entity tb_debounce is
end tb_debounce;

architecture tb of tb_debounce is

    component debounce
        port (clk       : in std_logic;
              rst       : in std_logic;
              btn_in    : in std_logic;
              btn_state : out std_logic;
              btn_press : out std_logic);
    end component;

    signal clk       : std_logic;
    signal rst       : std_logic;
    signal btn_in    : std_logic;
    signal btn_state : std_logic;
    signal btn_press : std_logic;

    constant TbPeriod : time := 100 ns; -- ***EDIT*** Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : debounce
    port map (clk       => clk,
              rst       => rst,
              btn_in    => btn_in,
              btn_state => btn_state,
              btn_press => btn_press);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- ***EDIT*** Check that clk is really your main clock signal
    clk <= TbClock;

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        btn_in <= '0';

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

configuration cfg_tb_debounce of tb_debounce is
    for tb
    end for;
end cfg_tb_debounce;