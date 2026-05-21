-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: kalpana_travels
-- Kalpana Travels Bus Management System - Full Seed Data
-- ============================================================
-- Login Credentials:
--   admin@kalpana.com            password: admin123
--   customer@kalpana.com         password: customer123
--   riya@customer.com            password: customer2
--   galyangcounter@operator.com  password: galyang123
--   pokhara@operator.com         password: operator123
-- ============================================================

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `kalpana_travels` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `kalpana_travels`;

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookings` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `user_id` int(11) DEFAULT NULL,
                            `schedule_id` int(11) DEFAULT NULL,
                            `seat_numbers` varchar(255) NOT NULL,
                            `total_fare` decimal(10,2) NOT NULL,
                            `booking_date` timestamp NOT NULL DEFAULT current_timestamp(),
                            `status` enum('CONFIRMED','CANCELLED','PENDING') DEFAULT 'CONFIRMED',
                            `passenger_name` varchar(100) DEFAULT NULL,
                            `passenger_phone` varchar(15) DEFAULT NULL,
                            `passenger_email` varchar(100) DEFAULT NULL,
                            `bus_setup_id` int(11) DEFAULT NULL,
                            `route_id` int(11) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            KEY `user_id` (`user_id`),
                            KEY `schedule_id` (`schedule_id`),
                            KEY `bookings_ibfk_bus_setup` (`bus_setup_id`),
                            KEY `bookings_ibfk_route` (`route_id`),
                            CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
                            CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE CASCADE,
                            CONSTRAINT `bookings_ibfk_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL,
                            CONSTRAINT `bookings_ibfk_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `bus_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bus_names` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `name` varchar(100) NOT NULL,
                             `bus_type` enum('SLEEPER','DELUXE','SOFA_SEATER') NOT NULL,
                             `capacity` int(11) NOT NULL,
                             `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bus_names` WRITE;
/*!40000 ALTER TABLE `bus_names` DISABLE KEYS */;
INSERT INTO `bus_names` VALUES (1,'Kalpana Airbus','SLEEPER',45,'2026-01-02 08:00:00'),(2,'Kiran Airbus','DELUXE',35,'2026-01-02 08:05:00'),(3,'Syangja Gandaki','SOFA_SEATER',48,'2026-01-02 08:10:00');
/*!40000 ALTER TABLE `bus_names` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `bus_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bus_numbers` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `bus_name_id` int(11) NOT NULL,
                               `registration_number` varchar(50) NOT NULL,
                               `status` enum('ACTIVE','INACTIVE','MAINTENANCE') DEFAULT 'ACTIVE',
                               `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `registration_number` (`registration_number`),
                               KEY `bus_numbers_ibfk_1` (`bus_name_id`),
                               CONSTRAINT `bus_numbers_ibfk_1` FOREIGN KEY (`bus_name_id`) REFERENCES `bus_names` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bus_numbers` WRITE;
/*!40000 ALTER TABLE `bus_numbers` DISABLE KEYS */;
INSERT INTO `bus_numbers` VALUES (1,2,'Lu Pra 01 001 Kha 0660','ACTIVE','2026-01-03 08:00:00'),(2,2,'Lu Pra 01 001 Kha 0661','ACTIVE','2026-01-03 08:05:00'),(3,1,'Lu Pra 01 001 Kha 0662','ACTIVE','2026-01-03 08:10:00'),(4,3,'Ga 1 Kha 1234','ACTIVE','2026-01-03 08:15:00'),(5,1,'Ba 2 Kha 5678','MAINTENANCE','2026-01-03 08:20:00');
/*!40000 ALTER TABLE `bus_numbers` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `bus_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bus_setup` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bus_number_id` int(11) NOT NULL,
                             `seat_layout_id` int(11) NOT NULL,
                             `trip_price` decimal(10,2) DEFAULT NULL,
                             `trip_time` time DEFAULT NULL,
                             `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                             `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `unique_bus_number` (`bus_number_id`),
                             KEY `bus_setup_ibfk_2` (`seat_layout_id`),
                             CONSTRAINT `bus_setup_ibfk_1` FOREIGN KEY (`bus_number_id`) REFERENCES `bus_numbers` (`id`) ON DELETE CASCADE,
                             CONSTRAINT `bus_setup_ibfk_2` FOREIGN KEY (`seat_layout_id`) REFERENCES `seat_layouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bus_setup` WRITE;
/*!40000 ALTER TABLE `bus_setup` DISABLE KEYS */;
INSERT INTO `bus_setup` VALUES (1,1,1,1200.00,'06:00:00','2026-01-07 08:00:00','2026-01-07 08:00:00'),(2,2,2,1500.00,'07:30:00','2026-01-07 08:05:00','2026-01-07 08:05:00'),(3,3,1,1100.00,'05:30:00','2026-01-07 08:10:00','2026-01-07 08:10:00'),(4,4,3,900.00,'08:00:00','2026-01-07 08:15:00','2026-01-07 08:15:00');
/*!40000 ALTER TABLE `bus_setup` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `bus_setup_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bus_setup_staff` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `bus_setup_id` int(11) NOT NULL,
                                   `staff_id` int(11) NOT NULL,
                                   `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                                   PRIMARY KEY (`id`),
                                   UNIQUE KEY `unique_setup_staff` (`bus_setup_id`,`staff_id`),
                                   KEY `bus_setup_staff_ibfk_2` (`staff_id`),
                                   CONSTRAINT `bus_setup_staff_ibfk_1` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE,
                                   CONSTRAINT `bus_setup_staff_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bus_setup_staff` WRITE;
/*!40000 ALTER TABLE `bus_setup_staff` DISABLE KEYS */;
INSERT INTO `bus_setup_staff` (`bus_setup_id`,`staff_id`) VALUES (1,2),(1,1),(2,4),(2,3),(3,2),(3,3),(4,4),(4,1);
/*!40000 ALTER TABLE `bus_setup_staff` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `buses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buses` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `bus_number` varchar(50) NOT NULL,
                         `bus_name` varchar(100) NOT NULL,
                         `capacity` int(11) NOT NULL,
                         `bus_type` enum('STANDARD','SEMI_DELUXE','AC_DELUXE','SUPER_DELUXE') NOT NULL,
                         `fare_per_seat` decimal(10,2) NOT NULL,
                         `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `bus_number` (`bus_number`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `buses` WRITE;
/*!40000 ALTER TABLE `buses` DISABLE KEYS */;
INSERT INTO `buses` VALUES (1,'Lu Pra 01 001 Kha 0660','Kiran Airbus',35,'AC_DELUXE',1200.00,'ACTIVE'),(2,'Lu Pra 01 001 Kha 0661','Kiran Airbus',35,'AC_DELUXE',1500.00,'ACTIVE'),(3,'Lu Pra 01 001 Kha 0662','Kalpana Airbus',45,'SEMI_DELUXE',1100.00,'ACTIVE'),(4,'Ga 1 Kha 1234','Syangja Gandaki',48,'STANDARD',900.00,'ACTIVE');
/*!40000 ALTER TABLE `buses` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `chalani`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chalani` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `bus_setup_id` int(11) NOT NULL,
                           `operator_id` int(11) DEFAULT NULL,
                           `booking_date` date NOT NULL,
                           `total_seats_booked` int(11) DEFAULT NULL,
                           `total_revenue` decimal(12,2) DEFAULT NULL,
                           `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                           PRIMARY KEY (`id`),
                           UNIQUE KEY `unique_chalani_setup_operator_date` (`bus_setup_id`,`operator_id`,`booking_date`),
                           KEY `chalani_ibfk_2` (`operator_id`),
                           CONSTRAINT `chalani_ibfk_1` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE,
                           CONSTRAINT `chalani_ibfk_2` FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `chalani` WRITE;
/*!40000 ALTER TABLE `chalani` DISABLE KEYS */;
INSERT INTO `chalani` (`bus_setup_id`,`operator_id`,`booking_date`,`total_seats_booked`,`total_revenue`) VALUES (1,3,DATE_SUB(CURDATE(),INTERVAL 1 DAY),12,14400.00),(2,5,DATE_SUB(CURDATE(),INTERVAL 1 DAY),8,12000.00),(3,3,DATE_SUB(CURDATE(),INTERVAL 2 DAY),10,9000.00),(1,3,DATE_SUB(CURDATE(),INTERVAL 7 DAY),15,18000.00),(2,5,DATE_SUB(CURDATE(),INTERVAL 7 DAY),11,16500.00),(4,3,DATE_SUB(CURDATE(),INTERVAL 3 DAY),7,6300.00);
/*!40000 ALTER TABLE `chalani` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `drop_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drop_points` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `route_id` int(11) NOT NULL,
                               `location_id` int(11) NOT NULL,
                               `drop_route` varchar(150) DEFAULT NULL,
                               `drop_time` time NOT NULL,
                               `price` decimal(10,2) DEFAULT 0.00,
                               `price_multiplier` decimal(5,2) DEFAULT 1.00,
                               `sequence_order` int(11) DEFAULT NULL,
                               `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                               PRIMARY KEY (`id`),
                               KEY `drop_points_ibfk_1` (`route_id`),
                               KEY `drop_points_ibfk_2` (`location_id`),
                               CONSTRAINT `drop_points_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE,
                               CONSTRAINT `drop_points_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `drop_points` WRITE;
/*!40000 ALTER TABLE `drop_points` DISABLE KEYS */;
INSERT INTO `drop_points` (`route_id`,`location_id`,`drop_route`,`drop_time`,`price`,`price_multiplier`,`sequence_order`) VALUES (1,6,'Mugling Bus Stop','10:00:00',700.00,0.60,1),(1,5,'Kathmandu New Bus Park','14:00:00',0.00,0.00,2),(2,6,'Mugling Chowk','11:00:00',600.00,0.40,1),(2,5,'Kathmandu New Bus Park','14:30:00',0.00,0.00,2),(3,9,'Mirdi Stop','07:00:00',300.00,0.35,1),(3,4,'Pokhara Bus Park','08:00:00',0.00,0.00,2),(4,6,'Mugling Bus Stop','12:00:00',500.00,0.56,1),(4,5,'Kathmandu New Bus Park','17:00:00',0.00,0.00,2);
/*!40000 ALTER TABLE `drop_points` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `event_reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_reservations` (
                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                      `user_id` int(11) NOT NULL,
                                      `event_type` varchar(50) NOT NULL,
                                      `event_name` varchar(255) NOT NULL,
                                      `event_date` date NOT NULL,
                                      `required_date` date NOT NULL,
                                      `number_of_passengers` int(11) NOT NULL,
                                      `number_of_buses` int(11) NOT NULL,
                                      `preferred_bus_type` varchar(50) DEFAULT NULL,
                                      `pickup_location` varchar(255) NOT NULL,
                                      `dropoff_location` varchar(255) NOT NULL,
                                      `description` text DEFAULT NULL,
                                      `status` varchar(50) DEFAULT 'PENDING',
                                      `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                                      PRIMARY KEY (`id`),
                                      KEY `event_reservations_ibfk_1` (`user_id`),
                                      CONSTRAINT `event_reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `event_reservations` WRITE;
/*!40000 ALTER TABLE `event_reservations` DISABLE KEYS */;
INSERT INTO `event_reservations` (`user_id`,`event_type`,`event_name`,`event_date`,`required_date`,`number_of_passengers`,`number_of_buses`,`preferred_bus_type`,`pickup_location`,`dropoff_location`,`description`,`status`) VALUES (2,'Wedding','Raju Wedding Party',DATE_ADD(CURDATE(),INTERVAL 10 DAY),DATE_ADD(CURDATE(),INTERVAL 8 DAY),80,2,'DELUXE','Waling Bus Park','Pokhara Hotel Barahi','Need 2 deluxe buses for wedding guests','PENDING'),(4,'School Trip','Riya School Excursion',DATE_ADD(CURDATE(),INTERVAL 20 DAY),DATE_ADD(CURDATE(),INTERVAL 18 DAY),45,1,'SOFA_SEATER','Syangja School','Pokhara Fewa Lake','Annual school trip for grade 10','CONFIRMED'),(6,'Corporate','Suman Company Picnic',DATE_ADD(CURDATE(),INTERVAL 5 DAY),DATE_ADD(CURDATE(),INTERVAL 3 DAY),30,1,'SLEEPER','Kathmandu Office','Pokhara Resort','Annual staff picnic','PENDING'),(2,'Pilgrimage','Muktinath Yatra',DATE_SUB(CURDATE(),INTERVAL 15 DAY),DATE_SUB(CURDATE(),INTERVAL 17 DAY),50,1,'DELUXE','Waling Bus Park','Muktinath Temple','Religious pilgrimage trip - completed','CONFIRMED');
/*!40000 ALTER TABLE `event_reservations` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `name` varchar(100) NOT NULL,
                             `district` varchar(50) DEFAULT NULL,
                             `latitude` decimal(10,8) DEFAULT NULL,
                             `longitude` decimal(11,8) DEFAULT NULL,
                             `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Waling','Syangja',27.98810000,83.78210000,'2026-01-05 08:00:00'),(2,'Syangja','Syangja',27.95570000,83.88470000,'2026-01-05 08:01:00'),(3,'Ramdi','Syangja',28.00190000,83.72040000,'2026-01-05 08:02:00'),(4,'Pokhara','Kaski',28.20960000,83.98560000,'2026-01-05 08:03:00'),(5,'Kathmandu','Kathmandu',27.71720000,85.32400000,'2026-01-05 08:04:00'),(6,'Mugling','Chitwan',27.86940000,84.51660000,'2026-01-05 08:05:00'),(7,'Damauli','Tanahun',27.96230000,84.29290000,'2026-01-05 08:06:00'),(8,'Butwal','Rupandehi',27.70060000,83.44830000,'2026-01-05 08:07:00'),(9,'Mirdi','Baglung',28.12600000,83.81500000,'2026-01-05 08:08:00'),(10,'Malunga','Syangja',27.97000000,83.75000000,'2026-01-05 08:09:00');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `loyalty_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loyalty_points` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `user_id` int(11) NOT NULL,
                                  `points_balance` int(11) DEFAULT 0,
                                  `total_points_earned` int(11) DEFAULT 0,
                                  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                                  PRIMARY KEY (`id`),
                                  UNIQUE KEY `unique_user_loyalty` (`user_id`),
                                  CONSTRAINT `loyalty_points_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `loyalty_points` WRITE;
/*!40000 ALTER TABLE `loyalty_points` DISABLE KEYS */;
INSERT INTO `loyalty_points` (`user_id`,`points_balance`,`total_points_earned`) VALUES (2,480,600),(4,300,300),(6,120,150);
/*!40000 ALTER TABLE `loyalty_points` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `pickup_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pickup_points` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `route_id` int(11) NOT NULL,
                                 `location_id` int(11) NOT NULL,
                                 `pickup_route` varchar(150) DEFAULT NULL,
                                 `pickup_time` time NOT NULL,
                                 `price` decimal(10,2) DEFAULT 0.00,
                                 `price_multiplier` decimal(5,2) DEFAULT 1.00,
                                 `sequence_order` int(11) DEFAULT NULL,
                                 `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                                 PRIMARY KEY (`id`),
                                 KEY `pickup_points_ibfk_1` (`route_id`),
                                 KEY `pickup_points_ibfk_2` (`location_id`),
                                 CONSTRAINT `pickup_points_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE,
                                 CONSTRAINT `pickup_points_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `pickup_points` WRITE;
/*!40000 ALTER TABLE `pickup_points` DISABLE KEYS */;
INSERT INTO `pickup_points` (`route_id`,`location_id`,`pickup_route`,`pickup_time`,`price`,`price_multiplier`,`sequence_order`) VALUES (1,1,'Waling Bus Park','06:00:00',1200.00,1.00,1),(1,10,'Malunga Chowk','06:20:00',800.00,0.70,2),(1,3,'Ramdi Bus Stop','06:40:00',750.00,0.65,3),(2,4,'Pokhara Bus Park','07:30:00',1500.00,1.00,1),(2,7,'Damauli Bus Stop','08:30:00',1100.00,0.75,2),(3,1,'Waling Bus Park','05:30:00',900.00,1.00,1),(3,2,'Syangja Chowk','06:00:00',600.00,0.70,2),(4,2,'Syangja Bus Park','08:00:00',900.00,1.00,1),(4,1,'Waling Bus Stop','08:30:00',850.00,0.95,2);
/*!40000 ALTER TABLE `pickup_points` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `routes` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `source` varchar(50) NOT NULL,
                          `destination` varchar(50) NOT NULL,
                          `distance` int(11) DEFAULT NULL,
                          `duration` varchar(20) DEFAULT NULL,
                          `departure_location_id` int(11) DEFAULT NULL,
                          `arrival_location_id` int(11) DEFAULT NULL,
                          `duration_hours` decimal(5,2) DEFAULT NULL,
                          `distance_km` decimal(8,2) DEFAULT NULL,
                          `remarks` text DEFAULT NULL,
                          `bus_setup_id` int(11) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          KEY `routes_ibfk_departure` (`departure_location_id`),
                          KEY `routes_ibfk_arrival` (`arrival_location_id`),
                          KEY `fk_route_bus_setup` (`bus_setup_id`),
                          CONSTRAINT `fk_route_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL,
                          CONSTRAINT `routes_ibfk_arrival` FOREIGN KEY (`arrival_location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL,
                          CONSTRAINT `routes_ibfk_departure` FOREIGN KEY (`departure_location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
INSERT INTO `routes` VALUES (1,'Waling','Kathmandu',220,'8h',1,5,8.00,220.00,'Via Pokhara and Mugling',1),(2,'Pokhara','Kathmandu',200,'7h',4,5,7.00,200.00,'Express route via Mugling',2),(3,'Waling','Pokhara',60,'2.5h',1,4,2.50,60.00,'Local route via Syangja',3),(4,'Syangja','Kathmandu',240,'9h',2,5,9.00,240.00,'Budget route via Waling',4);
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bus_id` int(11) NOT NULL,
                             `route_id` int(11) NOT NULL,
                             `departure_time` time NOT NULL,
                             `arrival_time` time NOT NULL,
                             `travel_date` date NOT NULL,
                             `available_seats` int(11) NOT NULL,
                             `bus_setup_id` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `bus_id` (`bus_id`),
                             KEY `route_id` (`route_id`),
                             KEY `schedules_ibfk_bus_setup` (`bus_setup_id`),
                             CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE CASCADE,
                             CONSTRAINT `schedules_ibfk_2` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE,
                             CONSTRAINT `schedules_ibfk_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` (`id`,`bus_id`,`route_id`,`departure_time`,`arrival_time`,`travel_date`,`available_seats`,`bus_setup_id`) VALUES (1,1,1,'06:00:00','14:00:00',DATE_ADD(CURDATE(),INTERVAL 1 DAY),30,1),(2,2,2,'07:30:00','14:30:00',DATE_ADD(CURDATE(),INTERVAL 1 DAY),32,2),(3,3,3,'05:30:00','08:00:00',DATE_ADD(CURDATE(),INTERVAL 1 DAY),40,3),(4,4,4,'08:00:00','17:00:00',DATE_ADD(CURDATE(),INTERVAL 2 DAY),45,4),(5,1,1,'06:00:00','14:00:00',DATE_ADD(CURDATE(),INTERVAL 3 DAY),35,1),(6,2,2,'07:30:00','14:30:00',DATE_ADD(CURDATE(),INTERVAL 3 DAY),33,2),(7,3,3,'05:30:00','08:00:00',DATE_ADD(CURDATE(),INTERVAL 5 DAY),42,3),(8,1,1,'06:00:00','14:00:00',DATE_ADD(CURDATE(),INTERVAL 7 DAY),35,1),(9,1,1,'06:00:00','14:00:00',DATE_SUB(CURDATE(),INTERVAL 1 DAY),0,1),(10,2,2,'07:30:00','14:30:00',DATE_SUB(CURDATE(),INTERVAL 1 DAY),2,2),(11,3,3,'05:30:00','08:00:00',DATE_SUB(CURDATE(),INTERVAL 2 DAY),5,3),(12,4,4,'08:00:00','17:00:00',DATE_SUB(CURDATE(),INTERVAL 3 DAY),8,4),(13,1,1,'06:00:00','14:00:00',DATE_SUB(CURDATE(),INTERVAL 7 DAY),0,1),(14,2,2,'07:30:00','14:30:00',DATE_SUB(CURDATE(),INTERVAL 7 DAY),1,2);
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `seat_layouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seat_layouts` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `name` varchar(100) NOT NULL,
                                `type` enum('2X2_SOFA','2X2_SOFA_WITH_SLEEPER','2X1_SOFA') NOT NULL,
                                `total_seats` int(11) NOT NULL,
                                `rows` int(11) NOT NULL,
                                `columns` int(11) NOT NULL,
                                `layout_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`layout_json`)),
                                `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                                PRIMARY KEY (`id`),
                                UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `seat_layouts` WRITE;
/*!40000 ALTER TABLE `seat_layouts` DISABLE KEYS */;
INSERT INTO `seat_layouts` VALUES (1,'2x2 Sofa Seater (48)','2X2_SOFA',48,12,4,NULL,'2026-01-06 08:00:00'),(2,'2x2 Sofa With Sleeper (50)','2X2_SOFA_WITH_SLEEPER',50,13,4,NULL,'2026-01-06 08:05:00'),(3,'2x1 Sofa Seat (32)','2X1_SOFA',32,16,2,NULL,'2026-01-06 08:10:00');
/*!40000 ALTER TABLE `seat_layouts` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `seats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seats` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `bus_setup_id` int(11) NOT NULL,
                         `seat_number` varchar(10) NOT NULL,
                         `status` enum('AVAILABLE','BOOKED','LOCKED') DEFAULT 'AVAILABLE',
                         `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `unique_seat` (`bus_setup_id`,`seat_number`),
                         CONSTRAINT `seats_ibfk_1` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `seats` WRITE;
/*!40000 ALTER TABLE `seats` DISABLE KEYS */;
INSERT INTO `seats` (`bus_setup_id`,`seat_number`,`status`) VALUES
                                                                (1,'A1','BOOKED'),(1,'A2','BOOKED'),(1,'A3','AVAILABLE'),(1,'A4','AVAILABLE'),
                                                                (1,'B1','BOOKED'),(1,'B2','AVAILABLE'),(1,'B3','AVAILABLE'),(1,'B4','BOOKED'),
                                                                (1,'C1','AVAILABLE'),(1,'C2','AVAILABLE'),(1,'C3','AVAILABLE'),(1,'C4','AVAILABLE'),
                                                                (1,'D1','AVAILABLE'),(1,'D2','AVAILABLE'),(1,'D3','BOOKED'),(1,'D4','BOOKED'),
                                                                (1,'E1','AVAILABLE'),(1,'E2','AVAILABLE'),(1,'E3','AVAILABLE'),(1,'E4','AVAILABLE'),
                                                                (1,'F1','AVAILABLE'),(1,'F2','AVAILABLE'),(1,'F3','AVAILABLE'),(1,'F4','AVAILABLE'),
                                                                (1,'G1','AVAILABLE'),(1,'G2','AVAILABLE'),(1,'G3','AVAILABLE'),(1,'G4','AVAILABLE'),
                                                                (1,'H1','AVAILABLE'),(1,'H2','AVAILABLE'),(1,'H3','AVAILABLE'),(1,'H4','AVAILABLE'),
                                                                (1,'I1','AVAILABLE'),(1,'I2','AVAILABLE'),(1,'I3','AVAILABLE'),(1,'I4','AVAILABLE'),
                                                                (1,'J1','AVAILABLE'),(1,'J2','AVAILABLE'),(1,'J3','AVAILABLE'),(1,'J4','AVAILABLE'),
                                                                (1,'K1','AVAILABLE'),(1,'K2','AVAILABLE'),(1,'K3','AVAILABLE'),(1,'K4','AVAILABLE'),
                                                                (1,'L1','AVAILABLE'),(1,'L2','AVAILABLE'),(1,'L3','AVAILABLE'),(1,'L4','AVAILABLE'),
                                                                (2,'A1','BOOKED'),(2,'A2','BOOKED'),(2,'A3','BOOKED'),(2,'A4','AVAILABLE'),
                                                                (2,'B1','AVAILABLE'),(2,'B2','AVAILABLE'),(2,'B3','AVAILABLE'),(2,'B4','AVAILABLE'),
                                                                (2,'C1','AVAILABLE'),(2,'C2','AVAILABLE'),(2,'C3','AVAILABLE'),(2,'C4','AVAILABLE'),
                                                                (2,'D1','AVAILABLE'),(2,'D2','AVAILABLE'),(2,'D3','AVAILABLE'),(2,'D4','AVAILABLE'),
                                                                (2,'E1','AVAILABLE'),(2,'E2','AVAILABLE'),(2,'E3','AVAILABLE'),(2,'E4','AVAILABLE'),
                                                                (2,'F1','AVAILABLE'),(2,'F2','AVAILABLE'),(2,'F3','AVAILABLE'),(2,'F4','AVAILABLE'),
                                                                (2,'G1','AVAILABLE'),(2,'G2','AVAILABLE'),(2,'G3','AVAILABLE'),(2,'G4','AVAILABLE'),
                                                                (2,'H1','AVAILABLE'),(2,'H2','AVAILABLE'),(2,'H3','AVAILABLE'),(2,'H4','AVAILABLE'),
                                                                (2,'I1','AVAILABLE'),(2,'I2','AVAILABLE'),(2,'I3','AVAILABLE'),
                                                                (3,'A1','AVAILABLE'),(3,'A2','AVAILABLE'),(3,'A3','AVAILABLE'),(3,'A4','AVAILABLE'),
                                                                (3,'B1','AVAILABLE'),(3,'B2','AVAILABLE'),(3,'B3','AVAILABLE'),(3,'B4','AVAILABLE'),
                                                                (3,'C1','AVAILABLE'),(3,'C2','AVAILABLE'),(3,'C3','AVAILABLE'),(3,'C4','AVAILABLE'),
                                                                (3,'D1','AVAILABLE'),(3,'D2','AVAILABLE'),(3,'D3','AVAILABLE'),(3,'D4','AVAILABLE'),
                                                                (3,'E1','AVAILABLE'),(3,'E2','AVAILABLE'),(3,'E3','AVAILABLE'),(3,'E4','AVAILABLE'),
                                                                (3,'F1','AVAILABLE'),(3,'F2','AVAILABLE'),(3,'F3','AVAILABLE'),(3,'F4','AVAILABLE'),
                                                                (3,'G1','AVAILABLE'),(3,'G2','AVAILABLE'),(3,'G3','AVAILABLE'),(3,'G4','AVAILABLE'),
                                                                (3,'H1','AVAILABLE'),(3,'H2','AVAILABLE'),(3,'H3','AVAILABLE'),(3,'H4','AVAILABLE'),
                                                                (3,'I1','AVAILABLE'),(3,'I2','AVAILABLE'),(3,'I3','AVAILABLE'),(3,'I4','AVAILABLE'),
                                                                (3,'J1','AVAILABLE'),(3,'J2','AVAILABLE'),(3,'J3','AVAILABLE'),(3,'J4','AVAILABLE'),
                                                                (3,'K1','AVAILABLE'),(3,'K2','AVAILABLE'),(3,'K3','AVAILABLE'),(3,'K4','AVAILABLE'),
                                                                (3,'L1','AVAILABLE'),
                                                                (4,'A1','AVAILABLE'),(4,'A2','AVAILABLE'),(4,'B1','AVAILABLE'),(4,'B2','AVAILABLE'),
                                                                (4,'C1','AVAILABLE'),(4,'C2','AVAILABLE'),(4,'D1','AVAILABLE'),(4,'D2','AVAILABLE'),
                                                                (4,'E1','AVAILABLE'),(4,'E2','AVAILABLE'),(4,'F1','AVAILABLE'),(4,'F2','AVAILABLE'),
                                                                (4,'G1','AVAILABLE'),(4,'G2','AVAILABLE'),(4,'H1','AVAILABLE'),(4,'H2','AVAILABLE'),
                                                                (4,'I1','AVAILABLE'),(4,'I2','AVAILABLE'),(4,'J1','AVAILABLE'),(4,'J2','AVAILABLE'),
                                                                (4,'K1','AVAILABLE'),(4,'K2','AVAILABLE'),(4,'L1','AVAILABLE'),(4,'L2','AVAILABLE'),
                                                                (4,'M1','AVAILABLE'),(4,'M2','AVAILABLE'),(4,'N1','AVAILABLE'),(4,'N2','AVAILABLE'),
                                                                (4,'O1','AVAILABLE'),(4,'O2','AVAILABLE'),(4,'P1','AVAILABLE'),(4,'P2','AVAILABLE');
/*!40000 ALTER TABLE `seats` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `name` varchar(100) NOT NULL,
                         `role` enum('DRIVER','CONDUCTOR','HELPER') NOT NULL,
                         `phone` varchar(15) NOT NULL,
                         `address` varchar(255) DEFAULT NULL,
                         `license_number` varchar(50) DEFAULT NULL,
                         `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
                         `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                         PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'Kiran Regmi','HELPER','9822780545','Syangja',NULL,'ACTIVE','2026-01-04 08:00:00'),(2,'Jeevan Bhusal','DRIVER','9822780546','Syangja','DL-SYA-001','ACTIVE','2026-01-04 08:05:00'),(3,'Bikash Poudel','CONDUCTOR','9841004004','Pokhara',NULL,'ACTIVE','2026-01-04 08:10:00'),(4,'Hari Thapa','DRIVER','9841005005','Kathmandu','DL-KTM-042','ACTIVE','2026-01-04 08:15:00'),(5,'Sita Karki','CONDUCTOR','9841006006','Waling',NULL,'INACTIVE','2026-01-04 08:20:00');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `full_name` varchar(100) NOT NULL,
                         `email` varchar(100) NOT NULL,
                         `password` varchar(255) NOT NULL,
                         `phone` varchar(15) NOT NULL,
                         `role` enum('ADMIN','OPERATOR','CUSTOMER') DEFAULT 'CUSTOMER',
                         `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin User','admin@kalpana.com','JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=','9800000001','ADMIN','2026-01-01 08:00:00'),(2,'Raju Sharma','customer@kalpana.com','sEHArrNbsPpKpmjKWpILWQGW/a+aAOuFLJt/TRI8xtY=','9841001001','CUSTOMER','2026-01-05 09:00:00'),(3,'Galyang Counter','galyangcounter@operator.com','+aAkMn/htUknPsOEStn3yrkq5Jh7tNZjNlyU+woW02Y=','9822780545','OPERATOR','2026-01-10 09:00:00'),(4,'Riya Thapa','riya@customer.com','yMfLW56Pehs9HQJgKtpiMnEyOR2+Do7geRPNVQ7qHzs=','9841002002','CUSTOMER','2026-02-01 10:00:00'),(5,'Pokhara Counter','pokhara@operator.com','7G4cJSWAAuscZ9Fcf0XaeUX6TFh3j9fYj6peU+O0aY0=','9856003003','OPERATOR','2026-02-05 08:00:00'),(6,'Suman Gurung','suman@customer.com','sEHArrNbsPpKpmjKWpILWQGW/a+aAOuFLJt/TRI8xtY=','9841003003','CUSTOMER','2026-02-10 11:00:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

INSERT INTO `bookings` (`id`,`user_id`,`schedule_id`,`seat_numbers`,`total_fare`,`booking_date`,`status`,`passenger_name`,`passenger_phone`,`passenger_email`,`bus_setup_id`,`route_id`) VALUES (1,2,1,'A1,A2',2400.00,DATE_SUB(NOW(),INTERVAL 2 DAY),'CONFIRMED','Raju Sharma','9841001001','customer@kalpana.com',1,1),(2,4,2,'A1,A2,A3',4500.00,DATE_SUB(NOW(),INTERVAL 1 DAY),'CONFIRMED','Riya Thapa','9841002002','riya@customer.com',2,2),(3,6,3,'D3,D4',1800.00,DATE_SUB(NOW(),INTERVAL 1 DAY),'CONFIRMED','Suman Gurung','9841003003','suman@customer.com',1,1),(4,NULL,1,'B1',1200.00,DATE_SUB(NOW(),INTERVAL 3 DAY),'CONFIRMED','Nisha Poudel','9800100200','nisha@example.com',1,1),(5,2,9,'A1,A2',2400.00,DATE_SUB(NOW(),INTERVAL 8 DAY),'CONFIRMED','Raju Sharma','9841001001','customer@kalpana.com',1,1),(6,4,10,'A1,A2,A3',4500.00,DATE_SUB(NOW(),INTERVAL 8 DAY),'CONFIRMED','Riya Thapa','9841002002','riya@customer.com',2,2),(7,6,11,'B1',900.00,DATE_SUB(NOW(),INTERVAL 9 DAY),'CONFIRMED','Suman Gurung','9841003003','suman@customer.com',3,3),(8,2,13,'C1,C2',2400.00,DATE_SUB(NOW(),INTERVAL 14 DAY),'CONFIRMED','Raju Sharma','9841001001','customer@kalpana.com',1,1),(9,4,14,'B1',1500.00,DATE_SUB(NOW(),INTERVAL 14 DAY),'CONFIRMED','Riya Thapa','9841002002','riya@customer.com',2,2),(10,6,12,'G1',900.00,DATE_SUB(NOW(),INTERVAL 4 DAY),'CANCELLED','Suman Gurung','9841003003','suman@customer.com',4,4),(11,2,5,'E1',1200.00,DATE_SUB(NOW(),INTERVAL 1 HOUR),'PENDING','Raju Sharma','9841001001','customer@kalpana.com',1,1);

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: kalpana_travels
-- Kalpana Travels Bus Management System - Full Seed Data
-- ============================================================
-- Login Credentials:
--   admin@kalpana.com            password: admin123
--   customer@kalpana.com         password: customer123
--   riya@customer.com            password: customer2
--   galyangcounter@operator.com  password: galyang123
--   pokhara@operator.com         password: operator123
-- ============================================================

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `kalpana_travels` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `kalpana_travels`;

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookings` (
                            `id` int(11) NOT NULL AUTO_INCREMENT,
                            `user_id` int(11) DEFAULT NULL,
                            `schedule_id` int(11) DEFAULT NULL,
                            `seat_numbers` varchar(255) NOT NULL,
                            `total_fare` decimal(10,2) NOT NULL,
                            `booking_date` timestamp NOT NULL DEFAULT current_timestamp(),
                            `status` enum('CONFIRMED','CANCELLED','PENDING') DEFAULT 'CONFIRMED',
                            `passenger_name` varchar(100) DEFAULT NULL,
                            `passenger_phone` varchar(15) DEFAULT NULL,
                            `passenger_email` varchar(100) DEFAULT NULL,
                            `bus_setup_id` int(11) DEFAULT NULL,
                            `route_id` int(11) DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            KEY `user_id` (`user_id`),
                            KEY `schedule_id` (`schedule_id`),
                            KEY `bookings_ibfk_bus_setup` (`bus_setup_id`),
                            KEY `bookings_ibfk_route` (`route_id`),
                            CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
                            CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE CASCADE,
                            CONSTRAINT `bookings_ibfk_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL,
                            CONSTRAINT `bookings_ibfk_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `bus_names`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bus_names` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `name` varchar(100) NOT NULL,
                             `bus_type` enum('SLEEPER','DELUXE','SOFA_SEATER') NOT NULL,
                             `capacity` int(11) NOT NULL,
                             `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bus_names` WRITE;
/*!40000 ALTER TABLE `bus_names` DISABLE KEYS */;
INSERT INTO `bus_names` VALUES (1,'Kalpana Airbus','SLEEPER',45,'2026-01-02 08:00:00'),(2,'Kiran Airbus','DELUXE',35,'2026-01-02 08:05:00'),(3,'Syangja Gandaki','SOFA_SEATER',48,'2026-01-02 08:10:00');
/*!40000 ALTER TABLE `bus_names` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `bus_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bus_numbers` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `bus_name_id` int(11) NOT NULL,
                               `registration_number` varchar(50) NOT NULL,
                               `status` enum('ACTIVE','INACTIVE','MAINTENANCE') DEFAULT 'ACTIVE',
                               `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `registration_number` (`registration_number`),
                               KEY `bus_numbers_ibfk_1` (`bus_name_id`),
                               CONSTRAINT `bus_numbers_ibfk_1` FOREIGN KEY (`bus_name_id`) REFERENCES `bus_names` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bus_numbers` WRITE;
/*!40000 ALTER TABLE `bus_numbers` DISABLE KEYS */;
INSERT INTO `bus_numbers` VALUES (1,2,'Lu Pra 01 001 Kha 0660','ACTIVE','2026-01-03 08:00:00'),(2,2,'Lu Pra 01 001 Kha 0661','ACTIVE','2026-01-03 08:05:00'),(3,1,'Lu Pra 01 001 Kha 0662','ACTIVE','2026-01-03 08:10:00'),(4,3,'Ga 1 Kha 1234','ACTIVE','2026-01-03 08:15:00'),(5,1,'Ba 2 Kha 5678','MAINTENANCE','2026-01-03 08:20:00');
/*!40000 ALTER TABLE `bus_numbers` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `bus_setup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bus_setup` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bus_number_id` int(11) NOT NULL,
                             `seat_layout_id` int(11) NOT NULL,
                             `trip_price` decimal(10,2) DEFAULT NULL,
                             `trip_time` time DEFAULT NULL,
                             `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                             `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `unique_bus_number` (`bus_number_id`),
                             KEY `bus_setup_ibfk_2` (`seat_layout_id`),
                             CONSTRAINT `bus_setup_ibfk_1` FOREIGN KEY (`bus_number_id`) REFERENCES `bus_numbers` (`id`) ON DELETE CASCADE,
                             CONSTRAINT `bus_setup_ibfk_2` FOREIGN KEY (`seat_layout_id`) REFERENCES `seat_layouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bus_setup` WRITE;
/*!40000 ALTER TABLE `bus_setup` DISABLE KEYS */;
INSERT INTO `bus_setup` VALUES (1,1,1,1200.00,'06:00:00','2026-01-07 08:00:00','2026-01-07 08:00:00'),(2,2,2,1500.00,'07:30:00','2026-01-07 08:05:00','2026-01-07 08:05:00'),(3,3,1,1100.00,'05:30:00','2026-01-07 08:10:00','2026-01-07 08:10:00'),(4,4,3,900.00,'08:00:00','2026-01-07 08:15:00','2026-01-07 08:15:00');
/*!40000 ALTER TABLE `bus_setup` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `bus_setup_staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bus_setup_staff` (
                                   `id` int(11) NOT NULL AUTO_INCREMENT,
                                   `bus_setup_id` int(11) NOT NULL,
                                   `staff_id` int(11) NOT NULL,
                                   `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                                   PRIMARY KEY (`id`),
                                   UNIQUE KEY `unique_setup_staff` (`bus_setup_id`,`staff_id`),
                                   KEY `bus_setup_staff_ibfk_2` (`staff_id`),
                                   CONSTRAINT `bus_setup_staff_ibfk_1` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE,
                                   CONSTRAINT `bus_setup_staff_ibfk_2` FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `bus_setup_staff` WRITE;
/*!40000 ALTER TABLE `bus_setup_staff` DISABLE KEYS */;
INSERT INTO `bus_setup_staff` (`bus_setup_id`,`staff_id`) VALUES (1,2),(1,1),(2,4),(2,3),(3,2),(3,3),(4,4),(4,1);
/*!40000 ALTER TABLE `bus_setup_staff` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `buses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buses` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `bus_number` varchar(50) NOT NULL,
                         `bus_name` varchar(100) NOT NULL,
                         `capacity` int(11) NOT NULL,
                         `bus_type` enum('STANDARD','SEMI_DELUXE','AC_DELUXE','SUPER_DELUXE') NOT NULL,
                         `fare_per_seat` decimal(10,2) NOT NULL,
                         `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `bus_number` (`bus_number`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `buses` WRITE;
/*!40000 ALTER TABLE `buses` DISABLE KEYS */;
INSERT INTO `buses` VALUES (1,'Lu Pra 01 001 Kha 0660','Kiran Airbus',35,'AC_DELUXE',1200.00,'ACTIVE'),(2,'Lu Pra 01 001 Kha 0661','Kiran Airbus',35,'AC_DELUXE',1500.00,'ACTIVE'),(3,'Lu Pra 01 001 Kha 0662','Kalpana Airbus',45,'SEMI_DELUXE',1100.00,'ACTIVE'),(4,'Ga 1 Kha 1234','Syangja Gandaki',48,'STANDARD',900.00,'ACTIVE');
/*!40000 ALTER TABLE `buses` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `chalani`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `chalani` (
                           `id` int(11) NOT NULL AUTO_INCREMENT,
                           `bus_setup_id` int(11) NOT NULL,
                           `operator_id` int(11) DEFAULT NULL,
                           `booking_date` date NOT NULL,
                           `total_seats_booked` int(11) DEFAULT NULL,
                           `total_revenue` decimal(12,2) DEFAULT NULL,
                           `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                           PRIMARY KEY (`id`),
                           UNIQUE KEY `unique_chalani_setup_operator_date` (`bus_setup_id`,`operator_id`,`booking_date`),
                           KEY `chalani_ibfk_2` (`operator_id`),
                           CONSTRAINT `chalani_ibfk_1` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE,
                           CONSTRAINT `chalani_ibfk_2` FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `chalani` WRITE;
/*!40000 ALTER TABLE `chalani` DISABLE KEYS */;
INSERT INTO `chalani` (`bus_setup_id`,`operator_id`,`booking_date`,`total_seats_booked`,`total_revenue`) VALUES (1,3,DATE_SUB(CURDATE(),INTERVAL 1 DAY),12,14400.00),(2,5,DATE_SUB(CURDATE(),INTERVAL 1 DAY),8,12000.00),(3,3,DATE_SUB(CURDATE(),INTERVAL 2 DAY),10,9000.00),(1,3,DATE_SUB(CURDATE(),INTERVAL 7 DAY),15,18000.00),(2,5,DATE_SUB(CURDATE(),INTERVAL 7 DAY),11,16500.00),(4,3,DATE_SUB(CURDATE(),INTERVAL 3 DAY),7,6300.00);
/*!40000 ALTER TABLE `chalani` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `drop_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `drop_points` (
                               `id` int(11) NOT NULL AUTO_INCREMENT,
                               `route_id` int(11) NOT NULL,
                               `location_id` int(11) NOT NULL,
                               `drop_route` varchar(150) DEFAULT NULL,
                               `drop_time` time NOT NULL,
                               `price` decimal(10,2) DEFAULT 0.00,
                               `price_multiplier` decimal(5,2) DEFAULT 1.00,
                               `sequence_order` int(11) DEFAULT NULL,
                               `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                               PRIMARY KEY (`id`),
                               KEY `drop_points_ibfk_1` (`route_id`),
                               KEY `drop_points_ibfk_2` (`location_id`),
                               CONSTRAINT `drop_points_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE,
                               CONSTRAINT `drop_points_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `drop_points` WRITE;
/*!40000 ALTER TABLE `drop_points` DISABLE KEYS */;
INSERT INTO `drop_points` (`route_id`,`location_id`,`drop_route`,`drop_time`,`price`,`price_multiplier`,`sequence_order`) VALUES (1,6,'Mugling Bus Stop','10:00:00',700.00,0.60,1),(1,5,'Kathmandu New Bus Park','14:00:00',0.00,0.00,2),(2,6,'Mugling Chowk','11:00:00',600.00,0.40,1),(2,5,'Kathmandu New Bus Park','14:30:00',0.00,0.00,2),(3,9,'Mirdi Stop','07:00:00',300.00,0.35,1),(3,4,'Pokhara Bus Park','08:00:00',0.00,0.00,2),(4,6,'Mugling Bus Stop','12:00:00',500.00,0.56,1),(4,5,'Kathmandu New Bus Park','17:00:00',0.00,0.00,2);
/*!40000 ALTER TABLE `drop_points` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `event_reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_reservations` (
                                      `id` int(11) NOT NULL AUTO_INCREMENT,
                                      `user_id` int(11) NOT NULL,
                                      `event_type` varchar(50) NOT NULL,
                                      `event_name` varchar(255) NOT NULL,
                                      `event_date` date NOT NULL,
                                      `required_date` date NOT NULL,
                                      `number_of_passengers` int(11) NOT NULL,
                                      `number_of_buses` int(11) NOT NULL,
                                      `preferred_bus_type` varchar(50) DEFAULT NULL,
                                      `pickup_location` varchar(255) NOT NULL,
                                      `dropoff_location` varchar(255) NOT NULL,
                                      `description` text DEFAULT NULL,
                                      `status` varchar(50) DEFAULT 'PENDING',
                                      `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                                      PRIMARY KEY (`id`),
                                      KEY `event_reservations_ibfk_1` (`user_id`),
                                      CONSTRAINT `event_reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `event_reservations` WRITE;
/*!40000 ALTER TABLE `event_reservations` DISABLE KEYS */;
INSERT INTO `event_reservations` (`user_id`,`event_type`,`event_name`,`event_date`,`required_date`,`number_of_passengers`,`number_of_buses`,`preferred_bus_type`,`pickup_location`,`dropoff_location`,`description`,`status`) VALUES (2,'Wedding','Raju Wedding Party',DATE_ADD(CURDATE(),INTERVAL 10 DAY),DATE_ADD(CURDATE(),INTERVAL 8 DAY),80,2,'DELUXE','Waling Bus Park','Pokhara Hotel Barahi','Need 2 deluxe buses for wedding guests','PENDING'),(4,'School Trip','Riya School Excursion',DATE_ADD(CURDATE(),INTERVAL 20 DAY),DATE_ADD(CURDATE(),INTERVAL 18 DAY),45,1,'SOFA_SEATER','Syangja School','Pokhara Fewa Lake','Annual school trip for grade 10','CONFIRMED'),(6,'Corporate','Suman Company Picnic',DATE_ADD(CURDATE(),INTERVAL 5 DAY),DATE_ADD(CURDATE(),INTERVAL 3 DAY),30,1,'SLEEPER','Kathmandu Office','Pokhara Resort','Annual staff picnic','PENDING'),(2,'Pilgrimage','Muktinath Yatra',DATE_SUB(CURDATE(),INTERVAL 15 DAY),DATE_SUB(CURDATE(),INTERVAL 17 DAY),50,1,'DELUXE','Waling Bus Park','Muktinath Temple','Religious pilgrimage trip - completed','CONFIRMED');
/*!40000 ALTER TABLE `event_reservations` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locations` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `name` varchar(100) NOT NULL,
                             `district` varchar(50) DEFAULT NULL,
                             `latitude` decimal(10,8) DEFAULT NULL,
                             `longitude` decimal(11,8) DEFAULT NULL,
                             `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Waling','Syangja',27.98810000,83.78210000,'2026-01-05 08:00:00'),(2,'Syangja','Syangja',27.95570000,83.88470000,'2026-01-05 08:01:00'),(3,'Ramdi','Syangja',28.00190000,83.72040000,'2026-01-05 08:02:00'),(4,'Pokhara','Kaski',28.20960000,83.98560000,'2026-01-05 08:03:00'),(5,'Kathmandu','Kathmandu',27.71720000,85.32400000,'2026-01-05 08:04:00'),(6,'Mugling','Chitwan',27.86940000,84.51660000,'2026-01-05 08:05:00'),(7,'Damauli','Tanahun',27.96230000,84.29290000,'2026-01-05 08:06:00'),(8,'Butwal','Rupandehi',27.70060000,83.44830000,'2026-01-05 08:07:00'),(9,'Mirdi','Baglung',28.12600000,83.81500000,'2026-01-05 08:08:00'),(10,'Malunga','Syangja',27.97000000,83.75000000,'2026-01-05 08:09:00');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `loyalty_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `loyalty_points` (
                                  `id` int(11) NOT NULL AUTO_INCREMENT,
                                  `user_id` int(11) NOT NULL,
                                  `points_balance` int(11) DEFAULT 0,
                                  `total_points_earned` int(11) DEFAULT 0,
                                  `last_updated` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
                                  PRIMARY KEY (`id`),
                                  UNIQUE KEY `unique_user_loyalty` (`user_id`),
                                  CONSTRAINT `loyalty_points_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `loyalty_points` WRITE;
/*!40000 ALTER TABLE `loyalty_points` DISABLE KEYS */;
INSERT INTO `loyalty_points` (`user_id`,`points_balance`,`total_points_earned`) VALUES (2,480,600),(4,300,300),(6,120,150);
/*!40000 ALTER TABLE `loyalty_points` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `pickup_points`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pickup_points` (
                                 `id` int(11) NOT NULL AUTO_INCREMENT,
                                 `route_id` int(11) NOT NULL,
                                 `location_id` int(11) NOT NULL,
                                 `pickup_route` varchar(150) DEFAULT NULL,
                                 `pickup_time` time NOT NULL,
                                 `price` decimal(10,2) DEFAULT 0.00,
                                 `price_multiplier` decimal(5,2) DEFAULT 1.00,
                                 `sequence_order` int(11) DEFAULT NULL,
                                 `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                                 PRIMARY KEY (`id`),
                                 KEY `pickup_points_ibfk_1` (`route_id`),
                                 KEY `pickup_points_ibfk_2` (`location_id`),
                                 CONSTRAINT `pickup_points_ibfk_1` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE,
                                 CONSTRAINT `pickup_points_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `pickup_points` WRITE;
/*!40000 ALTER TABLE `pickup_points` DISABLE KEYS */;
INSERT INTO `pickup_points` (`route_id`,`location_id`,`pickup_route`,`pickup_time`,`price`,`price_multiplier`,`sequence_order`) VALUES (1,1,'Waling Bus Park','06:00:00',1200.00,1.00,1),(1,10,'Malunga Chowk','06:20:00',800.00,0.70,2),(1,3,'Ramdi Bus Stop','06:40:00',750.00,0.65,3),(2,4,'Pokhara Bus Park','07:30:00',1500.00,1.00,1),(2,7,'Damauli Bus Stop','08:30:00',1100.00,0.75,2),(3,1,'Waling Bus Park','05:30:00',900.00,1.00,1),(3,2,'Syangja Chowk','06:00:00',600.00,0.70,2),(4,2,'Syangja Bus Park','08:00:00',900.00,1.00,1),(4,1,'Waling Bus Stop','08:30:00',850.00,0.95,2);
/*!40000 ALTER TABLE `pickup_points` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `routes` (
                          `id` int(11) NOT NULL AUTO_INCREMENT,
                          `source` varchar(50) NOT NULL,
                          `destination` varchar(50) NOT NULL,
                          `distance` int(11) DEFAULT NULL,
                          `duration` varchar(20) DEFAULT NULL,
                          `departure_location_id` int(11) DEFAULT NULL,
                          `arrival_location_id` int(11) DEFAULT NULL,
                          `duration_hours` decimal(5,2) DEFAULT NULL,
                          `distance_km` decimal(8,2) DEFAULT NULL,
                          `remarks` text DEFAULT NULL,
                          `bus_setup_id` int(11) DEFAULT NULL,
                          PRIMARY KEY (`id`),
                          KEY `routes_ibfk_departure` (`departure_location_id`),
                          KEY `routes_ibfk_arrival` (`arrival_location_id`),
                          KEY `fk_route_bus_setup` (`bus_setup_id`),
                          CONSTRAINT `fk_route_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL,
                          CONSTRAINT `routes_ibfk_arrival` FOREIGN KEY (`arrival_location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL,
                          CONSTRAINT `routes_ibfk_departure` FOREIGN KEY (`departure_location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
INSERT INTO `routes` VALUES (1,'Waling','Kathmandu',220,'8h',1,5,8.00,220.00,'Via Pokhara and Mugling',1),(2,'Pokhara','Kathmandu',200,'7h',4,5,7.00,200.00,'Express route via Mugling',2),(3,'Waling','Pokhara',60,'2.5h',1,4,2.50,60.00,'Local route via Syangja',3),(4,'Syangja','Kathmandu',240,'9h',2,5,9.00,240.00,'Budget route via Waling',4);
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `schedules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schedules` (
                             `id` int(11) NOT NULL AUTO_INCREMENT,
                             `bus_id` int(11) NOT NULL,
                             `route_id` int(11) NOT NULL,
                             `departure_time` time NOT NULL,
                             `arrival_time` time NOT NULL,
                             `travel_date` date NOT NULL,
                             `available_seats` int(11) NOT NULL,
                             `bus_setup_id` int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `bus_id` (`bus_id`),
                             KEY `route_id` (`route_id`),
                             KEY `schedules_ibfk_bus_setup` (`bus_setup_id`),
                             CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE CASCADE,
                             CONSTRAINT `schedules_ibfk_2` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE,
                             CONSTRAINT `schedules_ibfk_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` (`id`,`bus_id`,`route_id`,`departure_time`,`arrival_time`,`travel_date`,`available_seats`,`bus_setup_id`) VALUES (1,1,1,'06:00:00','14:00:00',DATE_ADD(CURDATE(),INTERVAL 1 DAY),30,1),(2,2,2,'07:30:00','14:30:00',DATE_ADD(CURDATE(),INTERVAL 1 DAY),32,2),(3,3,3,'05:30:00','08:00:00',DATE_ADD(CURDATE(),INTERVAL 1 DAY),40,3),(4,4,4,'08:00:00','17:00:00',DATE_ADD(CURDATE(),INTERVAL 2 DAY),45,4),(5,1,1,'06:00:00','14:00:00',DATE_ADD(CURDATE(),INTERVAL 3 DAY),35,1),(6,2,2,'07:30:00','14:30:00',DATE_ADD(CURDATE(),INTERVAL 3 DAY),33,2),(7,3,3,'05:30:00','08:00:00',DATE_ADD(CURDATE(),INTERVAL 5 DAY),42,3),(8,1,1,'06:00:00','14:00:00',DATE_ADD(CURDATE(),INTERVAL 7 DAY),35,1),(9,1,1,'06:00:00','14:00:00',DATE_SUB(CURDATE(),INTERVAL 1 DAY),0,1),(10,2,2,'07:30:00','14:30:00',DATE_SUB(CURDATE(),INTERVAL 1 DAY),2,2),(11,3,3,'05:30:00','08:00:00',DATE_SUB(CURDATE(),INTERVAL 2 DAY),5,3),(12,4,4,'08:00:00','17:00:00',DATE_SUB(CURDATE(),INTERVAL 3 DAY),8,4),(13,1,1,'06:00:00','14:00:00',DATE_SUB(CURDATE(),INTERVAL 7 DAY),0,1),(14,2,2,'07:30:00','14:30:00',DATE_SUB(CURDATE(),INTERVAL 7 DAY),1,2);
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `seat_layouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seat_layouts` (
                                `id` int(11) NOT NULL AUTO_INCREMENT,
                                `name` varchar(100) NOT NULL,
                                `type` enum('2X2_SOFA','2X2_SOFA_WITH_SLEEPER','2X1_SOFA') NOT NULL,
                                `total_seats` int(11) NOT NULL,
                                `rows` int(11) NOT NULL,
                                `columns` int(11) NOT NULL,
                                `layout_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`layout_json`)),
                                `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                                PRIMARY KEY (`id`),
                                UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `seat_layouts` WRITE;
/*!40000 ALTER TABLE `seat_layouts` DISABLE KEYS */;
INSERT INTO `seat_layouts` VALUES (1,'2x2 Sofa Seater (48)','2X2_SOFA',48,12,4,NULL,'2026-01-06 08:00:00'),(2,'2x2 Sofa With Sleeper (50)','2X2_SOFA_WITH_SLEEPER',50,13,4,NULL,'2026-01-06 08:05:00'),(3,'2x1 Sofa Seat (32)','2X1_SOFA',32,16,2,NULL,'2026-01-06 08:10:00');
/*!40000 ALTER TABLE `seat_layouts` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `seats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `seats` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `bus_setup_id` int(11) NOT NULL,
                         `seat_number` varchar(10) NOT NULL,
                         `status` enum('AVAILABLE','BOOKED','LOCKED') DEFAULT 'AVAILABLE',
                         `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `unique_seat` (`bus_setup_id`,`seat_number`),
                         CONSTRAINT `seats_ibfk_1` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `seats` WRITE;
/*!40000 ALTER TABLE `seats` DISABLE KEYS */;
INSERT INTO `seats` (`bus_setup_id`,`seat_number`,`status`) VALUES
                                                                (1,'A1','BOOKED'),(1,'A2','BOOKED'),(1,'A3','AVAILABLE'),(1,'A4','AVAILABLE'),
                                                                (1,'B1','BOOKED'),(1,'B2','AVAILABLE'),(1,'B3','AVAILABLE'),(1,'B4','BOOKED'),
                                                                (1,'C1','AVAILABLE'),(1,'C2','AVAILABLE'),(1,'C3','AVAILABLE'),(1,'C4','AVAILABLE'),
                                                                (1,'D1','AVAILABLE'),(1,'D2','AVAILABLE'),(1,'D3','BOOKED'),(1,'D4','BOOKED'),
                                                                (1,'E1','AVAILABLE'),(1,'E2','AVAILABLE'),(1,'E3','AVAILABLE'),(1,'E4','AVAILABLE'),
                                                                (1,'F1','AVAILABLE'),(1,'F2','AVAILABLE'),(1,'F3','AVAILABLE'),(1,'F4','AVAILABLE'),
                                                                (1,'G1','AVAILABLE'),(1,'G2','AVAILABLE'),(1,'G3','AVAILABLE'),(1,'G4','AVAILABLE'),
                                                                (1,'H1','AVAILABLE'),(1,'H2','AVAILABLE'),(1,'H3','AVAILABLE'),(1,'H4','AVAILABLE'),
                                                                (1,'I1','AVAILABLE'),(1,'I2','AVAILABLE'),(1,'I3','AVAILABLE'),(1,'I4','AVAILABLE'),
                                                                (1,'J1','AVAILABLE'),(1,'J2','AVAILABLE'),(1,'J3','AVAILABLE'),(1,'J4','AVAILABLE'),
                                                                (1,'K1','AVAILABLE'),(1,'K2','AVAILABLE'),(1,'K3','AVAILABLE'),(1,'K4','AVAILABLE'),
                                                                (1,'L1','AVAILABLE'),(1,'L2','AVAILABLE'),(1,'L3','AVAILABLE'),(1,'L4','AVAILABLE'),
                                                                (2,'A1','BOOKED'),(2,'A2','BOOKED'),(2,'A3','BOOKED'),(2,'A4','AVAILABLE'),
                                                                (2,'B1','AVAILABLE'),(2,'B2','AVAILABLE'),(2,'B3','AVAILABLE'),(2,'B4','AVAILABLE'),
                                                                (2,'C1','AVAILABLE'),(2,'C2','AVAILABLE'),(2,'C3','AVAILABLE'),(2,'C4','AVAILABLE'),
                                                                (2,'D1','AVAILABLE'),(2,'D2','AVAILABLE'),(2,'D3','AVAILABLE'),(2,'D4','AVAILABLE'),
                                                                (2,'E1','AVAILABLE'),(2,'E2','AVAILABLE'),(2,'E3','AVAILABLE'),(2,'E4','AVAILABLE'),
                                                                (2,'F1','AVAILABLE'),(2,'F2','AVAILABLE'),(2,'F3','AVAILABLE'),(2,'F4','AVAILABLE'),
                                                                (2,'G1','AVAILABLE'),(2,'G2','AVAILABLE'),(2,'G3','AVAILABLE'),(2,'G4','AVAILABLE'),
                                                                (2,'H1','AVAILABLE'),(2,'H2','AVAILABLE'),(2,'H3','AVAILABLE'),(2,'H4','AVAILABLE'),
                                                                (2,'I1','AVAILABLE'),(2,'I2','AVAILABLE'),(2,'I3','AVAILABLE'),
                                                                (3,'A1','AVAILABLE'),(3,'A2','AVAILABLE'),(3,'A3','AVAILABLE'),(3,'A4','AVAILABLE'),
                                                                (3,'B1','AVAILABLE'),(3,'B2','AVAILABLE'),(3,'B3','AVAILABLE'),(3,'B4','AVAILABLE'),
                                                                (3,'C1','AVAILABLE'),(3,'C2','AVAILABLE'),(3,'C3','AVAILABLE'),(3,'C4','AVAILABLE'),
                                                                (3,'D1','AVAILABLE'),(3,'D2','AVAILABLE'),(3,'D3','AVAILABLE'),(3,'D4','AVAILABLE'),
                                                                (3,'E1','AVAILABLE'),(3,'E2','AVAILABLE'),(3,'E3','AVAILABLE'),(3,'E4','AVAILABLE'),
                                                                (3,'F1','AVAILABLE'),(3,'F2','AVAILABLE'),(3,'F3','AVAILABLE'),(3,'F4','AVAILABLE'),
                                                                (3,'G1','AVAILABLE'),(3,'G2','AVAILABLE'),(3,'G3','AVAILABLE'),(3,'G4','AVAILABLE'),
                                                                (3,'H1','AVAILABLE'),(3,'H2','AVAILABLE'),(3,'H3','AVAILABLE'),(3,'H4','AVAILABLE'),
                                                                (3,'I1','AVAILABLE'),(3,'I2','AVAILABLE'),(3,'I3','AVAILABLE'),(3,'I4','AVAILABLE'),
                                                                (3,'J1','AVAILABLE'),(3,'J2','AVAILABLE'),(3,'J3','AVAILABLE'),(3,'J4','AVAILABLE'),
                                                                (3,'K1','AVAILABLE'),(3,'K2','AVAILABLE'),(3,'K3','AVAILABLE'),(3,'K4','AVAILABLE'),
                                                                (3,'L1','AVAILABLE'),
                                                                (4,'A1','AVAILABLE'),(4,'A2','AVAILABLE'),(4,'B1','AVAILABLE'),(4,'B2','AVAILABLE'),
                                                                (4,'C1','AVAILABLE'),(4,'C2','AVAILABLE'),(4,'D1','AVAILABLE'),(4,'D2','AVAILABLE'),
                                                                (4,'E1','AVAILABLE'),(4,'E2','AVAILABLE'),(4,'F1','AVAILABLE'),(4,'F2','AVAILABLE'),
                                                                (4,'G1','AVAILABLE'),(4,'G2','AVAILABLE'),(4,'H1','AVAILABLE'),(4,'H2','AVAILABLE'),
                                                                (4,'I1','AVAILABLE'),(4,'I2','AVAILABLE'),(4,'J1','AVAILABLE'),(4,'J2','AVAILABLE'),
                                                                (4,'K1','AVAILABLE'),(4,'K2','AVAILABLE'),(4,'L1','AVAILABLE'),(4,'L2','AVAILABLE'),
                                                                (4,'M1','AVAILABLE'),(4,'M2','AVAILABLE'),(4,'N1','AVAILABLE'),(4,'N2','AVAILABLE'),
                                                                (4,'O1','AVAILABLE'),(4,'O2','AVAILABLE'),(4,'P1','AVAILABLE'),(4,'P2','AVAILABLE');
/*!40000 ALTER TABLE `seats` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `staff`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `staff` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `name` varchar(100) NOT NULL,
                         `role` enum('DRIVER','CONDUCTOR','HELPER') NOT NULL,
                         `phone` varchar(15) NOT NULL,
                         `address` varchar(255) DEFAULT NULL,
                         `license_number` varchar(50) DEFAULT NULL,
                         `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
                         `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                         PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'Kiran Regmi','HELPER','9822780545','Syangja',NULL,'ACTIVE','2026-01-04 08:00:00'),(2,'Jeevan Bhusal','DRIVER','9822780546','Syangja','DL-SYA-001','ACTIVE','2026-01-04 08:05:00'),(3,'Bikash Poudel','CONDUCTOR','9841004004','Pokhara',NULL,'ACTIVE','2026-01-04 08:10:00'),(4,'Hari Thapa','DRIVER','9841005005','Kathmandu','DL-KTM-042','ACTIVE','2026-01-04 08:15:00'),(5,'Sita Karki','CONDUCTOR','9841006006','Waling',NULL,'INACTIVE','2026-01-04 08:20:00');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
                         `id` int(11) NOT NULL AUTO_INCREMENT,
                         `full_name` varchar(100) NOT NULL,
                         `email` varchar(100) NOT NULL,
                         `password` varchar(255) NOT NULL,
                         `phone` varchar(15) NOT NULL,
                         `role` enum('ADMIN','OPERATOR','CUSTOMER') DEFAULT 'CUSTOMER',
                         `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin User','admin@kalpana.com','JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=','9800000001','ADMIN','2026-01-01 08:00:00'),(2,'Raju Sharma','customer@kalpana.com','sEHArrNbsPpKpmjKWpILWQGW/a+aAOuFLJt/TRI8xtY=','9841001001','CUSTOMER','2026-01-05 09:00:00'),(3,'Galyang Counter','galyangcounter@operator.com','+aAkMn/htUknPsOEStn3yrkq5Jh7tNZjNlyU+woW02Y=','9822780545','OPERATOR','2026-01-10 09:00:00'),(4,'Riya Thapa','riya@customer.com','yMfLW56Pehs9HQJgKtpiMnEyOR2+Do7geRPNVQ7qHzs=','9841002002','CUSTOMER','2026-02-01 10:00:00'),(5,'Pokhara Counter','pokhara@operator.com','7G4cJSWAAuscZ9Fcf0XaeUX6TFh3j9fYj6peU+O0aY0=','9856003003','OPERATOR','2026-02-05 08:00:00'),(6,'Suman Gurung','suman@customer.com','sEHArrNbsPpKpmjKWpILWQGW/a+aAOuFLJt/TRI8xtY=','9841003003','CUSTOMER','2026-02-10 11:00:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

INSERT INTO `bookings` (`id`,`user_id`,`schedule_id`,`seat_numbers`,`total_fare`,`booking_date`,`status`,`passenger_name`,`passenger_phone`,`passenger_email`,`bus_setup_id`,`route_id`) VALUES (1,2,1,'A1,A2',2400.00,DATE_SUB(NOW(),INTERVAL 2 DAY),'CONFIRMED','Raju Sharma','9841001001','customer@kalpana.com',1,1),(2,4,2,'A1,A2,A3',4500.00,DATE_SUB(NOW(),INTERVAL 1 DAY),'CONFIRMED','Riya Thapa','9841002002','riya@customer.com',2,2),(3,6,3,'D3,D4',1800.00,DATE_SUB(NOW(),INTERVAL 1 DAY),'CONFIRMED','Suman Gurung','9841003003','suman@customer.com',1,1),(4,NULL,1,'B1',1200.00,DATE_SUB(NOW(),INTERVAL 3 DAY),'CONFIRMED','Nisha Poudel','9800100200','nisha@example.com',1,1),(5,2,9,'A1,A2',2400.00,DATE_SUB(NOW(),INTERVAL 8 DAY),'CONFIRMED','Raju Sharma','9841001001','customer@kalpana.com',1,1),(6,4,10,'A1,A2,A3',4500.00,DATE_SUB(NOW(),INTERVAL 8 DAY),'CONFIRMED','Riya Thapa','9841002002','riya@customer.com',2,2),(7,6,11,'B1',900.00,DATE_SUB(NOW(),INTERVAL 9 DAY),'CONFIRMED','Suman Gurung','9841003003','suman@customer.com',3,3),(8,2,13,'C1,C2',2400.00,DATE_SUB(NOW(),INTERVAL 14 DAY),'CONFIRMED','Raju Sharma','9841001001','customer@kalpana.com',1,1),(9,4,14,'B1',1500.00,DATE_SUB(NOW(),INTERVAL 14 DAY),'CONFIRMED','Riya Thapa','9841002002','riya@customer.com',2,2),(10,6,12,'G1',900.00,DATE_SUB(NOW(),INTERVAL 4 DAY),'CANCELLED','Suman Gurung','9841003003','suman@customer.com',4,4),(11,2,5,'E1',1200.00,DATE_SUB(NOW(),INTERVAL 1 HOUR),'PENDING','Raju Sharma','9841001001','customer@kalpana.com',1,1);

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;