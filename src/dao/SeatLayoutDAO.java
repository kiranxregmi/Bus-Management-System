package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import model.SeatLayout;
import util.DBConnection;

public class SeatLayoutDAO {

    public List<SeatLayout> getAllSeatLayouts() throws SQLException {
        List<SeatLayout> layouts = new ArrayList<>();
        String sql = "SELECT * FROM seat_layouts ORDER BY name";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                layouts.add(extractSeatLayoutFromResultSet(rs));
            }
        }
        return layouts;
    }

    public SeatLayout getSeatLayoutById(int id) throws SQLException {
        String sql = "SELECT * FROM seat_layouts WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractSeatLayoutFromResultSet(rs);
            }
        }
        return null;
    }

    public boolean addSeatLayout(SeatLayout layout) throws SQLException {
        String sql = "INSERT INTO seat_layouts (name, type, total_seats, rows, columns, layout_json) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, layout.getName());
            pstmt.setString(2, layout.getType());
            pstmt.setInt(3, layout.getTotalSeats());
            pstmt.setInt(4, layout.getRows());
            pstmt.setInt(5, layout.getColumns());
            pstmt.setString(6, layout.getLayoutJson());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean updateSeatLayout(SeatLayout layout) throws SQLException {
        String sql = "UPDATE seat_layouts SET name = ?, type = ?, total_seats = ?, rows = ?, columns = ?, layout_json = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, layout.getName());
            pstmt.setString(2, layout.getType());
            pstmt.setInt(3, layout.getTotalSeats());
            pstmt.setInt(4, layout.getRows());
            pstmt.setInt(5, layout.getColumns());
            pstmt.setString(6, layout.getLayoutJson());
            pstmt.setInt(7, layout.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteSeatLayout(int id) throws SQLException {
        String sql = "DELETE FROM seat_layouts WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    private SeatLayout extractSeatLayoutFromResultSet(ResultSet rs) throws SQLException {
        SeatLayout layout = new SeatLayout();
        layout.setId(rs.getInt("id"));
        layout.setName(rs.getString("name"));
        layout.setType(rs.getString("type"));
        layout.setTotalSeats(rs.getInt("total_seats"));
        layout.setRows(rs.getInt("rows"));
        layout.setColumns(rs.getInt("columns"));
        layout.setLayoutJson(rs.getString("layout_json"));
        layout.setCreatedAt(rs.getTimestamp("created_at"));
        return layout;
    }
}
