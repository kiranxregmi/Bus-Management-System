package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.BusName;
import util.DBConnection;

public class BusNameDAO {

    public List<BusName> getAllBusNames() throws SQLException {
        List<BusName> busNames = new ArrayList<>();
        String sql = "SELECT * FROM bus_names ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                busNames.add(extractBusNameFromResultSet(rs));
            }
        }
        return busNames;
    }

    public BusName getBusNameById(int id) throws SQLException {
        String sql = "SELECT * FROM bus_names WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractBusNameFromResultSet(rs);
            }
        }
        return null;
    }

    public boolean addBusName(BusName busName) throws SQLException {
        String sql = "INSERT INTO bus_names (name, bus_type, capacity) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, busName.getName());
            pstmt.setString(2, busName.getBusType());
            pstmt.setInt(3, busName.getCapacity());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateBusName(BusName busName) throws SQLException {
        String sql = "UPDATE bus_names SET name = ?, bus_type = ?, capacity = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, busName.getName());
            pstmt.setString(2, busName.getBusType());
            pstmt.setInt(3, busName.getCapacity());
            pstmt.setInt(4, busName.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteBusName(int id) throws SQLException {
        String sql = "DELETE FROM bus_names WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    private BusName extractBusNameFromResultSet(ResultSet rs) throws SQLException {
        BusName busName = new BusName();
        busName.setId(rs.getInt("id"));
        busName.setName(rs.getString("name"));
        busName.setBusType(rs.getString("bus_type"));
        busName.setCapacity(rs.getInt("capacity"));
        busName.setCreatedAt(rs.getTimestamp("created_at"));
        return busName;
    }
}
