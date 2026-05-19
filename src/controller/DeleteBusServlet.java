package controller;

import dao.BusNameDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/delete-bus")
public class DeleteBusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BusNameDAO busNameDAO = new BusNameDAO();

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

        String idValue = request.getParameter("id");
        try {
            int id = Integer.parseInt(idValue);
            boolean deleted = busNameDAO.deleteBusName(id);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/buses.jsp?success=Bus deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/buses.jsp?error=Unable to delete bus");
            }
        } catch (NumberFormatException | SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/buses.jsp?error=Invalid bus id");
        }
    }
}
