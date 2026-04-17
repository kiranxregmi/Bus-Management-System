-- MySQL dump 10.13  Distrib 10.4.32-MariaDB, for Linux (x86_64)
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
-- Table structure for table `bookings`
--

DROP TABLE IF EXISTS `bookings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bookings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `schedule_id` int(11) NOT NULL,
  `seat_numbers` varchar(255) NOT NULL,
  `total_fare` decimal(10,2) NOT NULL,
  `booking_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('CONFIRMED','CANCELLED','PENDING') DEFAULT 'CONFIRMED',
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `schedule_id` (`schedule_id`),
  CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE CASCADE
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
INSERT INTO `buses` VALUES
(1,'GA-6006','Kalpana Air Bus',50,'AC_DELUXE',1500.00,'ACTIVE'),
(2,'KT-001','Kalpana Express',45,'SUPER_DELUXE',1200.00,'ACTIVE'),
(3,'PK-2020','Pokhara Travel',48,'AC_DELUXE',1400.00,'ACTIVE'),
(4,'KM-5050','Mountain Journey',40,'SEMI_DELUXE',1000.00,'ACTIVE'),
(5,'CT-3030','City Cruiser',55,'STANDARD',800.00,'ACTIVE'),
(6,'KN-1001','Kathmandu Night Express',48,'SUPER_DELUXE',1800.00,'ACTIVE'),
(7,'PK-3030','Pokhara Premium',45,'AC_DELUXE',1600.00,'ACTIVE'),
(8,'CT-4040','Chitwan Travels',50,'SEMI_DELUXE',1100.00,'ACTIVE'),
(9,'LM-5050','Lumbini Express',55,'STANDARD',900.00,'ACTIVE'),
(10,'JN-6060','Janakpur Deluxe',42,'AC_DELUXE',1400.00,'ACTIVE'),
(11,'BW-7070','Butwal Comfort',48,'SEMI_DELUXE',1200.00,'ACTIVE'),
(12,'RP-8080','Royal Palace',50,'SUPER_DELUXE',2000.00,'ACTIVE'),
(13,'VS-9090','VIP Service',40,'SUPER_DELUXE',2200.00,'ACTIVE');
/*!40000 ALTER TABLE `buses` ENABLE KEYS */;
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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
INSERT INTO `routes` VALUES
(1,'Kathmandu','Pokhara',200,'7 hours'),
(2,'Kathmandu','Chitwan',180,'5 hours'),
(3,'Pokhara','Baglung',85,'2.5 hours'),
(4,'Kathmandu','Bhaktapur',25,'1 hour'),
(5,'Kathmandu','Lumbini',260,'8 hours'),
(6,'Pokhara','Kathmandu',200,'7 hours'),
(7,'Chitwan','Lumbini',120,'4 hours'),
(8,'Kathmandu','Janakpur',280,'10 hours'),
(9,'Pokhara','Butwal',130,'4 hours');
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
  PRIMARY KEY (`id`),
  KEY `bus_id` (`bus_id`),
  KEY `route_id` (`route_id`),
  CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `schedules_ibfk_2` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedules`
--

LOCK TABLES `schedules` WRITE;
/*!40000 ALTER TABLE `schedules` DISABLE KEYS */;
INSERT INTO `schedules` VALUES
(1,1,1,'06:00:00','13:00:00','2026-04-10',50),
(2,1,1,'14:00:00','21:00:00','2026-04-10',50),
(3,2,2,'05:30:00','10:30:00','2026-04-10',45),
(4,3,3,'07:00:00','09:30:00','2026-04-10',48),
(5,4,4,'08:00:00','09:00:00','2026-04-10',40),
(6,2,1,'07:00:00','14:00:00','2026-04-11',45),
(7,4,2,'06:00:00','11:00:00','2026-04-11',40),
(8,5,3,'08:00:00','10:30:00','2026-04-12',48),
(9,6,4,'09:00:00','10:00:00','2026-04-11',50),
(10,7,5,'05:00:00','13:00:00','2026-04-11',40),
(11,8,6,'06:30:00','13:30:00','2026-04-10',47),
(12,9,7,'08:00:00','12:00:00','2026-04-11',44),
(13,10,8,'04:00:00','14:00:00','2026-04-12',42),
(14,11,9,'07:00:00','11:00:00','2026-04-10',40),
(15,3,1,'18:00:00','02:00:00','2026-04-11',50),
(16,5,2,'14:00:00','19:00:00','2026-04-10',48),
(17,6,3,'16:00:00','18:30:00','2026-04-12',50),
(18,7,4,'15:00:00','16:00:00','2026-04-10',45),
(19,12,5,'19:00:00','04:00:00','2026-04-11',38),
(20,8,7,'14:00:00','18:00:00','2026-04-11',48);
/*!40000 ALTER TABLE `schedules` ENABLE KEYS */;
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
  `role` enum('ADMIN','CUSTOMER') DEFAULT 'CUSTOMER',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES 
(1,'Admin User','admin@kalpana.com','JAvlGPq9JyTdtvBO6x2llnRI1+gxwIyPqCKAn3THIKk=','9800000001','ADMIN','2026-04-09 20:00:00'),
(2,'Customer User','customer@kalpana.com','sEHArrNbsPpKpmjKWpILWQGW/a+aAOuFLJt/TRI8xtY=','9800000002','CUSTOMER','2026-04-09 20:05:00');
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

-- Dump completed on 2026-04-09 20:16:54
