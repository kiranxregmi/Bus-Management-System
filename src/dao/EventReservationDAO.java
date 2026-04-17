package dao;

import model.EventReservation;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class EventReservationDAO {

    public boolean insert(EventReservation reservation) throws SQLException {
        String sql = "INSERT INTO event_reservations (user_id, event_type, event_name, event_date, required_date, " +
                     "number_of_passengers, number_of_buses, preferred_bus_type, pickup_location, dropoff_location, description, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, reservation.getUserId());
            stmt.setString(2, reservation.getEventType());
            stmt.setString(3, reservation.getEventName());
            stmt.setDate(4, reservation.getEventDate());
            stmt.setDate(5, reservation.getRequiredDate());
            stmt.setInt(6, reservation.getNumberOfPassengers());
            stmt.setInt(7, reservation.getNumberOfBuses());
            stmt.setString(8, reservation.getPreferredBusType());
            stmt.setString(9, reservation.getPickupLocation());
            stmt.setString(10, reservation.getDropoffLocation());
            stmt.setString(11, reservation.getDescription());
            stmt.setString(12, reservation.getStatus() != null ? reservation.getStatus() : "PENDING");
            
            return stmt.executeUpdate() > 0;
        }
    }

    public List<EventReservation> getAll() throws SQLException {
        List<EventReservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM event_reservations ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                reservations.add(mapResultSetToEventReservation(rs));
            }
        }
        return reservations;
    }

    public List<EventReservation> getByUserId(int userId) throws SQLException {
        List<EventReservation> reservations = new ArrayList<>();
        String sql = "SELECT * FROM event_reservations WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    reservations.add(mapResultSetToEventReservation(rs));
                }
            }
        }
        return reservations;
    }

    public boolean updateStatus(int id, String status) throws SQLException {
        String sql = "UPDATE event_reservations SET status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, status);
            stmt.setInt(2, id);
            
            return stmt.executeUpdate() > 0;
        }
    }

    private EventReservation mapResultSetToEventReservation(ResultSet rs) throws SQLException {
        EventReservation res = new EventReservation();
        res.setId(rs.getInt("id"));
        res.setUserId(rs.getInt("user_id"));
        res.setEventType(rs.getString("event_type"));
        res.setEventName(rs.getString("event_name"));
        res.setEventDate(rs.getDate("event_date"));
        res.setRequiredDate(rs.getDate("required_date"));
        res.setNumberOfPassengers(rs.getInt("number_of_passengers"));
        res.setNumberOfBuses(rs.getInt("number_of_buses"));
        res.setPreferredBusType(rs.getString("preferred_bus_type"));
        res.setPickupLocation(rs.getString("pickup_location"));
        res.setDropoffLocation(rs.getString("dropoff_location"));
        res.setDescription(rs.getString("description"));
        res.setStatus(rs.getString("status"));
        res.setCreatedAt(rs.getTimestamp("created_at"));
        return res;
    }
}
