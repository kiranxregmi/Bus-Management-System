package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.BusName;
import model.BusNumber;
import util.DBConnection;

public class BusNumberDAO {

    public List<BusNumber> getAllBusNumbers() throws SQLException {
        List<BusNumber> busNumbers = new ArrayList<>();
        String sql = "SELECT bn.*, bm.name, bm.bus_type, bm.capacity FROM bus_numbers bn " +
                    "LEFT JOIN bus_names bm ON bn.bus_name_id = bm.id ORDER BY bn.registration_number";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                busNumbers.add(extractBusNumberFromResultSet(rs));
            }
        }
        return busNumbers;
    }

    public BusNumber getBusNumberById(int id) throws SQLException {
        String sql = "SELECT bn.*, bm.name, bm.bus_type, bm.capacity FROM bus_numbers bn " +
                    "LEFT JOIN bus_names bm ON bn.bus_name_id = bm.id WHERE bn.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractBusNumberFromResultSet(rs);
            }
        }
        return null;
    }

    public List<BusNumber> getBusNumbersByBusName(int busNameId) throws SQLException {
        List<BusNumber> busNumbers = new ArrayList<>();
        String sql = "SELECT bn.*, bm.name, bm.bus_type, bm.capacity FROM bus_numbers bn " +
                    "LEFT JOIN bus_names bm ON bn.bus_name_id = bm.id WHERE bn.bus_name_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busNameId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                busNumbers.add(extractBusNumberFromResultSet(rs));
            }
        }
        return busNumbers;
    }

    public boolean addBusNumber(BusNumber busNumber) throws SQLException {
        String sql = "INSERT INTO bus_numbers (bus_name_id, registration_number, status) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busNumber.getBusNameId());
            pstmt.setString(2, busNumber.getRegistrationNumber());
            pstmt.setString(3, busNumber.getStatus());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateBusNumber(BusNumber busNumber) throws SQLException {
        String sql = "UPDATE bus_numbers SET bus_name_id = ?, registration_number = ?, status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busNumber.getBusNameId());
            pstmt.setString(2, busNumber.getRegistrationNumber());
            pstmt.setString(3, busNumber.getStatus());
            pstmt.setInt(4, busNumber.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteBusNumber(int id) throws SQLException {
        String sql = "DELETE FROM bus_numbers WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    private BusNumber extractBusNumberFromResultSet(ResultSet rs) throws SQLException {
        BusNumber busNumber = new BusNumber();
        busNumber.setId(rs.getInt("id"));
        busNumber.setBusNameId(rs.getInt("bus_name_id"));
        busNumber.setRegistrationNumber(rs.getString("registration_number"));
        busNumber.setStatus(rs.getString("status"));
        busNumber.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Set BusName if available
        if (rs.getString("name") != null) {
            BusName busName = new BusName();
            busName.setName(rs.getString("name"));
            busName.setBusType(rs.getString("bus_type"));
            busName.setCapacity(rs.getInt("capacity"));
            busNumber.setBusName(busName);
        }
        return busNumber;
    }
}
