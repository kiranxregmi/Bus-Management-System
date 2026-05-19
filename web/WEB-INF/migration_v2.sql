-- Database Migration Script for Bus Management System v2
-- This script adds OPERATOR role support and new tables for enhanced functionality

-- =====================================================================
-- STEP 1: Update existing users table to support OPERATOR role
-- =====================================================================
ALTER TABLE `users` 
MODIFY COLUMN `role` enum('ADMIN','OPERATOR','CUSTOMER') DEFAULT 'CUSTOMER';

-- =====================================================================
-- STEP 2: Create bus_names table (different bus companies/types)
-- =====================================================================
CREATE TABLE IF NOT EXISTS `bus_names` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL UNIQUE,
  `bus_type` enum('SLEEPER','DELUXE','SOFA_SEATER') NOT NULL,
  `capacity` int(11) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert default bus names
INSERT IGNORE INTO `bus_names` (`name`, `bus_type`, `capacity`) VALUES
('Kalpana Airbus', 'DELUXE', 50),
('Syangja Gandaki', 'SLEEPER', 45),
('Syangja Aadhiganga', 'SOFA_SEATER', 48);

-- =====================================================================
-- STEP 3: Create bus_numbers table (individual bus numbers)
-- =====================================================================
CREATE TABLE IF NOT EXISTS `bus_numbers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bus_name_id` int(11) NOT NULL,
  `registration_number` varchar(50) NOT NULL UNIQUE,
  `status` enum('ACTIVE','INACTIVE','MAINTENANCE') DEFAULT 'ACTIVE',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`bus_name_id`) REFERENCES `bus_names` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================================
-- STEP 4: Create staff table (Drivers, Conductors, Helpers)
-- =====================================================================
CREATE TABLE IF NOT EXISTS `staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `role` enum('DRIVER','CONDUCTOR','HELPER') NOT NULL,
  `phone` varchar(15) NOT NULL,
  `address` varchar(255),
  `license_number` varchar(50),
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================================
-- STEP 5: Create locations table (Bus stops)
-- =====================================================================
CREATE TABLE IF NOT EXISTS `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL UNIQUE,
  `district` varchar(50),
  `latitude` decimal(10, 8),
  `longitude` decimal(11, 8),
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert default locations
INSERT IGNORE INTO `locations` (`name`, `district`) VALUES
('Ramdi', 'Syangja'),
('Malunga', 'Syangja'),
('Karadi', 'Syangja'),
('Waling', 'Syangja'),
('Mirdi', 'Baglung'),
('Tiryasi', 'Syangja'),
('Bayarghari', 'Syangja'),
('Syangja', 'Syangja'),
('Pokhara', 'Kaski'),
('Kathmandu', 'Kathmandu');

-- =====================================================================
-- STEP 6: Update routes table with new columns
-- =====================================================================
ALTER TABLE `routes` 
ADD COLUMN IF NOT EXISTS `departure_location_id` int(11),
ADD COLUMN IF NOT EXISTS `arrival_location_id` int(11),
ADD COLUMN IF NOT EXISTS `duration_hours` decimal(5, 2),
ADD COLUMN IF NOT EXISTS `distance_km` decimal(8, 2),
ADD COLUMN IF NOT EXISTS `remarks` text,
ADD CONSTRAINT `routes_ibfk_departure` FOREIGN KEY (`departure_location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL,
ADD CONSTRAINT `routes_ibfk_arrival` FOREIGN KEY (`arrival_location_id`) REFERENCES `locations` (`id`) ON DELETE SET NULL;

-- =====================================================================
-- STEP 7: Create pickup_points table
-- =====================================================================
CREATE TABLE IF NOT EXISTS `pickup_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `pickup_route` varchar(150),
  `pickup_time` time NOT NULL,
  `price` decimal(10, 2) DEFAULT 0.00,
  `price_multiplier` decimal(5, 2) DEFAULT 1.0,
  `sequence_order` int(11),
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `pickup_points`
ADD COLUMN IF NOT EXISTS `pickup_route` varchar(150),
ADD COLUMN IF NOT EXISTS `price` decimal(10, 2) DEFAULT 0.00;

-- =====================================================================
-- STEP 8: Create drop_points table
-- =====================================================================
CREATE TABLE IF NOT EXISTS `drop_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `route_id` int(11) NOT NULL,
  `location_id` int(11) NOT NULL,
  `drop_route` varchar(150),
  `drop_time` time NOT NULL,
  `price` decimal(10, 2) DEFAULT 0.00,
  `price_multiplier` decimal(5, 2) DEFAULT 1.0,
  `sequence_order` int(11),
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

ALTER TABLE `drop_points`
ADD COLUMN IF NOT EXISTS `drop_route` varchar(150),
ADD COLUMN IF NOT EXISTS `price` decimal(10, 2) DEFAULT 0.00;

-- =====================================================================
-- STEP 9: Create seat_layouts table (2x2 Sofa, 2x1 Sleeper, etc.)
-- =====================================================================
CREATE TABLE IF NOT EXISTS `seat_layouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL UNIQUE,
  `type` enum('2X2_SOFA','2X2_SOFA_WITH_SLEEPER','2X1_SOFA') NOT NULL,
  `total_seats` int(11) NOT NULL,
  `rows` int(11) NOT NULL,
  `columns` int(11) NOT NULL,
  `layout_json` json,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Insert default seat layouts
INSERT IGNORE INTO `seat_layouts` (`name`, `type`, `total_seats`, `rows`, `columns`) VALUES
('2x2 Sofa Seater', '2X2_SOFA', 48, 12, 4),
('2x2 Sofa With Sleeper', '2X2_SOFA_WITH_SLEEPER', 50, 13, 4),
('2x1 Sofa Seat', '2X1_SOFA', 32, 16, 2);

-- =====================================================================
-- STEP 10: Create bus_setup table (Bus Number + Seat Layout + Staff + Price + Time)
-- =====================================================================
CREATE TABLE IF NOT EXISTS `bus_setup` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bus_number_id` int(11) NOT NULL,
  `seat_layout_id` int(11) NOT NULL,
  `trip_price` decimal(10, 2),
  `trip_time` time,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`bus_number_id`) REFERENCES `bus_numbers` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`seat_layout_id`) REFERENCES `seat_layouts` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_bus_number` (`bus_number_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================================
-- STEP 11: Create bus_setup_staff junction table (Many-to-Many)
-- =====================================================================
CREATE TABLE IF NOT EXISTS `bus_setup_staff` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bus_setup_id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`staff_id`) REFERENCES `staff` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_setup_staff` (`bus_setup_id`, `staff_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================================
-- STEP 12: Create seats table (Individual seats tracking)
-- =====================================================================
CREATE TABLE IF NOT EXISTS `seats` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bus_setup_id` int(11) NOT NULL,
  `seat_number` varchar(10) NOT NULL,
  `status` enum('AVAILABLE','BOOKED','LOCKED') DEFAULT 'AVAILABLE',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_seat` (`bus_setup_id`, `seat_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================================
-- STEP 13: Create loyalty_points table
-- =====================================================================
CREATE TABLE IF NOT EXISTS `loyalty_points` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `points_balance` int(11) DEFAULT 0,
  `total_points_earned` int(11) DEFAULT 0,
  `last_updated` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  UNIQUE KEY `unique_user_loyalty` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================================
-- STEP 14: Update bookings table to include more details
-- =====================================================================
ALTER TABLE `bookings` 
MODIFY COLUMN `user_id` int(11) NULL,
MODIFY COLUMN `schedule_id` int(11) NULL,
ADD COLUMN IF NOT EXISTS `passenger_name` varchar(100),
ADD COLUMN IF NOT EXISTS `passenger_phone` varchar(15),
ADD COLUMN IF NOT EXISTS `passenger_email` varchar(100),
ADD COLUMN IF NOT EXISTS `bus_setup_id` int(11),
ADD COLUMN IF NOT EXISTS `route_id` int(11),
ADD CONSTRAINT `bookings_ibfk_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL,
ADD CONSTRAINT `bookings_ibfk_route` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`) ON DELETE SET NULL;

-- =====================================================================
-- STEP 15: Update schedules table to include bus_setup_id
-- =====================================================================
ALTER TABLE `schedules` 
ADD COLUMN IF NOT EXISTS `bus_setup_id` int(11),
ADD CONSTRAINT `schedules_ibfk_bus_setup` FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE SET NULL;

-- =====================================================================
-- STEP 16: Create chalani (booking history) table
-- =====================================================================
CREATE TABLE IF NOT EXISTS `chalani` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bus_setup_id` int(11) NOT NULL,
  `operator_id` int(11),
  `booking_date` date NOT NULL,
  `total_seats_booked` int(11),
  `total_revenue` decimal(12, 2),
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_chalani_setup_operator_date` (`bus_setup_id`, `operator_id`, `booking_date`),
  FOREIGN KEY (`bus_setup_id`) REFERENCES `bus_setup` (`id`) ON DELETE CASCADE,
  FOREIGN KEY (`operator_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- =====================================================================
-- STEP 17: Create event_reservations table for Rental/Event section
-- =====================================================================
CREATE TABLE IF NOT EXISTS `event_reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `event_type` varchar(50) NOT NULL,
  `event_name` varchar(255) NOT NULL,
  `event_date` date NOT NULL,
  `required_date` date NOT NULL,
  `number_of_passengers` int(11) NOT NULL,
  `number_of_buses` int(11) NOT NULL,
  `preferred_bus_type` varchar(50),
  `pickup_location` varchar(255) NOT NULL,
  `dropoff_location` varchar(255) NOT NULL,
  `description` text,
  `status` varchar(50) DEFAULT 'PENDING',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
