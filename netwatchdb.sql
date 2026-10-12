-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Host: db
-- Erstellungszeit: 12. Okt 2026 um 11:42
-- Server-Version: 13.0.2-MariaDB-ubu2604
-- PHP-Version: 8.3.35

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Datenbank: `netwatchdb`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `checks`
--

CREATE TABLE `checks` (
  `check_id` int(11) NOT NULL,
  `system_id` int(11) NOT NULL,
  `check_date` datetime NOT NULL,
  `status_id` int(11) NOT NULL,
  `response_time` decimal(10,3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `status`
--

CREATE TABLE `status` (
  `status_id` int(11) NOT NULL,
  `status_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Daten für Tabelle `status`
--

INSERT INTO `status` (`status_id`, `status_name`) VALUES
(1, 'ONLINE'),
(2, 'OFFLINE');

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `system`
--

CREATE TABLE `system` (
  `system_id` int(11) NOT NULL,
  `system_name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_uca1400_ai_ci;

--
-- Daten für Tabelle `system`
--

INSERT INTO `system` (`system_id`, `system_name`) VALUES
(1, 'NAS-B218-920p.aloberlin.de');

--
-- Indizes der exportierten Tabellen
--

--
-- Indizes für die Tabelle `checks`
--
ALTER TABLE `checks`
  ADD PRIMARY KEY (`check_id`),
  ADD KEY `fk_checks_system` (`system_id`),
  ADD KEY `fk_checks_status` (`status_id`);

--
-- Indizes für die Tabelle `status`
--
ALTER TABLE `status`
  ADD PRIMARY KEY (`status_id`);

--
-- Indizes für die Tabelle `system`
--
ALTER TABLE `system`
  ADD PRIMARY KEY (`system_id`);

--
-- AUTO_INCREMENT für exportierte Tabellen
--

--
-- AUTO_INCREMENT für Tabelle `checks`
--
ALTER TABLE `checks`
  MODIFY `check_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT für Tabelle `status`
--
ALTER TABLE `status`
  MODIFY `status_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT für Tabelle `system`
--
ALTER TABLE `system`
  MODIFY `system_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints der exportierten Tabellen
--

--
-- Constraints der Tabelle `checks`
--
ALTER TABLE `checks`
  ADD CONSTRAINT `fk_checks_status` FOREIGN KEY (`status_id`) REFERENCES `status` (`status_id`),
  ADD CONSTRAINT `fk_checks_system` FOREIGN KEY (`system_id`) REFERENCES `system` (`system_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
