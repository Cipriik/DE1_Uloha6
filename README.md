# DE1_Uloha6
Digital Safe / Combination Lock
Implement a 4-digit code entry system with visual feedback. Store entered codes in registers and compare to the preset combination to indicate success or failure.

1. hodina - Začali sme robiť základnú blokovú schému, spravili základný digi_safe.vhd a zakomponovali do neho debounce. Do projektu sme pridali aj súbory display_driver, bin_2_seg a counter.

2. Zde diagram, obsahuje základní debounce plus dvě komponenty, které později připojím

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

##Bloková schéma

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/df86a58035c3521a5049305c993d1fe48ce598b0/final%20schema.png)

Zde popisujeme soubory projektu:

## Top projektu

[digi_safe.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sources_1/new/digi_safe.vhd)

Testbench projektu

[digi_safe_tb.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sim_1/new/digi_safe_tb.vhd)

Inputy:
* clk - 100 MHz systémový clock z desky Nexys A7-50T
* rst -  Globální reset tlačítko (na desce také btnu) 
* btnc -  tlačítko, které slouží pro shiftování přes sloty
* sw - nastavování čísel pro heslo (binárně)

Outputy
* led_green - led dioda která se rozsvítí při správném zadání hesla
* led_red - led dioda která se rozsvítí při špatném zadání hesla
* seg - 7 segmentový display
* an - anody

## clk_en

[clk_en_tb.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sim_1/new/clk_en_tb.vhd)

[clk_en](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sources_1/imports/new/clk_en.vhd)

Inputy
* clk - systémový clock
* rst -  Globální reset
Outputy
* ce - výstup clk_en

## safe_control_logic

[safe_control_logic.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sources_1/new/safe_control_logic.vhd)

[safe_control_tb.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sources_1/new/safe_control_logic.vhd)

Inputy
* clk - systémový clock
* rst -  Globální reset
* sw - switch
* secret_code - tajný kód námi nastavený
Outputy
* shift_reg - shiftování registru
* led_green - výstup zelené led diody
* led_red - výstup červené led diody

## debounce

[debounce.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sources_1/imports/new/debounce.vhd)

[debounce_tb.vhd](https://github.com/Cipriik/DE1_Uloha6/blob/main/digi_safe/digi_safe.srcs/sim_1/new/debounce_tb.vhd)

Inputy
* clk - systémový clock
* rst -  Globální reset
* btn_in - vstup tlačítka

Outputy
* btn_press - Uživatel stiskne tlačítko a btn_press půjde do 1 jen na jeden takt clk a hned se vrátí do 0.
* btn_state - Zjištění zda je na 1 nebo 0.


Zde v tomto projektu jsme udělali tzv. Testbenche s cílem potvrdit správnost implementované logiky, v oblasti generování řídicích signálů a časové synchronizace. Testbench zde vlastně slouží pro simulaci hardwarové části


## digi_safe_tb

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/9bc76df5b71bd33921422fe5e3c2dab055cb0577/Simul%C3%A1cia%20digi_safe.png)

Simulácia obsahuje interakcie medzi ovládacími prvkami a logikou digitálneho trezoru.

Reset - Signál rst inicializuje systém, následne kód s_code sa nastaví na 0000 a ukazovateľ pozície s_pos na prvé číslo.

Nadstavenie prvej cifry - Stlačenie tlačidla btnu (button up) zmení prvú hodnotu o jednu hodnotu nahor

Posunutie kurzora - btnr (button right) mení s_pos z 1 na 2 pozíciu čím vieme editovať ďalšiu hodnotu

Nadstavenie druhej cifry - Stlačenie tlačidla btnu (button up) zmení druhú hodnotu o jednu hodnotu nahor

Multiplexovanie displeja - Zmeny v signáloch an (anóda) a seg (segmenty) ukazujú že prebieha proces dynamického prepínania číslic

## safe_control_tb  //prerobiť ešte

Zde simulace ověřuje součinnost 16bitového posuvného registru a porovnávací logiky. Po odeznění počátečního resetu, který bezpečně nuluje veškeré vnitřní stavy, je systém připraven k postupnému načítání dat. Vstupní 4bitová hodnota ze sběrnice sw[3:0] je připravena k sériovému posunu do registru shift_reg[15:0].

V každém taktu probíhá paralelní porovnání obsahu uživatelského registru s referenční hodnotou v secret_reg[15:0]. Průběh signálů potvrzuje, že výstupy led_green a led_red jsou drženy v logické nule až do okamžiku finálního vyhodnocení. Tato konfigurace zaručuje, že nedojde k falešnému povolení přístupu během procesu posouvání bitů v registru. 

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/c427b204c03fd7ea259b0f3681181e79477f5cc0/safe_control_logic_tb.png)

