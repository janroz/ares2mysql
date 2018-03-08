# ares2mysql
Skripty a příkazy pro extrahování dat z xml souborů do MySQL (SQL) databáze.

Obsah tohoto repozitáře slouží ke zpracování [exportu otevřených dat](http://wwwinfo.mfcr.cz/ares/ares_opendata.html.cz) ze systému [ARES](http://wwwinfo.mfcr.cz/ares/).
Export tvoří archiv s přibližně milionem XML souborů. PHP skriptem lze soubory postupně zpracovat do (My)SQL databáze.

Podobným projektem je [ARES open data](https://github.com/kokes/ares_opendata), který používá Python a primární cíl je (zřejmě) CSV.

## Použití

### Databáze

Je potřeba vytvořit databázi dle příslušného schématu (soubor ares.sql).

SQL schéma není přesným ekvivalentem [XSD](http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/ares/ares_answer_vreo/v_1.0.0/ares_answer_vreo.xsd), v těchto ohledech:

- nejsou ukládány nenalezené záznamy
- není explicitně ukládáno pořadí (lze řadit podle primárních, automaticky generovaných klíčů)
- položky typu textové pole (obsahují pouze subelementy typu Text) jsou zjednodušeny na vícenásobné (nezanořené) položky

### Zdrojová data

Je potřeba stáhnout [Výstup pro všechna IČO](http://wwwinfo.mfcr.cz/ares/ares_vreo_all.tar.gz) (cca 450 MB, po rozbalení cca 5-7 GB).

V PHP skriptu lze nastavit zdrojovou a cílovou složku - zpracované soubory jsou přesouvány (lze snadno upravit pro okamžité mazání).

### Spouštění

Skript lze spouštět přes web, obsahuje tag meta refresh pro automatické obnovování. Nebo například z příkazové řádky.

## Data

Při kopírování do databáze nedochází k normalizaci dat, tzn. opakující se hodnoty jsou vloženy vícekrát (tak, jak jsou obsaženy v XML souborech).

### Chyby v datech

Typy polí nejsou zcela optimální (např. varchar(255) všude tam, kde není pevně daná délka).

V adresách se nachází velké množství chyb - obsah položek číslo orientační, popisné, evidenční, ulice a obec jsou zpřeházené a různě kombinované.

Pole kód státu (zřejmě ISO 3166-1 numeric) ne vždy koresponduje s adresou sídla.

Některá pole nejsou vyplněna u žádných řádků (např. data narození a rodná čísla - dle platné legislativy),
dále právní forma, skrytý údaj u adresy ad.

U několika IČ soubory XML obsahují, že subjekt nebyl nalezen (webové rozhrazení ARES některé z nich najde - tučně).
V první verzi balíku to byla tato: **06678173**, 06719937, 06719945, 06719953, 06719961, 06719988, **06772331**, **06775420**, **06825745**, 27964400, **66521378**, 68399871

Včetně těchto nenalezených IČ balík obsahuje všechna IČ ze [Seznamu IČO k Balíku](http://wwwinfo.mfcr.cz/ares/ares_seznamIC_VR_balik.csv.7z).

### Počty
Jedná se o počty hlášené MySQL, v první verzi balíku (bez aplikovaných změn), nenormalizovaná data.

| tabulka                                               | počet řádků     |
| ----------------------------------------------------- | --------------- |
| balik_AdresaTyp                                       |         5978488 |
| balik_AdresaTyp_skrytyUdaj                            |               0 |
| balik_CinnostiTyp                                     |          828846 |
| balik_CinnostiTyp_DoplnkovaCinnost                    |            8273 |
| balik_CinnostiTyp_PredmetCinnosti                     |          134580 |
| balik_CinnostiTyp_PredmetPodnikani                    |         1463827 |
| balik_CinnostiTyp_Ucel                                |          125674 |
| balik_ClenstviTyp                                     |         1088815 |
| balik_FunkceTyp                                       |         3511327 |
| balik_FyzickaOsobaTyp                                 |         4731766 |
| balik_PravniFormaTyp                                  |               0 |
| balik_PravnickaOsobaTyp                               |          204126 |
| balik_UdajTypuAngazma                                 |          677833 |
| balik_UdajTypuAngazmaClenstvi                         |         4952734 |
| balik_UdajTypuAngazmaClenstvi_skrytyUdaj              |            6051 |
| balik_UdajTypuStatutar                                |         1059696 |
| balik_UvodTyp                                         |          978641 |
| balik_VypisVrEo                                       |          978641 |
| balik_ZakladniUdajeVr                                 |          978641 |
| balik_ZakladniUdajeVr_DuvodVymazu                     |           88074 |
| balik_ZpusobJednaniTyp                                |         1093413 |
| balik_vazba_AdresaTyp_skrytyUdaj                      |               0 |
| balik_vazba_CinnostiTyp_DoplnkovaCinnost              |            8273 |
| balik_vazba_CinnostiTyp_PredmetCinnosti               |          134580 |
| balik_vazba_CinnostiTyp_PredmetPodnikani              |         1463827 |
| balik_vazba_CinnostiTyp_Ucel                          |          125674 |
| balik_vazba_PravnickaOsobaTyp_UdajTypuAngazmaClenstvi |           15447 |
| balik_vazba_UdajTypuAngazmaClenstvi_skrytyUdaj        |            6051 |
| balik_vazba_UdajTypuAngazma_UdajTypuAngazmaClenstvi   |         1187106 |
| balik_vazba_UdajTypuStatutar_UdajTypuAngazmaClenstvi  |         3750181 |
| balik_vazba_UdajTypuStatutar_ZpusobJednaniTyp         |         1093413 |
| balik_vazba_VypisVrEo_UdajTypuAngazma                 |          677833 |
| balik_vazba_VypisVrEo_UdajTypuStatutar                |         1059696 |
| balik_vazba_ZakladniUdajeVr_DuvodVymazu               |           88074 |

Velikost výsledné MySQL databáze s InnoDB engine je cca 2,3 GB.
