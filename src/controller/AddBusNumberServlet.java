package controller;

import dao.BusNumberDAO;
import model.BusNumber;
import model.User;
import util.ValidationUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/admin/add-bus-number")
public class AddBusNumberServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BusNumberDAO busNumberDAO = new BusNumberDAO();

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
            int busNameId = Integer.parseInt(request.getParameter("busNameId"));
            String registrationNumber = request.getParameter("registrationNumber");
            if (registrationNumber == null || registrationNumber.trim().isEmpty()) {
                throw new IllegalArgumentException("Registration number is required.");
            }
            String regTrimmed = registrationNumber.trim();
            if (!ValidationUtil.isValidBusNumber(regTrimmed)) {
                throw new IllegalArgumentException("Invalid registration number format. Valid formats: 'Ga 1 Kha 4702' or 'Lu Pra 01 001 Kha 0660'.");
            }
            BusNumber busNumber = new BusNumber(busNameId, regTrimmed);
            boolean added = busNumberDAO.addBusNumber(busNumber);
            if (added) {
                response.sendRedirect(request.getContextPath() + "/admin/bus-numbers.jsp?success=Bus number added successfully");
            } else {
                request.setAttribute("error", "Unable to add bus number.");
                request.getRequestDispatcher("/admin/bus-numbers.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid bus name selected.");
            request.getRequestDispatcher("/admin/bus-numbers.jsp").forward(request, response);
        } catch (IllegalArgumentException | SQLException e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/admin/bus-numbers.jsp").forward(request, response);
        }
    }
}
