# DE1_Uloha6
Digital Safe / Combination Lock
Implement a 4-digit code entry system with visual feedback. Store entered codes in registers and compare to the preset combination to indicate success or failure.

1. hodina - Začali sme robiť základnú blokovú schému, spravili základný digi_safe.vhd a zakomponovali do neho debounce. Do projektu sme pridali aj súbory display_driver, bin_2_seg a counter.

2. Zde diagram, obsahuje základní debounce plus dvě komponenty, které později připojím

V tomhle projektu řešíme digitální zámek. V kódu jsme zakomponovali heslo pro pro rozsvícení led kontrolky určitou barvou, uživatel zadává čísla pomocí tzv. switchů (na vstupu komponenty SW[3:0]) heslo může být zadáno 10 tisíci kombinacemi. Uživatel pracuje se switchemi pomocí  principu posuvného registru (Shift Register). 

Je to řetězec, kde každé nové číslo vytlačí to nejstarší. Náš registr je rozdělen na 4 sloty po 4 bitech.

  Slot 4 (nejstarší) se vymaže.
  
  Slot 3 se posune na místo slotu 4.
  
  Slot 2 se posune na místo slotu 3.
  
  Slot 1 se posune na místo slotu 2.
  
  Nové číslo ze switchů sw se zapíše do uvolněného slotu 1.
  
Shiftujeme (přesouváme) čísla pomocí tlačítka Btnc. Pokud nemáme správné heslo tak se rozsvítí po všech zadaných číslech LED dioda na červeno. Pokud jsme zadali správně heslo tak se rozsvítí zelená LED dioda.

Čísla se zadávají binárním způsobem tedy například 0011 by znamenalo číslo 2+1 tedy 3. 

| Port name | Direction | Type | Description |
| :--- | :---: | :--- | :--- |
| **clk** | in | `std_logic` | System clock signal |
| **btnu** | in | `std_logic` | Reset button |
| **btnc** | in | `std_logic` | Confirm shift number button |
| **sw** | in | `std_logic_vector(3 downto 0)` | Switch used for binary numbers |
| **led_red** | out | `std_logic` |  Wrong password (red LED) |
| **led_green** | out | `std_logic` |  Correct password(green LED) |
| **seg** | out | `std_logic_vector(6 downto 0)` | 7-segment display cathodes (CA–CG, active-low) |
| **dp** | out | `std_logic` | Decimal point (active-low) |
| **anode** | out | `std_logic_vector(7 downto 0)` | 7-segment display anodes (AN7–AN0, active-low) |

![image alt](https://github.com/Cipriik/DE1_Uloha6/blob/446b895d32d7b08f2fb61433a62882deee007493/schema.png)

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/46c84bc1a03707b4ca8bbe6d2e278e0ed7f9b273/linter.png)

Zde v tomto projektu jsme udělali tzv. Testbenche s cílem potvrdit správnost implementované logiky, v oblasti generování řídicích signálů a časové synchronizace. Testbench zde vlastně slouží pro simulaci hardwarové části

clk_en_tb

Testbench generátoru systémového hodinového signálu clk s pevně definovanou periodou TbPeriod, odpovídá cílové pracovní frekvenci aplikace. 

Stabilita simulace je zajištěna úvodní resetovací sekvencí. Během ní je signál rst držen v aktivní logické úrovni, což vynucuje přechod všech vnitřních registrů a stavových automatů do definovaných výchozích stavů. Reset zde eliminuje vznik nedefinovaných přechodových jevů.

Funkce signálu Clock Enable (CE). Testbench potvrzuje, že tento signál pracuje v plné synchronizaci s náběžnou hranou hlavních hodin, což je potřebné  pro FPGA. Testbench ukazuje, že clock enable je zde jako  synchronní dělička frekvence se střídou 50 %. Tzn., že zatímco hlavní hodiny běží kontinuálně, signál CE selektivně povoluje zápis dat nebo změnu vnitřního stavu navazujících modulů v každém druhém taktu. Takto jsme dosáhli přesného řízení datového toku.

Výstupy ze simulátoru generují pulzy s přesnou periodicitou a bez fázového posunu vůči referenčním hodinám.

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/c427b204c03fd7ea259b0f3681181e79477f5cc0/clk_en_tb.png)

debounce_tb

Testování pro pro zamezení tzv. debouncingu bylo zaměřeno na ověření správné detekce stabilního stavu vstupu a generování relevantních výstupních příznaků. 
Testovací proces začíná ukázkou signálu rst, který po dobu prvních 40 ns drží vnitřní registry v nulovém stavu, což je v simulaci ukázáno přechodem z neznámých hodnot do definované logické nuly. 
Po uvolnění resetu pracuje modul synchronně s hlavními hodinami clk o periodě 100 ns.

Z naměřených průběhů je patrné, že testbench simuluje přechodový jev na vstupním portu btn_in. Hlavním cílem simulace je prokázat, že výstupy btn_state (indikující aktuální stabilní stav tlačítka) a btn_press (krátký pulz signalizující okamžik stisku) reagují pouze na vstupy, které vykazují dostatečnou stabilitu v čase. 
Na snímku je zachycena fáze po uvolnění resetu, kdy systém čeká na stabilizaci vstupu předtím, než změní stav výstupních signálů. Synchronizace všech změn s náběžnou hranou hodin potvrzuje eliminace mechanických zákmitů kritická pro správnou funkci uživatelského rozhraní. Výsledná simulace ukazuje, že modul efektivně filtruje krátké parazitní jevy a poskytuje čistý, časově zarovnaný signál pro další zpracování v FPGA.

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/c427b204c03fd7ea259b0f3681181e79477f5cc0/debounce_tb.png)

digi_safe_tb

Simulace zde zachycuje počáteční fázi provozu modulu digitálního trezoru, přičemž se zaměřuje na proces inicializace a stabilitu systému v klidovém stavu.
Celková délka zobrazené simulace je 1000ns, s periodou clocku nastavenou na 100ns. 
Ukázka začíná aktivací resetovacího signálu rst, který je držen v logické jedničce po dobu prvního hodinového cyklu. Během této fáze dochází k odstranění nedefinovaných stavů na výstupních signálech led_green a led_red, které se následně ustálí na logické nule. Vstupy systému, jsou řešeny přepínači sw[3:0] a potvrzovacím tlačítkem btn_in (na desce nexys btnc), jsou v této fázi simulace udržovány na nulových hodnotách. To umožňuje ověřit chování systému v tzv. "IDLE" stavu. Výstupy určené pro sedmisegmentovku, konkrétně sběrnice seg[6:0] s hodnotou 01 a anoda an[7:0] s hexadecimální hodnotou FE, indikují aktivitu zobrazení. Hodnota FE (binárně 11111110) značí, že je aktivní pouze první pozice displeje. Z časového průběhu vyplývá, že celý systém pracuje v plné synchronizaci s náběžnou hranou clocku.

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/c427b204c03fd7ea259b0f3681181e79477f5cc0/digi_safe_tb.png)

safe_control_tb

Zde simulace ověřuje součinnost 16bitového posuvného registru a porovnávací logiky. Po odeznění počátečního resetu, který bezpečně nuluje veškeré vnitřní stavy, je systém připraven k postupnému načítání dat. Vstupní 4bitová hodnota ze sběrnice sw[3:0] je připravena k sériovému posunu do registru shift_reg[15:0].

V každém taktu probíhá paralelní porovnání obsahu uživatelského registru s referenční hodnotou v secret_reg[15:0]. Průběh signálů potvrzuje, že výstupy led_green a led_red jsou drženy v logické nule až do okamžiku finálního vyhodnocení. Tato konfigurace zaručuje, že nedojde k falešnému povolení přístupu během procesu posouvání bitů v registru. 

![image_alt](https://github.com/Cipriik/DE1_Uloha6/blob/c427b204c03fd7ea259b0f3681181e79477f5cc0/safe_control_logic_tb.png)
