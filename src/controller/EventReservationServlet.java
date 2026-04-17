package controller;

import dao.EventReservationDAO;
import model.EventReservation;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;

@WebServlet("/eventReservation")
public class EventReservationServlet extends HttpServlet {
    private EventReservationDAO reservationDAO = new EventReservationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=Please login to make a reservation");
            return;
        }

        try {
            EventReservation reservation = new EventReservation();
            reservation.setUserId(user.getId());
            reservation.setEventType(request.getParameter("eventType"));
            reservation.setEventName(request.getParameter("eventName"));
            reservation.setEventDate(Date.valueOf(request.getParameter("eventDate")));
            reservation.setRequiredDate(Date.valueOf(request.getParameter("requiredDate")));
            reservation.setNumberOfPassengers(Integer.parseInt(request.getParameter("numberOfPassengers")));
            reservation.setNumberOfBuses(Integer.parseInt(request.getParameter("numberOfBuses")));
            reservation.setPreferredBusType(request.getParameter("preferredBusType"));
            reservation.setPickupLocation(request.getParameter("pickupLocation"));
            reservation.setDropoffLocation(request.getParameter("dropoffLocation"));
            reservation.setDescription(request.getParameter("description"));
            reservation.setStatus("PENDING");

            boolean success = reservationDAO.insert(reservation);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/eventReservation.jsp?success=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/eventReservation.jsp?error=Failed to submit reservation");
            }
        } catch (IllegalArgumentException | SQLException e) {
            response.sendRedirect(request.getContextPath() + "/eventReservation.jsp?error=" + e.getMessage());
        }
    }
}
