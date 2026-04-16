package dao;

import model.Booking;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // Create booking
    public int createBooking(Booking booking) throws SQLException {
        String sql = "INSERT INTO bookings (user_id, schedule_id, seat_numbers, total_fare, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setInt(1, booking.getUserId());
            pstmt.setInt(2, booking.getScheduleId());
            pstmt.setString(3, booking.getSeatNumbers());
            pstmt.setDouble(4, booking.getTotalFare());
            pstmt.setString(5, "CONFIRMED");

            pstmt.executeUpdate();

            ResultSet rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
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
        return booking;
    }
}
