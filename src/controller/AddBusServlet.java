package controller;

import dao.BusNameDAO;
import model.BusName;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/add-bus")
public class AddBusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BusNameDAO busNameDAO = new BusNameDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User currentUser = (User) session.getAttribute("user");
        if (!currentUser.hasRole("ADMIN")) {
            request.setAttribute("error", "Access denied.");
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
            return;
        }

        String busName = request.getParameter("busName");
        String busType = request.getParameter("busType");
        String capacityValue = request.getParameter("capacity");

        try {
            int capacity = Integer.parseInt(capacityValue);
            BusName bus = new BusName(busName, busType, capacity);
            boolean added = busNameDAO.addBusName(bus);
            if (added) {
                response.sendRedirect(request.getContextPath() + "/admin/buses.jsp?success=Bus added successfully");
            } else {
                request.setAttribute("error", "Unable to add bus.");
                request.getRequestDispatcher("/admin/buses.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Capacity must be a valid number.");
            request.getRequestDispatcher("/admin/buses.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/buses.jsp").forward(request, response);
        }
    }
}
