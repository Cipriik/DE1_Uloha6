library ieee;
use ieee.std_logic_1164.all;

entity tb_safe_control_logic is
end tb_safe_control_logic;

architecture tb of tb_safe_control_logic is

    component safe_control_logic
        port (
            clk          : in  std_logic;
            rst          : in  std_logic;
            btn_press    : in  std_logic;
            entered_code : in  std_logic_vector(15 downto 0);
            secret_code  : in  std_logic_vector(15 downto 0);
            ledm16       : out std_logic;
            ledn16       : out std_logic
        );
    end component;

    signal clk          : std_logic := '0';
    signal rst          : std_logic := '0';
    signal btn_press    : std_logic := '0';
    signal entered_code : std_logic_vector(15 downto 0) := (others => '0');
    signal secret_code  : std_logic_vector(15 downto 0) := (others => '0');
    signal ledm16       : std_logic;
    signal ledn16       : std_logic;

    constant CLK_PERIOD : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- CLOCK
    --------------------------------------------------------------------
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;


    --------------------------------------------------------------------
    -- DUT
    --------------------------------------------------------------------
    dut : safe_control_logic
        port map (
            clk          => clk,
            rst          => rst,
            btn_press    => btn_press,
            entered_code => entered_code,
            secret_code  => secret_code,
            ledm16       => ledm16,
            ledn16       => ledn16
        );


    --------------------------------------------------------------------
    -- TEST
    --------------------------------------------------------------------
    stim_proc : process
    begin

        ----------------------------------------------------------------
        -- RESET
        ----------------------------------------------------------------
        rst <= '1';
        btn_press <= '0';
        entered_code <= x"0000";
        secret_code  <= x"1234";

        wait for 30 ns;

        rst <= '0';
        wait for 20 ns;

        assert ledm16 = '0'
            report "ERROR: Po resete ma byt ledm16 = 0"
            severity error;

        assert ledn16 = '0'
            report "ERROR: Po resete ma byt ledn16 = 0"
            severity error;


        ----------------------------------------------------------------
        -- SPRAVNY KOD
        ----------------------------------------------------------------
        entered_code <= x"1234";
        secret_code  <= x"1234";

        wait for 10 ns;

        btn_press <= '1';
        wait for CLK_PERIOD;

        btn_press <= '0';
        wait for 20 ns;

        assert ledm16 = '1'
            report "ERROR: Spravny kod nerozsvietil ledm16"
            severity error;

        assert ledn16 = '0'
            report "ERROR: Pri spravnom kode nema svietit ledn16"
            severity error;


        ----------------------------------------------------------------
        -- RESET PRED ZLYM KODOM
        ----------------------------------------------------------------
        rst <= '1';
        wait for 20 ns;

        rst <= '0';
        wait for 20 ns;


        ----------------------------------------------------------------
        -- ZLY KOD
        ----------------------------------------------------------------
        entered_code <= x"9999";
        secret_code  <= x"1234";

        wait for 10 ns;

        btn_press <= '1';
        wait for CLK_PERIOD;

        btn_press <= '0';
        wait for 20 ns;

        assert ledm16 = '0'
            report "ERROR: Pri zlom kode nema svietit ledm16"
            severity error;

        assert ledn16 = '1'
            report "ERROR: Zly kod nerozsvietil ledn16"
            severity error;


        ----------------------------------------------------------------
        -- KONIEC SIMULACIE
        ----------------------------------------------------------------
        assert false
            report "SIMULATION FINISHED"
            severity note;

        wait;

    end process;

end tb;