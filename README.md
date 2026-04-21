# DE1_Uloha6
Digital Safe / Combination Lock
Implement a 4-digit code entry system with visual feedback. Store entered codes in registers and compare to the preset combination to indicate success or failure.

1. hodina - Začali sme robiť základnú blokovú schému, spravili základný digi_safe.vhd a zakomponovali do neho debounce. Do projektu sme pridali aj súbory display_driver, bin_2_seg a counter.

2. Zde diagram, obsahuje základní debounce plus dvě komponenty, které později připojím

V tomhle projektu řešíme digitální zámek. V kódu jsme zakomponovali heslo pro pro rozsvícení led kontrolky určitou barvou, uživatel zadává čísla pomocí tzv. switchů (na vstupu komponenty SW[3:0]) heslo může být zadáno 10 tisíci kombinacemi. Uživatel pracuje se switchemi pomocí  principu posuvného registru (Shift Register). Je to řetězec, kde každé nové číslo vytlačí to nejstarší. Náš registr je rozdělen na 4 sloty po 4 bitech. 
  Slot 4 (nejstarší) se vymaže.
  Slot 3 se posune na místo slotu 4.
  Slot 2 se posune na místo slotu 3.
  Slot 1 se posune na místo slotu 2.
  Nové číslo ze switchů sw se zapíše do uvolněného slotu 1.
Shiftujeme (přesouváme) čísla pomocí tlačítka Btnc. Pokud nemáme správné heslo tak se rozsvítí po všech zadaných číslech LED dioda na červeno. Pokud jsme zadali správně heslo tak se rozsvítí zelená LED dioda.
Čísla se zadávají binárním způsobem tedy například 0011 by znamenalo číslo 2+1 tedy 3. 


![image alt](https://github.com/Cipriik/DE1_Uloha6/blob/365e246a7b02a11b814ce18ed331d33443140402/image.png)
