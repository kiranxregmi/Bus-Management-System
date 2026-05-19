package controller;

import dao.SeatLayoutDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/delete-seat-layout")
public class DeleteSeatLayoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final SeatLayoutDAO seatLayoutDAO = new SeatLayoutDAO();

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
            boolean deleted = seatLayoutDAO.deleteSeatLayout(id);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/seat-layouts.jsp?success=Seat layout deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/seat-layouts.jsp?error=Unable to delete seat layout");
            }
        } catch (NumberFormatException | SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/seat-layouts.jsp?error=Invalid layout id");
        }
    }
}
