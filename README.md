# DE1_Uloha6
Digital Safe / Combination Lock
Implement a 4-digit code entry system with visual feedback. Store entered codes in registers and compare to the preset combination to indicate success or failure.


V tomhle projektu řešíme digitální zámek. V kódu jsme zakomponovali heslo pro pro rozsvícení led kontrolky určitou barvou, uživatel zadává čísla pomocí tzv. buttons. Heslo může být zadáno 10 tisíci kombinacemi. Uživatel pracuje s buttons pomocí  principu posuvného registru (Shift Register). 

Aktuálny projekt funguje tak že nám zasvieti displej a začne blikať číslo ktoré aktuálne zadávame. Číslo vieme meniť pomocou btnu a btnd (Button up a Button down). Vieme prepnúť pozíciu čísla ktoré meníme pomocou btnl a btnr (Button left a Button right). Číslo ktoré sme už vybrali vieme kedykoľvek zmeniť opätovným presunutím sa na jeho pozíćiu. Keď máme celý kód vybraný stlačíme btnc (Button confirm) a podľa správnosti kódu zasvieti ledn16 a ledm16 ( Zelená alebo červená ledka). Pokiaľ chceme kód resetovať použijeme na to prvý switch.
  

| Port name | Direction | Type | Description |
| :--- | :---: | :--- | :--- |
| **clk** | in | `std_logic` | System clock signal |
| **rst** | in | `std_logic` | Asynchronous reset |
| **btnu** | in | `std_logic` | Button - increment selected digit |
| **btnd** | in | `std_logic` | Button - decrement selected digit |
| **btnl** | in | `std_logic` | Button - move selection left |
| **btnr** | in | `std_logic` | Button - move selection right |
| **btnc** | in | `std_logic` | Button - confirm entered code |
| **ledn16** | out | `std_logic` |  Wrong password (red LED) |
| **ledm16** | out | `std_logic` |  Correct password(green LED) |
| **seg** | out | `std_logic_vector(6 downto 0)` | 7-segment display cathodes (active-low) |
| **an** | out | `std_logic_vector(7 downto 0)` | 7-segment display anodes (digit selection, active-low) |

## Video 

Vo videu demonštrujeme fungovanie projektu a popisujeme ako funguje
[Video](https://www.youtube.com/shorts/0L7l6XuYVXE)

## Bloková schéma

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/cfa4f29539304cef6e23f11bd03cdba220a41803/linter.png)

Zde popisujeme soubory projektu:

## Top projektu

[digi_safe.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sources_1/new/digi_safe.vhd)

Inputy:
* clk - 100 MHz systémový clock z desky Nexys A7-50T
* rst -  Globální reset tlačítko (na desce také sw) 
* btnu -  tlačítko, které slouží pro zvyšovanie hodnôt na displeji
* btnd -  tlačítko, které slouží pro zmenšovanie hodnôt na displeji
* btnl -  tlačítko, které slouží pro posúvanie upravvaného čísla o 1 pozíciu doľava
* btnr - tlačítko, které slouží pro posúvanie upravovaného čísla o 1 pozíciu doprava

Outputy
* ledm16 - led dioda která se rozsvítí při správném zadání hesla
* ledn16 - led dioda která se rozsvítí při špatném zadání hesla
* seg - 7 segmentový display
* an - anody

Testbench projektu

[digi_safe_tb.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sim_1/new/digi_safe_tb.vhd)

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/9bc76df5b71bd33921422fe5e3c2dab055cb0577/Simul%C3%A1cia%20digi_safe.png)

Simulácia obsahuje interakcie medzi ovládacími prvkami a logikou digitálneho trezoru.

Reset - Signál rst inicializuje systém, následne kód s_code sa nastaví na 0000 a ukazovateľ pozície s_pos na prvé číslo.

Nadstavenie prvej cifry - Stlačenie tlačidla btnu (button up) zmení prvú hodnotu o jednu hodnotu nahor

Posunutie kurzora - btnr (button right) mení s_pos z 1 na 2 pozíciu čím vieme editovať ďalšiu hodnotu

Nadstavenie druhej cifry - Stlačenie tlačidla btnu (button up) zmení druhú hodnotu o jednu hodnotu nahor

Multiplexovanie displeja - Zmeny v signáloch an (anóda) a seg (segmenty) ukazujú že prebieha proces dynamického prepínania číslic


## safe_control_logic

[safe_control_logic.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sources_1/new/safe_control_logic.vhd)


Inputy
* clk - systémový clock
* rst -  Globální reset
* btn_press
* secret_code - tajný kód námi nastavený
* entered_code - zadaný kód ktorý sa porovnáva so secret_code

Outputy
* ledm16 - výstup zelené led diody
* ledn16 - výstup červené led diody

[safe_control_tb.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/2051a70c417804a45e1742274a433fd7e66df454/digi_safe/digi_safe.srcs/sim_1/new/tb_safe_control_logic.vhd)

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/6ffa87974b3be3068188db19688ab7df12ccdcc1/safe_control_logic_tb.png)

Začiatok simulácie: 
clk beží pravidelne

rst = 0 systém nie je resetovaný

entered_code bliká ako 0000 - nesvieti žiadna led, následne príde signál btn_press (stláčanie tlačidiel a menenie kódu)

zadaný kód sa následne mení na 1234, to je náš secret_code => svieti zelená LED (ledm16)

ku koncu príde signál rst => resetuje sa kód a zadávame druhý, v našom prípade 9999 a stláčame btn_press

zadaný kód sa porovná so secret_code a zistí sa že je nesprávny => svieti červená LED (ledn16)

## digit_editor

[digit_editor.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/23dc0b6d0e45e6ec9dac9e16aff0f083e60cca73/digi_safe/digi_safe.srcs/sources_1/new/digit_editor.vhd)

Inputy
* clk - systémový clock
* rst - globálny reset
* btnu -  tlačítko, které slouží pro zvyšovanie hodnôt na displeji
* btnd -  tlačítko, které slouží pro zmenšovanie hodnôt na displeji
* btnl -  tlačítko, které slouží pro posúvanie upravvaného čísla o 1 pozíciu doľava
* btnr - tlačítko, které slouží pro posúvanie upravovaného čísla o 1 pozíciu doprava

Outputy
* code_out (15 downto 0) - výsledný 16 bitový kód
* selected (range 0 to 3) -index vybranej číslice
* blink_on - signál blikania, mení svoj stav medzi 0 a 1 na práve vybratej číslici

## clk_en

[clk_en](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sources_1/imports/new/clk_en.vhd)

Inputy
* clk - systémový clock
* rst -  Globální reset
Outputy
* ce - výstup clk_en


## debounce

[debounce.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sources_1/imports/new/debounce.vhd)


Inputy
* clk - systémový clock
* rst -  Globální reset
* btn_in - vstup tlačítka

Outputy
* btn_press - Uživatel stiskne tlačítko a btn_press půjde do 1 jen na jeden takt clk a hned se vrátí do 0.
* btn_state - Zjištění zda je na 1 nebo 0.



## Rozdelenie úloh v tíme
Cipro - vytvorenie prvotného kódu, robenie testbenchov, .xdc súbor, schéma

Atanasov - readme, spravenie plagátu, úprava kódov pre lepšiu funkčnosť, schéma

Borot - implementácia návrhov na zlepšenie od profesora do kódu, vytvorenie kódu na ovládanie cez btns a instantnej odozvy displeja
                    
