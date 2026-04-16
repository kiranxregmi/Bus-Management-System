package controller;

import model.Schedule;
import model.User;
import model.Bus;
import model.Route;
import service.ScheduleService;
import service.BusService;
import service.RouteService;

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
import java.util.Calendar;

@WebServlet("/admin/schedule")
public class AdminScheduleServlet extends HttpServlet {
    private ScheduleService scheduleService = new ScheduleService();
    private BusService busService = new BusService();
    private RouteService routeService = new RouteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    showAddForm(request, response);
                    break;
                case "delete":
                    deleteSchedule(request, response);
                    break;
                case "list":
                default:
                    listSchedules(request, response);
                    break;
            }
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
        try {
            if ("add".equals(action)) {
                addSchedule(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listSchedules(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        String dateStr = request.getParameter("date");
        Date date = (dateStr == null || dateStr.isEmpty()) ? new Date(System.currentTimeMillis()) : Date.valueOf(dateStr);
        
        List<Schedule> schedules = scheduleService.getSchedulesForDate(date);
        request.setAttribute("schedules", schedules);
        request.setAttribute("selectedDate", date);
        request.getRequestDispatcher("/admin/manageSchedules.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        request.setAttribute("buses", busService.getAllBuses());
        request.setAttribute("routes", routeService.getAllRoutes());
        request.getRequestDispatcher("/admin/addSchedule.jsp").forward(request, response);
    }

    private void addSchedule(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        int busId = Integer.parseInt(request.getParameter("busId"));
        int routeId = Integer.parseInt(request.getParameter("routeId"));
        Time depTime = Time.valueOf(request.getParameter("departureTime") + ":00");
        Time arrTime = Time.valueOf(request.getParameter("arrivalTime") + ":00");
        Date travelDate = Date.valueOf(request.getParameter("travelDate"));
        double fare = Double.parseDouble(request.getParameter("fare"));
        
        String bulkType = request.getParameter("bulkCreate"); // "none", "1week", "4weeks"
        
        try {
            // Initial one
            Schedule baseSchedule = createScheduleObject(busId, routeId, depTime, arrTime, travelDate, fare);
            scheduleService.addSchedule(baseSchedule);

            // Handle Bulk
            if ("1week".equals(bulkType) || "4weeks".equals(bulkType)) {
                int days = "1week".equals(bulkType) ? 7 : 28;
                Calendar cal = Calendar.getInstance();
                cal.setTime(travelDate);
                
                for (int i = 1; i <= days; i++) {
                    cal.add(Calendar.DATE, 1);
                    Schedule next = createScheduleObject(busId, routeId, depTime, arrTime, new Date(cal.getTimeInMillis()), fare);
                    try {
                        scheduleService.addSchedule(next);
                    } catch (Exception e) {
                        // Log and continue (e.g., skip conflicts)
                        System.err.println("Skipping bulk schedule for date " + next.getTravelDate() + ": " + e.getMessage());
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/schedule?action=list&date=" + travelDate + "&success=Schedule(s) created successfully");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            showAddForm(request, response);
        }
    }

    private Schedule createScheduleObject(int busId, int routeId, Time dep, Time arr, Date date, double fare) {
        Schedule s = new Schedule();
        s.setBusId(busId);
        s.setRouteId(routeId);
        s.setDepartureTime(dep);
        s.setArrivalTime(arr);
        s.setTravelDate(date);
        s.setFare(fare);
        s.setStatus("SCHEDULED");
        return s;
    }

    private void deleteSchedule(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String date = request.getParameter("date");
        scheduleService.deleteSchedule(id);
        response.sendRedirect(request.getContextPath() + "/admin/schedule?action=list&date=" + date + "&success=Schedule deleted successfully");
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
}
