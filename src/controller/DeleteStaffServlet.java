package controller;

import dao.StaffDAO;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/delete-staff")
public class DeleteStaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StaffDAO staffDAO = new StaffDAO();

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
            boolean deleted = staffDAO.deleteStaff(id);
            if (deleted) {
                response.sendRedirect(request.getContextPath() + "/admin/staff.jsp?success=Staff deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/staff.jsp?error=Unable to delete staff");
            }
        } catch (NumberFormatException | SQLException e) {
            response.sendRedirect(request.getContextPath() + "/admin/staff.jsp?error=Invalid staff id");
        }
    }
}
