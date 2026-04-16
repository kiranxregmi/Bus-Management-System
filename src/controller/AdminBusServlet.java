package controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Bus;
import model.User;
import service.BookingService;
import service.BusService;

@WebServlet("/admin/bus")
public class AdminBusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BusService busService = new BusService();
    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            switch (action) {
                case "delete" -> {
                    int busId = Integer.parseInt(request.getParameter("id"));
                    busService.deleteBus(busId);
                    response.sendRedirect("manageBuses.jsp?deleted=true");
                }
                case "viewBookings" -> {
                    request.setAttribute("bookings", bookingService.getAllBookings());
                    request.getRequestDispatcher("/admin/viewAllBookings.jsp").forward(request, response);
                }
                default -> response.sendRedirect("adminDashboard.jsp");
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
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                String busNumber = request.getParameter("busNumber");
                String busName = request.getParameter("busName");
                int capacity = Integer.parseInt(request.getParameter("capacity"));
                String busType = request.getParameter("busType");
                double fare = Double.parseDouble(request.getParameter("farePerSeat"));

                Bus bus = new Bus(busNumber, busName, capacity, busType, fare);
                busService.addBus(bus);
                response.sendRedirect("manageBuses.jsp?added=true");
            } else {
                response.sendRedirect("adminDashboard.jsp");
            }
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin/addBus.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
        }
    }
}
