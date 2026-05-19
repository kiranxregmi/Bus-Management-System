package controller;

import model.User;
import service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/add-operator")
public class AddOperatorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User admin = (User) session.getAttribute("user");
        if (!admin.hasRole("ADMIN")) {
            request.setAttribute("error", "Access denied.");
            request.getRequestDispatcher("/common/error.jsp").forward(request, response);
            return;
        }
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        User operator = new User(fullName, email, password, phone, "OPERATOR");
        try {
            boolean created = userService.registerUser(operator);
            if (created) {
                request.setAttribute("success", "Operator account created successfully.");
            } else {
                request.setAttribute("error", "Failed to create operator account.");
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
        }
        request.getRequestDispatcher("/admin/addOperator.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/admin/addOperator.jsp");
    }
}
