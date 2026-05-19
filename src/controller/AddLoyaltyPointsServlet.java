package controller;

import dao.LoyaltyPointDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

import java.io.IOException;

@WebServlet("/admin/add-loyalty-points")
public class AddLoyaltyPointsServlet extends HttpServlet {
    private final LoyaltyPointDAO loyaltyPointDAO = new LoyaltyPointDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session == null ? null : (User) session.getAttribute("user");
        if (user == null || !user.hasRole("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            if (loyaltyPointDAO.getLoyaltyPointsByUserId(userId) == null) {
                loyaltyPointDAO.initializeLoyaltyPoints(userId);
            }
            loyaltyPointDAO.addPoints(userId, 5);
            response.sendRedirect(request.getContextPath() + "/admin/passengers.jsp?success=5 loyalty points added");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/passengers.jsp?error=Unable to add points");
        }
    }
}
