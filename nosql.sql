/*
Navicat MySQL Data Transfer

Source Server         : nosql
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : nosql

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2020-02-05 12:12:37
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for akt_o_organizaciji
-- ----------------------------
DROP TABLE IF EXISTS `akt_o_organizaciji`;
CREATE TABLE `akt_o_organizaciji` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `AO_REDNI_BROJ` decimal(4,0) NOT NULL,
  `OJ_IDENTIFIKATOR` int(11) NOT NULL,
  `AO_DATUM_DOKUMENTA` date NOT NULL,
  `AO_VAZI_DO` date DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`AO_REDNI_BROJ`),
  KEY `FK_DONEO_ORGAN` (`TIP_UST`,`VU_IDENTIFIKATOR`,`OJ_IDENTIFIKATOR`),
  CONSTRAINT `FK_DOKUMENT_O_ORGANIZACIJI` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`),
  CONSTRAINT `FK_DONEO_ORGAN` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`) REFERENCES `organizacione_jedinice` (`TIP_UST`, `VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of akt_o_organizaciji
-- ----------------------------

-- ----------------------------
-- Table structure for clanovi_podorice
-- ----------------------------
DROP TABLE IF EXISTS `clanovi_podorice`;
CREATE TABLE `clanovi_podorice` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `ZAP_REDNI_BROJ` decimal(6,0) NOT NULL,
  `RCP_REDNI_BROJ` decimal(2,0) NOT NULL,
  `RCP_PREZIME` varchar(20) DEFAULT NULL,
  `RCP_IME` varchar(20) DEFAULT NULL,
  `RCP_JMBG` char(13) DEFAULT NULL,
  `VSR_OZNAKA` char(2) DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`,`RCP_REDNI_BROJ`),
  KEY `FK_U_SRODSTVU` (`VSR_OZNAKA`),
  CONSTRAINT `FK_RELATIONSHIP_18` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`) REFERENCES `registar_zaposlenih` (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`),
  CONSTRAINT `FK_U_SRODSTVU` FOREIGN KEY (`VSR_OZNAKA`) REFERENCES `vrsta_srodstva` (`VSR_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of clanovi_podorice
-- ----------------------------

-- ----------------------------
-- Table structure for dodatni_podaci
-- ----------------------------
DROP TABLE IF EXISTS `dodatni_podaci`;
CREATE TABLE `dodatni_podaci` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `ZAP_REDNI_BROJ` decimal(6,0) NOT NULL,
  `RCP_REDNI_BROJ` decimal(2,0) NOT NULL,
  `ULO_OZNAKA` char(2) NOT NULL,
  `PL_OZNAKA` int(11) NOT NULL,
  `DOD_IDENT` smallint(6) NOT NULL,
  `DOD_OPIS` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`,`ULO_OZNAKA`,`PL_OZNAKA`,`RCP_REDNI_BROJ`,`DOD_IDENT`),
  KEY `FK_PREMA_PRAVNOM_LICU` (`PL_OZNAKA`),
  KEY `FK_ULOGE_CLANA` (`TIP_UST`,`VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`,`RCP_REDNI_BROJ`),
  KEY `FK_U_ULOZI` (`ULO_OZNAKA`),
  CONSTRAINT `FK_PREMA_PRAVNOM_LICU` FOREIGN KEY (`PL_OZNAKA`) REFERENCES `pravna_lica` (`PL_OZNAKA`),
  CONSTRAINT `FK_ULOGE_CLANA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`, `RCP_REDNI_BROJ`) REFERENCES `clanovi_podorice` (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`, `RCP_REDNI_BROJ`),
  CONSTRAINT `FK_U_ULOZI` FOREIGN KEY (`ULO_OZNAKA`) REFERENCES `uloga` (`ULO_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of dodatni_podaci
-- ----------------------------

-- ----------------------------
-- Table structure for dokumenti_o_zaposlenim
-- ----------------------------
DROP TABLE IF EXISTS `dokumenti_o_zaposlenim`;
CREATE TABLE `dokumenti_o_zaposlenim` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `VD_OZNAKA` char(2) NOT NULL,
  `UG_GODINA` decimal(4,0) NOT NULL,
  `UG_BROJ_DOKUMENTA` int(11) NOT NULL,
  `UG_DATIM` date NOT NULL,
  `UG_DATUM_VAZENJA` date DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`VD_OZNAKA`,`UG_GODINA`,`UG_BROJ_DOKUMENTA`),
  KEY `FK_KLASIFIKACIJA_DOKUMENTA` (`VD_OZNAKA`),
  CONSTRAINT `FK_KLASIFIKACIJA_DOKUMENTA` FOREIGN KEY (`VD_OZNAKA`) REFERENCES `vrsta_dokumenta` (`VD_OZNAKA`),
  CONSTRAINT `FK_PROTOKOL_UGOVORA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of dokumenti_o_zaposlenim
-- ----------------------------

-- ----------------------------
-- Table structure for dokumentovanje_predmeta
-- ----------------------------
DROP TABLE IF EXISTS `dokumentovanje_predmeta`;
CREATE TABLE `dokumentovanje_predmeta` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `NP_PREDMET` varchar(6) NOT NULL,
  `NP_VERZIJA` decimal(2,0) NOT NULL,
  `JEZ_JERIK2` char(3) NOT NULL,
  `OSNOVNI_DOKUMENT` char(2) NOT NULL,
  `POVEZANI_DOKUMENT` char(2) NOT NULL,
  `SDOK_NIVO` decimal(2,0) NOT NULL,
  `DOKPR_DEO` decimal(2,0) NOT NULL,
  `DOKPR_OPIS` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`JEZ_JERIK2`,`OSNOVNI_DOKUMENT`,`POVEZANI_DOKUMENT`,`SDOK_NIVO`,`NP_PREDMET`,`NP_VERZIJA`,`DOKPR_DEO`),
  KEY `FK_DOKUMENTACIJA_ZA_PREDMET` (`JEZ_JERIK2`,`OSNOVNI_DOKUMENT`,`POVEZANI_DOKUMENT`,`SDOK_NIVO`),
  KEY `FK_PRATECA_DOKUMENTACIJA` (`TIP_UST`,`VU_IDENTIFIKATOR`,`NP_PREDMET`,`NP_VERZIJA`),
  CONSTRAINT `FK_DOKUMENTACIJA_ZA_PREDMET` FOREIGN KEY (`JEZ_JERIK2`, `OSNOVNI_DOKUMENT`, `POVEZANI_DOKUMENT`, `SDOK_NIVO`) REFERENCES `struktura_dokumentacije` (`JEZ_JERIK2`, `OSNOVNI_TIP_DOKUMENTA`, `SADRZANI_TIP_DOKUMENTA`, `SDOK_NIVO`),
  CONSTRAINT `FK_PRATECA_DOKUMENTACIJA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `NP_PREDMET`, `NP_VERZIJA`) REFERENCES `nastavni_predmeti` (`TIP_UST`, `VU_IDENTIFIKATOR`, `NP_PREDMET`, `NP_VERZIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of dokumentovanje_predmeta
-- ----------------------------

-- ----------------------------
-- Table structure for dokumentovanje_programa
-- ----------------------------
DROP TABLE IF EXISTS `dokumentovanje_programa`;
CREATE TABLE `dokumentovanje_programa` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `TIPP_TIP` char(1) NOT NULL,
  `SP_EVIDENCIONI_BROJ` int(11) NOT NULL,
  `SP_VERZIJA` decimal(2,0) NOT NULL,
  `JEZ_JEZIK` char(3) NOT NULL,
  `OSNOVNI_TIP_DOKUMENTA` char(2) NOT NULL,
  `POVEZANI_TIP_DOKUMENTA` char(2) NOT NULL,
  `SDOK_NIVO` decimal(2,0) NOT NULL,
  `DOKPR_DEO_DOKUMENTACIJ` decimal(2,0) NOT NULL,
  `DOKPR_TEKST` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`TIPP_TIP`,`JEZ_JEZIK`,`OSNOVNI_TIP_DOKUMENTA`,`POVEZANI_TIP_DOKUMENTA`,`SP_EVIDENCIONI_BROJ`,`SP_VERZIJA`,`SDOK_NIVO`,`DOKPR_DEO_DOKUMENTACIJ`),
  KEY `FK_DOKUMENTACIJA_ZA_PROGRAM` (`JEZ_JEZIK`,`OSNOVNI_TIP_DOKUMENTA`,`POVEZANI_TIP_DOKUMENTA`,`SDOK_NIVO`),
  KEY `FK_PROGRAM_DOKUMENTACIJA` (`TIP_UST`,`VU_IDENTIFIKATOR`,`TIPP_TIP`,`SP_EVIDENCIONI_BROJ`,`SP_VERZIJA`),
  CONSTRAINT `FK_DOKUMENTACIJA_ZA_PROGRAM` FOREIGN KEY (`JEZ_JEZIK`, `OSNOVNI_TIP_DOKUMENTA`, `POVEZANI_TIP_DOKUMENTA`, `SDOK_NIVO`) REFERENCES `struktura_dokumentacije` (`JEZ_JERIK2`, `OSNOVNI_TIP_DOKUMENTA`, `SADRZANI_TIP_DOKUMENTA`, `SDOK_NIVO`),
  CONSTRAINT `FK_PROGRAM_DOKUMENTACIJA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`) REFERENCES `registrovani_programi` (`TIP_UST`, `VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of dokumentovanje_programa
-- ----------------------------

-- ----------------------------
-- Table structure for dokumentovanje__akreditacije
-- ----------------------------
DROP TABLE IF EXISTS `dokumentovanje__akreditacije`;
CREATE TABLE `dokumentovanje__akreditacije` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `AD_GODINA` decimal(4,0) NOT NULL,
  `AD_EVIDENCIONI_BROJ` decimal(2,0) NOT NULL,
  `AD_VERZIJA` decimal(2,0) NOT NULL,
  `JEZ_JERIK2` char(3) NOT NULL,
  `OSNOVNI_TIP_DOKUMENTA` char(2) NOT NULL,
  `POVEZANI_TIP_DOKUMENTA` char(2) NOT NULL,
  `SDOK_NIVO` decimal(2,0) NOT NULL,
  `AKDOK_DEO` decimal(2,0) NOT NULL,
  `AKDOK_OPIS` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`JEZ_JERIK2`,`OSNOVNI_TIP_DOKUMENTA`,`POVEZANI_TIP_DOKUMENTA`,`AD_GODINA`,`AD_EVIDENCIONI_BROJ`,`AD_VERZIJA`,`SDOK_NIVO`,`AKDOK_DEO`),
  KEY `FK_DOKUMENTACIJA_ZA_AKREDITACIJU` (`JEZ_JERIK2`,`OSNOVNI_TIP_DOKUMENTA`,`POVEZANI_TIP_DOKUMENTA`,`SDOK_NIVO`),
  KEY `FK_PREAMBULE_DOKUMENATA` (`TIP_UST`,`VU_IDENTIFIKATOR`,`AD_GODINA`,`AD_EVIDENCIONI_BROJ`,`AD_VERZIJA`),
  CONSTRAINT `FK_DOKUMENTACIJA_ZA_AKREDITACIJU` FOREIGN KEY (`JEZ_JERIK2`, `OSNOVNI_TIP_DOKUMENTA`, `POVEZANI_TIP_DOKUMENTA`, `SDOK_NIVO`) REFERENCES `struktura_dokumentacije` (`JEZ_JERIK2`, `OSNOVNI_TIP_DOKUMENTA`, `SADRZANI_TIP_DOKUMENTA`, `SDOK_NIVO`),
  CONSTRAINT `FK_PREAMBULE_DOKUMENATA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `AD_GODINA`, `AD_EVIDENCIONI_BROJ`, `AD_VERZIJA`) REFERENCES `dokument_o_akreditaciji` (`TIP_UST`, `VU_IDENTIFIKATOR`, `AD_GODINA`, `AD_EVIDENCIONI_BROJ`, `AD_VERZIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of dokumentovanje__akreditacije
-- ----------------------------

-- ----------------------------
-- Table structure for dokument_o_akreditaciji
-- ----------------------------
DROP TABLE IF EXISTS `dokument_o_akreditaciji`;
CREATE TABLE `dokument_o_akreditaciji` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `AD_GODINA` decimal(4,0) NOT NULL,
  `AD_EVIDENCIONI_BROJ` decimal(2,0) NOT NULL,
  `AD_VERZIJA` decimal(2,0) NOT NULL,
  `AD_DATUM_FORMIRANJA` date NOT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`AD_GODINA`,`AD_EVIDENCIONI_BROJ`,`AD_VERZIJA`),
  CONSTRAINT `FK_DOKUMENTI_AKREDITACIJE` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of dokument_o_akreditaciji
-- ----------------------------

-- ----------------------------
-- Table structure for drzava
-- ----------------------------
DROP TABLE IF EXISTS `drzava`;
CREATE TABLE `drzava` (
  `DR_IDENTIFIKATOR` char(3) NOT NULL,
  `DR_NAZIV` varchar(80) NOT NULL,
  `DR_DATUM_OSNIVANJA` date NOT NULL,
  `DR_POSTOJALA_DO` date DEFAULT NULL,
  `DR_GRB` longblob,
  `DR_ZASTAVA` longblob,
  `DR_HIMNA` longblob,
  `DRZ_DR_IDENTIFIKATOR` char(3) DEFAULT NULL,
  PRIMARY KEY (`DR_IDENTIFIKATOR`),
  KEY `FK_PRAVNI_NASLEDNIK` (`DRZ_DR_IDENTIFIKATOR`),
  CONSTRAINT `FK_PRAVNI_NASLEDNIK` FOREIGN KEY (`DRZ_DR_IDENTIFIKATOR`) REFERENCES `drzava` (`DR_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of drzava
-- ----------------------------
INSERT INTO `drzava` VALUES ('BIH', 'Bosna', '0000-00-00', null, null, null, null, null);
INSERT INTO `drzava` VALUES ('SRB', 'Srbija', '0000-00-00', null, null, null, null, null);

-- ----------------------------
-- Table structure for fondovi_po_kompetencijama
-- ----------------------------
DROP TABLE IF EXISTS `fondovi_po_kompetencijama`;
CREATE TABLE `fondovi_po_kompetencijama` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `NP_PREDMET` varchar(6) NOT NULL,
  `NP_VERZIJA` decimal(2,0) NOT NULL,
  `VID_VID` char(1) NOT NULL,
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `OBL_OBLAST` char(2) NOT NULL,
  `KOMP_KATEGORIJA` char(2) NOT NULL,
  `KO_KOMPETENCIJA` char(2) NOT NULL,
  `KUP_U_FONDU_OD` decimal(2,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`NP_PREDMET`,`NP_VERZIJA`,`VID_VID`,`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`KO_KOMPETENCIJA`),
  KEY `FK_KMPETENCIJA_U_FONDU_PREDMETU` (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`KO_KOMPETENCIJA`),
  CONSTRAINT `FK_KMPETENCIJA_U_FONDU_PREDMETU` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KO_KOMPETENCIJA`) REFERENCES `kompetencije` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KO_KOMPETENCIJA`),
  CONSTRAINT `FK_PO_KOMPETENCIJAMA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `NP_PREDMET`, `NP_VERZIJA`, `VID_VID`) REFERENCES `fondovi_po_vidu` (`TIP_UST`, `VU_IDENTIFIKATOR`, `NP_PREDMET`, `NP_VERZIJA`, `VID_VID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of fondovi_po_kompetencijama
-- ----------------------------

-- ----------------------------
-- Table structure for fondovi_po_vidu
-- ----------------------------
DROP TABLE IF EXISTS `fondovi_po_vidu`;
CREATE TABLE `fondovi_po_vidu` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `NP_PREDMET` varchar(6) NOT NULL,
  `NP_VERZIJA` decimal(2,0) NOT NULL,
  `VID_VID` char(1) NOT NULL,
  `FOND_UKUPNO_CASOVA` decimal(5,2) NOT NULL DEFAULT '30.00',
  `FOND_NACIN_IZVO_ENJA` char(1) NOT NULL DEFAULT 'K',
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`NP_PREDMET`,`NP_VERZIJA`,`VID_VID`),
  KEY `FK_VID_FONDA` (`VID_VID`),
  CONSTRAINT `FK_FOND_NASTAVE` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `NP_PREDMET`, `NP_VERZIJA`) REFERENCES `nastavni_predmeti` (`TIP_UST`, `VU_IDENTIFIKATOR`, `NP_PREDMET`, `NP_VERZIJA`),
  CONSTRAINT `FK_VID_FONDA` FOREIGN KEY (`VID_VID`) REFERENCES `vidovi_nastave` (`VID_VID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of fondovi_po_vidu
-- ----------------------------

-- ----------------------------
-- Table structure for glavni_gradovi
-- ----------------------------
DROP TABLE IF EXISTS `glavni_gradovi`;
CREATE TABLE `glavni_gradovi` (
  `DR_IDENTIFIKATOR` char(3) NOT NULL,
  `NM_IDENTIFIKATOR` bigint(20) NOT NULL,
  `UDR_REDNI_BROJ` decimal(1,0) NOT NULL,
  PRIMARY KEY (`NM_IDENTIFIKATOR`,`DR_IDENTIFIKATOR`,`UDR_REDNI_BROJ`),
  KEY `FK_GLAVNI_GRADOVI2` (`DR_IDENTIFIKATOR`,`NM_IDENTIFIKATOR`,`UDR_REDNI_BROJ`),
  CONSTRAINT `FK_GLAVNI_GRADOVI` FOREIGN KEY (`DR_IDENTIFIKATOR`) REFERENCES `drzava` (`DR_IDENTIFIKATOR`),
  CONSTRAINT `FK_GLAVNI_GRADOVI2` FOREIGN KEY (`DR_IDENTIFIKATOR`, `NM_IDENTIFIKATOR`, `UDR_REDNI_BROJ`) REFERENCES `u_drzavi` (`DR_IDENTIFIKATOR`, `NM_IDENTIFIKATOR`, `UDR_REDNI_BROJ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of glavni_gradovi
-- ----------------------------

-- ----------------------------
-- Table structure for istorija_staza
-- ----------------------------
DROP TABLE IF EXISTS `istorija_staza`;
CREATE TABLE `istorija_staza` (
  `TIP_UST` char(2) NOT NULL,
  `REG_VU_IDENTIFIKATOR` int(11) NOT NULL,
  `ZAP_REDNI_BROJ` decimal(6,0) NOT NULL,
  `PL_OZNAKA` int(11) NOT NULL,
  `IST_IDENT` smallint(6) NOT NULL,
  `RAD_TIP_UST` char(2) DEFAULT NULL,
  `VU_IDENTIFIKATOR` int(11) DEFAULT NULL,
  `RM_OZNAKA` char(3) DEFAULT NULL,
  `VRO_OZNAKA` char(2) NOT NULL,
  `IST_OD` date NOT NULL,
  `IST_DO` date NOT NULL,
  `IST_STAZ_GODINA` decimal(2,0) NOT NULL DEFAULT '0',
  `IST_STAZ_MESECI` decimal(2,0) NOT NULL DEFAULT '0',
  `IST_STAZ_DANA` decimal(2,0) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TIP_UST`,`REG_VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`,`PL_OZNAKA`,`IST_IDENT`),
  KEY `FK_NA_POSLOVIMA` (`RAD_TIP_UST`,`VU_IDENTIFIKATOR`,`RM_OZNAKA`),
  KEY `FK_RADILI_KOD` (`PL_OZNAKA`),
  KEY `FK_VRSTA_RO` (`VRO_OZNAKA`),
  CONSTRAINT `FK_AFFILIATION` FOREIGN KEY (`TIP_UST`, `REG_VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`) REFERENCES `registar_zaposlenih` (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`),
  CONSTRAINT `FK_NA_POSLOVIMA` FOREIGN KEY (`RAD_TIP_UST`, `VU_IDENTIFIKATOR`, `RM_OZNAKA`) REFERENCES `radna_mesta` (`TIP_UST`, `VU_IDENTIFIKATOR`, `RM_OZNAKA`),
  CONSTRAINT `FK_RADILI_KOD` FOREIGN KEY (`PL_OZNAKA`) REFERENCES `pravna_lica` (`PL_OZNAKA`),
  CONSTRAINT `FK_VRSTA_RO` FOREIGN KEY (`VRO_OZNAKA`) REFERENCES `vrsta_radnog_odnosa` (`VRO_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of istorija_staza
-- ----------------------------

-- ----------------------------
-- Table structure for jezici
-- ----------------------------
DROP TABLE IF EXISTS `jezici`;
CREATE TABLE `jezici` (
  `JEZ_JERIK2` char(3) NOT NULL,
  `JEZ_NAZIV2` varchar(40) NOT NULL,
  PRIMARY KEY (`JEZ_JERIK2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of jezici
-- ----------------------------

-- ----------------------------
-- Table structure for kategorija_kompetencije
-- ----------------------------
DROP TABLE IF EXISTS `kategorija_kompetencije`;
CREATE TABLE `kategorija_kompetencije` (
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `OBL_OBLAST` char(2) NOT NULL,
  `KOMP_KATEGORIJA` char(2) NOT NULL,
  `KOMP_NAZIV` varchar(120) NOT NULL,
  `KOMP_OPIS` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`),
  CONSTRAINT `FK_KATEGORIZIRANE_KOMPETENCIJE` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`) REFERENCES `registar_oblasti_obrazovanja` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of kategorija_kompetencije
-- ----------------------------

-- ----------------------------
-- Table structure for kompetencije
-- ----------------------------
DROP TABLE IF EXISTS `kompetencije`;
CREATE TABLE `kompetencije` (
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `OBL_OBLAST` char(2) NOT NULL,
  `KOMP_KATEGORIJA` char(2) NOT NULL,
  `KO_KOMPETENCIJA` char(2) NOT NULL,
  `KO_NAZIV` varchar(120) NOT NULL,
  `KO_OPIS` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`KO_KOMPETENCIJA`),
  CONSTRAINT `FK_KOMPETENCIJE` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`) REFERENCES `kategorija_kompetencije` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of kompetencije
-- ----------------------------

-- ----------------------------
-- Table structure for kontakt_podaci
-- ----------------------------
DROP TABLE IF EXISTS `kontakt_podaci`;
CREATE TABLE `kontakt_podaci` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `ZAP_REDNI_BROJ` decimal(6,0) NOT NULL,
  `TKO_OZNAKA` char(1) NOT NULL,
  `KP_REDNI_BROJ` decimal(2,0) NOT NULL,
  `NM_IDENTIFIKATOR` bigint(20) DEFAULT NULL,
  `KP_ADRESA` varchar(80) DEFAULT NULL,
  `KP_E_POSTA` varchar(60) DEFAULT NULL,
  `KP_WWW` varchar(60) DEFAULT NULL,
  `KP_KONTAKT_TELEFON` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`TKO_OZNAKA`,`ZAP_REDNI_BROJ`,`KP_REDNI_BROJ`),
  KEY `FK_KONTAKTIRA_SE` (`TIP_UST`,`VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`),
  KEY `FK_MESTO_KONTAKTA` (`NM_IDENTIFIKATOR`),
  KEY `FK_U_KONTAKTU_SA` (`TKO_OZNAKA`),
  CONSTRAINT `FK_KONTAKTIRA_SE` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`) REFERENCES `registar_zaposlenih` (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`),
  CONSTRAINT `FK_MESTO_KONTAKTA` FOREIGN KEY (`NM_IDENTIFIKATOR`) REFERENCES `naseljeno_mesto` (`NM_IDENTIFIKATOR`),
  CONSTRAINT `FK_U_KONTAKTU_SA` FOREIGN KEY (`TKO_OZNAKA`) REFERENCES `tip_kontakta` (`TKO_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of kontakt_podaci
-- ----------------------------

-- ----------------------------
-- Table structure for lista_kompetencija
-- ----------------------------
DROP TABLE IF EXISTS `lista_kompetencija`;
CREATE TABLE `lista_kompetencija` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `NP_PREDMET` varchar(6) NOT NULL,
  `NP_VERZIJA` decimal(2,0) NOT NULL,
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `OBL_OBLAST` char(2) NOT NULL,
  `KOMP_KATEGORIJA` char(2) NOT NULL,
  `KO_KOMPETENCIJA` char(2) NOT NULL,
  PRIMARY KEY (`TIP_UST`,`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`VU_IDENTIFIKATOR`,`KO_KOMPETENCIJA`,`NP_PREDMET`,`NP_VERZIJA`),
  KEY `FK_LISTA_KOMPETENCIJA` (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`KO_KOMPETENCIJA`),
  KEY `FK_LISTA_KOMPETENCIJA2` (`TIP_UST`,`VU_IDENTIFIKATOR`,`NP_PREDMET`,`NP_VERZIJA`),
  CONSTRAINT `FK_LISTA_KOMPETENCIJA` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KO_KOMPETENCIJA`) REFERENCES `kompetencije` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KO_KOMPETENCIJA`),
  CONSTRAINT `FK_LISTA_KOMPETENCIJA2` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `NP_PREDMET`, `NP_VERZIJA`) REFERENCES `nastavni_predmeti` (`TIP_UST`, `VU_IDENTIFIKATOR`, `NP_PREDMET`, `NP_VERZIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of lista_kompetencija
-- ----------------------------

-- ----------------------------
-- Table structure for naseljeno_mesto
-- ----------------------------
DROP TABLE IF EXISTS `naseljeno_mesto`;
CREATE TABLE `naseljeno_mesto` (
  `NM_IDENTIFIKATOR` bigint(20) NOT NULL,
  `NM_NAZIV` varchar(40) NOT NULL,
  PRIMARY KEY (`NM_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of naseljeno_mesto
-- ----------------------------
INSERT INTO `naseljeno_mesto` VALUES ('1', 'Beograd');
INSERT INTO `naseljeno_mesto` VALUES ('2', 'Novi Sad');
INSERT INTO `naseljeno_mesto` VALUES ('3', 'Niš');
INSERT INTO `naseljeno_mesto` VALUES ('4', 'Bjeljina');
INSERT INTO `naseljeno_mesto` VALUES ('5', 'Sarajevo');

-- ----------------------------
-- Table structure for nastavni_predmeti
-- ----------------------------
DROP TABLE IF EXISTS `nastavni_predmeti`;
CREATE TABLE `nastavni_predmeti` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `NP_PREDMET` varchar(6) NOT NULL,
  `NP_VERZIJA` decimal(2,0) NOT NULL,
  `NP_NAZIV_PREDMETA` varchar(120) NOT NULL,
  `NP_IZBORNA` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`NP_PREDMET`,`NP_VERZIJA`),
  CONSTRAINT `FK_NUDI_PREDMETE` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of nastavni_predmeti
-- ----------------------------

-- ----------------------------
-- Table structure for nivo_studija
-- ----------------------------
DROP TABLE IF EXISTS `nivo_studija`;
CREATE TABLE `nivo_studija` (
  `STS_OZNAKA` char(2) NOT NULL,
  `NS_NIVO` decimal(1,0) NOT NULL,
  `NA_NAZIV` varchar(60) NOT NULL,
  `SN_OZNAKA` char(2) DEFAULT NULL,
  PRIMARY KEY (`STS_OZNAKA`,`NS_NIVO`),
  KEY `FK_NAZIV_ZA_NIVO` (`SN_OZNAKA`),
  CONSTRAINT `FK_NAZIV_ZA_NIVO` FOREIGN KEY (`SN_OZNAKA`) REFERENCES `registar_strucnih_naziva` (`SN_OZNAKA`),
  CONSTRAINT `FK_PO_NIVOIMA` FOREIGN KEY (`STS_OZNAKA`) REFERENCES `stepen_studija` (`STS_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of nivo_studija
-- ----------------------------

-- ----------------------------
-- Table structure for obuhvat_akreditacije
-- ----------------------------
DROP TABLE IF EXISTS `obuhvat_akreditacije`;
CREATE TABLE `obuhvat_akreditacije` (
  `TIP_UST` char(2) NOT NULL,
  `REG_VU_IDENTIFIKATOR` int(11) NOT NULL,
  `AD_GODINA` decimal(4,0) NOT NULL,
  `AD_EVIDENCIONI_BROJ` decimal(2,0) NOT NULL,
  `AD_VERZIJA` decimal(2,0) NOT NULL,
  `OAK_POZICIJA` decimal(3,0) NOT NULL,
  `TIPP_TIP` char(1) NOT NULL,
  `SP_EVIDENCIONI_BROJ` int(11) NOT NULL,
  `SP_VERZIJA` decimal(2,0) NOT NULL,
  `OAK_STATUS` decimal(1,0) NOT NULL DEFAULT '1',
  PRIMARY KEY (`TIP_UST`,`REG_VU_IDENTIFIKATOR`,`AD_GODINA`,`AD_EVIDENCIONI_BROJ`,`AD_VERZIJA`,`OAK_POZICIJA`),
  KEY `FK_PROGRAM_U_OBUHVATU` (`TIP_UST`,`REG_VU_IDENTIFIKATOR`,`TIPP_TIP`,`SP_EVIDENCIONI_BROJ`,`SP_VERZIJA`),
  CONSTRAINT `FK_PROGRAMI_U_DOKUMENTU` FOREIGN KEY (`TIP_UST`, `REG_VU_IDENTIFIKATOR`, `AD_GODINA`, `AD_EVIDENCIONI_BROJ`, `AD_VERZIJA`) REFERENCES `dokument_o_akreditaciji` (`TIP_UST`, `VU_IDENTIFIKATOR`, `AD_GODINA`, `AD_EVIDENCIONI_BROJ`, `AD_VERZIJA`),
  CONSTRAINT `FK_PROGRAM_U_OBUHVATU` FOREIGN KEY (`TIP_UST`, `REG_VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`) REFERENCES `registrovani_programi` (`TIP_UST`, `VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of obuhvat_akreditacije
-- ----------------------------

-- ----------------------------
-- Table structure for odgovorni_rukovodilac
-- ----------------------------
DROP TABLE IF EXISTS `odgovorni_rukovodilac`;
CREATE TABLE `odgovorni_rukovodilac` (
  `TIP_UST` char(2) NOT NULL,
  `REG_VU_IDENTIFIKATOR` int(11) NOT NULL,
  `ZAP_REDNI_BROJ` decimal(6,0) NOT NULL,
  `DOK_TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `VD_OZNAKA` char(2) NOT NULL,
  `UG_GODINA` decimal(4,0) NOT NULL,
  `UG_BROJ_UGOVORA` int(11) NOT NULL,
  PRIMARY KEY (`DOK_TIP_UST`,`TIP_UST`,`REG_VU_IDENTIFIKATOR`,`VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`,`VD_OZNAKA`,`UG_GODINA`,`UG_BROJ_UGOVORA`),
  KEY `FK_ODGOVORNI_RUKOVODILAC` (`TIP_UST`,`REG_VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`),
  KEY `FK_ODGOVORNI_RUKOVODILAC2` (`DOK_TIP_UST`,`VU_IDENTIFIKATOR`,`VD_OZNAKA`,`UG_GODINA`,`UG_BROJ_UGOVORA`),
  CONSTRAINT `FK_ODGOVORNI_RUKOVODILAC` FOREIGN KEY (`TIP_UST`, `REG_VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`) REFERENCES `registar_zaposlenih` (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`),
  CONSTRAINT `FK_ODGOVORNI_RUKOVODILAC2` FOREIGN KEY (`DOK_TIP_UST`, `VU_IDENTIFIKATOR`, `VD_OZNAKA`, `UG_GODINA`, `UG_BROJ_UGOVORA`) REFERENCES `dokumenti_o_zaposlenim` (`TIP_UST`, `VU_IDENTIFIKATOR`, `VD_OZNAKA`, `UG_GODINA`, `UG_BROJ_DOKUMENTA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of odgovorni_rukovodilac
-- ----------------------------

-- ----------------------------
-- Table structure for organizacija_nastave
-- ----------------------------
DROP TABLE IF EXISTS `organizacija_nastave`;
CREATE TABLE `organizacija_nastave` (
  `ON_OZNAKA` char(1) NOT NULL,
  `ON_NAZIV` varchar(20) NOT NULL,
  PRIMARY KEY (`ON_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of organizacija_nastave
-- ----------------------------

-- ----------------------------
-- Table structure for organizaciona_sema
-- ----------------------------
DROP TABLE IF EXISTS `organizaciona_sema`;
CREATE TABLE `organizaciona_sema` (
  `TIP_UST` char(2) NOT NULL,
  `AKT_VU_IDENTIFIKATOR` int(11) NOT NULL,
  `AO_REDNI_BROJ` decimal(4,0) NOT NULL,
  `OJ_IDENTIFIKATOR` int(11) NOT NULL,
  PRIMARY KEY (`TIP_UST`,`AKT_VU_IDENTIFIKATOR`,`AO_REDNI_BROJ`,`OJ_IDENTIFIKATOR`),
  KEY `FK_ORGANIZACIONA_SEMA2` (`TIP_UST`,`AKT_VU_IDENTIFIKATOR`,`OJ_IDENTIFIKATOR`),
  CONSTRAINT `FK_ORGANIZACIONA_SEMA` FOREIGN KEY (`TIP_UST`, `AKT_VU_IDENTIFIKATOR`, `AO_REDNI_BROJ`) REFERENCES `akt_o_organizaciji` (`TIP_UST`, `VU_IDENTIFIKATOR`, `AO_REDNI_BROJ`),
  CONSTRAINT `FK_ORGANIZACIONA_SEMA2` FOREIGN KEY (`TIP_UST`, `AKT_VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`) REFERENCES `organizacione_jedinice` (`TIP_UST`, `VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of organizaciona_sema
-- ----------------------------

-- ----------------------------
-- Table structure for organizacione_jedinice
-- ----------------------------
DROP TABLE IF EXISTS `organizacione_jedinice`;
CREATE TABLE `organizacione_jedinice` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `OJ_IDENTIFIKATOR` int(11) NOT NULL,
  `OJ_NAZIV` varchar(80) NOT NULL,
  `NM_IDENTIFIKATOR` bigint(20) NOT NULL,
  `OJ_ADRESA` varchar(80) DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`OJ_IDENTIFIKATOR`),
  KEY `FK_SEDISTE_JEDINICE` (`NM_IDENTIFIKATOR`),
  CONSTRAINT `FK_SEDISTE_JEDINICE` FOREIGN KEY (`NM_IDENTIFIKATOR`) REFERENCES `naseljeno_mesto` (`NM_IDENTIFIKATOR`),
  CONSTRAINT `FK_UNUTRASNJA_ORGANIZACIJA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of organizacione_jedinice
-- ----------------------------
INSERT INTO `organizacione_jedinice` VALUES ('DH', '22', '7', 'Poslovna jedinica 1', '1', 'Marsala Tita 15');
INSERT INTO `organizacione_jedinice` VALUES ('PM', '23', '1', 'Centar Beograd', '1', 'Danijelova 32');
INSERT INTO `organizacione_jedinice` VALUES ('PM', '23', '2', 'Centar Novi Sad', '2', 'Adresa u Novom Sadru');
INSERT INTO `organizacione_jedinice` VALUES ('PM', '23', '3', 'Centar Niš', '3', 'Adresa pored reke');
INSERT INTO `organizacione_jedinice` VALUES ('PM', '24', '6', 'Bezanija', '1', 'asdadsadsads');
INSERT INTO `organizacione_jedinice` VALUES ('TT', '25', '8', 'Jedinica 1', '4', 'Narodnih heroja');
INSERT INTO `organizacione_jedinice` VALUES ('UM', '32', '10', 'dhfgh', '1', 'fhffh');

-- ----------------------------
-- Table structure for povezane_kompetencije
-- ----------------------------
DROP TABLE IF EXISTS `povezane_kompetencije`;
CREATE TABLE `povezane_kompetencije` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `TIPP_TIP` char(1) NOT NULL,
  `SP_EVIDENCIONI_BROJ` int(11) NOT NULL,
  `SP_VERZIJA` decimal(2,0) NOT NULL,
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `OBL_OBLAST` char(2) NOT NULL,
  `KOMP_KATEGORIJA` char(2) NOT NULL,
  `KO_KOMPETENCIJA` char(2) NOT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`TIPP_TIP`,`SP_EVIDENCIONI_BROJ`,`SP_VERZIJA`,`KO_KOMPETENCIJA`),
  KEY `FK_POVEZANE_KOMPETENCIJE` (`TIP_UST`,`VU_IDENTIFIKATOR`,`TIPP_TIP`,`SP_EVIDENCIONI_BROJ`,`SP_VERZIJA`),
  KEY `FK_POVEZANE_KOMPETENCIJE2` (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`KO_KOMPETENCIJA`),
  CONSTRAINT `FK_POVEZANE_KOMPETENCIJE` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`) REFERENCES `registrovani_programi` (`TIP_UST`, `VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`),
  CONSTRAINT `FK_POVEZANE_KOMPETENCIJE2` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KO_KOMPETENCIJA`) REFERENCES `kompetencije` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KO_KOMPETENCIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of povezane_kompetencije
-- ----------------------------

-- ----------------------------
-- Table structure for pozicije_u_semi
-- ----------------------------
DROP TABLE IF EXISTS `pozicije_u_semi`;
CREATE TABLE `pozicije_u_semi` (
  `VIS_TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `RS_IDENTIFIKATOR` smallint(6) NOT NULL,
  `POZ_OZNAKA` char(2) NOT NULL,
  PRIMARY KEY (`VIS_TIP_UST`,`VU_IDENTIFIKATOR`,`POZ_OZNAKA`,`RS_IDENTIFIKATOR`),
  KEY `FK_POZICIJE_U_SEMI` (`POZ_OZNAKA`),
  KEY `FK_POZICIJE_U_SEMI2` (`VIS_TIP_UST`,`VU_IDENTIFIKATOR`,`RS_IDENTIFIKATOR`),
  CONSTRAINT `FK_POZICIJE_U_SEMI` FOREIGN KEY (`POZ_OZNAKA`) REFERENCES `pozicije___funkcije` (`POZ_OZNAKA`),
  CONSTRAINT `FK_POZICIJE_U_SEMI2` FOREIGN KEY (`VIS_TIP_UST`, `VU_IDENTIFIKATOR`, `RS_IDENTIFIKATOR`) REFERENCES `rukovodna_sema` (`VIS_TIP_UST`, `VU_IDENTIFIKATOR`, `RS_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pozicije_u_semi
-- ----------------------------

-- ----------------------------
-- Table structure for pozicije___funkcije
-- ----------------------------
DROP TABLE IF EXISTS `pozicije___funkcije`;
CREATE TABLE `pozicije___funkcije` (
  `POZ_OZNAKA` char(2) NOT NULL,
  `POZ_NAZIV` varchar(60) NOT NULL,
  PRIMARY KEY (`POZ_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pozicije___funkcije
-- ----------------------------

-- ----------------------------
-- Table structure for pravna_lica
-- ----------------------------
DROP TABLE IF EXISTS `pravna_lica`;
CREATE TABLE `pravna_lica` (
  `PL_OZNAKA` int(11) NOT NULL,
  `PL_NAZIV` varchar(120) NOT NULL,
  PRIMARY KEY (`PL_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of pravna_lica
-- ----------------------------

-- ----------------------------
-- Table structure for radna_mesta
-- ----------------------------
DROP TABLE IF EXISTS `radna_mesta`;
CREATE TABLE `radna_mesta` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `RM_OZNAKA` char(3) NOT NULL,
  `RM_NAZIV` varchar(50) NOT NULL,
  `RM_OPERATIVNO` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`RM_OZNAKA`),
  CONSTRAINT `FK_SISTEMATIZACIJA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of radna_mesta
-- ----------------------------

-- ----------------------------
-- Table structure for rasporedi_na_radna_mesta
-- ----------------------------
DROP TABLE IF EXISTS `rasporedi_na_radna_mesta`;
CREATE TABLE `rasporedi_na_radna_mesta` (
  `REG_TIP_UST` char(2) NOT NULL,
  `REG_VU_IDENTIFIKATOR` int(11) NOT NULL,
  `ZAP_REDNI_BROJ` decimal(6,0) NOT NULL,
  `RAS_RBR` decimal(4,0) NOT NULL,
  `VRO_OZNAKA` char(2) DEFAULT NULL,
  `RM_OZNAKA` char(3) NOT NULL,
  `OJ_IDENTIFIKATOR` int(11) NOT NULL,
  `RAS_ODKADA` date NOT NULL,
  `RAS_DO_KADA` date DEFAULT NULL,
  PRIMARY KEY (`REG_TIP_UST`,`REG_VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`,`RAS_RBR`),
  KEY `FK_DODELJENI_ZAPOSLENI` (`REG_TIP_UST`,`REG_VU_IDENTIFIKATOR`,`OJ_IDENTIFIKATOR`),
  KEY `FK_KO_JE_RASPOREDJEN` (`REG_TIP_UST`,`REG_VU_IDENTIFIKATOR`,`RM_OZNAKA`),
  KEY `FK_VRSTA_U_USTANOVI` (`VRO_OZNAKA`),
  CONSTRAINT `FK_DODELJENI_ZAPOSLENI` FOREIGN KEY (`REG_TIP_UST`, `REG_VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`) REFERENCES `organizacione_jedinice` (`TIP_UST`, `VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`),
  CONSTRAINT `FK_KO_JE_RASPOREDJEN` FOREIGN KEY (`REG_TIP_UST`, `REG_VU_IDENTIFIKATOR`, `RM_OZNAKA`) REFERENCES `radna_mesta` (`TIP_UST`, `VU_IDENTIFIKATOR`, `RM_OZNAKA`),
  CONSTRAINT `FK_RASPORED_RADA` FOREIGN KEY (`REG_TIP_UST`, `REG_VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`) REFERENCES `registar_zaposlenih` (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`),
  CONSTRAINT `FK_VRSTA_U_USTANOVI` FOREIGN KEY (`VRO_OZNAKA`) REFERENCES `vrsta_radnog_odnosa` (`VRO_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of rasporedi_na_radna_mesta
-- ----------------------------

-- ----------------------------
-- Table structure for registar_grupa_obrazovanja
-- ----------------------------
DROP TABLE IF EXISTS `registar_grupa_obrazovanja`;
CREATE TABLE `registar_grupa_obrazovanja` (
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `GRU_NAZIV` varchar(120) NOT NULL,
  PRIMARY KEY (`PO_POLJE`,`GRU_GRUPA`),
  CONSTRAINT `FK_IMA_GRUPE` FOREIGN KEY (`PO_POLJE`) REFERENCES `registar_obrazovnih_polja` (`PO_POLJE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of registar_grupa_obrazovanja
-- ----------------------------

-- ----------------------------
-- Table structure for registar_oblasti_obrazovanja
-- ----------------------------
DROP TABLE IF EXISTS `registar_oblasti_obrazovanja`;
CREATE TABLE `registar_oblasti_obrazovanja` (
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `OBL_OBLAST` char(2) NOT NULL,
  `OBL_NAZIV` varchar(120) NOT NULL,
  `OBL_KORPUS` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`),
  CONSTRAINT `FK_IMA_OBLASTI` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`) REFERENCES `registar_grupa_obrazovanja` (`PO_POLJE`, `GRU_GRUPA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of registar_oblasti_obrazovanja
-- ----------------------------

-- ----------------------------
-- Table structure for registar_obrazovnih_polja
-- ----------------------------
DROP TABLE IF EXISTS `registar_obrazovnih_polja`;
CREATE TABLE `registar_obrazovnih_polja` (
  `PO_POLJE` char(2) NOT NULL,
  `PO_NAZIV` varchar(120) NOT NULL,
  PRIMARY KEY (`PO_POLJE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of registar_obrazovnih_polja
-- ----------------------------

-- ----------------------------
-- Table structure for registar_strucnih_naziva
-- ----------------------------
DROP TABLE IF EXISTS `registar_strucnih_naziva`;
CREATE TABLE `registar_strucnih_naziva` (
  `SN_OZNAKA` char(2) NOT NULL,
  `SN_STRUCNI_NAZIV` varchar(120) NOT NULL,
  `SN_SKRACENI_NAZIV` varchar(12) NOT NULL,
  PRIMARY KEY (`SN_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of registar_strucnih_naziva
-- ----------------------------

-- ----------------------------
-- Table structure for registar_zaposlenih
-- ----------------------------
DROP TABLE IF EXISTS `registar_zaposlenih`;
CREATE TABLE `registar_zaposlenih` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `ZAP_REDNI_BROJ` decimal(6,0) NOT NULL,
  `ZAP_PREZIME` varchar(20) NOT NULL,
  `ZAP_SREDNJE_SLOVO` char(2) NOT NULL,
  `ZAP_IME` varchar(20) NOT NULL,
  `ZAP_FOTOGRAFIJA` longblob,
  `ZAP_JMBG` char(13) DEFAULT NULL,
  `RCP_REDNI_BROJ` decimal(2,0) DEFAULT NULL,
  `CLA_ZAP_REDNI_BROJ` decimal(6,0) DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`),
  KEY `FK_ZAPOSLEN_KOD_POSLODAVCA` (`TIP_UST`,`VU_IDENTIFIKATOR`,`CLA_ZAP_REDNI_BROJ`,`RCP_REDNI_BROJ`),
  CONSTRAINT `FK_UPOSLJAVA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`),
  CONSTRAINT `FK_ZAPOSLEN_KOD_POSLODAVCA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `CLA_ZAP_REDNI_BROJ`, `RCP_REDNI_BROJ`) REFERENCES `clanovi_podorice` (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`, `RCP_REDNI_BROJ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of registar_zaposlenih
-- ----------------------------

-- ----------------------------
-- Table structure for registrovani_programi
-- ----------------------------
DROP TABLE IF EXISTS `registrovani_programi`;
CREATE TABLE `registrovani_programi` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `TIPP_TIP` char(1) NOT NULL,
  `SP_EVIDENCIONI_BROJ` int(11) NOT NULL,
  `SP_VERZIJA` decimal(2,0) NOT NULL,
  `SP_NAZIV` varchar(60) NOT NULL,
  `STS_OZNAKA` char(2) NOT NULL,
  `NS_NIVO` decimal(1,0) NOT NULL,
  `JEZ_JERIK2` char(3) NOT NULL,
  `SN_OZNAKA` char(2) NOT NULL,
  `SP_DATUM_FORMIRANJA` date NOT NULL,
  `SP_DATUM_UKIDANJA` date DEFAULT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`TIPP_TIP`,`SP_EVIDENCIONI_BROJ`,`SP_VERZIJA`),
  KEY `FK_DIPLOMIRANJEM_POSTAJE` (`SN_OZNAKA`),
  KEY `FK_JEZIK_PROGRAMA` (`JEZ_JERIK2`),
  KEY `FK_STEPEN_I_NIVO_STUDIJA` (`STS_OZNAKA`,`NS_NIVO`),
  KEY `FK_TIPIZIRANI_PROGRAMI` (`TIPP_TIP`),
  CONSTRAINT `FK_DIPLOMIRANJEM_POSTAJE` FOREIGN KEY (`SN_OZNAKA`) REFERENCES `registar_strucnih_naziva` (`SN_OZNAKA`),
  CONSTRAINT `FK_JEZIK_PROGRAMA` FOREIGN KEY (`JEZ_JERIK2`) REFERENCES `jezici` (`JEZ_JERIK2`),
  CONSTRAINT `FK_STEPEN_I_NIVO_STUDIJA` FOREIGN KEY (`STS_OZNAKA`, `NS_NIVO`) REFERENCES `nivo_studija` (`STS_OZNAKA`, `NS_NIVO`),
  CONSTRAINT `FK_STUDIJSKI_PROGRAMI_USTANOVE` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`),
  CONSTRAINT `FK_TIPIZIRANI_PROGRAMI` FOREIGN KEY (`TIPP_TIP`) REFERENCES `tip_programa` (`TIPP_TIP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of registrovani_programi
-- ----------------------------

-- ----------------------------
-- Table structure for rukovodna_sema
-- ----------------------------
DROP TABLE IF EXISTS `rukovodna_sema`;
CREATE TABLE `rukovodna_sema` (
  `VIS_TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `RS_IDENTIFIKATOR` smallint(6) NOT NULL,
  `RS_DATUM_FORMIRANJA` date NOT NULL,
  `OJ_IDENTIFIKATOR` int(11) NOT NULL,
  PRIMARY KEY (`VIS_TIP_UST`,`VU_IDENTIFIKATOR`,`RS_IDENTIFIKATOR`),
  KEY `FK_FORMIRAN_OD_STRANE` (`VIS_TIP_UST`,`VU_IDENTIFIKATOR`,`OJ_IDENTIFIKATOR`),
  CONSTRAINT `FK_FORMIRAN_OD_STRANE` FOREIGN KEY (`VIS_TIP_UST`, `VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`) REFERENCES `organizacione_jedinice` (`TIP_UST`, `VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`),
  CONSTRAINT `FK_POSEBNE_POZICIJE` FOREIGN KEY (`VIS_TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of rukovodna_sema
-- ----------------------------

-- ----------------------------
-- Table structure for sastav_jedinice
-- ----------------------------
DROP TABLE IF EXISTS `sastav_jedinice`;
CREATE TABLE `sastav_jedinice` (
  `ORG_TIP_UST` char(2) NOT NULL,
  `ORG_VU_IDENTIFIKATOR` int(11) NOT NULL,
  `ORG_OJ_IDENTIFIKATOR` int(11) NOT NULL,
  `OJ_IDENTIFIKATOR` int(11) NOT NULL,
  PRIMARY KEY (`ORG_TIP_UST`,`ORG_VU_IDENTIFIKATOR`,`OJ_IDENTIFIKATOR`,`ORG_OJ_IDENTIFIKATOR`),
  KEY `FK_SLOZENA_JEDINICA` (`ORG_TIP_UST`,`ORG_VU_IDENTIFIKATOR`,`ORG_OJ_IDENTIFIKATOR`),
  CONSTRAINT `FK_JEDINICA_U_SASTAVU` FOREIGN KEY (`ORG_TIP_UST`, `ORG_VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`) REFERENCES `organizacione_jedinice` (`TIP_UST`, `VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`),
  CONSTRAINT `FK_SLOZENA_JEDINICA` FOREIGN KEY (`ORG_TIP_UST`, `ORG_VU_IDENTIFIKATOR`, `ORG_OJ_IDENTIFIKATOR`) REFERENCES `organizacione_jedinice` (`TIP_UST`, `VU_IDENTIFIKATOR`, `OJ_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sastav_jedinice
-- ----------------------------

-- ----------------------------
-- Table structure for sastav_slozene_ustanove
-- ----------------------------
DROP TABLE IF EXISTS `sastav_slozene_ustanove`;
CREATE TABLE `sastav_slozene_ustanove` (
  `TIP_UST` char(2) NOT NULL,
  `AKT_VU_IDENTIFIKATOR` int(11) NOT NULL,
  `AO_REDNI_BROJ` decimal(4,0) NOT NULL,
  `VIS_TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  PRIMARY KEY (`VIS_TIP_UST`,`TIP_UST`,`AKT_VU_IDENTIFIKATOR`,`AO_REDNI_BROJ`,`VU_IDENTIFIKATOR`),
  KEY `FK_SASTAV_SLOZENE_USTANOVE` (`TIP_UST`,`AKT_VU_IDENTIFIKATOR`,`AO_REDNI_BROJ`),
  KEY `FK_SASTAV_SLOZENE_USTANOVE2` (`VIS_TIP_UST`,`VU_IDENTIFIKATOR`),
  CONSTRAINT `FK_SASTAV_SLOZENE_USTANOVE` FOREIGN KEY (`TIP_UST`, `AKT_VU_IDENTIFIKATOR`, `AO_REDNI_BROJ`) REFERENCES `akt_o_organizaciji` (`TIP_UST`, `VU_IDENTIFIKATOR`, `AO_REDNI_BROJ`),
  CONSTRAINT `FK_SASTAV_SLOZENE_USTANOVE2` FOREIGN KEY (`VIS_TIP_UST`, `VU_IDENTIFIKATOR`) REFERENCES `visokoskolska_ustanova` (`TIP_UST`, `VU_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sastav_slozene_ustanove
-- ----------------------------

-- ----------------------------
-- Table structure for skolpleni_sa
-- ----------------------------
DROP TABLE IF EXISTS `skolpleni_sa`;
CREATE TABLE `skolpleni_sa` (
  `DOK_TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `VD_OZNAKA` char(2) NOT NULL,
  `UG_GODINA` decimal(4,0) NOT NULL,
  `UG_BROJ_UGOVORA` int(11) NOT NULL,
  `TIP_UST` char(2) NOT NULL,
  `REG_VU_IDENTIFIKATOR` int(11) NOT NULL,
  `ZAP_REDNI_BROJ` decimal(6,0) NOT NULL,
  PRIMARY KEY (`DOK_TIP_UST`,`TIP_UST`,`REG_VU_IDENTIFIKATOR`,`VU_IDENTIFIKATOR`,`VD_OZNAKA`,`UG_GODINA`,`UG_BROJ_UGOVORA`,`ZAP_REDNI_BROJ`),
  KEY `FK_SKOLPLENI_SA` (`DOK_TIP_UST`,`VU_IDENTIFIKATOR`,`VD_OZNAKA`,`UG_GODINA`,`UG_BROJ_UGOVORA`),
  KEY `FK_SKOLPLENI_SA2` (`TIP_UST`,`REG_VU_IDENTIFIKATOR`,`ZAP_REDNI_BROJ`),
  CONSTRAINT `FK_SKOLPLENI_SA` FOREIGN KEY (`DOK_TIP_UST`, `VU_IDENTIFIKATOR`, `VD_OZNAKA`, `UG_GODINA`, `UG_BROJ_UGOVORA`) REFERENCES `dokumenti_o_zaposlenim` (`TIP_UST`, `VU_IDENTIFIKATOR`, `VD_OZNAKA`, `UG_GODINA`, `UG_BROJ_DOKUMENTA`),
  CONSTRAINT `FK_SKOLPLENI_SA2` FOREIGN KEY (`TIP_UST`, `REG_VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`) REFERENCES `registar_zaposlenih` (`TIP_UST`, `VU_IDENTIFIKATOR`, `ZAP_REDNI_BROJ`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of skolpleni_sa
-- ----------------------------

-- ----------------------------
-- Table structure for slozena_drzava
-- ----------------------------
DROP TABLE IF EXISTS `slozena_drzava`;
CREATE TABLE `slozena_drzava` (
  `DR_IDENTIFIKATOR` char(3) NOT NULL,
  `DRZ_DR_IDENTIFIKATOR` char(3) NOT NULL,
  PRIMARY KEY (`DR_IDENTIFIKATOR`,`DRZ_DR_IDENTIFIKATOR`),
  KEY `FK_DR_AVA_U_SASTAVU` (`DRZ_DR_IDENTIFIKATOR`),
  CONSTRAINT `FK_DR_AVA_U_SASTAVU` FOREIGN KEY (`DRZ_DR_IDENTIFIKATOR`) REFERENCES `drzava` (`DR_IDENTIFIKATOR`),
  CONSTRAINT `FK_SLOZENA_DRZAVA` FOREIGN KEY (`DR_IDENTIFIKATOR`) REFERENCES `drzava` (`DR_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of slozena_drzava
-- ----------------------------

-- ----------------------------
-- Table structure for sluzbeni_jezici
-- ----------------------------
DROP TABLE IF EXISTS `sluzbeni_jezici`;
CREATE TABLE `sluzbeni_jezici` (
  `JEZ_JERIK2` char(3) NOT NULL,
  `DR_IDENTIFIKATOR` char(3) NOT NULL,
  PRIMARY KEY (`JEZ_JERIK2`,`DR_IDENTIFIKATOR`),
  KEY `FK_SLUZBENI_JEZICI2` (`DR_IDENTIFIKATOR`),
  CONSTRAINT `FK_SLUZBENI_JEZICI` FOREIGN KEY (`JEZ_JERIK2`) REFERENCES `jezici` (`JEZ_JERIK2`),
  CONSTRAINT `FK_SLUZBENI_JEZICI2` FOREIGN KEY (`DR_IDENTIFIKATOR`) REFERENCES `drzava` (`DR_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of sluzbeni_jezici
-- ----------------------------

-- ----------------------------
-- Table structure for stepen_studija
-- ----------------------------
DROP TABLE IF EXISTS `stepen_studija`;
CREATE TABLE `stepen_studija` (
  `STS_OZNAKA` char(2) NOT NULL,
  `STS_NAZIV` varchar(40) NOT NULL,
  PRIMARY KEY (`STS_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of stepen_studija
-- ----------------------------

-- ----------------------------
-- Table structure for struktura_dokumentacije
-- ----------------------------
DROP TABLE IF EXISTS `struktura_dokumentacije`;
CREATE TABLE `struktura_dokumentacije` (
  `JEZ_JERIK2` char(3) NOT NULL,
  `OSNOVNI_TIP_DOKUMENTA` char(2) NOT NULL,
  `SDOK_NIVO` decimal(2,0) NOT NULL,
  `SADRZANI_TIP_DOKUMENTA` char(2) NOT NULL,
  `SDOK_NAZIV` varchar(120) NOT NULL,
  PRIMARY KEY (`JEZ_JERIK2`,`OSNOVNI_TIP_DOKUMENTA`,`SADRZANI_TIP_DOKUMENTA`,`SDOK_NIVO`),
  KEY `FK_SADRZANI` (`JEZ_JERIK2`,`SADRZANI_TIP_DOKUMENTA`),
  CONSTRAINT `FK_OSNOVNI` FOREIGN KEY (`JEZ_JERIK2`, `OSNOVNI_TIP_DOKUMENTA`) REFERENCES `tip_dokumentacije` (`JEZ_JERIK2`, `TIP_DOKUMENTA`),
  CONSTRAINT `FK_SADRZANI` FOREIGN KEY (`JEZ_JERIK2`, `SADRZANI_TIP_DOKUMENTA`) REFERENCES `tip_dokumentacije` (`JEZ_JERIK2`, `TIP_DOKUMENTA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of struktura_dokumentacije
-- ----------------------------

-- ----------------------------
-- Table structure for struktura_programa
-- ----------------------------
DROP TABLE IF EXISTS `struktura_programa`;
CREATE TABLE `struktura_programa` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `TIPP_TIP` char(1) NOT NULL,
  `SP_EVIDENCIONI_BROJ` int(11) NOT NULL,
  `SP_VERZIJA` decimal(2,0) NOT NULL,
  `ON_OZNAKA` char(1) NOT NULL,
  `BLOKN_REDNI_BROJ` decimal(2,0) NOT NULL,
  `BLOKN_TRAJE` decimal(2,0) NOT NULL DEFAULT '1',
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`TIPP_TIP`,`SP_EVIDENCIONI_BROJ`,`SP_VERZIJA`,`ON_OZNAKA`,`BLOKN_REDNI_BROJ`),
  KEY `FK_BLOK_NASTAVE` (`ON_OZNAKA`),
  CONSTRAINT `FK_BLOK_NASTAVE` FOREIGN KEY (`ON_OZNAKA`) REFERENCES `organizacija_nastave` (`ON_OZNAKA`),
  CONSTRAINT `FK_STRUKTURIRANJE_PROGRAMA` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`) REFERENCES `registrovani_programi` (`TIP_UST`, `VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of struktura_programa
-- ----------------------------

-- ----------------------------
-- Table structure for strukturirane_kategorije
-- ----------------------------
DROP TABLE IF EXISTS `strukturirane_kategorije`;
CREATE TABLE `strukturirane_kategorije` (
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `OBL_OBLAST` char(2) NOT NULL,
  `KOMP_KATEGORIJA` char(2) NOT NULL,
  `KAT_KOMP_KATEGORIJA` char(2) NOT NULL,
  PRIMARY KEY (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`KAT_KOMP_KATEGORIJA`),
  KEY `FK_POVEZANA_KATEGORIJA` (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KAT_KOMP_KATEGORIJA`),
  CONSTRAINT `FK_OSNOVNA_KATEGORIJA` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`) REFERENCES `kategorija_kompetencije` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`),
  CONSTRAINT `FK_POVEZANA_KATEGORIJA` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KAT_KOMP_KATEGORIJA`) REFERENCES `kategorija_kompetencije` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of strukturirane_kategorije
-- ----------------------------

-- ----------------------------
-- Table structure for strukturirane_kompetencije
-- ----------------------------
DROP TABLE IF EXISTS `strukturirane_kompetencije`;
CREATE TABLE `strukturirane_kompetencije` (
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `OBL_OBLAST` char(2) NOT NULL,
  `KOMP_KATEGORIJA` char(2) NOT NULL,
  `KO_KOMPETENCIJA` char(2) NOT NULL,
  `KOM_KO_KOMPETENCIJA` char(2) NOT NULL,
  PRIMARY KEY (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`KO_KOMPETENCIJA`,`KOM_KO_KOMPETENCIJA`),
  KEY `FK_STRUKTURIRANE_KOMPETENCIJE2` (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`KOMP_KATEGORIJA`,`KOM_KO_KOMPETENCIJA`),
  CONSTRAINT `FK_OSNOVNA_KOMPETENCIJ` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KO_KOMPETENCIJA`) REFERENCES `kompetencije` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KO_KOMPETENCIJA`),
  CONSTRAINT `FK_STRUKTURIRANE_KOMPETENCIJE2` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KOM_KO_KOMPETENCIJA`) REFERENCES `kompetencije` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`, `KOMP_KATEGORIJA`, `KO_KOMPETENCIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of strukturirane_kompetencije
-- ----------------------------

-- ----------------------------
-- Table structure for tipovi_ustanova
-- ----------------------------
DROP TABLE IF EXISTS `tipovi_ustanova`;
CREATE TABLE `tipovi_ustanova` (
  `TIP_UST` char(2) NOT NULL,
  `TIP_NAZIV` varchar(40) NOT NULL,
  PRIMARY KEY (`TIP_UST`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tipovi_ustanova
-- ----------------------------
INSERT INTO `tipovi_ustanova` VALUES ('DH', 'društveno-humanističke nauke');
INSERT INTO `tipovi_ustanova` VALUES ('MD', 'medicinske nauke');
INSERT INTO `tipovi_ustanova` VALUES ('PM', 'prirodno-matematičke nauke');
INSERT INTO `tipovi_ustanova` VALUES ('TT', 'tehničko-tehnološke nauke');
INSERT INTO `tipovi_ustanova` VALUES ('UM', 'umetnost');

-- ----------------------------
-- Table structure for tip_dokumentacije
-- ----------------------------
DROP TABLE IF EXISTS `tip_dokumentacije`;
CREATE TABLE `tip_dokumentacije` (
  `JEZ_JERIK2` char(3) NOT NULL,
  `TIP_DOKUMENTA` char(2) NOT NULL,
  `TIP_NAZIV_TIPA` varchar(60) NOT NULL,
  PRIMARY KEY (`JEZ_JERIK2`,`TIP_DOKUMENTA`),
  CONSTRAINT `FK_NA_JEZICIMA` FOREIGN KEY (`JEZ_JERIK2`) REFERENCES `jezici` (`JEZ_JERIK2`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tip_dokumentacije
-- ----------------------------

-- ----------------------------
-- Table structure for tip_kontakta
-- ----------------------------
DROP TABLE IF EXISTS `tip_kontakta`;
CREATE TABLE `tip_kontakta` (
  `TKO_OZNAKA` char(1) NOT NULL,
  `TKO_NAZIV` varchar(30) NOT NULL,
  PRIMARY KEY (`TKO_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tip_kontakta
-- ----------------------------

-- ----------------------------
-- Table structure for tip_programa
-- ----------------------------
DROP TABLE IF EXISTS `tip_programa`;
CREATE TABLE `tip_programa` (
  `TIPP_TIP` char(1) NOT NULL,
  `TIPP_NAZIV` varchar(40) NOT NULL,
  PRIMARY KEY (`TIPP_TIP`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of tip_programa
-- ----------------------------

-- ----------------------------
-- Table structure for uloga
-- ----------------------------
DROP TABLE IF EXISTS `uloga`;
CREATE TABLE `uloga` (
  `ULO_OZNAKA` char(2) NOT NULL,
  `ULO_NAZIV` varchar(40) NOT NULL,
  PRIMARY KEY (`ULO_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of uloga
-- ----------------------------

-- ----------------------------
-- Table structure for u_drzavi
-- ----------------------------
DROP TABLE IF EXISTS `u_drzavi`;
CREATE TABLE `u_drzavi` (
  `DR_IDENTIFIKATOR` char(3) NOT NULL,
  `NM_IDENTIFIKATOR` bigint(20) NOT NULL,
  `UDR_REDNI_BROJ` decimal(1,0) NOT NULL,
  `OD_DATUMA` date DEFAULT NULL,
  `DO_DATUMA` date DEFAULT NULL,
  PRIMARY KEY (`DR_IDENTIFIKATOR`,`NM_IDENTIFIKATOR`,`UDR_REDNI_BROJ`),
  KEY `FK_U_DRZAVAMA` (`NM_IDENTIFIKATOR`),
  CONSTRAINT `FK_NASELJENA_MESTA` FOREIGN KEY (`DR_IDENTIFIKATOR`) REFERENCES `drzava` (`DR_IDENTIFIKATOR`),
  CONSTRAINT `FK_U_DRZAVAMA` FOREIGN KEY (`NM_IDENTIFIKATOR`) REFERENCES `naseljeno_mesto` (`NM_IDENTIFIKATOR`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of u_drzavi
-- ----------------------------

-- ----------------------------
-- Table structure for vidovi_nastave
-- ----------------------------
DROP TABLE IF EXISTS `vidovi_nastave`;
CREATE TABLE `vidovi_nastave` (
  `VID_VID` char(1) NOT NULL,
  `VID_NAZIV` varchar(40) NOT NULL,
  PRIMARY KEY (`VID_VID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of vidovi_nastave
-- ----------------------------

-- ----------------------------
-- Table structure for visokoskolska_ustanova
-- ----------------------------
DROP TABLE IF EXISTS `visokoskolska_ustanova`;
CREATE TABLE `visokoskolska_ustanova` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `VU_NAZIV` varchar(120) DEFAULT NULL,
  `DR_IDENTIFIKATOR` char(3) NOT NULL,
  `VU_OSNOVANA` date DEFAULT NULL,
  `NM_IDENTIFIKATOR` bigint(20) DEFAULT NULL,
  `VU_ADRESA` varchar(60) DEFAULT NULL,
  `VU_WEB_ADRESA` varchar(80) DEFAULT NULL,
  `VU_E_MAIL` varchar(60) DEFAULT NULL,
  `VV_OZNAKA` char(2) NOT NULL,
  `VU_PIB` char(10) DEFAULT NULL,
  `VU_MATICNI_BROJ` char(11) DEFAULT NULL,
  `VU_GRB` longblob,
  `VU_MEMORANDUM` longblob,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`),
  KEY `FK_IMA_VISIKOSKOLSKE_USTANOVE` (`NM_IDENTIFIKATOR`),
  KEY `FK_REGISTROVANE_USTANOVA` (`DR_IDENTIFIKATOR`),
  KEY `FK_VLASNICKA_ODREDNICA` (`VV_OZNAKA`),
  CONSTRAINT `FK_IMA_VISIKOSKOLSKE_USTANOVE` FOREIGN KEY (`NM_IDENTIFIKATOR`) REFERENCES `naseljeno_mesto` (`NM_IDENTIFIKATOR`),
  CONSTRAINT `FK_REGISTROVANE_USTANOVA` FOREIGN KEY (`DR_IDENTIFIKATOR`) REFERENCES `drzava` (`DR_IDENTIFIKATOR`),
  CONSTRAINT `FK_TIPIZIRA_USTANOVE` FOREIGN KEY (`TIP_UST`) REFERENCES `tipovi_ustanova` (`TIP_UST`),
  CONSTRAINT `FK_VLASNICKA_ODREDNICA` FOREIGN KEY (`VV_OZNAKA`) REFERENCES `vrsta_vlasnistva` (`VV_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of visokoskolska_ustanova
-- ----------------------------
INSERT INTO `visokoskolska_ustanova` VALUES ('DH', '22', 'Univerzitet Union', 'SRB', '2010-12-27', null, 'Prve probe 11', 'http://nesto.com', 'info@nesto.com', 'PR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('DH', '26', 'Filozofski fakultet', 'SRB', '1987-05-08', null, 'Studentski trg 2', 'filozof.com', 'filozof@f.com', 'DR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('DH', '33', 'djole', 'SRB', '2020-01-09', null, 'sdadasdasdas', 'adsdasdasds', 'adsdasads', 'PR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('MD', '27', 'Veterinarski fakultet', 'SRB', '1905-11-30', null, 'Bul oslobodjenja 15', 'vetfak.com', 'vetfak@vetfak.com', 'DR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('PM', '23', 'Univerzitet Singidunum', 'SRB', '2005-06-27', null, 'Danijelova 32', 'singidunum.ac.rs', 'office@singidunum.rs', 'PR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('PM', '24', 'Univerzitet VOG', 'SRB', '2019-02-10', null, 'Bezanija', 'vog.com', 'vog@mail.com', 'PR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('PM', '28', 'Prirodno-matematicki', 'SRB', '1925-05-01', null, 'Studentski trg 4', 'matf.com', 'matf@matf.rs', 'DR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('TT', '25', 'Sinergija', 'BIH', '2000-12-10', null, '11. oktobar 55', 'sinergija.com', 'sinergija@sin.com', 'PR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('TT', '29', 'Elektrotehnicki fakultet', 'SRB', '1920-01-01', null, 'Bul kralja Aleksandra', 'etf.com', 'etf@etf.ac.rs', 'DR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('UM', '30', 'Muzicka akademija', 'SRB', '1985-02-02', null, 'Resavska 15', 'ma.ac.rs', 'ma@ma.ac.rs', 'DR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('UM', '31', 'Akademija lepih umetnosti', 'SRB', '2005-05-06', null, 'Trg republike 2', 'alu.ac.rs', 'alu@alu.ac.rs', 'PR', null, null, null, null);
INSERT INTO `visokoskolska_ustanova` VALUES ('UM', '32', 'Fakultet dramskih umetnosti', 'SRB', '1999-04-05', null, 'Bulevar umetnosti', 'fdu.ac.rs', 'fdu@fdu.ac.rs', 'DR', null, null, null, null);

-- ----------------------------
-- Table structure for vrsta_dokumenta
-- ----------------------------
DROP TABLE IF EXISTS `vrsta_dokumenta`;
CREATE TABLE `vrsta_dokumenta` (
  `VD_OZNAKA` char(2) NOT NULL,
  `VD_NAZIV` varchar(40) NOT NULL,
  PRIMARY KEY (`VD_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of vrsta_dokumenta
-- ----------------------------

-- ----------------------------
-- Table structure for vrsta_radnog_odnosa
-- ----------------------------
DROP TABLE IF EXISTS `vrsta_radnog_odnosa`;
CREATE TABLE `vrsta_radnog_odnosa` (
  `VRO_OZNAKA` char(2) NOT NULL,
  `VRO_NAZIV` varchar(40) NOT NULL,
  PRIMARY KEY (`VRO_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of vrsta_radnog_odnosa
-- ----------------------------

-- ----------------------------
-- Table structure for vrsta_srodstva
-- ----------------------------
DROP TABLE IF EXISTS `vrsta_srodstva`;
CREATE TABLE `vrsta_srodstva` (
  `VSR_OZNAKA` char(2) NOT NULL,
  `VSR_NAZIV` varchar(30) NOT NULL,
  PRIMARY KEY (`VSR_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of vrsta_srodstva
-- ----------------------------

-- ----------------------------
-- Table structure for vrsta_vlasnistva
-- ----------------------------
DROP TABLE IF EXISTS `vrsta_vlasnistva`;
CREATE TABLE `vrsta_vlasnistva` (
  `VV_OZNAKA` char(2) NOT NULL,
  `VV_NAZIV` varchar(40) NOT NULL,
  PRIMARY KEY (`VV_OZNAKA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of vrsta_vlasnistva
-- ----------------------------
INSERT INTO `vrsta_vlasnistva` VALUES ('DR', 'državno');
INSERT INTO `vrsta_vlasnistva` VALUES ('PR', 'privatno');

-- ----------------------------
-- Table structure for za_oblasti_obrazovanja
-- ----------------------------
DROP TABLE IF EXISTS `za_oblasti_obrazovanja`;
CREATE TABLE `za_oblasti_obrazovanja` (
  `TIP_UST` char(2) NOT NULL,
  `VU_IDENTIFIKATOR` int(11) NOT NULL,
  `TIPP_TIP` char(1) NOT NULL,
  `SP_EVIDENCIONI_BROJ` int(11) NOT NULL,
  `SP_VERZIJA` decimal(2,0) NOT NULL,
  `PO_POLJE` char(2) NOT NULL,
  `GRU_GRUPA` char(2) NOT NULL,
  `OBL_OBLAST` char(2) NOT NULL,
  PRIMARY KEY (`TIP_UST`,`VU_IDENTIFIKATOR`,`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`,`TIPP_TIP`,`SP_EVIDENCIONI_BROJ`,`SP_VERZIJA`),
  KEY `FK_ZA_OBLASTI_OBRAZOVANJA` (`PO_POLJE`,`GRU_GRUPA`,`OBL_OBLAST`),
  KEY `FK_ZA_OBLASTI_OBRAZOVANJA2` (`TIP_UST`,`VU_IDENTIFIKATOR`,`TIPP_TIP`,`SP_EVIDENCIONI_BROJ`,`SP_VERZIJA`),
  CONSTRAINT `FK_ZA_OBLASTI_OBRAZOVANJA` FOREIGN KEY (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`) REFERENCES `registar_oblasti_obrazovanja` (`PO_POLJE`, `GRU_GRUPA`, `OBL_OBLAST`),
  CONSTRAINT `FK_ZA_OBLASTI_OBRAZOVANJA2` FOREIGN KEY (`TIP_UST`, `VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`) REFERENCES `registrovani_programi` (`TIP_UST`, `VU_IDENTIFIKATOR`, `TIPP_TIP`, `SP_EVIDENCIONI_BROJ`, `SP_VERZIJA`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of za_oblasti_obrazovanja
-- ----------------------------
DROP TRIGGER IF EXISTS `trigger_oj_bi`;
DELIMITER ;;
CREATE TRIGGER `trigger_oj_bi` BEFORE INSERT ON `organizacione_jedinice` FOR EACH ROW BEGIN
  SET NEW.OJ_IDENTIFIKATOR = ( SELECT IFNULL(MAX(OJ_IDENTIFIKATOR), 0) + 1 FROM organizacione_jedinice);
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `trigger_visokoskolska_ustanova_bi`;
DELIMITER ;;
CREATE TRIGGER `trigger_visokoskolska_ustanova_bi` BEFORE INSERT ON `visokoskolska_ustanova` FOR EACH ROW BEGIN
  SET NEW.VU_IDENTIFIKATOR = (SELECT MAX(visokoskolska_ustanova.VU_IDENTIFIKATOR) FROM visokoskolska_ustanova) + 1;
END
;;
DELIMITER ;
