package controller;

import model.Schedule;
import model.User;
import service.BusService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/bus")
public class BusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BusService busService = new BusService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("search".equals(action)) {
            String source = request.getParameter("source");
            String destination = request.getParameter("destination");
            String travelDate = request.getParameter("travelDate");

            try {
                List<Schedule> buses = busService.searchBuses(source, destination, travelDate);
                request.setAttribute("buses", buses);
                request.setAttribute("source", source);
                request.setAttribute("destination", destination);
                request.getRequestDispatcher("/customer/searchResults.jsp").forward(request, response);
            } catch (IllegalArgumentException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            } catch (SQLException e) {
                request.setAttribute("error", "Database error: " + e.getMessage());
                request.getRequestDispatcher("/common/error.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("index.jsp");
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
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Admin bus operations would go here
        // For now, redirect to admin dashboard
        response.sendRedirect("admin/adminDashboard.jsp");
    }
}
