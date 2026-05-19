package controller;

import dao.LocationDAO;
import model.Location;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

@WebServlet("/admin/add-location")
public class AddLocationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final LocationDAO locationDAO = new LocationDAO();

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

        String name = request.getParameter("name");
        String district = request.getParameter("district");
        String latitudeVal = request.getParameter("latitude");
        String longitudeVal = request.getParameter("longitude");

        try {
            Location location = new Location(name, district);
            if (latitudeVal != null && !latitudeVal.isBlank()) {
                location.setLatitude(new BigDecimal(latitudeVal.trim()));
            }
            if (longitudeVal != null && !longitudeVal.isBlank()) {
                location.setLongitude(new BigDecimal(longitudeVal.trim()));
            }
            boolean added = locationDAO.addLocation(location);
            if (added) {
                response.sendRedirect(request.getContextPath() + "/admin/locations.jsp?success=Location added successfully");
            } else {
                request.setAttribute("error", "Unable to add location.");
                request.getRequestDispatcher("/admin/locations.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid latitude or longitude format.");
            request.getRequestDispatcher("/admin/locations.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/locations.jsp").forward(request, response);
        }
    }
}
