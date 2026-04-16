package dao;

import model.Schedule;
import model.Bus;
import model.Route;
import util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ScheduleDAO {

    public boolean addSchedule(Schedule schedule) throws SQLException {
        String sql = "INSERT INTO schedules (bus_id, route_id, departure_time, arrival_time, travel_date, available_seats, status, fare) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, schedule.getBusId());
            pstmt.setInt(2, schedule.getRouteId());
            pstmt.setTime(3, schedule.getDepartureTime());
            pstmt.setTime(4, schedule.getArrivalTime());
            pstmt.setDate(5, schedule.getTravelDate());
            pstmt.setInt(6, schedule.getAvailableSeats());
            pstmt.setString(7, schedule.getStatus() != null ? schedule.getStatus() : "SCHEDULED");
            pstmt.setDouble(8, schedule.getFare());
            return pstmt.executeUpdate() > 0;
        }
    }

    public List<Schedule> getSchedulesByDateRange(Date start, Date end) throws SQLException {
        List<Schedule> schedules = new ArrayList<>();
        String sql = "SELECT s.*, b.bus_number, b.bus_name, b.capacity, r.source, r.destination " +
                     "FROM schedules s " +
                     "JOIN buses b ON s.bus_id = b.id " +
                     "JOIN routes r ON s.route_id = r.id " +
                     "WHERE s.travel_date BETWEEN ? AND ? " +
                     "ORDER BY s.travel_date, s.departure_time";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setDate(1, start);
            pstmt.setDate(2, end);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                schedules.add(extractExtendedSchedule(rs));
            }
        }
        return schedules;
    }

    public boolean checkBusConflict(int busId, Date date, Time start, Time end) throws SQLException {
        // Simple conflict check: if any schedule for the same bus on the same date overlaps
        String sql = "SELECT COUNT(*) FROM schedules WHERE bus_id = ? AND travel_date = ? " +
                     "AND status != 'CANCELLED' " +
                     "AND ((departure_time <= ? AND arrival_time >= ?) OR (departure_time <= ? AND arrival_time >= ?))";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busId);
            pstmt.setDate(2, date);
            pstmt.setTime(3, end);
            pstmt.setTime(4, end);
            pstmt.setTime(5, start);
            pstmt.setTime(6, start);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    public Schedule getScheduleById(int id) throws SQLException {
        String sql = "SELECT s.*, b.bus_number, b.bus_name, b.capacity, r.source, r.destination " +
                     "FROM schedules s " +
                     "JOIN buses b ON s.bus_id = b.id " +
                     "JOIN routes r ON s.route_id = r.id " +
                     "WHERE s.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractExtendedSchedule(rs);
            }
        }
        return null;
    }

    public boolean updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE schedules SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateStaff(int id, Integer driverId, Integer conductorId) throws SQLException {
        String sql = "UPDATE schedules SET driver_id = ?, conductor_id = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (driverId != null) pstmt.setInt(1, driverId); else pstmt.setNull(1, Types.INTEGER);
            if (conductorId != null) pstmt.setInt(2, conductorId); else pstmt.setNull(2, Types.INTEGER);
            pstmt.setInt(3, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateActualTimes(int id, Time dep, Time arr) throws SQLException {
        String sql = "UPDATE schedules SET actual_departure = ?, actual_arrival = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (dep != null) pstmt.setTime(1, dep); else pstmt.setNull(1, Types.TIME);
            if (arr != null) pstmt.setTime(2, arr); else pstmt.setNull(2, Types.TIME);
            pstmt.setInt(3, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteSchedule(int id) throws SQLException {
        String sql = "DELETE FROM schedules WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    private Schedule extractExtendedSchedule(ResultSet rs) throws SQLException {
        Schedule s = new Schedule();
        s.setId(rs.getInt("id"));
        s.setBusId(rs.getInt("bus_id"));
        s.setRouteId(rs.getInt("route_id"));
        s.setDepartureTime(rs.getTime("departure_time"));
        s.setArrivalTime(rs.getTime("arrival_time"));
        s.setTravelDate(rs.getDate("travel_date"));
        s.setAvailableSeats(rs.getInt("available_seats"));
        s.setActualDeparture(rs.getTime("actual_departure"));
        s.setActualArrival(rs.getTime("actual_arrival"));
        s.setDriverId((Integer) rs.getObject("driver_id"));
        s.setConductorId((Integer) rs.getObject("conductor_id"));
        s.setStatus(rs.getString("status"));
        s.setFare(rs.getDouble("fare"));

        Bus b = new Bus();
        b.setId(rs.getInt("bus_id"));
        b.setBusNumber(rs.getString("bus_number"));
        b.setBusName(rs.getString("bus_name"));
        b.setCapacity(rs.getInt("capacity"));
        s.setBus(b);

        Route r = new Route();
        r.setId(rs.getInt("route_id"));
        r.setSource(rs.getString("source"));
        r.setDestination(rs.getString("destination"));
        s.setRoute(r);

        return s;
    }
}
