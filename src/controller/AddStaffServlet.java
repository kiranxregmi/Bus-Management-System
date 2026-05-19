package controller;

import dao.StaffDAO;
import model.Staff;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/add-staff")
public class AddStaffServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final StaffDAO staffDAO = new StaffDAO();

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
        String role = request.getParameter("role");
        String phone = request.getParameter("phone");

        try {
            Staff staff = new Staff(name, role, phone);
            boolean added = staffDAO.addStaff(staff);
            if (added) {
                response.sendRedirect(request.getContextPath() + "/admin/staff.jsp?success=Staff member added successfully");
            } else {
                request.setAttribute("error", "Unable to add staff member.");
                request.getRequestDispatcher("/admin/staff.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/admin/staff.jsp").forward(request, response);
        }
    }
}
