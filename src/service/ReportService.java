package service;

import dao.ReportDAO;
import java.sql.Date;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class ReportService {
    private ReportDAO reportDAO = new ReportDAO();

    public Map<String, Object> getDailySummary(Date date) throws SQLException {
        return reportDAO.getDailySummary(date);
    }

    public List<Map<String, Object>> getRoutePerformance(Date start, Date end) throws SQLException {
        return reportDAO.getRoutePerformance(start, end);
    }

    public List<Map<String, Object>> getBusPerformance(Date start, Date end) throws SQLException {
        return reportDAO.getBusPerformance(start, end);
    }

    public List<Map<String, Object>> getRevenueTrend(Date start, Date end) throws SQLException {
        return reportDAO.getRevenueTrend(start, end);
    }
}
