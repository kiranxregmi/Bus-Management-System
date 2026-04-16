package controller;

import model.Schedule;
import model.User;
import service.ScheduleService;
import service.UserService;
import dao.BookingDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/admin/trip-sheet")
public class TripSheetServlet extends HttpServlet {
    private ScheduleService scheduleService = new ScheduleService();
    private UserService userService = new UserService();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String dateStr = request.getParameter("date");
        Date date = (dateStr == null || dateStr.isEmpty()) ? new Date(System.currentTimeMillis()) : Date.valueOf(dateStr);

        try {
            List<Schedule> schedules = scheduleService.getSchedulesForDate(date);
            Map<Integer, Integer> passengerCounts = new HashMap<>();
            
            for (Schedule s : schedules) {
                passengerCounts.put(s.getId(), bookingDAO.getPassengerCountBySchedule(s.getId()));
            }

            request.setAttribute("schedules", schedules);
            request.setAttribute("passengerCounts", passengerCounts);
            request.setAttribute("selectedDate", date);
            request.setAttribute("drivers", userService.getUsersByRole("DRIVER"));
            request.setAttribute("conductors", userService.getUsersByRole("CONDUCTOR"));
            
            request.getRequestDispatcher("/admin/tripSheet.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));

        try {
            if ("updateStatus".equals(action)) {
                String status = request.getParameter("status");
                scheduleService.updateStatus(scheduleId, status);
                
                // If DEPARTED, record actual time
                if ("DEPARTED".equals(status)) {
                    scheduleService.updateOperationalDetails(scheduleId, null, null, new Time(System.currentTimeMillis()), null);
                } else if ("ARRIVED".equals(status)) {
                    scheduleService.updateOperationalDetails(scheduleId, null, null, null, new Time(System.currentTimeMillis()));
                }
            } else if ("assignStaff".equals(action)) {
                int driverId = Integer.parseInt(request.getParameter("driverId"));
                int conductorId = Integer.parseInt(request.getParameter("conductorId"));
                scheduleService.updateOperationalDetails(scheduleId, driverId, conductorId, null, null);
                scheduleService.updateStatus(scheduleId, "DRIVER_ASSIGNED");
            }

            response.sendRedirect(request.getContextPath() + "/admin/trip-sheet?date=" + request.getParameter("date") + "&success=Trip updated");
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
}
