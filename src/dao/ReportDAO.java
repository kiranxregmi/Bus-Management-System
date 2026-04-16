package dao;

import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    public Map<String, Object> getDailySummary(Date date) throws SQLException {
        Map<String, Object> summary = new HashMap<>();
        String sql = "SELECT " +
                     "  COUNT(DISTINCT s.id) as total_trips, " +
                     "  SUM(b.total_fare) as total_revenue, " +
                     "  (SELECT SUM(total_fare) FROM bookings b2 JOIN schedules s2 ON b2.schedule_id = s2.id WHERE s2.travel_date = ? AND b2.status='CONFIRMED') as confirmed_revenue " +
                     "FROM schedules s " +
                     "LEFT JOIN bookings b ON s.id = b.schedule_id AND b.status = 'CONFIRMED' " +
                     "WHERE s.travel_date = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, date);
            pstmt.setDate(2, date);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                summary.put("totalTrips", rs.getInt("total_trips"));
                summary.put("totalRevenue", rs.getDouble("total_revenue"));
            }
        }
        return summary;
    }

    public List<Map<String, Object>> getRoutePerformance(Date start, Date end) throws SQLException {
        List<Map<String, Object>> performance = new ArrayList<>();
        String sql = "SELECT r.source, r.destination, " +
                     "COUNT(DISTINCT s.id) as trips, " +
                     "SUM(CASE WHEN b.status = 'CONFIRMED' THEN 1 ELSE 0 END) as bookings, " +
                     "SUM(CASE WHEN b.status = 'CONFIRMED' THEN b.total_fare ELSE 0 END) as revenue " +
                     "FROM routes r " +
                     "JOIN schedules s ON r.id = s.route_id " +
                     "LEFT JOIN bookings b ON s.id = b.schedule_id " +
                     "WHERE s.travel_date BETWEEN ? AND ? " +
                     "GROUP BY r.id " +
                     "ORDER BY revenue DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, start);
            pstmt.setDate(2, end);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("route", rs.getString("source") + " - " + rs.getString("destination"));
                row.put("trips", rs.getInt("trips"));
                row.put("bookings", rs.getInt("bookings"));
                row.put("revenue", rs.getDouble("revenue"));
                performance.add(row);
            }
        }
        return performance;
    }

    public List<Map<String, Object>> getBusPerformance(Date start, Date end) throws SQLException {
        List<Map<String, Object>> performance = new ArrayList<>();
        String sql = "SELECT b.bus_number, b.bus_name, " +
                     "COUNT(DISTINCT s.id) as trips, " +
                     "SUM(CASE WHEN bk.status = 'CONFIRMED' THEN bk.total_fare ELSE 0 END) as revenue " +
                     "FROM buses b " +
                     "JOIN schedules s ON b.id = s.bus_id " +
                     "LEFT JOIN bookings bk ON s.id = bk.schedule_id " +
                     "WHERE s.travel_date BETWEEN ? AND ? " +
                     "GROUP BY b.id " +
                     "ORDER BY revenue DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, start);
            pstmt.setDate(2, end);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("busNumber", rs.getString("bus_number"));
                row.put("busName", rs.getString("bus_name"));
                row.put("trips", rs.getInt("trips"));
                row.put("revenue", rs.getDouble("revenue"));
                performance.add(row);
            }
        }
        return performance;
    }

    public List<Map<String, Object>> getRevenueTrend(Date start, Date end) throws SQLException {
        List<Map<String, Object>> trend = new ArrayList<>();
        String sql = "SELECT s.travel_date, SUM(b.total_fare) as daily_revenue " +
                     "FROM schedules s " +
                     "JOIN bookings b ON s.id = b.schedule_id " +
                     "WHERE s.travel_date BETWEEN ? AND ? AND b.status = 'CONFIRMED' " +
                     "GROUP BY s.travel_date " +
                     "ORDER BY s.travel_date";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, start);
            pstmt.setDate(2, end);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("date", rs.getDate("travel_date"));
                row.put("revenue", rs.getDouble("daily_revenue"));
                trend.add(row);
            }
        }
        return trend;
    }
}
