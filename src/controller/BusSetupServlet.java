package controller;

import dao.BusSetupDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.BusSetup;
import model.User;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@WebServlet({"/admin/save-bus-setup", "/operator/save-bus-setup"})
public class BusSetupServlet extends HttpServlet {
    private final BusSetupDAO busSetupDAO = new BusSetupDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = currentUser(request);
        if (user == null || !user.hasRole("ADMIN", "OPERATOR")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            BusSetup setup = new BusSetup();
            setup.setBusNumberId(Integer.parseInt(request.getParameter("busNumberId")));
            setup.setSeatLayoutId(Integer.parseInt(request.getParameter("seatLayoutId")));
            setup.setTripPrice(new BigDecimal(request.getParameter("tripPrice")));
            setup.setTripTime(Time.valueOf(request.getParameter("tripTime") + ":00"));

            int setupId = busSetupDAO.saveOrUpdateBusSetup(setup, parseStaffIds(request));
            String destination = request.getRequestURI().contains("/operator/")
                    ? "/operator/bus-setup.jsp"
                    : "/admin/bus-setup.jsp";
            response.sendRedirect(request.getContextPath() + destination + "?success=Bus setup saved&setupId=" + setupId);
        } catch (Exception e) {
            String destination = request.getRequestURI().contains("/operator/")
                    ? "/operator/bus-setup.jsp"
                    : "/admin/bus-setup.jsp";
            response.sendRedirect(request.getContextPath() + destination + "?error=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private User currentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session == null ? null : (User) session.getAttribute("user");
    }

    private List<Integer> parseStaffIds(HttpServletRequest request) {
        List<Integer> ids = new ArrayList<>();
        String[] values = request.getParameterValues("staffIds");
        if (values == null) {
            return ids;
        }
        for (String value : values) {
            ids.add(Integer.parseInt(value));
        }
        return ids;
    }
}
