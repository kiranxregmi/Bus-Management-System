package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import service.BookingService;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        User user = (User) session.getAttribute("user");

        try {
            if ("mybookings".equals(action)) {
                request.setAttribute("bookings", bookingService.getUserBookings(user.getId()));
                request.getRequestDispatcher("/customer/myBookings.jsp").forward(request, response);
            } else if ("cancel".equals(action)) {
                int bookingId = Integer.parseInt(request.getParameter("id"));
                bookingService.cancelBooking(bookingId);
                response.sendRedirect("booking?action=mybookings&cancelled=true");
            } else {
                response.sendRedirect("customer/dashboard.jsp");
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        String scheduleIdStr = request.getParameter("scheduleId");
        String[] selectedSeats = request.getParameterValues("seats");

        if (scheduleIdStr == null || selectedSeats == null || selectedSeats.length == 0) {
            request.setAttribute("error", "Please select at least one seat");
            request.getRequestDispatcher("/customer/bookSeat.jsp").forward(request, response);
            return;
        }

        try {
            int scheduleId = Integer.parseInt(scheduleIdStr);
            List<String> seatList = Arrays.asList(selectedSeats);

            int bookingId = bookingService.processBooking(user.getId(), scheduleId, seatList);

            if (bookingId > 0) {
                // Get booking details for confirmation page
                String seats = String.join(", ", seatList);
                String busName = request.getParameter("busName");
                String departure = request.getParameter("departure");
                String arrival = request.getParameter("arrival");
                String source = request.getParameter("source");
                String destination = request.getParameter("destination");
                String totalFare = String.valueOf((Double.parseDouble(request.getParameter("fare")) * seatList.size()));

                // Redirect to confirmation page
                response.sendRedirect(request.getContextPath() + "/customer/bookingConfirmation.jsp?bookingId=" + bookingId 
                    + "&scheduleId=" + scheduleId + "&seats=" + seats + "&totalFare=" + totalFare 
                    + "&busName=" + busName + "&departure=" + departure + "&arrival=" + arrival 
                    + "&source=" + source + "&destination=" + destination);
            } else {
                request.setAttribute("error", "Booking failed. Please try again.");
                request.getRequestDispatcher("/customer/bookSeat.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/customer/bookSeat.jsp").forward(request, response);
        }
    }
}
