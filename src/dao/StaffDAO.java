package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.Staff;
import util.DBConnection;

public class StaffDAO {

    public List<Staff> getAllStaff() throws SQLException {
        List<Staff> staff = new ArrayList<>();
        String sql = "SELECT * FROM staff ORDER BY role, name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                staff.add(extractStaffFromResultSet(rs));
            }
        }
        return staff;
    }

    public List<Staff> getStaffByRole(String role) throws SQLException {
        List<Staff> staff = new ArrayList<>();
        String sql = "SELECT * FROM staff WHERE role = ? AND status = 'ACTIVE' ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, role);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                staff.add(extractStaffFromResultSet(rs));
            }
        }
        return staff;
    }

    public Staff getStaffById(int id) throws SQLException {
        String sql = "SELECT * FROM staff WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractStaffFromResultSet(rs);
            }
        }
        return null;
    }

    public boolean addStaff(Staff staff) throws SQLException {
        String sql = "INSERT INTO staff (name, role, phone, address, license_number, status) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, staff.getName());
            pstmt.setString(2, staff.getRole());
            pstmt.setString(3, staff.getPhone());
            pstmt.setString(4, staff.getAddress());
            pstmt.setString(5, staff.getLicenseNumber());
            pstmt.setString(6, staff.getStatus());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateStaff(Staff staff) throws SQLException {
        String sql = "UPDATE staff SET name = ?, role = ?, phone = ?, address = ?, license_number = ?, status = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, staff.getName());
            pstmt.setString(2, staff.getRole());
            pstmt.setString(3, staff.getPhone());
            pstmt.setString(4, staff.getAddress());
            pstmt.setString(5, staff.getLicenseNumber());
            pstmt.setString(6, staff.getStatus());
            pstmt.setInt(7, staff.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteStaff(int id) throws SQLException {
        String sql = "DELETE FROM staff WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    private Staff extractStaffFromResultSet(ResultSet rs) throws SQLException {
        Staff staff = new Staff();
        staff.setId(rs.getInt("id"));
        staff.setName(rs.getString("name"));
        staff.setRole(rs.getString("role"));
        staff.setPhone(rs.getString("phone"));
        staff.setAddress(rs.getString("address"));
        staff.setLicenseNumber(rs.getString("license_number"));
        staff.setStatus(rs.getString("status"));
        staff.setCreatedAt(rs.getTimestamp("created_at"));
        return staff;
    }
}
