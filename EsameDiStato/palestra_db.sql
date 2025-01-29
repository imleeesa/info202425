-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Gen 23, 2025 alle 21:05
-- Versione del server: 10.4.32-MariaDB
-- Versione PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `palestra_db`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `abbonato`
--

CREATE TABLE `abbonato` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `cognome` varchar(255) NOT NULL,
  `telefono` int(11) NOT NULL,
  `email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `abbonato`
--

INSERT INTO `abbonato` (`id`, `nome`, `cognome`, `telefono`, `email`) VALUES
(1, 'Mario', 'Rossi', 1234567890, 'mario.rossi@email.com'),
(2, 'Luca', 'Bianchi', 1234567891, 'luca.bianchi@email.com'),
(3, 'Giulia', 'Verdi', 1234567892, 'giulia.verdi@email.com'),
(4, 'Anna', 'Neri', 1234567893, 'anna.neri@email.com'),
(5, 'Stefano', 'Gialli', 1234567894, 'stefano.gialli@email.com');

-- --------------------------------------------------------

--
-- Struttura della tabella `attivita`
--

CREATE TABLE `attivita` (
  `id` int(11) NOT NULL,
  `tipo` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `attivita`
--

INSERT INTO `attivita` (`id`, `tipo`) VALUES
(1, 'Yoga'),
(2, 'Pilates'),
(3, 'CrossFit'),
(4, 'Zumba'),
(5, 'Boxe');

-- --------------------------------------------------------

--
-- Struttura della tabella `ha`
--

CREATE TABLE `ha` (
  `idPalestra` int(11) NOT NULL,
  `idOfferta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `ha`
--

INSERT INTO `ha` (`idPalestra`, `idOfferta`) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

-- --------------------------------------------------------

--
-- Struttura della tabella `offerta`
--

CREATE TABLE `offerta` (
  `id` int(11) NOT NULL,
  `prezzo` int(11) NOT NULL,
  `capienza` int(11) NOT NULL,
  `ora` int(11) NOT NULL,
  `giorno_settimana` varchar(255) NOT NULL,
  `idAttivita` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `offerta`
--

INSERT INTO `offerta` (`id`, `prezzo`, `capienza`, `ora`, `giorno_settimana`, `idAttivita`) VALUES
(1, 15, 20, 18, 'Mercoledi', 1),
(2, 20, 15, 19, 'Mercoledi', 2),
(3, 25, 10, 17, 'Lunedi', 3),
(4, 30, 12, 20, 'Venerdi\r\n', 4),
(5, 10, 25, 16, 'Mercoledi', 5);

-- --------------------------------------------------------

--
-- Struttura della tabella `palestra`
--

CREATE TABLE `palestra` (
  `id` int(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `latitudine` int(11) NOT NULL,
  `longitudine` int(11) NOT NULL,
  `citta` varchar(255) NOT NULL,
  `numero` int(11) NOT NULL,
  `via` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `palestra`
--

INSERT INTO `palestra` (`id`, `nome`, `latitudine`, `longitudine`, `citta`, `numero`, `via`) VALUES
(1, 'Gym One', 45, 9, 'Milano', 10, 'Via Roma'),
(2, 'FitLife', 46, 11, 'Roma', 20, 'Via Milano'),
(3, 'PowerHouse', 44, 8, 'Napoli', 5, 'Corso Umberto'),
(4, 'Energy Gym', 43, 10, 'Milano', 15, 'Via Torino'),
(5, 'Sport Center', 42, 7, 'Roma', 30, 'Via Napoli');

-- --------------------------------------------------------

--
-- Struttura della tabella `prenotazioni`
--

CREATE TABLE `prenotazioni` (
  `data_prenotazione` date NOT NULL,
  `idOfferta` int(11) NOT NULL,
  `idAbbonato` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dump dei dati per la tabella `prenotazioni`
--

INSERT INTO `prenotazioni` (`data_prenotazione`, `idOfferta`, `idAbbonato`) VALUES
('2024-04-05', 1, 1),
('2024-04-10', 1, 3),
('2024-04-10', 2, 2),
('2024-04-12', 2, 4),
('2024-04-15', 3, 3),
('2024-04-18', 3, 5),
('2024-04-20', 4, 4),
('2024-04-25', 5, 5);

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `abbonato`
--
ALTER TABLE `abbonato`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `attivita`
--
ALTER TABLE `attivita`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `ha`
--
ALTER TABLE `ha`
  ADD PRIMARY KEY (`idPalestra`,`idOfferta`),
  ADD KEY `idOfferta` (`idOfferta`);

--
-- Indici per le tabelle `offerta`
--
ALTER TABLE `offerta`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idAttivita` (`idAttivita`);

--
-- Indici per le tabelle `palestra`
--
ALTER TABLE `palestra`
  ADD PRIMARY KEY (`id`);

--
-- Indici per le tabelle `prenotazioni`
--
ALTER TABLE `prenotazioni`
  ADD PRIMARY KEY (`idOfferta`,`idAbbonato`),
  ADD KEY `idAbbonato` (`idAbbonato`);

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `ha`
--
ALTER TABLE `ha`
  ADD CONSTRAINT `ha_ibfk_1` FOREIGN KEY (`idPalestra`) REFERENCES `palestra` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ha_ibfk_2` FOREIGN KEY (`idOfferta`) REFERENCES `offerta` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `offerta`
--
ALTER TABLE `offerta`
  ADD CONSTRAINT `offerta_ibfk_1` FOREIGN KEY (`idAttivita`) REFERENCES `attivita` (`id`) ON DELETE CASCADE;

--
-- Limiti per la tabella `prenotazioni`
--
ALTER TABLE `prenotazioni`
  ADD CONSTRAINT `prenotazioni_ibfk_1` FOREIGN KEY (`idOfferta`) REFERENCES `offerta` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `prenotazioni_ibfk_2` FOREIGN KEY (`idAbbonato`) REFERENCES `abbonato` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
