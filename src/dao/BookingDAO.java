package dao;

import model.Booking;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BookingDAO {

    // Create booking
    public int createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO bookings (user_id, schedule_id, seat_numbers, total_fare, status, passenger_name, passenger_phone, passenger_email) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, booking.getUserId());
            pstmt.setInt(2, booking.getScheduleId());
            pstmt.setString(3, booking.getSeatNumbers());
            pstmt.setDouble(4, booking.getTotalFare());
            pstmt.setString(5, "CONFIRMED");
            pstmt.setString(6, booking.getPassengerName());
            pstmt.setString(7, booking.getPassengerPhone());
            pstmt.setString(8, booking.getPassengerEmail());

            pstmt.executeUpdate();

            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public int createCounterBooking(Booking booking, int operatorId) throws SQLException {
        String sql = "INSERT INTO bookings (user_id, schedule_id, seat_numbers, total_fare, status, " +
                "passenger_name, passenger_phone, passenger_email, bus_setup_id, route_id) " +
                "VALUES (?, NULL, ?, ?, 'CONFIRMED', ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                if (booking.getUserId() > 0) {
                    pstmt.setInt(1, booking.getUserId());
                } else {
                    pstmt.setNull(1, Types.INTEGER);
                }
                pstmt.setString(2, booking.getSeatNumbers());
                pstmt.setDouble(3, booking.getTotalFare());
                pstmt.setString(4, booking.getPassengerName());
                pstmt.setString(5, booking.getPassengerPhone());
                pstmt.setString(6, booking.getPassengerEmail());
                pstmt.setInt(7, booking.getBusSetupId());
                if (booking.getRouteId() > 0) {
                    pstmt.setInt(8, booking.getRouteId());
                } else {
                    pstmt.setNull(8, Types.INTEGER);
                }
                pstmt.executeUpdate();

                int bookingId;
                try (ResultSet keys = pstmt.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("Booking was not created.");
                    }
                    bookingId = keys.getInt(1);
                }

                List<String> seatNumbers = List.of(booking.getSeatNumbers().split(","));
                markSeats(conn, booking.getBusSetupId(), seatNumbers, "BOOKED");
                addLoyaltyForEmail(conn, booking.getPassengerEmail(), 5);
                upsertChalani(conn, booking.getBusSetupId(), operatorId, seatNumbers.size(), booking.getTotalFare());
                conn.commit();
                return bookingId;
            } catch (SQLException | RuntimeException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    // Update available seats after booking
    public boolean updateAvailableSeats(int scheduleId, int seatsBooked) throws SQLException {
        String sql = "UPDATE schedules SET available_seats = available_seats - ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, seatsBooked);
            pstmt.setInt(2, scheduleId);
            return pstmt.executeUpdate() > 0;
        }
    }

    // Get bookings by user
    public List<Booking> getBookingsByUser(int userId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, s.departure_time, s.arrival_time, s.travel_date, " +
                "bus.bus_name, bus.bus_number, r.source, r.destination " +
                "FROM bookings b " +
                "JOIN schedules s ON b.schedule_id = s.id " +
                "JOIN buses bus ON s.bus_id = bus.id " +
                "JOIN routes r ON s.route_id = r.id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.booking_date DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        }
        return bookings;
    }

    // Get all bookings (for admin)
    public List<Booking> getAllBookings() throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.*, u.full_name, u.email, " +
                "bus.bus_name, bus.bus_number, r.source, r.destination, s.travel_date " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN schedules s ON b.schedule_id = s.id " +
                "JOIN buses bus ON s.bus_id = bus.id " +
                "JOIN routes r ON s.route_id = r.id " +
                "ORDER BY b.booking_date DESC";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }
        }
        return bookings;
    }

    // Get booking count (for admin dashboard)
    public int getBookingCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status='CONFIRMED'";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    public int getTodayBookingCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE status='CONFIRMED' AND DATE(booking_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public double getTodayRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(total_fare), 0) FROM bookings WHERE status='CONFIRMED' AND DATE(booking_date) = CURDATE()";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getDouble(1) : 0;
        }
    }

    public List<Map<String, Object>> getLast7DayBookingStats() throws SQLException {
        List<Map<String, Object>> stats = new ArrayList<>();
        String sql = "SELECT DATE(booking_date) booking_day, COUNT(*) booking_count, COALESCE(SUM(total_fare), 0) revenue " +
                "FROM bookings WHERE booking_date >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) " +
                "GROUP BY DATE(booking_date) ORDER BY booking_day";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("date", rs.getDate("booking_day"));
                row.put("count", rs.getInt("booking_count"));
                row.put("revenue", rs.getDouble("revenue"));
                stats.add(row);
            }
        }
        return stats;
    }

    public List<Map<String, Object>> getRecentBookingRows(int limit) throws SQLException {
        List<Map<String, Object>> bookings = new ArrayList<>();
        String sql = "SELECT b.*, COALESCE(b.passenger_name, u.full_name) passenger_display_name, " +
                "COALESCE(b.passenger_email, u.email) passenger_display_email, " +
                "COALESCE(bn.registration_number, bus.bus_number) bus_number_display, " +
                "COALESCE(bm.name, bus.bus_name) bus_name_display, " +
                "COALESCE(rd.name, r.source) route_from, COALESCE(ra.name, r.destination) route_to " +
                "FROM bookings b " +
                "LEFT JOIN users u ON b.user_id = u.id " +
                "LEFT JOIN schedules s ON b.schedule_id = s.id " +
                "LEFT JOIN buses bus ON s.bus_id = bus.id " +
                "LEFT JOIN bus_setup bs ON b.bus_setup_id = bs.id " +
                "LEFT JOIN bus_numbers bn ON bs.bus_number_id = bn.id " +
                "LEFT JOIN bus_names bm ON bn.bus_name_id = bm.id " +
                "LEFT JOIN routes r ON COALESCE(b.route_id, s.route_id) = r.id " +
                "LEFT JOIN locations rd ON r.departure_location_id = rd.id " +
                "LEFT JOIN locations ra ON r.arrival_location_id = ra.id " +
                "ORDER BY b.booking_date DESC LIMIT ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("passengerName", rs.getString("passenger_display_name"));
                    row.put("busName", rs.getString("bus_name_display"));
                    row.put("busNumber", rs.getString("bus_number_display"));
                    row.put("routeFrom", rs.getString("route_from"));
                    row.put("routeTo", rs.getString("route_to"));
                    row.put("bookingDate", rs.getTimestamp("booking_date"));
                    row.put("price", rs.getDouble("total_fare"));
                    row.put("status", rs.getString("status"));
                    bookings.add(row);
                }
            }
        }
        return bookings;
    }

    // Get total passengers booked for a schedule
    public int getPassengerCountBySchedule(int scheduleId) throws SQLException {
        String sql = "SELECT seat_numbers FROM bookings WHERE schedule_id = ? AND status = 'CONFIRMED'";
        int total = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, scheduleId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                String seats = rs.getString("seat_numbers");
                if (seats != null && !seats.isEmpty()) {
                    total += seats.split(",").length;
                }
            }
        }
        return total;
    }

    public int getBookingCountByUser(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM bookings WHERE user_id = ? AND status = 'CONFIRMED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    // Cancel booking
    public boolean cancelBooking(int bookingId) throws SQLException {
        String sql = "UPDATE bookings SET status='CANCELLED' WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, bookingId);
            return pstmt.executeUpdate() > 0;
        }
    }

    // Helper method
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setScheduleId(rs.getInt("schedule_id"));
        booking.setSeatNumbers(rs.getString("seat_numbers"));
        booking.setTotalFare(rs.getDouble("total_fare"));
        booking.setBookingDate(rs.getTimestamp("booking_date"));
        booking.setStatus(rs.getString("status"));
        if (hasColumn(rs, "passenger_name")) {
            booking.setPassengerName(rs.getString("passenger_name"));
            booking.setPassengerPhone(rs.getString("passenger_phone"));
            booking.setPassengerEmail(rs.getString("passenger_email"));
            booking.setBusSetupId(rs.getInt("bus_setup_id"));
            booking.setRouteId(rs.getInt("route_id"));
        }
        return booking;
    }

    private void markSeats(Connection conn, int busSetupId, List<String> seatNumbers, String status) throws SQLException {
        String sql = "UPDATE seats SET status = ? WHERE bus_setup_id = ? AND seat_number = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (String seatNumber : seatNumbers) {
                pstmt.setString(1, status);
                pstmt.setInt(2, busSetupId);
                pstmt.setString(3, seatNumber.trim());
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }

    private void addLoyaltyForEmail(Connection conn, String email, int points) throws SQLException {
        if (email == null || email.isBlank()) {
            return;
        }
        Integer userId = null;
        try (PreparedStatement userStmt = conn.prepareStatement("SELECT id FROM users WHERE email = ? AND role = 'CUSTOMER'")) {
            userStmt.setString(1, email.trim());
            try (ResultSet rs = userStmt.executeQuery()) {
                if (rs.next()) {
                    userId = rs.getInt("id");
                }
            }
        }
        if (userId == null) {
            return;
        }
        String sql = "INSERT INTO loyalty_points (user_id, points_balance, total_points_earned) VALUES (?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE points_balance = points_balance + VALUES(points_balance), " +
                "total_points_earned = total_points_earned + VALUES(total_points_earned)";
        try (PreparedStatement loyalty = conn.prepareStatement(sql)) {
            loyalty.setInt(1, userId);
            loyalty.setInt(2, points);
            loyalty.setInt(3, points);
            loyalty.executeUpdate();
        }
    }

    private void upsertChalani(Connection conn, int busSetupId, int operatorId, int seatsBooked, double revenue) throws SQLException {
        String sql = "INSERT INTO chalani (bus_setup_id, operator_id, booking_date, total_seats_booked, total_revenue) " +
                "VALUES (?, ?, CURDATE(), ?, ?) " +
                "ON DUPLICATE KEY UPDATE total_seats_booked = total_seats_booked + VALUES(total_seats_booked), " +
                "total_revenue = total_revenue + VALUES(total_revenue)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busSetupId);
            if (operatorId > 0) {
                pstmt.setInt(2, operatorId);
            } else {
                pstmt.setNull(2, Types.INTEGER);
            }
            pstmt.setInt(3, seatsBooked);
            pstmt.setDouble(4, revenue);
            pstmt.executeUpdate();
        }
    }

    public java.util.List<String> getBookedSeatsBySchedule(int scheduleId) throws SQLException {
        java.util.List<String> bookedSeats = new java.util.ArrayList<>();
        String sql = "SELECT seat_numbers FROM bookings WHERE schedule_id = ? AND status = 'CONFIRMED'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, scheduleId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String seats = rs.getString("seat_numbers");
                    if (seats != null && !seats.isEmpty()) {
                        for (String seat : seats.split(",")) {
                            bookedSeats.add(seat.trim());
                        }
                    }
                }
            }
        }
        return bookedSeats;
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnLabel(i))) {
                return true;
            }
        }
        return false;
    }
}
