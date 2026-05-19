package dao;

import model.Seat;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class SeatDAO {
    public List<Seat> getSeatsByBusSetup(int busSetupId) throws SQLException {
        List<Seat> seats = new ArrayList<>();
        String sql = "SELECT * FROM seats WHERE bus_setup_id = ? ORDER BY CAST(SUBSTRING(seat_number, 2) AS UNSIGNED)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busSetupId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Seat seat = new Seat();
                    seat.setId(rs.getInt("id"));
                    seat.setBusSetupId(rs.getInt("bus_setup_id"));
                    seat.setSeatNumber(rs.getString("seat_number"));
                    seat.setStatus(rs.getString("status"));
                    seat.setCreatedAt(rs.getTimestamp("created_at"));
                    seats.add(seat);
                }
            }
        }
        return seats;
    }

    public boolean updateSeatStatus(int busSetupId, String seatNumber, String status) throws SQLException {
        String sql = "UPDATE seats SET status = ? WHERE bus_setup_id = ? AND seat_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setInt(2, busSetupId);
            pstmt.setString(3, seatNumber);
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean areSeatsAvailable(int busSetupId, List<String> seatNumbers) throws SQLException {
        if (seatNumbers == null || seatNumbers.isEmpty()) {
            return false;
        }
        String placeholders = String.join(",", java.util.Collections.nCopies(seatNumbers.size(), "?"));
        String sql = "SELECT COUNT(*) FROM seats WHERE bus_setup_id = ? AND status = 'AVAILABLE' AND seat_number IN (" + placeholders + ")";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busSetupId);
            for (int i = 0; i < seatNumbers.size(); i++) {
                pstmt.setString(i + 2, seatNumbers.get(i));
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && rs.getInt(1) == seatNumbers.size();
            }
        }
    }
}
