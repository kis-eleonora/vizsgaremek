-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2022. Feb 24. 15:05
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
-- Tábla szerkezet ehhez a táblához `jelenletik`
--

CREATE TABLE `jelenletik` (
  `szemely_id` int(11) NOT NULL,
  `datum` date NOT NULL,
  `statusz` enum('ledolgozott','tappenz','szabadsag','fiz_unnep','piheno') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `keresek`
--

CREATE TABLE `keresek` (
  `szemely_id` int(11) NOT NULL,
  `datum` date NOT NULL,
  `statusz` enum('tappenz','szabadsag') NOT NULL,
  `allapot` enum('elinditva','elfogadva') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `munkarend`
--

CREATE TABLE `munkarend` (
  `munkarend_id` int(11) NOT NULL,
  `munkakozi_szunet` int(11) NOT NULL DEFAULT 20 COMMENT 'Percekben meghatározva',
  `kezdes` time NOT NULL DEFAULT '08:00:00',
  `befejezes` time NOT NULL DEFAULT '16:20:00',
  `szunet_kezd` time NOT NULL DEFAULT '12:00:00',
  `szunet_vege` time NOT NULL DEFAULT '12:20:00',
  `ledolgozott_ora` int(11) NOT NULL DEFAULT 8
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `munkaszunetek`
--

CREATE TABLE `munkaszunetek` (
  `datum` date NOT NULL,
  `title` varchar(23) DEFAULT NULL,
  `description` varchar(42) DEFAULT NULL,
  `fizetett` enum('true','false') NOT NULL DEFAULT 'false'
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
('2022-05-01', 'Munka Ünnep', 'munkaszüneti nap (hétvége)', 'false'),
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
-- Tábla szerkezet ehhez a táblához `napok`
--

CREATE TABLE `napok` (
  `datum` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `napok`
--

INSERT INTO `napok` (`datum`) VALUES
('2022-01-01'),
('2022-01-02'),
('2022-01-03'),
('2022-01-04'),
('2022-01-05'),
('2022-01-06'),
('2022-01-07'),
('2022-01-08'),
('2022-01-09'),
('2022-01-10'),
('2022-01-11'),
('2022-01-12'),
('2022-01-13'),
('2022-01-14'),
('2022-01-15'),
('2022-01-16'),
('2022-01-17'),
('2022-01-18'),
('2022-01-19'),
('2022-01-20'),
('2022-01-21'),
('2022-01-22'),
('2022-01-23'),
('2022-01-24'),
('2022-01-25'),
('2022-01-26'),
('2022-01-27'),
('2022-01-28'),
('2022-01-29'),
('2022-01-30'),
('2022-01-31'),
('2022-02-01'),
('2022-02-02'),
('2022-02-03'),
('2022-02-04'),
('2022-02-05'),
('2022-02-06'),
('2022-02-07'),
('2022-02-08'),
('2022-02-09'),
('2022-02-10'),
('2022-02-11'),
('2022-02-12'),
('2022-02-13'),
('2022-02-14'),
('2022-02-15'),
('2022-02-16'),
('2022-02-17'),
('2022-02-18'),
('2022-02-19'),
('2022-02-20'),
('2022-02-21'),
('2022-02-22'),
('2022-02-23'),
('2022-02-24'),
('2022-02-25'),
('2022-02-26'),
('2022-02-27'),
('2022-02-28'),
('2022-03-01'),
('2022-03-02'),
('2022-03-03'),
('2022-03-04'),
('2022-03-05'),
('2022-03-06'),
('2022-03-07'),
('2022-03-08'),
('2022-03-09'),
('2022-03-10'),
('2022-03-11'),
('2022-03-12'),
('2022-03-13'),
('2022-03-14'),
('2022-03-15'),
('2022-03-16'),
('2022-03-17'),
('2022-03-18'),
('2022-03-19'),
('2022-03-20'),
('2022-03-21'),
('2022-03-22'),
('2022-03-23'),
('2022-03-24'),
('2022-03-25'),
('2022-03-26'),
('2022-03-27'),
('2022-03-28'),
('2022-03-29'),
('2022-03-30'),
('2022-03-31'),
('2022-04-01'),
('2022-04-02'),
('2022-04-03'),
('2022-04-04'),
('2022-04-05'),
('2022-04-06'),
('2022-04-07'),
('2022-04-08'),
('2022-04-09'),
('2022-04-10'),
('2022-04-11'),
('2022-04-12'),
('2022-04-13'),
('2022-04-14'),
('2022-04-15'),
('2022-04-16'),
('2022-04-17'),
('2022-04-18'),
('2022-04-19'),
('2022-04-20'),
('2022-04-21'),
('2022-04-22'),
('2022-04-23'),
('2022-04-24'),
('2022-04-25'),
('2022-04-26'),
('2022-04-27'),
('2022-04-28'),
('2022-04-29'),
('2022-04-30'),
('2022-05-01'),
('2022-05-02'),
('2022-05-03'),
('2022-05-04'),
('2022-05-05'),
('2022-05-06'),
('2022-05-07'),
('2022-05-08'),
('2022-05-09'),
('2022-05-10'),
('2022-05-11'),
('2022-05-12'),
('2022-05-13'),
('2022-05-14'),
('2022-05-15'),
('2022-05-16'),
('2022-05-17'),
('2022-05-18'),
('2022-05-19'),
('2022-05-20'),
('2022-05-21'),
('2022-05-22'),
('2022-05-23'),
('2022-05-24'),
('2022-05-25'),
('2022-05-26'),
('2022-05-27'),
('2022-05-28'),
('2022-05-29'),
('2022-05-30'),
('2022-05-31'),
('2022-06-01'),
('2022-06-02'),
('2022-06-03'),
('2022-06-04'),
('2022-06-05'),
('2022-06-06'),
('2022-06-07'),
('2022-06-08'),
('2022-06-09'),
('2022-06-10'),
('2022-06-11'),
('2022-06-12'),
('2022-06-13'),
('2022-06-14'),
('2022-06-15'),
('2022-06-16'),
('2022-06-17'),
('2022-06-18'),
('2022-06-19'),
('2022-06-20'),
('2022-06-21'),
('2022-06-22'),
('2022-06-23'),
('2022-06-24'),
('2022-06-25'),
('2022-06-26'),
('2022-06-27'),
('2022-06-28'),
('2022-06-29'),
('2022-06-30'),
('2022-07-01'),
('2022-07-02'),
('2022-07-03'),
('2022-07-04'),
('2022-07-05'),
('2022-07-06'),
('2022-07-07'),
('2022-07-08'),
('2022-07-09'),
('2022-07-10'),
('2022-07-11'),
('2022-07-12'),
('2022-07-13'),
('2022-07-14'),
('2022-07-15'),
('2022-07-16'),
('2022-07-17'),
('2022-07-18'),
('2022-07-19'),
('2022-07-20'),
('2022-07-21'),
('2022-07-22'),
('2022-07-23'),
('2022-07-24'),
('2022-07-25'),
('2022-07-26'),
('2022-07-27'),
('2022-07-28'),
('2022-07-29'),
('2022-07-30'),
('2022-07-31'),
('2022-08-01'),
('2022-08-02'),
('2022-08-03'),
('2022-08-04'),
('2022-08-05'),
('2022-08-06'),
('2022-08-07'),
('2022-08-08'),
('2022-08-09'),
('2022-08-10'),
('2022-08-11'),
('2022-08-12'),
('2022-08-13'),
('2022-08-14'),
('2022-08-15'),
('2022-08-16'),
('2022-08-17'),
('2022-08-18'),
('2022-08-19'),
('2022-08-20'),
('2022-08-21'),
('2022-08-22'),
('2022-08-23'),
('2022-08-24'),
('2022-08-25'),
('2022-08-26'),
('2022-08-27'),
('2022-08-28'),
('2022-08-29'),
('2022-08-30'),
('2022-08-31'),
('2022-09-01'),
('2022-09-02'),
('2022-09-03'),
('2022-09-04'),
('2022-09-05'),
('2022-09-06'),
('2022-09-07'),
('2022-09-08'),
('2022-09-09'),
('2022-09-10'),
('2022-09-11'),
('2022-09-12'),
('2022-09-13'),
('2022-09-14'),
('2022-09-15'),
('2022-09-16'),
('2022-09-17'),
('2022-09-18'),
('2022-09-19'),
('2022-09-20'),
('2022-09-21'),
('2022-09-22'),
('2022-09-23'),
('2022-09-24'),
('2022-09-25'),
('2022-09-26'),
('2022-09-27'),
('2022-09-28'),
('2022-09-29'),
('2022-09-30'),
('2022-10-01'),
('2022-10-02'),
('2022-10-03'),
('2022-10-04'),
('2022-10-05'),
('2022-10-06'),
('2022-10-07'),
('2022-10-08'),
('2022-10-09'),
('2022-10-10'),
('2022-10-11'),
('2022-10-12'),
('2022-10-13'),
('2022-10-14'),
('2022-10-15'),
('2022-10-16'),
('2022-10-17'),
('2022-10-18'),
('2022-10-19'),
('2022-10-20'),
('2022-10-21'),
('2022-10-22'),
('2022-10-23'),
('2022-10-24'),
('2022-10-25'),
('2022-10-26'),
('2022-10-27'),
('2022-10-28'),
('2022-10-29'),
('2022-10-30'),
('2022-10-31'),
('2022-11-01'),
('2022-11-02'),
('2022-11-03'),
('2022-11-04'),
('2022-11-05'),
('2022-11-06'),
('2022-11-07'),
('2022-11-08'),
('2022-11-09'),
('2022-11-10'),
('2022-11-11'),
('2022-11-12'),
('2022-11-13'),
('2022-11-14'),
('2022-11-15'),
('2022-11-16'),
('2022-11-17'),
('2022-11-18'),
('2022-11-19'),
('2022-11-20'),
('2022-11-21'),
('2022-11-22'),
('2022-11-23'),
('2022-11-24'),
('2022-11-25'),
('2022-11-26'),
('2022-11-27'),
('2022-11-28'),
('2022-11-29'),
('2022-11-30'),
('2022-12-01'),
('2022-12-02'),
('2022-12-03'),
('2022-12-04'),
('2022-12-05'),
('2022-12-06'),
('2022-12-07'),
('2022-12-08'),
('2022-12-09'),
('2022-12-10'),
('2022-12-11'),
('2022-12-12'),
('2022-12-13'),
('2022-12-14'),
('2022-12-15'),
('2022-12-16'),
('2022-12-17'),
('2022-12-18'),
('2022-12-19'),
('2022-12-20'),
('2022-12-21'),
('2022-12-22'),
('2022-12-23'),
('2022-12-24'),
('2022-12-25'),
('2022-12-26'),
('2022-12-27'),
('2022-12-28'),
('2022-12-29'),
('2022-12-30'),
('2022-12-31');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szemelyek`
--

CREATE TABLE `szemelyek` (
  `szemely_id` int(11) NOT NULL,
  `nev` varchar(30) NOT NULL,
  `adoazonosito` int(10) NOT NULL,
  `fonok` varchar(30) NOT NULL COMMENT 'A beosztott főnökének neve, ha üres, akkor ő a vezető, nincs főnöke.',
  `munkarend` int(11) NOT NULL COMMENT '0 - kötetlen\r\n1 - kötött',
  `belepes` date NOT NULL,
  `email` varchar(30) NOT NULL,
  `jelszo` varchar(30) NOT NULL,
  `eves_szabadsag` int(11) NOT NULL COMMENT 'Szabadnapok száma.',
  `heti_munkaido` int(11) NOT NULL COMMENT 'Heti óraszám.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `jelenletik`
--
ALTER TABLE `jelenletik`
  ADD KEY `szemely_id` (`szemely_id`),
  ADD KEY `datum` (`datum`);

--
-- A tábla indexei `keresek`
--
ALTER TABLE `keresek`
  ADD PRIMARY KEY (`szemely_id`);

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
-- A tábla indexei `napok`
--
ALTER TABLE `napok`
  ADD PRIMARY KEY (`datum`);

--
-- A tábla indexei `szemelyek`
--
ALTER TABLE `szemelyek`
  ADD PRIMARY KEY (`szemely_id`),
  ADD KEY `munkarend` (`munkarend`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `szemelyek`
--
ALTER TABLE `szemelyek`
  MODIFY `szemely_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `jelenletik`
--
ALTER TABLE `jelenletik`
  ADD CONSTRAINT `jelenletik_ibfk_1` FOREIGN KEY (`szemely_id`) REFERENCES `szemelyek` (`szemely_id`),
  ADD CONSTRAINT `jelenletik_ibfk_2` FOREIGN KEY (`datum`) REFERENCES `napok` (`datum`);

--
-- Megkötések a táblához `keresek`
--
ALTER TABLE `keresek`
  ADD CONSTRAINT `keresek_ibfk_1` FOREIGN KEY (`szemely_id`) REFERENCES `jelenletik` (`szemely_id`);

--
-- Megkötések a táblához `munkaszunetek`
--
ALTER TABLE `munkaszunetek`
  ADD CONSTRAINT `munkaszunetek_ibfk_1` FOREIGN KEY (`datum`) REFERENCES `napok` (`datum`);

--
-- Megkötések a táblához `szemelyek`
--
ALTER TABLE `szemelyek`
  ADD CONSTRAINT `szemelyek_ibfk_1` FOREIGN KEY (`munkarend`) REFERENCES `munkarend` (`munkarend_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
