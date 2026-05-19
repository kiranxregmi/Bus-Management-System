package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.LoyaltyPoint;
import util.DBConnection;

public class LoyaltyPointDAO {

    public LoyaltyPoint getLoyaltyPointsByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM loyalty_points WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractLoyaltyPointFromResultSet(rs);
            }
        }
        return null;
    }

    public List<LoyaltyPoint> getTopLoyalCustomers(int limit) throws SQLException {
        List<LoyaltyPoint> points = new ArrayList<>();
        String sql = "SELECT * FROM loyalty_points ORDER BY points_balance DESC LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                points.add(extractLoyaltyPointFromResultSet(rs));
            }
        }
        return points;
    }

    public boolean initializeLoyaltyPoints(int userId) throws SQLException {
        String sql = "INSERT INTO loyalty_points (user_id, points_balance, total_points_earned) VALUES (?, 0, 0)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, userId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean addPoints(int userId, int points) throws SQLException {
        String sql = "UPDATE loyalty_points SET points_balance = points_balance + ?, total_points_earned = total_points_earned + ? WHERE user_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, points);
            pstmt.setInt(2, points);
            pstmt.setInt(3, userId);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean redeemPoints(int userId, int points) throws SQLException {
        String sql = "UPDATE loyalty_points SET points_balance = points_balance - ? WHERE user_id = ? AND points_balance >= ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, points);
            pstmt.setInt(2, userId);
            pstmt.setInt(3, points);
            return pstmt.executeUpdate() > 0;
        }
    }

    private LoyaltyPoint extractLoyaltyPointFromResultSet(ResultSet rs) throws SQLException {
        LoyaltyPoint loyalty = new LoyaltyPoint();
        loyalty.setId(rs.getInt("id"));
        loyalty.setUserId(rs.getInt("user_id"));
        loyalty.setPointsBalance(rs.getInt("points_balance"));
        loyalty.setTotalPointsEarned(rs.getInt("total_points_earned"));
        loyalty.setLastUpdated(rs.getTimestamp("last_updated"));
        return loyalty;
    }
}
