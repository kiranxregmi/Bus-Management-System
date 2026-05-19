package controller;

import model.User;
import service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            redirectByRole(request, response, user.getRole());
            return;
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        try {
            User user = userService.authenticateUser(email, password);

            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);

                if ("on".equals(remember) || "true".equals(remember)) {
                    Cookie emailCookie = new Cookie("userEmail", email);
                    emailCookie.setMaxAge(7 * 24 * 60 * 60);
                    response.addCookie(emailCookie);
                }

                redirectByRole(request, response, user.getRole());
            } else {
                request.setAttribute("error", "Invalid email or password");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            request.setAttribute("error", "Database error: " + e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void redirectByRole(HttpServletRequest request, HttpServletResponse response, String role) throws IOException {
        HttpSession session = request.getSession(false);
        String redirectUrl = (session != null) ? (String) session.getAttribute("redirectAfterLogin") : null;

        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            session.removeAttribute("redirectAfterLogin");
            // If the redirectUrl starts with / it's relative to context path
            response.sendRedirect(request.getContextPath() + (redirectUrl.startsWith("/") ? "" : "/") + redirectUrl);
        } else if ("ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/adminDashboard.jsp");
        } else if ("OPERATOR".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/operator/dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/customer/dashboard.jsp");
        }
    }
}
