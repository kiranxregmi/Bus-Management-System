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
import java.sql.SQLException;
import java.util.List;

@WebServlet("/admin/rentals")
public class AdminRentalServlet extends HttpServlet {
    private EventReservationDAO reservationDAO = new EventReservationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<EventReservation> rentals = reservationDAO.getAll();
            request.setAttribute("rentals", rentals);
            request.getRequestDispatcher("/admin/manageRentals.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));

        try {
            if ("updateStatus".equals(action)) {
                String status = request.getParameter("status");
                reservationDAO.updateStatus(id, status);
                response.sendRedirect(request.getContextPath() + "/admin/rentals?success=Status updated");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/rentals?error=Invalid action");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
}
