library ieee;
use ieee.std_logic_1164.all;

entity tb_bin2seg is
end tb_bin2seg;

architecture tb of tb_bin2seg is

    component bin2seg
        port (bin : in std_logic_vector (3 downto 0);
              seg : out std_logic_vector (6 downto 0));
    end component;

    signal bin : std_logic_vector (3 downto 0);
    signal seg : std_logic_vector (6 downto 0);

begin

    dut : bin2seg
    port map (bin => bin,
              seg => seg);

    stimuli : process
    begin
        -- ***EDIT*** Adapt initialization as needed
        bin <= (others => '0');

        -- ***EDIT*** Add stimuli here

        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_bin2seg of tb_bin2seg is
    for tb
    end for;
end cfg_tb_bin2seg;
