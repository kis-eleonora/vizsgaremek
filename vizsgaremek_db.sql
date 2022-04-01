-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2022. Ápr 01. 16:29
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
-- Adatbázis: `vizsgaremek_db`
--

DELIMITER $$
--
-- Függvények
--
CREATE DEFINER=`root`@`localhost` FUNCTION `napJelleg` (`datum` DATE) RETURNS INT(11) READS SQL DATA
BEGIN
-- 1 = munkanap
-- 2 = pihenőnap
-- 3 = ünnepnap
-- 4 = szombatra áthelyezett munkanap
-- 5 = szombat
-- 6 = vasárnap
DECLARE v INT;
-- ünnepnapot vizsgálunk
SELECT COUNT(*) INTO v FROM unnepnapok WHERE unnepnapok.unnepnap = datum;
IF v>0 THEN 
    RETURN 3; 
END IF;

-- WEEKDAY() -> 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 4 = Friday, 5 = Saturday, 6 = Sunday

-- vasárnapot keresünk
IF WEEKDAY(datum)=6 THEN RETURN 6; END IF;
-- szombatot vizsgálunk
IF WEEKDAY(datum)=5 THEN
	SELECT COUNT(*) INTO v FROM athelyezett WHERE athelyezett.athelyezett = datum;
	RETURN IF(v>0,4,5); 
END IF;
-- munkanap áthelyezést vizsgálunk
SELECT COUNT(*) INTO v FROM pihenonap WHERE pihenonap.pihenonap = datum;
IF v>0 THEN 
	RETURN 2; 
END IF;
RETURN 1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `keresek`
--

CREATE TABLE `keresek` (
  `azon` int(11) NOT NULL COMMENT 'A kérelem egyedi azonosítója.',
  `szemely_id` int(11) NOT NULL COMMENT 'Kapcsolat a ''szemelyek'' táblával.',
  `datum` date NOT NULL COMMENT 'Dátum, amelyre a kérelem vonatkozik.',
  `statusz` enum('tappenz','szabadsag') NOT NULL COMMENT 'A távollét oka.',
  `allapot` enum('elinditva','elfogadva') NOT NULL COMMENT 'Végleges rögzítésre került-e a távollét.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `keresek`
--

INSERT INTO `keresek` (`azon`, `szemely_id`, `datum`, `statusz`, `allapot`) VALUES
(1, 3, '2022-03-21', 'tappenz', 'elfogadva'),
(2, 3, '2022-03-22', 'tappenz', 'elfogadva'),
(3, 3, '2022-03-23', 'tappenz', 'elfogadva'),
(4, 3, '2022-03-24', 'szabadsag', 'elfogadva'),
(5, 3, '2022-03-25', 'szabadsag', 'elfogadva'),
(7, 3, '2022-04-04', 'szabadsag', 'elfogadva'),
(8, 3, '2022-04-05', 'szabadsag', 'elfogadva'),
(9, 3, '2022-04-06', 'szabadsag', 'elfogadva'),
(13, 3, '2022-04-07', 'szabadsag', 'elinditva'),
(14, 4, '2022-04-04', 'szabadsag', 'elfogadva'),
(15, 4, '2022-04-05', 'szabadsag', 'elinditva'),
(16, 4, '2022-04-06', 'szabadsag', 'elinditva'),
(17, 4, '2022-04-07', 'szabadsag', 'elinditva'),
(18, 4, '2022-04-08', 'szabadsag', 'elinditva');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `munkarend`
--

CREATE TABLE `munkarend` (
  `munkarend_id` int(11) NOT NULL COMMENT 'A különböző munkarendek azonosítója.',
  `munkakozi_szunet` int(11) NOT NULL DEFAULT 20 COMMENT 'Percekben meghatározva',
  `kezdes` time NOT NULL DEFAULT '08:00:00' COMMENT 'A napi munkavégzés kezdete.',
  `befejezes` time NOT NULL DEFAULT '16:20:00' COMMENT 'A napi munkavégzés vége.',
  `szunet_kezd` time NOT NULL DEFAULT '12:00:00' COMMENT 'A szünet kezdete.',
  `szunet_vege` time NOT NULL DEFAULT '12:20:00' COMMENT 'A szünet vége.',
  `ledolgozott_ora` int(11) NOT NULL DEFAULT 8 COMMENT 'Naponta ledolgozott órák.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `munkarend`
--

INSERT INTO `munkarend` (`munkarend_id`, `munkakozi_szunet`, `kezdes`, `befejezes`, `szunet_kezd`, `szunet_vege`, `ledolgozott_ora`) VALUES
(0, 20, '08:00:00', '16:20:00', '12:00:00', '12:20:00', 8),
(1, 20, '00:00:00', '00:00:00', '00:00:00', '00:00:00', 8);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `munkaszunetek`
--

CREATE TABLE `munkaszunetek` (
  `datum` date NOT NULL COMMENT 'A munkaszünet dátuma.',
  `title` varchar(23) DEFAULT NULL COMMENT 'A munkaszüneti nap neve.',
  `description` varchar(42) DEFAULT NULL COMMENT 'Hosszabb leírás a munkaszüneti napról.',
  `fizetett` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'Fizetett ünnepről van-e szó.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `munkaszunetek`
--

INSERT INTO `munkaszunetek` (`datum`, `title`, `description`, `fizetett`) VALUES
('2022-01-01', 'Új Év napja', 'munkaszüneti nap (hétvége)', 'false'),
('2022-03-14', 'pihenőnap', 'pihenő nap (4 napos hétvége)', 'false'),
('2022-03-15', 'Nemzeti ünnep', 'munkaszüneti nap (4 napos hétvége)', 'true'),
('2022-03-26', 'munkanap', 'áthelyezett munkanap (március 14. helyett)', 'false'),
('2022-04-15', 'Nagypéntek', 'munkaszüneti nap (4 napos hétvége)', 'true'),
('2022-04-18', 'Húsvét', 'munkaszüneti nap (4 napos hétvége)', 'true'),
('2022-05-01', 'A munka ünnepe', 'munkaszüneti nap (hétvége)', 'false'),
('2022-06-06', 'Pünkösd', 'munkaszüneti nap (3 napos hétvége)', 'true'),
('2022-08-20', 'Államalapítás ünnepe', 'munkaszüneti nap (hétvége)', 'false'),
('2022-10-15', 'munkanap', 'áthelyezett munkanap (október 31. helyett)', 'false'),
('2022-10-23', '56-os forradalom ünnepe', 'munkaszüneti nap (hétvége)', 'false'),
('2022-10-31', 'pihenőnap', 'pihenőnap (4 napos hétvége)', 'false'),
('2022-11-01', 'Mindenszentek', 'munkaszüneti nap (4 napos hétvége)', 'true'),
('2022-12-24', 'Szenteste', 'pihenőnap (3 napos hétvége)', 'false'),
('2022-12-25', 'Karácsony', 'munkaszüneti nap (3 napos hétvége)', 'false'),
('2022-12-26', 'Karácsony', 'munkaszüneti nap (3 napos hétvége)', 'true');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szemelyek`
--

CREATE TABLE `szemelyek` (
  `szemely_id` int(11) NOT NULL COMMENT 'A személy egyedi azonosítója.',
  `nev` varchar(30) NOT NULL COMMENT 'A dolgozó neve.',
  `adoazonosito` int(10) NOT NULL COMMENT 'A dolgozó adóazonosítója.',
  `fonok` int(11) NOT NULL COMMENT 'A beosztott főnökének neve, ha üres, akkor ő a vezető, nincs főnöke.',
  `munkarend` int(11) NOT NULL COMMENT '0 - kötött\r\n1 - kötetlen',
  `belepes` date NOT NULL COMMENT 'A munkahelyre történt felvétel dátuma.',
  `email` varchar(30) NOT NULL COMMENT 'A felhasználó e-mail címe.',
  `jelszo` varchar(500) NOT NULL COMMENT 'A felhasználó jelszava.',
  `eves_szabadsag` int(11) NOT NULL COMMENT 'Szabadnapok száma egy évre.',
  `heti_munkaido` int(11) NOT NULL COMMENT 'Heti óraszám.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `szemelyek`
--

INSERT INTO `szemelyek` (`szemely_id`, `nev`, `adoazonosito`, `fonok`, `munkarend`, `belepes`, `email`, `jelszo`, `eves_szabadsag`, `heti_munkaido`) VALUES
(2, 'Kovács István', 1527938761, 0, 1, '2021-08-01', 'kovacs@gmail.com', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 25, 40),
(3, 'Veres Péter', 1234567891, 2, 0, '2022-01-03', 'veres@gmail.com', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 28, 40),
(4, 'Szabó Péter', 265341897, 2, 0, '2022-01-03', 'szabo@gmail.com', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 26, 40),
(5, 'Papp László', 562435619, 2, 0, '2022-01-03', 'papp@gmail.com', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 28, 40),
(6, 'Kiss István', 167382654, 0, 1, '2021-11-08', 'kiss@gmail.com', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 29, 40),
(7, 'Nagy Sándor', 12897657, 6, 0, '2022-01-03', 'nagy@gmail.com', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 26, 40),
(8, 'Tóth János', 152378956, 6, 0, '2022-01-03', 'toth@gmail.com', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 25, 40);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `keresek`
--
ALTER TABLE `keresek`
  ADD PRIMARY KEY (`azon`),
  ADD KEY `datum` (`datum`),
  ADD KEY `szemely_id` (`szemely_id`);

--
-- A tábla indexei `munkarend`
--
ALTER TABLE `munkarend`
  ADD PRIMARY KEY (`munkarend_id`);

--
-- A tábla indexei `munkaszunetek`
--
ALTER TABLE `munkaszunetek`
  ADD PRIMARY KEY (`datum`);

--
-- A tábla indexei `szemelyek`
--
ALTER TABLE `szemelyek`
  ADD PRIMARY KEY (`szemely_id`),
  ADD KEY `munkarend` (`munkarend`),
  ADD KEY `fonok` (`fonok`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `keresek`
--
ALTER TABLE `keresek`
  MODIFY `azon` int(11) NOT NULL AUTO_INCREMENT COMMENT 'A kérelem egyedi azonosítója.', AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT a táblához `szemelyek`
--
ALTER TABLE `szemelyek`
  MODIFY `szemely_id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'A személy egyedi azonosítója.', AUTO_INCREMENT=9;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `keresek`
--
ALTER TABLE `keresek`
  ADD CONSTRAINT `keresek_ibfk_1` FOREIGN KEY (`szemely_id`) REFERENCES `szemelyek` (`szemely_id`);

--
-- Megkötések a táblához `munkaszunetek`
--
ALTER TABLE `munkaszunetek`
  ADD CONSTRAINT `munkaszunetek_ibfk_1` FOREIGN KEY (`datum`) REFERENCES `napok` (`datum`);

--
-- Megkötések a táblához `szemelyek`
--
ALTER TABLE `szemelyek`
  ADD CONSTRAINT `fonok_fk` FOREIGN KEY (`fonok`) REFERENCES `szemelyek` (`szemely_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `szemelyek_ibfk_1` FOREIGN KEY (`munkarend`) REFERENCES `munkarend` (`munkarend_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
