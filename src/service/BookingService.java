package service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import dao.BookingDAO;

import dao.BookingDAO;
import model.Booking;

public class BookingService {

    private final BookingDAO bookingDAO = new BookingDAO();

    private final dao.LoyaltyPointDAO loyaltyPointDAO = new dao.LoyaltyPointDAO();

    public int processBooking(int userId, int scheduleId, List<String> selectedSeats) throws SQLException {
        return processBooking(userId, scheduleId, selectedSeats, null, null, null);
    }

    public int processBooking(int userId, int scheduleId, List<String> selectedSeats, String passengerName, String passengerPhone, String passengerEmail) throws SQLException {
        // Validate seats
        if (selectedSeats == null || selectedSeats.isEmpty()) {
            throw new IllegalArgumentException("Please select at least one seat");
        }

        double farePerSeat = 1000.00;
        try {
            model.Schedule schedule = new dao.ScheduleDAO().getScheduleById(scheduleId);
            if (schedule != null && schedule.getFare() > 0) {
                farePerSeat = schedule.getFare();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        double totalFare = farePerSeat * selectedSeats.size();

        // Create booking
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setScheduleId(scheduleId);
        booking.setSeatNumbers(String.join(",", selectedSeats));
        booking.setTotalFare(totalFare);
        booking.setPassengerName(passengerName);
        booking.setPassengerPhone(passengerPhone);
        booking.setPassengerEmail(passengerEmail);

        int bookingId = bookingDAO.createBooking(booking);

        if (bookingId > 0) {
            // Update available seats
            bookingDAO.updateAvailableSeats(scheduleId, selectedSeats.size());
            // Award loyalty points
            try {
                loyaltyPointDAO.addPoints(userId, 5);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        return bookingId;
    }

    public int processCounterBooking(Booking booking, int operatorId) throws SQLException {
        if (booking.getSeatNumbers() == null || booking.getSeatNumbers().isBlank()) {
            throw new IllegalArgumentException("Please select at least one seat.");
        }
        if (booking.getPassengerName() == null || booking.getPassengerName().isBlank()) {
            throw new IllegalArgumentException("Passenger name is required.");
        }
        if (booking.getPassengerPhone() == null || booking.getPassengerPhone().isBlank()) {
            throw new IllegalArgumentException("Passenger phone is required.");
        }
        return bookingDAO.createCounterBooking(booking, operatorId);
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

    public int getTodayBookingCount() throws SQLException {
        return bookingDAO.getTodayBookingCount();
    }

    public double getTodayRevenue() throws SQLException {
        return bookingDAO.getTodayRevenue();
    }

    public List<Map<String, Object>> getLast7DayBookingStats() throws SQLException {
        return bookingDAO.getLast7DayBookingStats();
    }

    public List<Map<String, Object>> getRecentBookingRows(int limit) throws SQLException {
        return bookingDAO.getRecentBookingRows(limit);
    }

    public boolean cancelBooking(int bookingId) throws SQLException {
        return bookingDAO.cancelBooking(bookingId);
    }
}
