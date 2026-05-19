package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import model.BusSetup;
import model.BusNumber;
import model.SeatLayout;
import util.DBConnection;

public class BusSetupDAO {

    public List<BusSetup> getAllBusSetups() throws SQLException {
        List<BusSetup> setups = new ArrayList<>();
        String sql = "SELECT bs.*, bn.registration_number, bm.name as bus_name, sl.name as layout_name " +
                    "FROM bus_setup bs " +
                    "LEFT JOIN bus_numbers bn ON bs.bus_number_id = bn.id " +
                    "LEFT JOIN bus_names bm ON bn.bus_name_id = bm.id " +
                    "LEFT JOIN seat_layouts sl ON bs.seat_layout_id = sl.id " +
                    "ORDER BY bs.id";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                setups.add(extractBusSetupFromResultSet(rs));
            }
        }
        return setups;
    }

    public BusSetup getBusSetupById(int id) throws SQLException {
        String sql = "SELECT bs.*, bn.registration_number, bm.name as bus_name, sl.name as layout_name " +
                    "FROM bus_setup bs " +
                    "LEFT JOIN bus_numbers bn ON bs.bus_number_id = bn.id " +
                    "LEFT JOIN bus_names bm ON bn.bus_name_id = bm.id " +
                    "LEFT JOIN seat_layouts sl ON bs.seat_layout_id = sl.id " +
                    "WHERE bs.id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractBusSetupFromResultSet(rs);
            }
        }
        return null;
    }

    public BusSetup getBusSetupByBusNumber(int busNumberId) throws SQLException {
        String sql = "SELECT bs.*, bn.registration_number, bm.name as bus_name, sl.name as layout_name " +
                    "FROM bus_setup bs " +
                    "LEFT JOIN bus_numbers bn ON bs.bus_number_id = bn.id " +
                    "LEFT JOIN bus_names bm ON bn.bus_name_id = bm.id " +
                    "LEFT JOIN seat_layouts sl ON bs.seat_layout_id = sl.id " +
                    "WHERE bs.bus_number_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busNumberId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return extractBusSetupFromResultSet(rs);
            }
        }
        return null;
    }

    public boolean addBusSetup(BusSetup setup) throws SQLException {
        String sql = "INSERT INTO bus_setup (bus_number_id, seat_layout_id, trip_price, trip_time) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, setup.getBusNumberId());
            pstmt.setInt(2, setup.getSeatLayoutId());
            pstmt.setBigDecimal(3, setup.getTripPrice());
            pstmt.setTime(4, setup.getTripTime());
            return pstmt.executeUpdate() > 0;
        }
    }

    public int saveOrUpdateBusSetup(BusSetup setup, List<Integer> staffIds) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                int setupId = findSetupIdByBusNumber(conn, setup.getBusNumberId());
                if (setupId > 0) {
                    String updateSql = "UPDATE bus_setup SET seat_layout_id = ?, trip_price = ?, trip_time = ? WHERE id = ?";
                    try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                        pstmt.setInt(1, setup.getSeatLayoutId());
                        pstmt.setBigDecimal(2, setup.getTripPrice());
                        pstmt.setTime(3, setup.getTripTime());
                        pstmt.setInt(4, setupId);
                        pstmt.executeUpdate();
                    }
                } else {
                    String insertSql = "INSERT INTO bus_setup (bus_number_id, seat_layout_id, trip_price, trip_time) VALUES (?, ?, ?, ?)";
                    try (PreparedStatement pstmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                        pstmt.setInt(1, setup.getBusNumberId());
                        pstmt.setInt(2, setup.getSeatLayoutId());
                        pstmt.setBigDecimal(3, setup.getTripPrice());
                        pstmt.setTime(4, setup.getTripTime());
                        pstmt.executeUpdate();
                        try (ResultSet keys = pstmt.getGeneratedKeys()) {
                            if (!keys.next()) {
                                throw new SQLException("Bus setup was not created.");
                            }
                            setupId = keys.getInt(1);
                        }
                    }
                }

                replaceStaff(conn, setupId, staffIds);
                ensureSeats(conn, setupId, setup.getSeatLayoutId());
                conn.commit();
                return setupId;
            } catch (SQLException | RuntimeException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public boolean updateBusSetup(BusSetup setup) throws SQLException {
        String sql = "UPDATE bus_setup SET seat_layout_id = ?, trip_price = ?, trip_time = ? WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, setup.getSeatLayoutId());
            pstmt.setBigDecimal(2, setup.getTripPrice());
            pstmt.setTime(3, setup.getTripTime());
            pstmt.setInt(4, setup.getId());
            return pstmt.executeUpdate() > 0;
        }
    }

    public boolean deleteBusSetup(int id) throws SQLException {
        String sql = "DELETE FROM bus_setup WHERE id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            return pstmt.executeUpdate() > 0;
        }
    }

    public Set<Integer> getAssignedStaffIds(int busSetupId) throws SQLException {
        Set<Integer> ids = new HashSet<>();
        String sql = "SELECT staff_id FROM bus_setup_staff WHERE bus_setup_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busSetupId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getInt("staff_id"));
                }
            }
        }
        return ids;
    }

    private int findSetupIdByBusNumber(Connection conn, int busNumberId) throws SQLException {
        String sql = "SELECT id FROM bus_setup WHERE bus_number_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, busNumberId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt("id") : 0;
            }
        }
    }

    private void replaceStaff(Connection conn, int setupId, List<Integer> staffIds) throws SQLException {
        try (PreparedStatement delete = conn.prepareStatement("DELETE FROM bus_setup_staff WHERE bus_setup_id = ?")) {
            delete.setInt(1, setupId);
            delete.executeUpdate();
        }
        if (staffIds == null || staffIds.isEmpty()) {
            return;
        }
        String sql = "INSERT INTO bus_setup_staff (bus_setup_id, staff_id) VALUES (?, ?)";
        try (PreparedStatement insert = conn.prepareStatement(sql)) {
            for (Integer staffId : staffIds) {
                insert.setInt(1, setupId);
                insert.setInt(2, staffId);
                insert.addBatch();
            }
            insert.executeBatch();
        }
    }

    private void ensureSeats(Connection conn, int setupId, int seatLayoutId) throws SQLException {
        int totalSeats = 0;
        try (PreparedStatement layout = conn.prepareStatement("SELECT total_seats FROM seat_layouts WHERE id = ?")) {
            layout.setInt(1, seatLayoutId);
            try (ResultSet rs = layout.executeQuery()) {
                if (rs.next()) {
                    totalSeats = rs.getInt("total_seats");
                }
            }
        }
        if (totalSeats <= 0) {
            return;
        }
        String sql = "INSERT IGNORE INTO seats (bus_setup_id, seat_number, status) VALUES (?, ?, 'AVAILABLE')";
        try (PreparedStatement seat = conn.prepareStatement(sql)) {
            for (int i = 1; i <= totalSeats; i++) {
                seat.setInt(1, setupId);
                seat.setString(2, "S" + i);
                seat.addBatch();
            }
            seat.executeBatch();
        }
    }

    private BusSetup extractBusSetupFromResultSet(ResultSet rs) throws SQLException {
        BusSetup setup = new BusSetup();
        setup.setId(rs.getInt("id"));
        setup.setBusNumberId(rs.getInt("bus_number_id"));
        setup.setSeatLayoutId(rs.getInt("seat_layout_id"));
        setup.setTripPrice(rs.getBigDecimal("trip_price"));
        setup.setTripTime(rs.getTime("trip_time"));
        setup.setCreatedAt(rs.getTimestamp("created_at"));
        setup.setUpdatedAt(rs.getTimestamp("updated_at"));
        if (hasColumn(rs, "registration_number") && rs.getString("registration_number") != null) {
            BusNumber busNumber = new BusNumber();
            busNumber.setId(setup.getBusNumberId());
            busNumber.setRegistrationNumber(rs.getString("registration_number"));
            setup.setBusNumber(busNumber);
        }
        if (hasColumn(rs, "layout_name") && rs.getString("layout_name") != null) {
            SeatLayout layout = new SeatLayout();
            layout.setId(setup.getSeatLayoutId());
            layout.setName(rs.getString("layout_name"));
            setup.setSeatLayout(layout);
        }
        return setup;
    }

    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData metaData = rs.getMetaData();
        for (int i = 1; i <= metaData.getColumnCount(); i++) {
            if (columnName.equalsIgnoreCase(metaData.getColumnLabel(i))) {
                return true;
            }
        }
        return false;
    }
}
