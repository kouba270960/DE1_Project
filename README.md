# LED Ping-Pong

Semestralni projekt do predmetu Digital Electronics 1. Projekt implementuje jednoduchou reakční hru LED Ping-Pong ve VHDL pro desku Nexys A7-50T. Jedna rozsvicena LED predstavuje micek, ktery se pohybuje mezi hraci. Hraci jej odrazeji tlacitky na krajich herniho pole; pokud hrac nestihne odraz, bod ziska souper.

## Tym

- Jakub Kriva
- Jonas Salich
- Pavel Stastny

## Zadani a princip hry

Hra vyuziva 16 LED, pet tlacitek a sedmisegmentovy displej. Micek se pohybuje po LED poli, smer se meni podle stisku hracskych tlacitek na spravne strane. Rychlost pohybu lze menit tlacitky `btnu` a `btnd`. Aktualni skore a nastavena rychlost se zobrazuji na sedmisegmentovem displeji.

Po resetu se hra vrati do vychoziho stavu. Signal `clk` slouzi jako hlavni hodinovy signal, `btnc` jako reset. Blok `clk_en2` vytvari posuvne impulzy pro pohyb micku a blok `cnt_b_bd` nastavuje rychlost.

## Blokove schema

![Project block diagram](DE_1.drawio.png)

## I/O porty top-levelu

Top-level komponenta: [PingPong_top.vhd](LED-PingPong/src/PingPong_top.vhd)

| Port | Smer | Sirka | Popis |
| --- | --- | ---: | --- |
| `clk` | input | 1 | Hlavni hodinovy signal z desky Nexys A7-50T. |
| `btnc` | input | 1 | Stredove tlacitko, reset hry. |
| `btnl` | input | 1 | Tlacitko leveho hrace. |
| `btnr` | input | 1 | Tlacitko praveho hrace. |
| `btnu` | input | 1 | Zvyseni rychlosti micku. |
| `btnd` | input | 1 | Snizeni rychlosti micku. |
| `led` | output | 16 | LED pole zobrazujici pozici micku. |
| `seg` | output | 7 | Segmenty sedmisegmentoveho displeje. |
| `an` | output | 8 | Vyber aktivni anody sedmisegmentoveho displeje. |

## Struktura repozitare

| Slozka | Obsah |
| --- | --- |
| `LED-PingPong/src/` | Zdrojove VHDL komponenty. |
| `LED-PingPong/sim/` | Testbenche a simulacni soubory. |
| `LED-PingPong/sim/img/` | Obrazky prubehu simulaci. |
| `LED-PingPong/constr/` | XDC constraints pro desku Nexys A7-50T. |
| `LED-PingPong/vivado/` | Vivado projekt. |
| `LED-PingPong/docs/` | Dalsi dokumentace a vystupy. |

## Hlavni komponenty

| Komponenta | Soubor | Uloha v projektu |
| --- | --- | --- |
| `PingPong_top` | [LED-PingPong/src/PingPong_top.vhd](LED-PingPong/src/PingPong_top.vhd) | Propojeni cele hry, tlacitek, pohybu micku, skore a displeje. |
| `cnt_d_bd` | [LED-PingPong/src/cnt_d_bd.vhd](LED-PingPong/src/cnt_d_bd.vhd) | Citac pozice micku a generovani LED vystupu. |
| `cnt_b_bd` | [LED-PingPong/src/cnt_b_bd.vhd](LED-PingPong/src/cnt_b_bd.vhd) | 3bitovy citac nastaveni rychlosti. |
| `clk_en2` | [LED-PingPong/src/clk_en2.vhd](LED-PingPong/src/clk_en2.vhd) | Nastavitelny clock-enable generator pro rychlost hry. |
| `clk_en` | [LED-PingPong/src/clk_en.vhd](LED-PingPong/src/clk_en.vhd) | Clock-enable generator pouzity v pomocnych blocich. |
| `debounce` | [LED-PingPong/src/debounce.vhd](LED-PingPong/src/debounce.vhd) | Odfiltrovani zakmitu tlacitek. |
| `counter10` | [LED-PingPong/src/counter10.vhd](LED-PingPong/src/counter10.vhd) | Dekadicky citac skore. |
| `display_driver` | [LED-PingPong/src/display_driver.vhd](LED-PingPong/src/display_driver.vhd) | Multiplex sedmisegmentoveho displeje. |
| `bin2seg` | [LED-PingPong/src/bin2seg.vhd](LED-PingPong/src/bin2seg.vhd) | Prevod 4bitove hodnoty na segmenty displeje. |
| `RSFlipFlop` | [LED-PingPong/src/RSFlipFlop.vhd](LED-PingPong/src/RSFlipFlop.vhd) | RS klopny obvod pro uchovani smeru. |
| `counter` | [LED-PingPong/src/counter.vhd](LED-PingPong/src/counter.vhd) | Obecny citac pouzity v zobrazovacich blocich. |

## Simulace

Vsechny simulace jsou soucasti tohoto README. Samostatny soubor se simulacemi uz neni potreba. Obrazky prubehu jsou ulozeny ve slozce [LED-PingPong/sim/img](LED-PingPong/sim/img).

### Prehled simulovanych bloku

| Simulace | Komponenta | Obrazek | Testbench |
| --- | --- | --- | --- |
| `clk_en` | [clk_en.vhd](LED-PingPong/src/clk_en.vhd) | [clk_en.png](LED-PingPong/sim/img/clk_en.png) | [tb_clk_en.vhd](LED-PingPong/sim/tb_clk_en.vhd) |
| `cnt_b_bd` | [cnt_b_bd.vhd](LED-PingPong/src/cnt_b_bd.vhd) | [cnt_b_bd_tb.png](LED-PingPong/sim/img/cnt_b_bd_tb.png) | [tb_cnt_b_bd.vhd](LED-PingPong/sim/tb_cnt_b_bd.vhd) |
| `cnt_d_bd` | [cnt_d_bd.vhd](LED-PingPong/src/cnt_d_bd.vhd) | [cnt_d_bd.png](LED-PingPong/sim/img/cnt_d_bd.png) | [tb_cnt_d_bd.vhd](LED-PingPong/sim/tb_cnt_d_bd.vhd) |
| `display_driver` | [display_driver.vhd](LED-PingPong/src/display_driver.vhd) | [display_driver_tb.png](LED-PingPong/sim/img/display_driver_tb.png) | [display_driver_tb.vhd](LED-PingPong/sim/display_driver_tb.vhd) |
| `counter10` | [counter10.vhd](LED-PingPong/src/counter10.vhd) | [counter10_tb.png](LED-PingPong/sim/img/counter10_tb.png) | - |
| `RSFlipFlop` | [RSFlipFlop.vhd](LED-PingPong/src/RSFlipFlop.vhd) | [RSFlipFlop_sim.png](LED-PingPong/sim/img/RSFlipFlop_sim.png) | - |
| `PingPong_top` | [PingPong_top.vhd](LED-PingPong/src/PingPong_top.vhd) | [TOP_sim.png](LED-PingPong/sim/img/TOP_sim.png) | - |

### Simulace `clk_en`

Komponenta: [LED-PingPong/src/clk_en.vhd](LED-PingPong/src/clk_en.vhd)  
Testbench: [LED-PingPong/sim/tb_clk_en.vhd](LED-PingPong/sim/tb_clk_en.vhd)

Blok `clk_en` generuje jednocyklovy signal `ce`, ktery se pouziva jako clock enable pro dalsi logiku. Simulace overuje reset, citani vnitrniho citace a vytvoreni kratkeho enable pulzu.

Overovane chovani:

- po resetu je `ce` v nule
- `ce` je aktivni pouze jeden takt
- vnitrni citac se po dosazeni maxima vraci na zacatek

![clk_en simulation waveform](LED-PingPong/sim/img/clk_en.png)

### Simulace `cnt_b_bd`

Komponenta: [LED-PingPong/src/cnt_b_bd.vhd](LED-PingPong/src/cnt_b_bd.vhd)  
Testbench: [LED-PingPong/sim/tb_cnt_b_bd.vhd](LED-PingPong/sim/tb_cnt_b_bd.vhd)

Blok `cnt_b_bd` je 3bitovy citac nastaveni rychlosti. Vstupy `count_up` a `count_down` meni hodnotu vystupu `count(2:0)`.

Overovane chovani:

- reset nastavi `count` na `000`
- `count_up` zvysuje hodnotu
- `count_down` snizuje hodnotu
- citac se zastavi na mezich `000` a `111`
- soucasny stisk nahoru a dolu nemeni hodnotu

![cnt_b_bd simulation waveform](LED-PingPong/sim/img/cnt_b_bd_tb.png)

### Simulace `cnt_d_bd`

Komponenta: [LED-PingPong/src/cnt_d_bd.vhd](LED-PingPong/src/cnt_d_bd.vhd)  
Testbench: [LED-PingPong/sim/tb_cnt_d_bd.vhd](LED-PingPong/sim/tb_cnt_d_bd.vhd)

Blok `cnt_d_bd` predstavuje pozici micku. Interni pozice je v rozsahu 0 az 19. Pozice 2 az 17 jsou viditelne na LED poli, zatimco pozice 0, 1, 18 a 19 slouzi pro detekci kraje a preteceni.

Overovane chovani:

- reset vraci micek do vychozi pozice
- `step` posune micek o jednu pozici
- `u_d = '1'` posouva doprava
- `u_d = '0'` posouva doleva
- `led(15:0)` zobrazuje aktivni pozici micku
- `count0`, `count1`, `count2`, `count17`, `count18` a `count19` indikuji krajni stavy

![cnt_d_bd simulation waveform](LED-PingPong/sim/img/cnt_d_bd.png)

### Simulace `display_driver`

Komponenta: [LED-PingPong/src/display_driver.vhd](LED-PingPong/src/display_driver.vhd)  
Testbench: [LED-PingPong/sim/display_driver_tb.vhd](LED-PingPong/sim/display_driver_tb.vhd)

Blok `display_driver` prijima 32bitova data pro osm pozic displeje a masku aktivnich anod. Simulace overuje multiplex jednotlivych cislic, vystup `seg(6:0)` a vyber aktivni anody `anode(7:0)`.

Overovane chovani:

- jednotlive nibbly z `data(31:0)` se postupne zobrazuji na `seg(6:0)`
- `anode(7:0)` vybere aktivni pozici displeje
- vypnute anody zustavaji neaktivni

![display_driver simulation waveform](LED-PingPong/sim/img/display_driver_tb.png)

### Simulace `counter10`

Komponenta: [LED-PingPong/src/counter10.vhd](LED-PingPong/src/counter10.vhd)

Blok `counter10` slouzi jako dekadicky citac skore. Cita hodnoty 0 az 9, pri preteceni se vrati na 0 a aktivuje vystup `c_out` pro navazujici vyssi rad.

Overovane chovani:

- reset nastavi citac na 0
- vstup `count` prida jeden bod
- hodnota se meni v rozsahu 0 az 9
- po 9 nasleduje 0 a carry vystup `c_out`

![counter10 simulation waveform](LED-PingPong/sim/img/counter10_tb.png)

### Simulace `RSFlipFlop`

Komponenta: [LED-PingPong/src/RSFlipFlop.vhd](LED-PingPong/src/RSFlipFlop.vhd)

Blok `RSFlipFlop` uchovava stav podle vstupu `S` a `R`. V projektu se pouziva pro pamatovani smeru pohybu micku.

Overovane chovani:

- `S = 1`, `R = 0` nastavi vystup `Q` na 1
- `S = 0`, `R = 1` nastavi vystup `Q` na 0
- `S = 0`, `R = 0` zachova predchozi stav
- neplatny stav `S = 1`, `R = 1` je osetren nulou

![RSFlipFlop simulation waveform](LED-PingPong/sim/img/RSFlipFlop_sim.png)

### Simulace `PingPong_top`

Komponenta: [LED-PingPong/src/PingPong_top.vhd](LED-PingPong/src/PingPong_top.vhd)

Top-level simulace overuje propojeni hlavnich bloku hry: debounce vstupu, nastaveni rychlosti, pohyb micku, zmenu smeru, pricitani skore a vystupy pro LED a displej.

Overovane chovani:

- reset cele hry
- pohyb micku pres LED pole
- reakce na tlacitka leveho a praveho hrace
- zmena rychlosti pres `btnu` a `btnd`
- pricitani bodu po preteceni micku
- priprava dat pro sedmisegmentovy displej

![PingPong_top simulation waveform](LED-PingPong/sim/img/TOP_sim.png)

## Constraints

Constraints pro desku Nexys A7-50T jsou v souboru [LED-PingPong/constr/nexys.xdc](LED-PingPong/constr/nexys.xdc). Obsahuji prirazeni pinu pro hodinovy signal, tlacitka, LED a sedmisegmentovy displej.

## Pouzite nastroje

- Vivado 2025.2
- VHDL
- Nexys A7-50T

## Reference

- Zadani projektu: [VHDL projects 2026](https://github.com/tomas-fryza/vhdl-examples/blob/master/lab8-project/README_2026.md)
- Digilent Nexys A7 reference manual
