-- ==============================================================================
-- kalpana_travels.sql — Schema / DDL Only
-- Database: kalpana_travels
-- Server: MariaDB 10.4.32
-- ==============================================================================

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

-- ------------------------------------------------------------------------------
-- Create and select the database
-- ------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS `kalpana_travels`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_general_ci;
USE `kalpana_travels`;

-- ==============================================================================
-- TABLE: users
-- ==============================================================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
                         `id`         int(11)      NOT NULL AUTO_INCREMENT,
                         `full_name`  varchar(100) NOT NULL,
                         `email`      varchar(100) NOT NULL,
                         `password`   varchar(255) NOT NULL,
                         `phone`      varchar(15)  NOT NULL,
                         `role`       enum('ADMIN','OPERATOR','CUSTOMER') DEFAULT 'CUSTOMER',
                         `created_at` timestamp    NOT NULL DEFAULT current_timestamp(),
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: buses
-- ==============================================================================
DROP TABLE IF EXISTS `buses`;
CREATE TABLE `buses` (
                         `id`           int(11)      NOT NULL AUTO_INCREMENT,
                         `bus_number`   varchar(20)  NOT NULL,
                         `bus_name`     varchar(100) NOT NULL,
                         `capacity`     int(11)      NOT NULL,
                         `bus_type`     enum('STANDARD','SEMI_DELUXE','AC_DELUXE','SUPER_DELUXE') NOT NULL,
                         `fare_per_seat` decimal(10,2) NOT NULL,
                         `status`       enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `bus_number` (`bus_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: routes
-- ==============================================================================
DROP TABLE IF EXISTS `routes`;
CREATE TABLE `routes` (
                          `id`                    int(11)      NOT NULL AUTO_INCREMENT,
                          `source`                varchar(50)  NOT NULL,
                          `destination`           varchar(50)  NOT NULL,
                          `distance`              int(11)      DEFAULT NULL,
                          `duration`              varchar(20)  DEFAULT NULL,
                          `departure_location_id` int(11)      DEFAULT NULL,
                          `arrival_location_id`   int(11)      DEFAULT NULL,
                          `duration_hours`        decimal(5,2) DEFAULT NULL,
                          `distance_km`           decimal(8,2) DEFAULT NULL,
                          `remarks`               text         DEFAULT NULL,
                          PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: schedules
-- ==============================================================================
DROP TABLE IF EXISTS `schedules`;
CREATE TABLE `schedules` (
                             `id`              int(11) NOT NULL AUTO_INCREMENT,
                             `bus_id`          int(11) NOT NULL,
                             `route_id`        int(11) NOT NULL,
                             `departure_time`  time    NOT NULL,
                             `arrival_time`    time    NOT NULL,
                             `travel_date`     date    NOT NULL,
                             `available_seats` int(11) NOT NULL,
                             `bus_setup_id`    int(11) DEFAULT NULL,
                             PRIMARY KEY (`id`),
                             KEY `bus_id`   (`bus_id`),
                             KEY `route_id` (`route_id`),
                             CONSTRAINT `schedules_ibfk_1` FOREIGN KEY (`bus_id`)   REFERENCES `buses`  (`id`) ON DELETE CASCADE,
                             CONSTRAINT `schedules_ibfk_2` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: bookings
-- ==============================================================================
DROP TABLE IF EXISTS `bookings`;
CREATE TABLE `bookings` (
                            `id`               int(11)      NOT NULL AUTO_INCREMENT,
                            `user_id`          int(11)      DEFAULT NULL,
                            `schedule_id`      int(11)      DEFAULT NULL,
                            `seat_numbers`     varchar(255) NOT NULL,
                            `total_fare`       decimal(10,2) NOT NULL,
                            `booking_date`     timestamp    NOT NULL DEFAULT current_timestamp(),
                            `status`           enum('CONFIRMED','CANCELLED','PENDING') DEFAULT 'CONFIRMED',
                            `passenger_name`   varchar(100) DEFAULT NULL,
                            `passenger_phone`  varchar(15)  DEFAULT NULL,
                            `passenger_email`  varchar(100) DEFAULT NULL,
                            `bus_setup_id`     int(11)      DEFAULT NULL,
                            `route_id`         int(11)      DEFAULT NULL,
                            PRIMARY KEY (`id`),
                            KEY `user_id`     (`user_id`),
                            KEY `schedule_id` (`schedule_id`),
                            CONSTRAINT `bookings_ibfk_1`    FOREIGN KEY (`user_id`)     REFERENCES `users`     (`id`) ON DELETE CASCADE,
                            CONSTRAINT `bookings_ibfk_2`    FOREIGN KEY (`schedule_id`) REFERENCES `schedules` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: bus_names
-- ==============================================================================
DROP TABLE IF EXISTS `bus_names`;
CREATE TABLE `bus_names` (
                             `id`         int(11)      NOT NULL AUTO_INCREMENT,
                             `name`       varchar(100) NOT NULL,
                             `bus_type`   enum('SLEEPER','DELUXE','SOFA_SEATER') NOT NULL,
                             `capacity`   int(11)      NOT NULL,
                             `created_at` timestamp    DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: bus_numbers
-- ==============================================================================
DROP TABLE IF EXISTS `bus_numbers`;
CREATE TABLE `bus_numbers` (
                               `id`                  int(11)     NOT NULL AUTO_INCREMENT,
                               `bus_name_id`         int(11)     NOT NULL,
                               `registration_number` varchar(50) NOT NULL,
                               `status`              enum('ACTIVE','INACTIVE','MAINTENANCE') DEFAULT 'ACTIVE',
                               `created_at`          timestamp   DEFAULT CURRENT_TIMESTAMP,
                               PRIMARY KEY (`id`),
                               UNIQUE KEY `registration_number` (`registration_number`),
                               CONSTRAINT `bus_numbers_ibfk_1` FOREIGN KEY (`bus_name_id`) REFERENCES `bus_names` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: staff
-- ==============================================================================
DROP TABLE IF EXISTS `staff`;
CREATE TABLE `staff` (
                         `id`             int(11)      NOT NULL AUTO_INCREMENT,
                         `name`           varchar(100) NOT NULL,
                         `role`           enum('DRIVER','CONDUCTOR','HELPER') NOT NULL,
                         `phone`          varchar(15)  NOT NULL,
                         `address`        varchar(255) DEFAULT NULL,
                         `license_number` varchar(50)  DEFAULT NULL,
                         `status`         enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
                         `created_at`     timestamp    DEFAULT CURRENT_TIMESTAMP,
                         PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: locations
-- ==============================================================================
DROP TABLE IF EXISTS `locations`;
CREATE TABLE `locations` (
                             `id`         int(11)        NOT NULL AUTO_INCREMENT,
                             `name`       varchar(100)   NOT NULL,
                             `district`   varchar(50)    DEFAULT NULL,
                             `latitude`   decimal(10,8)  DEFAULT NULL,
                             `longitude`  decimal(11,8)  DEFAULT NULL,
                             `created_at` timestamp      DEFAULT CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Now that locations exists, add the FK constraints to routes
ALTER TABLE `routes`
    ADD CONSTRAINT `routes_ibfk_departure` FOREIGN KEY (`departure_location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `routes_ibfk_arrival`   FOREIGN KEY (`arrival_location_id`)   REFERENCES `locations` (`id`) ON DELETE SET NULL;

-- ==============================================================================
-- TABLE: pickup_points
-- ==============================================================================
DROP TABLE IF EXISTS `pickup_points`;
CREATE TABLE `pickup_points` (
                                 `id`               int(11)       NOT NULL AUTO_INCREMENT,
                                 `route_id`         int(11)       NOT NULL,
                                 `location_id`      int(11)       NOT NULL,
                                 `pickup_route`     varchar(150)  DEFAULT NULL,
                                 `pickup_time`      time          NOT NULL,
                                 `price`            decimal(10,2) DEFAULT 0.00,
                                 `price_multiplier` decimal(5,2)  DEFAULT 1.00,
                                 `sequence_order`   int(11)       DEFAULT NULL,
                                 `created_at`       timestamp     DEFAULT CURRENT_TIMESTAMP,
                                 PRIMARY KEY (`id`),
                                 CONSTRAINT `pickup_points_ibfk_1` FOREIGN KEY (`route_id`)    REFERENCES `routes`    (`id`) ON DELETE CASCADE,
                                 CONSTRAINT `pickup_points_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: drop_points
-- ==============================================================================
DROP TABLE IF EXISTS `drop_points`;
CREATE TABLE `drop_points` (
                               `id`               int(11)       NOT NULL AUTO_INCREMENT,
                               `route_id`         int(11)       NOT NULL,
                               `location_id`      int(11)       NOT NULL,
                               `drop_route`       varchar(150)  DEFAULT NULL,
                               `drop_time`        time          NOT NULL,
                               `price`            decimal(10,2) DEFAULT 0.00,
                               `price_multiplier` decimal(5,2)  DEFAULT 1.00,
                               `sequence_order`   int(11)       DEFAULT NULL,
                               `created_at`       timestamp     DEFAULT CURRENT_TIMESTAMP,
                               PRIMARY KEY (`id`),
                               CONSTRAINT `drop_points_ibfk_1` FOREIGN KEY (`route_id`)    REFERENCES `routes`    (`id`) ON DELETE CASCADE,
                               CONSTRAINT `drop_points_ibfk_2` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: seat_layouts
-- ==============================================================================
DROP TABLE IF EXISTS `seat_layouts`;
CREATE TABLE `seat_layouts` (
                                `id`          int(11)      NOT NULL AUTO_INCREMENT,
                                `name`        varchar(100) NOT NULL,
                                `type`        enum('2X2_SOFA','2X2_SOFA_WITH_SLEEPER','2X1_SOFA') NOT NULL,
                                `total_seats` int(11)      NOT NULL,
                                `rows`        int(11)      NOT NULL,
                                `columns`     int(11)      NOT NULL,
                                `layout_json` json         DEFAULT NULL,
                                `created_at`  timestamp    DEFAULT CURRENT_TIMESTAMP,
                                PRIMARY KEY (`id`),
                                UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: bus_setup
-- ==============================================================================
DROP TABLE IF EXISTS `bus_setup`;
CREATE TABLE `bus_setup` (
                             `id`             int(11)       NOT NULL AUTO_INCREMENT,
                             `bus_number_id`  int(11)       NOT NULL,
                             `seat_layout_id` int(11)       NOT NULL,
                             `trip_price`     decimal(10,2) DEFAULT NULL,
                             `trip_time`      time          DEFAULT NULL,
                             `created_at`     timestamp     DEFAULT CURRENT_TIMESTAMP,
                             `updated_at`     timestamp     DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`),
                             UNIQUE KEY `unique_bus_number` (`bus_number_id`),
                             CONSTRAINT `bus_setup_ibfk_1` FOREIGN KEY (`bus_number_id`)  REFERENCES `bus_numbers`  (`id`) ON DELETE CASCADE,
                             CONSTRAINT `bus_setup_ibfk_2` FOREIGN KEY (`seat_layout_id`) REFERENCES `seat_layouts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Add bus_setup FK to schedules now that bus_setup exists
ALTER TABLE `schedules`
    ADD CONSTRAINT `schedules_ibfk_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL;

-- Add bus_setup and route FKs to bookings now that bus_setup exists
ALTER TABLE `bookings`
    ADD CONSTRAINT `bookings_ibfk_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `bookings_ibfk_route`     FOREIGN KEY (`route_id`)     REFERENCES `routes`    (`id`) ON DELETE SET NULL;

-- ==============================================================================
-- TABLE: bus_setup_staff
-- ==============================================================================
DROP TABLE IF EXISTS `bus_setup_staff`;
CREATE TABLE `bus_setup_staff` (
                                   `id`           int(11)   NOT NULL AUTO_INCREMENT,
                                   `bus_setup_id` int(11)   NOT NULL,
                                   `staff_id`     int(11)   NOT NULL,
                                   `created_at`   timestamp DEFAULT CURRENT_TIMESTAMP,
                                   PRIMARY KEY (`id`),
                                   UNIQUE KEY `unique_setup_staff` (`bus_setup_id`, `staff_id`),
                                   CONSTRAINT `bus_setup_staff_ibfk_1` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE,
                                   CONSTRAINT `bus_setup_staff_ibfk_2` FOREIGN KEY (`staff_id`)     REFERENCES `staff`     (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: seats
-- ==============================================================================
DROP TABLE IF EXISTS `seats`;
CREATE TABLE `seats` (
                         `id`           int(11)     NOT NULL AUTO_INCREMENT,
                         `bus_setup_id` int(11)     NOT NULL,
                         `seat_number`  varchar(10) NOT NULL,
                         `status`       enum('AVAILABLE','BOOKED','LOCKED') DEFAULT 'AVAILABLE',
                         `created_at`   timestamp   DEFAULT CURRENT_TIMESTAMP,
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `unique_seat` (`bus_setup_id`, `seat_number`),
                         CONSTRAINT `seats_ibfk_1` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: loyalty_points
-- ==============================================================================
DROP TABLE IF EXISTS `loyalty_points`;
CREATE TABLE `loyalty_points` (
                                  `id`                  int(11)   NOT NULL AUTO_INCREMENT,
                                  `user_id`             int(11)   NOT NULL,
                                  `points_balance`      int(11)   DEFAULT 0,
                                  `total_points_earned` int(11)   DEFAULT 0,
                                  `last_updated`        timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                  PRIMARY KEY (`id`),
                                  UNIQUE KEY `unique_user_loyalty` (`user_id`),
                                  CONSTRAINT `loyalty_points_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: chalani
-- ==============================================================================
DROP TABLE IF EXISTS `chalani`;
CREATE TABLE `chalani` (
                           `id`                 int(11)       NOT NULL AUTO_INCREMENT,
                           `bus_setup_id`       int(11)       NOT NULL,
                           `operator_id`        int(11)       DEFAULT NULL,
                           `booking_date`       date          NOT NULL,
                           `total_seats_booked` int(11)       DEFAULT NULL,
                           `total_revenue`      decimal(12,2) DEFAULT NULL,
                           `created_at`         timestamp     DEFAULT CURRENT_TIMESTAMP,
                           PRIMARY KEY (`id`),
                           UNIQUE KEY `unique_chalani_setup_operator_date` (`bus_setup_id`, `operator_id`, `booking_date`),
                           CONSTRAINT `chalani_ibfk_1` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE,
                           CONSTRAINT `chalani_ibfk_2` FOREIGN KEY (`operator_id`)  REFERENCES `users`     (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ==============================================================================
-- TABLE: event_reservations
-- ==============================================================================
DROP TABLE IF EXISTS `event_reservations`;
CREATE TABLE `event_reservations` (
                                      `id`                   int(11)      NOT NULL AUTO_INCREMENT,
                                      `user_id`              int(11)      NOT NULL,
                                      `event_type`           varchar(50)  NOT NULL,
                                      `event_name`           varchar(255) NOT NULL,
                                      `event_date`           date         NOT NULL,
                                      `required_date`        date         NOT NULL,
                                      `number_of_passengers` int(11)      NOT NULL,
                                      `number_of_buses`      int(11)      NOT NULL,
                                      `preferred_bus_type`   varchar(50)  DEFAULT NULL,
                                      `pickup_location`      varchar(255) NOT NULL,
                                      `dropoff_location`     varchar(255) NOT NULL,
                                      `description`          text         DEFAULT NULL,
                                      `status`               varchar(50)  DEFAULT 'PENDING',
                                      `created_at`           timestamp    DEFAULT CURRENT_TIMESTAMP,
                                      PRIMARY KEY (`id`),
                                      CONSTRAINT `event_reservations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ------------------------------------------------------------------------------

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;