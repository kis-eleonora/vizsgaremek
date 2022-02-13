-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2022. Feb 13. 18:28
-- Kiszolgáló verziója: 10.4.21-MariaDB
-- PHP verzió: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `vizsgaremek`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `beosztasok`
--

CREATE TABLE `beosztasok` (
  `Beosztas_ID` int(11) NOT NULL,
  `Szemely_ID` int(11) NOT NULL,
  `Kezdete` datetime NOT NULL,
  `Vege` datetime NOT NULL,
  `Munkanap` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jelenletek`
--

CREATE TABLE `jelenletek` (
  `Jelenlet_ID` int(11) NOT NULL,
  `Szemely_ID` int(11) NOT NULL,
  `Kezdete` datetime NOT NULL,
  `Vege` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jogosultsag`
--

CREATE TABLE `jogosultsag` (
  `jog_ID` int(11) NOT NULL,
  `Megnevezes` varchar(30) COLLATE utf8mb4_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `jogosultsag`
--

INSERT INTO `jogosultsag` (`jog_ID`, `Megnevezes`) VALUES
(1, 'Vezető'),
(2, 'Beosztott');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `munkarendek`
--

CREATE TABLE `munkarendek` (
  `Munkarend_ID` int(11) NOT NULL,
  `Megnevezes` varchar(30) COLLATE utf8mb4_hungarian_ci NOT NULL COMMENT 'Általános (8-16.20.ig) vagy kötetlen munkarend'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `munkarendek`
--

INSERT INTO `munkarendek` (`Munkarend_ID`, `Megnevezes`) VALUES
(1, 'Általános munkarend'),
(2, 'Kötetlen munkaidő');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `osztalyok`
--

CREATE TABLE `osztalyok` (
  `Osztaly_ID` int(11) NOT NULL,
  `Megnevezes` varchar(30) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `Osztalyvezeto_ID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szemelyek`
--

CREATE TABLE `szemelyek` (
  `Szemely_ID` int(11) NOT NULL,
  `jog_ID` int(11) NOT NULL COMMENT 'Kapcsolat a Jogosultsagok tablaval.',
  `osztaly_ID` int(11) DEFAULT NULL COMMENT 'Kapcsolat az Osztalyok tablaval.',
  `munkarend_ID` int(11) NOT NULL,
  `nev` varchar(50) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `Adoazonosito` int(10) NOT NULL,
  `Munkakor` varchar(50) COLLATE utf8mb4_hungarian_ci NOT NULL COMMENT 'Kereskedelmi-osztaly vezeto, vagy kereskedo...',
  `Belepes_Datum` date NOT NULL,
  `email` varchar(50) COLLATE utf8mb4_hungarian_ci NOT NULL COMMENT 'Egy e-mail cim csak egyszer szerepelhet.',
  `jelszo` varchar(50) COLLATE utf8mb4_hungarian_ci NOT NULL COMMENT 'Egy jelszo csak egyszer szerepelhet.',
  `Napi_munkaido` float NOT NULL DEFAULT 8 COMMENT 'Órában meghatározva.',
  `Munkakozi_szunet` float NOT NULL DEFAULT 20 COMMENT 'Percekben meghatározva.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- A tábla adatainak kiíratása `szemelyek`
--

INSERT INTO `szemelyek` (`Szemely_ID`, `jog_ID`, `osztaly_ID`, `munkarend_ID`, `nev`, `Adoazonosito`, `Munkakor`, `Belepes_Datum`, `email`, `jelszo`, `Napi_munkaido`, `Munkakozi_szunet`) VALUES
(3, 2, NULL, 1, 'Tóth János', 123456789, 'Hegesztő', '2022-01-01', 'valami@valami.com', '81dc9bdb52d04dc20036dbd8313ed055', 8, 20),
(5, 1, NULL, 2, 'Kovács István', 112233445, 'Vezető', '2022-01-01', 'masvalaki@gmail.com', '827ccb0eea8a706c4c34a16891f84e7b', 8, 20);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szemelyjogosultsag`
--

CREATE TABLE `szemelyjogosultsag` (
  `Szemely_ID` int(11) NOT NULL,
  `Jog_ID` int(11) NOT NULL,
  `HatalyDatum` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szemely_tavollet`
--

CREATE TABLE `szemely_tavollet` (
  `Szemely_ID` int(11) NOT NULL,
  `Tavollet_ID` varchar(1) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `Kezdete` date NOT NULL,
  `Vege` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `tavolletek`
--

CREATE TABLE `tavolletek` (
  `Tavollet_ID` varchar(1) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `Tavollet_fajta` varchar(30) COLLATE utf8mb4_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `beosztasok`
--
ALTER TABLE `beosztasok`
  ADD PRIMARY KEY (`Beosztas_ID`),
  ADD KEY `Szemely_ID` (`Szemely_ID`);

--
-- A tábla indexei `jelenletek`
--
ALTER TABLE `jelenletek`
  ADD PRIMARY KEY (`Jelenlet_ID`),
  ADD UNIQUE KEY `Szemely_ID` (`Szemely_ID`);

--
-- A tábla indexei `jogosultsag`
--
ALTER TABLE `jogosultsag`
  ADD PRIMARY KEY (`jog_ID`);

--
-- A tábla indexei `munkarendek`
--
ALTER TABLE `munkarendek`
  ADD PRIMARY KEY (`Munkarend_ID`),
  ADD KEY `Munkarend_ID` (`Munkarend_ID`);

--
-- A tábla indexei `osztalyok`
--
ALTER TABLE `osztalyok`
  ADD PRIMARY KEY (`Osztaly_ID`),
  ADD UNIQUE KEY `Osztalyvezeto_ID` (`Osztalyvezeto_ID`);

--
-- A tábla indexei `szemelyek`
--
ALTER TABLE `szemelyek`
  ADD PRIMARY KEY (`Szemely_ID`),
  ADD UNIQUE KEY `email` (`email`),
  ADD UNIQUE KEY `jelszo` (`jelszo`),
  ADD UNIQUE KEY `Munkarend_ID` (`munkarend_ID`),
  ADD UNIQUE KEY `osztaly_ID` (`osztaly_ID`);

--
-- A tábla indexei `szemelyjogosultsag`
--
ALTER TABLE `szemelyjogosultsag`
  ADD PRIMARY KEY (`Szemely_ID`),
  ADD UNIQUE KEY `Szemely_ID` (`Jog_ID`);

--
-- A tábla indexei `szemely_tavollet`
--
ALTER TABLE `szemely_tavollet`
  ADD PRIMARY KEY (`Tavollet_ID`),
  ADD UNIQUE KEY `Szemely_ID` (`Szemely_ID`);

--
-- A tábla indexei `tavolletek`
--
ALTER TABLE `tavolletek`
  ADD PRIMARY KEY (`Tavollet_ID`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `beosztasok`
--
ALTER TABLE `beosztasok`
  MODIFY `Beosztas_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `jelenletek`
--
ALTER TABLE `jelenletek`
  MODIFY `Jelenlet_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `osztalyok`
--
ALTER TABLE `osztalyok`
  MODIFY `Osztaly_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT a táblához `szemelyek`
--
ALTER TABLE `szemelyek`
  MODIFY `Szemely_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `beosztasok`
--
ALTER TABLE `beosztasok`
  ADD CONSTRAINT `beosztasok_ibfk_1` FOREIGN KEY (`Szemely_ID`) REFERENCES `szemelyek` (`Szemely_ID`);

--
-- Megkötések a táblához `jelenletek`
--
ALTER TABLE `jelenletek`
  ADD CONSTRAINT `jelenletek_ibfk_1` FOREIGN KEY (`Szemely_ID`) REFERENCES `szemelyek` (`Szemely_ID`);

--
-- Megkötések a táblához `osztalyok`
--
ALTER TABLE `osztalyok`
  ADD CONSTRAINT `osztalyok_ibfk_1` FOREIGN KEY (`Osztalyvezeto_ID`) REFERENCES `szemelyek` (`Szemely_ID`);

--
-- Megkötések a táblához `szemelyek`
--
ALTER TABLE `szemelyek`
  ADD CONSTRAINT `szemelyek_ibfk_1` FOREIGN KEY (`munkarend_ID`) REFERENCES `munkarendek` (`Munkarend_ID`),
  ADD CONSTRAINT `szemelyek_ibfk_2` FOREIGN KEY (`osztaly_ID`) REFERENCES `osztalyok` (`Osztaly_ID`);

--
-- Megkötések a táblához `szemelyjogosultsag`
--
ALTER TABLE `szemelyjogosultsag`
  ADD CONSTRAINT `szemelyjogosultsag_ibfk_1` FOREIGN KEY (`Szemely_ID`) REFERENCES `szemelyek` (`Szemely_ID`),
  ADD CONSTRAINT `szemelyjogosultsag_ibfk_2` FOREIGN KEY (`Jog_ID`) REFERENCES `jogosultsag` (`jog_ID`);

--
-- Megkötések a táblához `szemely_tavollet`
--
ALTER TABLE `szemely_tavollet`
  ADD CONSTRAINT `szemely_tavollet_ibfk_1` FOREIGN KEY (`Szemely_ID`) REFERENCES `szemelyek` (`Szemely_ID`),
  ADD CONSTRAINT `szemely_tavollet_ibfk_2` FOREIGN KEY (`Tavollet_ID`) REFERENCES `tavolletek` (`Tavollet_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
