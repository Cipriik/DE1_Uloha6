library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_digi_safe is
end tb_digi_safe;

architecture tb of tb_digi_safe is

    component digi_safe
        port (
            clk       : in  std_logic;
            rst       : in  std_logic;
            btnu      : in  std_logic;
            btnd      : in  std_logic;
            btnl      : in  std_logic;
            btnr      : in  std_logic;
            btnc      : in  std_logic;
            ledm16    : out std_logic;
            ledn16    : out std_logic;
            seg       : out std_logic_vector (6 downto 0);
            an        : out std_logic_vector (7 downto 0)
        );
    end component;

    signal clk       : std_logic := '0';
    signal rst       : std_logic := '0';
    signal btnu      : std_logic := '0';
    signal btnd      : std_logic := '0';
    signal btnl      : std_logic := '0';
    signal btnr      : std_logic := '0';
    signal btnc      : std_logic := '0';
    signal ledm16    : std_logic;
    signal ledn16    : std_logic;
    signal seg       : std_logic_vector (6 downto 0);
    signal an        : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 10 ns; 
    signal TbSimEnded : std_logic := '0';

begin

    dut : digi_safe
    port map (
        clk       => clk,
        rst       => rst,
        btnu      => btnu,
        btnd      => btnd,
        btnl      => btnl,
        btnr      => btnr,
        btnc      => btnc,
        ledm16 => ledm16,
        ledn16   => ledn16,
        seg       => seg,
        an        => an
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

        btnr <= '1'; wait for 100 ns; btnr <= '0';
        wait for 200 ns;

        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0';
        wait for 200 ns;

        btnr <= '1'; wait for 100 ns; btnr <= '0';
        wait for 200 ns;

        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0'; wait for 100 ns;
        btnu <= '1'; wait for 100 ns; btnu <= '0';
        wait for 200 ns;

        btnc <= '1'; wait for 100 ns; btnc <= '0';

        wait for 1 us;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;