-- MariaDB dump 10.19  Distrib 10.4.32-MariaDB, for Win64 (AMD64)
--
-- Host: localhost    Database: kalpana_travels
-- ------------------------------------------------------
-- Server version	10.4.32-MariaDB

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

--
-- Current Database: `kalpana_travels`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `kalpana_travels` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

USE `kalpana_travels`;

--
-- Table structure for table `bookings`
--

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

--
-- Dumping data for table `bookings`
--

LOCK TABLES `bookings` WRITE;
/*!40000 ALTER TABLE `bookings` DISABLE KEYS */;
/*!40000 ALTER TABLE `bookings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bus_names`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bus_names`
--

LOCK TABLES `bus_names` WRITE;
/*!40000 ALTER TABLE `bus_names` DISABLE KEYS */;
INSERT INTO `bus_names` VALUES (1,'Kalpana Airbus','SLEEPER',45,'2026-05-20 10:42:17'),(2,'Kiran Airbus','DELUXE',35,'2026-05-20 10:48:00');
/*!40000 ALTER TABLE `bus_names` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bus_numbers`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bus_numbers`
--

LOCK TABLES `bus_numbers` WRITE;
/*!40000 ALTER TABLE `bus_numbers` DISABLE KEYS */;
INSERT INTO `bus_numbers` VALUES (1,2,'Lu Pra 01 001 Kha 0660','ACTIVE','2026-05-20 10:48:43'),(2,2,'Lu Pra 01 001 Kha 0661','ACTIVE','2026-05-20 10:48:53'),(3,1,'Lu Pra 01 001 Kha 0662','ACTIVE','2026-05-20 10:49:00');
/*!40000 ALTER TABLE `bus_numbers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bus_setup`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bus_setup`
--

LOCK TABLES `bus_setup` WRITE;
/*!40000 ALTER TABLE `bus_setup` DISABLE KEYS */;
/*!40000 ALTER TABLE `bus_setup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bus_setup_staff`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bus_setup_staff`
--

LOCK TABLES `bus_setup_staff` WRITE;
/*!40000 ALTER TABLE `bus_setup_staff` DISABLE KEYS */;
/*!40000 ALTER TABLE `bus_setup_staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buses`
--

DROP TABLE IF EXISTS `buses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `buses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bus_number` varchar(20) NOT NULL,
  `bus_name` varchar(100) NOT NULL,
  `capacity` int(11) NOT NULL,
  `bus_type` enum('STANDARD','SEMI_DELUXE','AC_DELUXE','SUPER_DELUXE') NOT NULL,
  `fare_per_seat` decimal(10,2) NOT NULL,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  PRIMARY KEY (`id`),
  UNIQUE KEY `bus_number` (`bus_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buses`
--

LOCK TABLES `buses` WRITE;
/*!40000 ALTER TABLE `buses` DISABLE KEYS */;
/*!40000 ALTER TABLE `buses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chalani`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chalani`
--

LOCK TABLES `chalani` WRITE;
/*!40000 ALTER TABLE `chalani` DISABLE KEYS */;
/*!40000 ALTER TABLE `chalani` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drop_points`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drop_points`
--

LOCK TABLES `drop_points` WRITE;
/*!40000 ALTER TABLE `drop_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `drop_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_reservations`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_reservations`
--

LOCK TABLES `event_reservations` WRITE;
/*!40000 ALTER TABLE `event_reservations` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
INSERT INTO `locations` VALUES (1,'Waling','Syangja',NULL,NULL,'2026-05-20 10:51:38');
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loyalty_points`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loyalty_points`
--

LOCK TABLES `loyalty_points` WRITE;
/*!40000 ALTER TABLE `loyalty_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `loyalty_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pickup_points`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pickup_points`
--

LOCK TABLES `pickup_points` WRITE;
/*!40000 ALTER TABLE `pickup_points` DISABLE KEYS */;
/*!40000 ALTER TABLE `pickup_points` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routes`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedules`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seat_layouts`
--

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `seat_layouts`
--

LOCK TABLES `seat_layouts` WRITE;
/*!40000 ALTER TABLE `seat_layouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `seat_layouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `seats`
--

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

--
-- Dumping data for table `seats`
--

LOCK TABLES `seats` WRITE;
/*!40000 ALTER TABLE `seats` DISABLE KEYS */;
/*!40000 ALTER TABLE `seats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff`
--

LOCK TABLES `staff` WRITE;
/*!40000 ALTER TABLE `staff` DISABLE KEYS */;
INSERT INTO `staff` VALUES (1,'Kiran Regmi','HELPER','9822780545',NULL,NULL,'ACTIVE','2026-05-20 10:50:24'),(2,'Jeevan Bhusal','DRIVER','9822780546',NULL,NULL,'ACTIVE','2026-05-20 10:50:41');
/*!40000 ALTER TABLE `staff` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Admin User','admin@kalpana.com','JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=','9800000001','ADMIN','2026-05-20 10:35:04'),(2,'Customer User','customer@kalpana.com','sEHArrNbsPpKpmjKWpILWQGW/a+aAOuFLJt/TRI8xtY=','9800000002','CUSTOMER','2026-05-20 10:35:04'),(3,'Galyang Counter','galyangcounter@operator.com','+aAkMn/htUknPsOEStn3yrkq5Jh7tNZjNlyU+woW02Y=','9822780545','OPERATOR','2026-05-20 10:39:45');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-20 16:40:22
