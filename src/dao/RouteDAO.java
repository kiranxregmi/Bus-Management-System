package dao;

import model.Route;
import model.PickupPoint;
import model.DropPoint;
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

    public int addRouteWithPoints(Route route, List<PickupPoint> pickupPoints, List<DropPoint> dropPoints) throws SQLException {
        String sql = "INSERT INTO routes (source, destination, distance, duration, departure_location_id, " +
                "arrival_location_id, duration_hours, distance_km, remarks) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            boolean previousAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setString(1, route.getSource());
                pstmt.setString(2, route.getDestination());
                pstmt.setInt(3, route.getDistance());
                pstmt.setString(4, route.getDuration());
                pstmt.setInt(5, route.getDepartureLocationId());
                pstmt.setInt(6, route.getArrivalLocationId());
                pstmt.setBigDecimal(7, route.getDurationHours());
                pstmt.setBigDecimal(8, route.getDistanceKm());
                pstmt.setString(9, route.getRemarks());
                pstmt.executeUpdate();

                int routeId;
                try (ResultSet keys = pstmt.getGeneratedKeys()) {
                    if (!keys.next()) {
                        throw new SQLException("Route was not created.");
                    }
                    routeId = keys.getInt(1);
                }

                insertPickupPoints(conn, routeId, pickupPoints);
                insertDropPoints(conn, routeId, dropPoints);
                conn.commit();
                conn.setAutoCommit(previousAutoCommit);
                return routeId;
            } catch (SQLException | RuntimeException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public List<Route> getAllRoutes() throws SQLException {
        List<Route> routes = new ArrayList<>();
        String sql = "SELECT r.*, dl.name AS departure_name, al.name AS arrival_name " +
                "FROM routes r " +
                "LEFT JOIN locations dl ON r.departure_location_id = dl.id " +
                "LEFT JOIN locations al ON r.arrival_location_id = al.id " +
                "ORDER BY COALESCE(dl.name, r.source), COALESCE(al.name, r.destination)";
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

    public boolean checkDuplicateByLocation(int departureLocationId, int arrivalLocationId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM routes WHERE departure_location_id = ? AND arrival_location_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, departureLocationId);
            pstmt.setInt(2, arrivalLocationId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public Route getRouteById(int id) throws SQLException {
        String sql = "SELECT r.*, dl.name AS departure_name, al.name AS arrival_name " +
                "FROM routes r " +
                "LEFT JOIN locations dl ON r.departure_location_id = dl.id " +
                "LEFT JOIN locations al ON r.arrival_location_id = al.id " +
                "WHERE r.id = ?";
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

    public int getRouteCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM routes";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private void insertPickupPoints(Connection conn, int routeId, List<PickupPoint> pickupPoints) throws SQLException {
        if (pickupPoints == null || pickupPoints.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO pickup_points (route_id, location_id, pickup_route, pickup_time, price, sequence_order) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int index = 1;
            for (PickupPoint point : pickupPoints) {
                pstmt.setInt(1, routeId);
                pstmt.setInt(2, point.getLocationId());
                pstmt.setString(3, point.getPickupRoute());
                pstmt.setTime(4, point.getPickupTime());
                pstmt.setBigDecimal(5, point.getPrice());
                pstmt.setInt(6, index++);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }

    private void insertDropPoints(Connection conn, int routeId, List<DropPoint> dropPoints) throws SQLException {
        if (dropPoints == null || dropPoints.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO drop_points (route_id, location_id, drop_route, drop_time, price, sequence_order) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            int index = 1;
            for (DropPoint point : dropPoints) {
                pstmt.setInt(1, routeId);
                pstmt.setInt(2, point.getLocationId());
                pstmt.setString(3, point.getDropRoute());
                pstmt.setTime(4, point.getDropTime());
                pstmt.setBigDecimal(5, point.getPrice());
                pstmt.setInt(6, index++);
                pstmt.addBatch();
            }
            pstmt.executeBatch();
        }
    }

    private Route extractRouteFromResultSet(ResultSet rs) throws SQLException {
        Route route = new Route();
        route.setId(rs.getInt("id"));
        route.setSource(rs.getString("source"));
        route.setDestination(rs.getString("destination"));
        route.setDistance(rs.getInt("distance"));
        route.setDuration(rs.getString("duration"));
        if (hasColumn(rs, "departure_location_id")) {
            route.setDepartureLocationId(rs.getInt("departure_location_id"));
            route.setArrivalLocationId(rs.getInt("arrival_location_id"));
            route.setDurationHours(rs.getBigDecimal("duration_hours"));
            route.setDistanceKm(rs.getBigDecimal("distance_km"));
            route.setRemarks(rs.getString("remarks"));
        }
        if (hasColumn(rs, "departure_name")) {
            route.setDepartureLocationName(rs.getString("departure_name"));
            route.setArrivalLocationName(rs.getString("arrival_name"));
        }
        if (hasColumn(rs, "bus_setup_id")) {
            int bsId = rs.getInt("bus_setup_id");
            if (!rs.wasNull()) {
                route.setBusSetupId(bsId);
            }
        }
        return route;
    }

    public boolean updateRouteBusSetup(int routeId, Integer busSetupId) throws SQLException {
        String sql = "UPDATE routes SET bus_setup_id = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (busSetupId == null) {
                pstmt.setNull(1, java.sql.Types.INTEGER);
            } else {
                pstmt.setInt(1, busSetupId);
            }
            pstmt.setInt(2, routeId);
            return pstmt.executeUpdate() > 0;
        }
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnLabel(i))) {
                return true;
            }
        }
        return false;
    }
}
