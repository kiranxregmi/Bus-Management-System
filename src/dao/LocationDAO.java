package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Location;
import util.DBConnection;

public class LocationDAO {

    public List<Location> getAllLocations() throws SQLException {
        List<Location> locations = new ArrayList<>();
        String sql = "SELECT * FROM locations ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                locations.add(extractLocationFromResultSet(rs));
            }
        }
        return locations;
    }

    public Location getLocationById(int id) throws SQLException {
        String sql = "SELECT * FROM locations WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractLocationFromResultSet(rs);
            }
        }
        return null;
    }

    public Location getLocationByName(String name) throws SQLException {
        String sql = "SELECT * FROM locations WHERE name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractLocationFromResultSet(rs);
            }
        }
        return null;
    }

    public boolean addLocation(Location location) throws SQLException {
        String sql = "INSERT INTO locations (name, district, latitude, longitude) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, location.getName());
            pstmt.setString(2, location.getDistrict());
            pstmt.setBigDecimal(3, location.getLatitude());
            pstmt.setBigDecimal(4, location.getLongitude());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateLocation(Location location) throws SQLException {
        String sql = "UPDATE locations SET name = ?, district = ?, latitude = ?, longitude = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, location.getName());
            pstmt.setString(2, location.getDistrict());
            pstmt.setBigDecimal(3, location.getLatitude());
            pstmt.setBigDecimal(4, location.getLongitude());
            pstmt.setInt(5, location.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteLocation(int id) throws SQLException {
        String sql = "DELETE FROM locations WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    private Location extractLocationFromResultSet(ResultSet rs) throws SQLException {
        Location location = new Location();
        location.setId(rs.getInt("id"));
        location.setName(rs.getString("name"));
        location.setDistrict(rs.getString("district"));
        location.setLatitude(rs.getBigDecimal("latitude"));
        location.setLongitude(rs.getBigDecimal("longitude"));
        location.setCreatedAt(rs.getTimestamp("created_at"));
        return location;
    }
}
