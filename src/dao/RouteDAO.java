package dao;

import model.Route;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.HashSet;
import java.util.Set;

public class RouteDAO {

    public boolean addRoute(Route route) throws SQLException {
        String sql = "INSERT INTO routes (source, destination, distance, duration) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, route.getSource());
            pstmt.setString(2, route.getDestination());
            pstmt.setInt(3, route.getDistance());
            pstmt.setString(4, route.getDuration());
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<Route> getAllRoutes() throws SQLException {
        List<Route> routes = new ArrayList<>();
        String sql = "SELECT * FROM routes ORDER BY source, destination";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                routes.add(extractRouteFromResultSet(rs));
            }
        }
        return routes;
    }

    public Set<String> getAllCities() throws SQLException {
        Set<String> cities = new HashSet<>();
        String sql = "SELECT source as city FROM routes UNION SELECT destination as city FROM routes";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                cities.add(rs.getString("city"));
            }
        }
        return cities;
    }

    public boolean checkDuplicate(String source, String destination) throws SQLException {
        String sql = "SELECT COUNT(*) FROM routes WHERE source = ? AND destination = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, source);
            pstmt.setString(2, destination);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public Route getRouteById(int id) throws SQLException {
        String sql = "SELECT * FROM routes WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractRouteFromResultSet(rs);
            }
        }
        return null;
    }

    public boolean deleteRoute(int id) throws SQLException {
        String sql = "DELETE FROM routes WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    private Route extractRouteFromResultSet(ResultSet rs) throws SQLException {
        Route route = new Route();
        route.setId(rs.getInt("id"));
        route.setSource(rs.getString("source"));
        route.setDestination(rs.getString("destination"));
        route.setDistance(rs.getInt("distance"));
        route.setDuration(rs.getString("duration"));
        return route;
    }
}
