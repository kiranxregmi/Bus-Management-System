package controller;

import dao.LocationDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/delete-location")
public class DeleteLocationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final LocationDAO locationDAO = new LocationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
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

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean deleted = locationDAO.deleteLocation(id);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/locations.jsp?success=Location deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/locations.jsp?error=Unable to delete location");
            }
        } catch (NumberFormatException | SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/locations.jsp?error=Invalid location id");
        }
    }
}
