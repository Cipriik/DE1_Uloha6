library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_digit_editor is
end tb_digit_editor;

architecture tb of tb_digit_editor is

    component digit_editor
        port (
            clk      : in  std_logic;
            rst      : in  std_logic;
            btnu     : in  std_logic;
            btnd     : in  std_logic;
            btnl     : in  std_logic;
            btnr     : in  std_logic;
            code_out : out std_logic_vector(15 downto 0);
            selected : out integer range 0 to 3;
            blink_on : out std_logic
        );
    end component;

    signal clk      : std_logic := '0';
    signal rst      : std_logic := '0';
    signal btnu     : std_logic := '0';
    signal btnd     : std_logic := '0';
    signal btnl     : std_logic := '0';
    signal btnr     : std_logic := '0';
    signal code_out : std_logic_vector(15 downto 0);
    signal selected : integer range 0 to 3;
    signal blink_on : std_logic;

    constant TbPeriod : time := 10 ns; 
    signal TbSimEnded : std_logic := '0';

begin

    dut : digit_editor
    port map (
        clk      => clk,
        rst      => rst,
        btnu     => btnu,
        btnd     => btnd,
        btnl     => btnl,
        btnr     => btnr,
        code_out => code_out,
        selected => selected,
        blink_on => blink_on
    );

    clk <= not clk after TbPeriod/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait for 100 ns;

        btnu <= '1'; wait for 100 ns; btnu <= '0';
        wait for 200 ns;

        btnr <= '1'; wait for 100 ns; btnr <= '0';
        wait for 200 ns;

        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0';
        wait for 200 ns;

        btnl <= '1'; wait for 100 ns; btnl <= '0';
        wait for 200 ns;

        btnd <= '1'; wait for 100 ns; btnd <= '0';
        wait for 200 ns;

        wait for 2 us;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;