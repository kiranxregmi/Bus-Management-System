package controller;

import dao.SeatLayoutDAO;
import model.SeatLayout;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/add-seat-layout")
public class AddSeatLayoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final SeatLayoutDAO seatLayoutDAO = new SeatLayoutDAO();

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

        try {
            String name = request.getParameter("name");
            String type = request.getParameter("type");
            int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
            int rows = Integer.parseInt(request.getParameter("rows"));
            int columns = Integer.parseInt(request.getParameter("columns"));

            SeatLayout layout = new SeatLayout(name, type, totalSeats, rows, columns);
            boolean added = seatLayoutDAO.addSeatLayout(layout);
            if (added) {
                response.sendRedirect(request.getContextPath() + "/admin/seat-layouts.jsp?success=Seat layout added successfully");
            } else {
                request.setAttribute("error", "Unable to create seat layout.");
                request.getRequestDispatcher("/admin/seat-layouts.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Rows, columns, and total seats must be valid numbers.");
            request.getRequestDispatcher("/admin/seat-layouts.jsp").forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/seat-layouts.jsp").forward(request, response);
        }
    }
}
