package service;

import java.sql.SQLException;
import java.util.List;

import dao.BookingDAO;
import model.Booking;

public class BookingService {

    private final BookingDAO bookingDAO = new BookingDAO();

    public int processBooking(int userId, int scheduleId, List<String> selectedSeats) throws SQLException {
        // Validate seats
        if (selectedSeats == null || selectedSeats.isEmpty()) {
            throw new IllegalArgumentException("Please select at least one seat");
        }

        // Get schedule to calculate fare
        // For simplicity, we'll calculate fare based on bus fare

        // In a real implementation, you'd fetch the bus fare:
        // Bus bus = busDAO.getBusByScheduleId(scheduleId);
        // double farePerSeat = bus.getFarePerSeat();

        // For now, using a placeholder fare calculation
        double farePerSeat = 1000.00; // This should come from database
        double totalFare = farePerSeat * selectedSeats.size();

        // Create booking
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setScheduleId(scheduleId);
        booking.setSeatNumbers(String.join(",", selectedSeats));
        booking.setTotalFare(totalFare);

        int bookingId = bookingDAO.createBooking(booking);

        if (bookingId > 0) {
            // Update available seats
            bookingDAO.updateAvailableSeats(scheduleId, selectedSeats.size());
        }

        return bookingId;
    }

    public List<Booking> getUserBookings(int userId) throws SQLException {
        return bookingDAO.getBookingsByUser(userId);
    }

    public List<Booking> getAllBookings() throws SQLException {
        return bookingDAO.getAllBookings();
    }

    public int getBookingCount() throws SQLException {
        return bookingDAO.getBookingCount();
    }

    public boolean cancelBooking(int bookingId) throws SQLException {
        return bookingDAO.cancelBooking(bookingId);
    }
}
