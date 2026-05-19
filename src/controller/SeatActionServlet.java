package controller;

import dao.SeatDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;
import service.BookingService;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.List;

@WebServlet("/operator/seat-action")
public class SeatActionServlet extends HttpServlet {
    private final SeatDAO seatDAO = new SeatDAO();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null || !user.hasRole("ADMIN", "OPERATOR")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        int setupId = Integer.parseInt(request.getParameter("setupId"));
        String action = request.getParameter("action");
        try {
            if ("toggleLock".equals(action)) {
                String seatNumber = request.getParameter("seatNumber");
                String currentStatus = request.getParameter("currentStatus");
                String newStatus = "LOCKED".equals(currentStatus) ? "AVAILABLE" : "LOCKED";
                seatDAO.updateSeatStatus(setupId, seatNumber, newStatus);
                redirect(response, request, setupId, "Seat updated.");
                return;
            }

            String[] selected = request.getParameterValues("selectedSeats");
            List<String> seats = selected == null ? List.of() : Arrays.asList(selected);
            if (!seatDAO.areSeatsAvailable(setupId, seats)) {
                throw new IllegalArgumentException("One or more selected seats are no longer available.");
            }

            Booking booking = new Booking();
            booking.setBusSetupId(setupId);
            booking.setPassengerName(request.getParameter("passengerName"));
            booking.setPassengerPhone(request.getParameter("passengerPhone"));
            booking.setPassengerEmail(request.getParameter("passengerEmail"));
            booking.setSeatNumbers(String.join(",", seats));
            booking.setTotalFare(Double.parseDouble(request.getParameter("totalFare")));
            String routeId = request.getParameter("routeId");
            if (routeId != null && !routeId.isBlank()) {
                booking.setRouteId(Integer.parseInt(routeId));
            }
            bookingService.processCounterBooking(booking, user.getId());
            redirect(response, request, setupId, "Booking saved.");
        } catch (Exception e) {
            redirectError(response, request, setupId, e.getMessage());
        }
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("user");
    }

    private void redirect(HttpServletResponse response, HttpServletRequest request, int setupId, String message) throws IOException {
        response.sendRedirect(request.getContextPath() + "/operator/chalani.jsp?setupId=" + setupId + "&success=" + encode(message));
    }

    private void redirectError(HttpServletResponse response, HttpServletRequest request, int setupId, String message) throws IOException {
        response.sendRedirect(request.getContextPath() + "/operator/chalani.jsp?setupId=" + setupId + "&error=" + encode(message));
    }

    private String encode(String value) {
        return URLEncoder.encode(value == null ? "Unable to process request." : value, StandardCharsets.UTF_8);
    }
}
