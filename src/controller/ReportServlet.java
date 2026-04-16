package controller;

import model.User;
import service.ReportService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/reports")
public class ReportServlet extends HttpServlet {
    private ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String startStr = request.getParameter("startDate");
        String endStr = request.getParameter("endDate");

        Calendar cal = Calendar.getInstance();
        Date endDate = (endStr == null || endStr.isEmpty()) ? new Date(System.currentTimeMillis()) : Date.valueOf(endStr);
        
        if (startStr == null || startStr.isEmpty()) {
            cal.setTime(endDate);
            cal.add(Calendar.MONTH, -1); // Default to last 30 days
            startStr = new Date(cal.getTimeInMillis()).toString();
        }
        Date startDate = Date.valueOf(startStr);

        String export = request.getParameter("export");
        if (export != null) {
            handleExport(request, response, export, startDate, endDate);
            return;
        }

        try {
            request.setAttribute("summary", reportService.getDailySummary(endDate));
            request.setAttribute("routePerformance", reportService.getRoutePerformance(startDate, endDate));
            request.setAttribute("busPerformance", reportService.getBusPerformance(startDate, endDate));
            request.setAttribute("revenueTrend", reportService.getRevenueTrend(startDate, endDate));
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);

            request.getRequestDispatcher("/admin/reports.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void handleExport(HttpServletRequest request, HttpServletResponse response, String type, Date start, Date end) throws IOException, ServletException {
        try {
            if ("csv".equals(type)) {
                response.setContentType("text/csv");
                response.setHeader("Content-Disposition", "attachment; filename=report_" + start + "_to_" + end + ".csv");
                List<Map<String, Object>> data = reportService.getRoutePerformance(start, end);
                response.getWriter().println("Route,Trips,Bookings,Revenue");
                for (Map<String, Object> row : data) {
                    response.getWriter().println(row.get("route") + "," + row.get("trips") + "," + row.get("bookings") + "," + row.get("revenue"));
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unsupported export type");
            }
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
