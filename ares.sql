CREATE TABLE `balik_AdresaTyp` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `ruianKod` int(11) DEFAULT NULL,
  `stat` varchar(32) DEFAULT NULL,
  `psc` varchar(255) DEFAULT NULL,
  `okres` varchar(255) DEFAULT NULL,
  `obec` varchar(255) DEFAULT NULL,
  `castObce` varchar(255) DEFAULT NULL,
  `mop` varchar(255) DEFAULT NULL,
  `ulice` varchar(255) DEFAULT NULL,
  `cisloPop` varchar(255) DEFAULT NULL,
  `cisloOr` varchar(255) DEFAULT NULL,
  `cisloEv` varchar(255) DEFAULT NULL,
  `cisloTxt` varchar(255) DEFAULT NULL,
  `text` varchar(255) DEFAULT NULL,
  `doplnujiciText` varchar(255) DEFAULT NULL,
  `dorucovaciCislo` varchar(255) DEFAULT NULL
);

CREATE TABLE `balik_AdresaTyp_skrytyUdaj` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Text` text NOT NULL
);

CREATE TABLE `balik_CinnostiTyp` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY
);

CREATE TABLE `balik_CinnostiTyp_DoplnkovaCinnost` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Text` text NOT NULL
);

CREATE TABLE `balik_CinnostiTyp_PredmetCinnosti` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Text` text NOT NULL
);

CREATE TABLE `balik_CinnostiTyp_PredmetPodnikani` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Text` text NOT NULL
);

CREATE TABLE `balik_CinnostiTyp_Ucel` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Text` text NOT NULL
);

CREATE TABLE `balik_ClenstviTyp` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `vznikClenstvi` date DEFAULT NULL,
  `zanikClenstvi` date DEFAULT NULL
);

CREATE TABLE `balik_FunkceTyp` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `nazev` varchar(255) DEFAULT NULL,
  `vznikFunkce` date DEFAULT NULL,
  `zanikFunkce` date DEFAULT NULL
);

CREATE TABLE `balik_FyzickaOsobaTyp` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `adresa` bigint(20) UNSIGNED DEFAULT NULL,
  `jmeno` varchar(255) DEFAULT NULL,
  `prijmeni` varchar(255) DEFAULT NULL,
  `datumNarozeni` date DEFAULT NULL,
  `rodneCislo` varchar(32) DEFAULT NULL,
  `obcanstvi` varchar(32) DEFAULT NULL,
  `titulPred` varchar(255) DEFAULT NULL,
  `titulZa` varchar(255) DEFAULT NULL,
  `bydliste` bigint(20) UNSIGNED DEFAULT NULL
);

CREATE TABLE `balik_PravnickaOsobaTyp` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `adresa` bigint(20) UNSIGNED DEFAULT NULL,
  `ICO` char(8) DEFAULT NULL,
  `ObchodniFirma` varchar(255) DEFAULT NULL,
  `PravniForma` bigint(20) UNSIGNED DEFAULT NULL
);

CREATE TABLE `balik_PravniFormaTyp` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Kod_PF` smallint(5) UNSIGNED DEFAULT NULL,
  `Nazev_PF` varchar(255) DEFAULT NULL
);

CREATE TABLE `balik_UdajTypuAngazma` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Nazev` varchar(255) DEFAULT NULL
);

CREATE TABLE `balik_UdajTypuAngazmaClenstvi` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `clenstvi` bigint(20) UNSIGNED DEFAULT NULL,
  `funkce` bigint(20) UNSIGNED DEFAULT NULL,
  `fosoba` bigint(20) UNSIGNED DEFAULT NULL,
  `posoba` bigint(20) UNSIGNED DEFAULT NULL
);

CREATE TABLE `balik_UdajTypuAngazmaClenstvi_skrytyUdaj` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Text` text NOT NULL
);

CREATE TABLE `balik_UdajTypuStatutar` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Nazev` varchar(255) DEFAULT NULL
);

CREATE TABLE `balik_UvodTyp` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Nadpis` varchar(255) DEFAULT NULL,
  `Aktualizace_DB` date DEFAULT NULL,
  `Datum_vypisu` date DEFAULT NULL,
  `Cas_vypisu` time DEFAULT NULL,
  `Typ_vypisu` varchar(255) DEFAULT NULL,
  `Pozadovane_datum_platnosti_dat` date DEFAULT NULL,
  `Typ_odkazu` varchar(255) DEFAULT NULL,
  `Typ_odpovedi` varchar(255) DEFAULT NULL
);

CREATE TABLE `balik_vazba_AdresaTyp_skrytyUdaj` (
  `Adresa` bigint(20) UNSIGNED NOT NULL,
  `skrytyUdaj` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_CinnostiTyp_DoplnkovaCinnost` (
  `Cinnosti` bigint(20) UNSIGNED NOT NULL,
  `DoplnkovaCinnost` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_CinnostiTyp_PredmetCinnosti` (
  `Cinnosti` bigint(20) UNSIGNED NOT NULL,
  `PredmetCinnosti` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_CinnostiTyp_PredmetPodnikani` (
  `Cinnosti` bigint(20) UNSIGNED NOT NULL,
  `PredmetPodnikani` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_CinnostiTyp_Ucel` (
  `Cinnosti` bigint(20) UNSIGNED NOT NULL,
  `Ucel` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_PravnickaOsobaTyp_UdajTypuAngazmaClenstvi` (
  `posoba` bigint(20) UNSIGNED NOT NULL,
  `Clen_nebo_Zastoupeni` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_UdajTypuAngazmaClenstvi_skrytyUdaj` (
  `UdajTypuAngazmaClenstvi` bigint(20) UNSIGNED NOT NULL,
  `skrytyUdaj` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_UdajTypuAngazma_UdajTypuAngazmaClenstvi` (
  `Jiny_organ` bigint(20) UNSIGNED NOT NULL,
  `Clen_nebo_Zastoupeni` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_UdajTypuStatutar_UdajTypuAngazmaClenstvi` (
  `Statutarni_organ` bigint(20) UNSIGNED NOT NULL,
  `Clen_nebo_Zastoupeni` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_UdajTypuStatutar_ZpusobJednaniTyp` (
  `Statutarni_organ` bigint(20) UNSIGNED NOT NULL,
  `ZpusobJednani` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_VypisVrEo_UdajTypuAngazma` (
  `VypisVrEo` bigint(20) UNSIGNED NOT NULL,
  `Jiny_organ` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_VypisVrEo_UdajTypuStatutar` (
  `VypisVrEo` bigint(20) UNSIGNED NOT NULL,
  `Statutarni_organ` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_vazba_ZakladniUdajeVr_DuvodVymazu` (
  `Zakladni_udaje` bigint(20) UNSIGNED NOT NULL,
  `DuvodVymazu` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_VypisVrEo` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Uvod` bigint(20) UNSIGNED DEFAULT NULL,
  `Zakladni_udaje` bigint(20) UNSIGNED NOT NULL
);

CREATE TABLE `balik_ZakladniUdajeVr` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `Rejstrik` enum('OR','NR','ROPS','RSVJ','RU','SR') DEFAULT NULL,
  `ICO` char(8) DEFAULT NULL,
  `ObchodniFirma` varchar(255) DEFAULT NULL,
  `PravniForma` bigint(20) UNSIGNED DEFAULT NULL,
  `Sidlo` bigint(20) UNSIGNED DEFAULT NULL,
  `Bydliste` bigint(20) UNSIGNED DEFAULT NULL,
  `Pobyt` bigint(20) UNSIGNED DEFAULT NULL,
  `DatumVzniku` date DEFAULT NULL,
  `DatumZapisu` date DEFAULT NULL,
  `DatumVymazu` date DEFAULT NULL,
  `StatusVerejneProspesnosti` tinyint(1) DEFAULT NULL,
  `Cinnosti` bigint(20) UNSIGNED DEFAULT NULL
);

CREATE TABLE `balik_ZakladniUdajeVr_DuvodVymazu` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Text` text NOT NULL
);

CREATE TABLE `balik_ZpusobJednaniTyp` (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `dza` date DEFAULT NULL,
  `dvy` date DEFAULT NULL,
  `Text` text NOT NULL
);


ALTER TABLE `balik_vazba_AdresaTyp_skrytyUdaj`
  ADD PRIMARY KEY (`Adresa`,`skrytyUdaj`);

ALTER TABLE `balik_vazba_CinnostiTyp_DoplnkovaCinnost`
  ADD PRIMARY KEY (`Cinnosti`,`DoplnkovaCinnost`);

ALTER TABLE `balik_vazba_CinnostiTyp_PredmetCinnosti`
  ADD PRIMARY KEY (`Cinnosti`,`PredmetCinnosti`);

ALTER TABLE `balik_vazba_CinnostiTyp_PredmetPodnikani`
  ADD PRIMARY KEY (`Cinnosti`,`PredmetPodnikani`);

ALTER TABLE `balik_vazba_CinnostiTyp_Ucel`
  ADD PRIMARY KEY (`Cinnosti`,`Ucel`);

ALTER TABLE `balik_vazba_PravnickaOsobaTyp_UdajTypuAngazmaClenstvi`
  ADD PRIMARY KEY (`posoba`,`Clen_nebo_Zastoupeni`);

ALTER TABLE `balik_vazba_UdajTypuAngazmaClenstvi_skrytyUdaj`
  ADD PRIMARY KEY (`UdajTypuAngazmaClenstvi`,`skrytyUdaj`);

ALTER TABLE `balik_vazba_UdajTypuAngazma_UdajTypuAngazmaClenstvi`
  ADD PRIMARY KEY (`Jiny_organ`,`Clen_nebo_Zastoupeni`);

ALTER TABLE `balik_vazba_UdajTypuStatutar_UdajTypuAngazmaClenstvi`
  ADD PRIMARY KEY (`Statutarni_organ`,`Clen_nebo_Zastoupeni`);

ALTER TABLE `balik_vazba_UdajTypuStatutar_ZpusobJednaniTyp`
  ADD PRIMARY KEY (`Statutarni_organ`,`ZpusobJednani`);

ALTER TABLE `balik_vazba_VypisVrEo_UdajTypuAngazma`
  ADD PRIMARY KEY (`VypisVrEo`,`Jiny_organ`);

ALTER TABLE `balik_vazba_VypisVrEo_UdajTypuStatutar`
  ADD PRIMARY KEY (`VypisVrEo`,`Statutarni_organ`);

ALTER TABLE `balik_vazba_ZakladniUdajeVr_DuvodVymazu`
  ADD PRIMARY KEY (`Zakladni_udaje`,`DuvodVymazu`);

