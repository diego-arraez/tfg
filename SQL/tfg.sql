-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: PMYSQL176.dns-servicio.com:3306
-- Versión del servidor: 8.0.39
-- Versión de PHP: 8.3.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `8132305_tfg`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compraventa`
--

CREATE TABLE `compraventa` (
  `compraventa_id` int NOT NULL,
  `compraventa_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `compraventa_users_id_compra` int NOT NULL,
  `compraventa_users_id_venta` int NOT NULL,
  `compraventa_entrega_ud` int NOT NULL,
  `compraventa_entrega_tipo` varchar(255) NOT NULL,
  `compraventa_recibe_ud` int NOT NULL,
  `compraventa_recibe_tipo` varchar(255) NOT NULL,
  `compraventa_puntos` int NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ranking`
--

CREATE TABLE `ranking` (
  `ranking_id` int NOT NULL,
  `ranking_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ranking_users_id` int NOT NULL,
  `ranking_cobre` int NOT NULL DEFAULT '0',
  `ranking_plata` int NOT NULL DEFAULT '0',
  `ranking_oro` int NOT NULL DEFAULT '0',
  `ranking_diamante` int NOT NULL DEFAULT '0',
  `ranking_points` int GENERATED ALWAYS AS ((((`ranking_cobre` + (`ranking_plata` * 3)) + (`ranking_oro` * 7)) + (`ranking_diamante` * 15))) VIRTUAL,
  `ranking_coins` int DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `users_id` int NOT NULL,
  `users_name` varchar(100) NOT NULL,
  `users_password` varchar(100) NOT NULL,
  `users_compras` int NOT NULL DEFAULT '0',
  `users_premiocanj` varchar(50) NOT NULL DEFAULT '-',
  `users_premiodisp` varchar(50) NOT NULL DEFAULT 'A'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `values`
--

CREATE TABLE `values` (
  `values_id` int NOT NULL,
  `values_updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `values_tipo` varchar(255) NOT NULL,
  `values_valor` int NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb3;


--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `compraventa`
--
ALTER TABLE `compraventa`
  ADD PRIMARY KEY (`compraventa_id`);

--
-- Indices de la tabla `ranking`
--
ALTER TABLE `ranking`
  ADD PRIMARY KEY (`ranking_id`);

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`users_id`);

--
-- Indices de la tabla `values`
--
ALTER TABLE `values`
  ADD PRIMARY KEY (`values_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `compraventa`
--
ALTER TABLE `compraventa`
  MODIFY `compraventa_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `ranking`
--
ALTER TABLE `ranking`
  MODIFY `ranking_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `users`
--
ALTER TABLE `users`
  MODIFY `users_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `values`
--
ALTER TABLE `values`
  MODIFY `values_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
