package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());

    private static final String URL = "jdbc:mysql://localhost:3306/kalpana_travels";
    private static final String USER = "root";
    private static final String PASSWORD = ""; // Your MySQL password (leave empty if none)

    private static Connection connection = null;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            LOGGER.log(java.util.logging.Level.SEVERE, "MySQL JDBC Driver not found. Add mysql-connector-java.jar to WEB-INF/lib/", e);
            throw new RuntimeException("MySQL JDBC Driver not found. Add mysql-connector-java.jar to WEB-INF/lib/", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        }
        return connection;
    }

    public static void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                LOGGER.log(java.util.logging.Level.WARNING, "Error closing database connection", e);
            }
        }
    }
}
