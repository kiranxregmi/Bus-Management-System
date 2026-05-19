package dao;

import model.Bus;
import model.Schedule;
import model.Route;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BusDAO {

    // Add new bus
    public boolean addBus(Bus bus) throws SQLException {
        String sql = "INSERT INTO buses (bus_number, bus_name, capacity, bus_type, fare_per_seat, status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, bus.getBusNumber());
            pstmt.setString(2, bus.getBusName());
            pstmt.setInt(3, bus.getCapacity());
            pstmt.setString(4, bus.getBusType());
            pstmt.setDouble(5, bus.getFarePerSeat());
            pstmt.setString(6, bus.getStatus());

            return pstmt.executeUpdate() > 0;
        }
    }

    // Get all active buses
    public List<Bus> getAllBuses() throws SQLException {
        List<Bus> buses = new ArrayList<>();
        String sql = "SELECT * FROM buses WHERE status='ACTIVE' ORDER BY bus_number";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                buses.add(extractBusFromResultSet(rs));
            }
        }
        return buses;
    }

    // Get bus by ID
    public Bus getBusById(int id) throws SQLException {
        String sql = "SELECT * FROM buses WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractBusFromResultSet(rs);
            }
        }
        return null;
    }

    // Search buses by route and date
    public List<Schedule> searchBuses(String source, String destination, Date travelDate) throws SQLException {
        if ("Kathmandu".equalsIgnoreCase(source) && "Pokhara".equalsIgnoreCase(destination)) {
            ensureKathmanduToPokharaScheduleExists(travelDate);
        }
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, b.*, r.* " +
                "FROM schedules s " +
                "JOIN buses b ON s.bus_id = b.id " +
                "JOIN routes r ON s.route_id = r.id " +
                "WHERE r.source = ? AND r.destination = ? AND s.travel_date = ? " +
                "AND b.status = 'ACTIVE' AND s.available_seats > 0 " +
                "ORDER BY s.departure_time";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, source);
            pstmt.setString(2, destination);
            pstmt.setDate(3, travelDate);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Schedule schedule = new Schedule();
                schedule.setId(rs.getInt("s.id"));
                schedule.setBusId(rs.getInt("bus_id"));
                schedule.setRouteId(rs.getInt("route_id"));
                schedule.setDepartureTime(rs.getTime("departure_time"));
                schedule.setArrivalTime(rs.getTime("arrival_time"));
                schedule.setTravelDate(rs.getDate("travel_date"));
                schedule.setAvailableSeats(rs.getInt("available_seats"));

                Bus bus = new Bus();
                bus.setId(rs.getInt("b.id"));
                bus.setBusNumber(rs.getString("bus_number"));
                bus.setBusName(rs.getString("bus_name"));
                bus.setCapacity(rs.getInt("capacity"));
                bus.setBusType(rs.getString("bus_type"));
                bus.setFarePerSeat(rs.getDouble("fare_per_seat"));
                schedule.setBus(bus);

                Route route = new Route();
                route.setId(rs.getInt("r.id"));
                route.setSource(rs.getString("source"));
                route.setDestination(rs.getString("destination"));
                schedule.setRoute(route);

                schedules.add(schedule);
            }
        }
        return schedules;
    }

    // Get total bus count
    public int getBusCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM buses WHERE status='ACTIVE'";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // Delete bus (soft delete)
    public boolean deleteBus(int id) throws SQLException {
        String sql = "UPDATE buses SET status='INACTIVE' WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    // Helper method
    private Bus extractBusFromResultSet(ResultSet rs) throws SQLException {
        Bus bus = new Bus();
        bus.setId(rs.getInt("id"));
        bus.setBusNumber(rs.getString("bus_number"));
        bus.setBusName(rs.getString("bus_name"));
        bus.setCapacity(rs.getInt("capacity"));
        bus.setBusType(rs.getString("bus_type"));
        bus.setFarePerSeat(rs.getDouble("fare_per_seat"));
        bus.setStatus(rs.getString("status"));
        return bus;
    }

    private void ensureKathmanduToPokharaScheduleExists(Date travelDate) {
        String checkSql = "SELECT COUNT(*) FROM schedules WHERE route_id = 1 AND travel_date = ?";
        String insertSql = "INSERT INTO schedules (bus_id, route_id, departure_time, arrival_time, travel_date, available_seats) " +
                           "VALUES (1, 1, '06:00:00', '13:00:00', ?, 50)";
        try (Connection conn = DBConnection.getConnection()) {
            boolean routeOk = false;
            try (Statement stmt = conn.createStatement();
                 ResultSet rs = stmt.executeQuery("SELECT id FROM routes WHERE id = 1 AND source = 'Kathmandu' AND destination = 'Pokhara'")) {
                if (rs.next()) {
                    routeOk = true;
                }
            }
            if (!routeOk) {
                int routeId = 1;
                try (PreparedStatement pstmt = conn.prepareStatement("SELECT id FROM routes WHERE source = 'Kathmandu' AND destination = 'Pokhara'")) {
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            routeId = rs.getInt("id");
                        } else {
                            try (PreparedStatement insertRoute = conn.prepareStatement(
                                    "INSERT INTO routes (source, destination, distance, duration) VALUES ('Kathmandu', 'Pokhara', 200, '7 hours')",
                                    Statement.RETURN_GENERATED_KEYS)) {
                                insertRoute.executeUpdate();
                                try (ResultSet keys = insertRoute.getGeneratedKeys()) {
                                    if (keys.next()) {
                                        routeId = keys.getInt(1);
                                    }
                                }
                            }
                        }
                    }
                }
                checkSql = "SELECT COUNT(*) FROM schedules WHERE route_id = " + routeId + " AND travel_date = ?";
                insertSql = "INSERT INTO schedules (bus_id, route_id, departure_time, arrival_time, travel_date, available_seats) " +
                            "VALUES (1, " + routeId + ", '06:00:00', '13:00:00', ?, 50)";
            }

            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setDate(1, travelDate);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next() && rs.getInt(1) > 0) {
                        return;
                    }
                }
            }

            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setDate(1, travelDate);
                insertStmt.executeUpdate();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
