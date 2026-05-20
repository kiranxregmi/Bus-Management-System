package util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    
    private static final String USER = "root";
    private static final String PASSWORD = ""; 

    private static HikariDataSource dataSource;

    private static int detectMySQLPort() {
        int[] ports = {3307, 3306};
        for (int port : ports) {
            try (java.net.Socket socket = new java.net.Socket()) {
                socket.connect(new java.net.InetSocketAddress("localhost", port), 200);
                LOGGER.info("Detected active service on port " + port + ". Using it for database connection.");
                return port;
            } catch (Exception e) {
                // Try next port
            }
        }
        LOGGER.warning("Could not detect any service on port 3306 or 3307. Defaulting database port to 3306.");
        return 3306;
    }

    static {
        try {
            int port = detectMySQLPort();
            String jdbcUrl = "jdbc:mysql://localhost:" + port + "/kalpana_travels";
            
            HikariConfig config = new HikariConfig();
            
            // Basic settings
            config.setJdbcUrl(jdbcUrl);
            config.setUsername(USER);
            config.setPassword(PASSWORD);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            // Pool configuration
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setConnectionTimeout(5000);  // 5 seconds
            config.setIdleTimeout(600000);      // 10 minutes
            config.setMaxLifetime(1800000);     // 30 minutes
            config.setInitializationFailTimeout(-1);
            
            // Performance optimizations for MySQL
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);
            LOGGER.info("HikariCP connection pool initialized successfully.");
            
            // Run auto migrations
            try (Connection conn = dataSource.getConnection();
                 Statement stmt = conn.createStatement()) {
                try {
                    stmt.executeUpdate("ALTER TABLE routes ADD COLUMN bus_setup_id INT DEFAULT NULL");
                } catch (SQLException ignore) {}
                try {
                    stmt.executeUpdate("ALTER TABLE routes ADD CONSTRAINT fk_route_bus_setup FOREIGN KEY (bus_setup_id) REFERENCES bus_setup(id) ON DELETE SET NULL");
                } catch (SQLException ignore) {}
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Auto migration failed or already run: " + e.getMessage());
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize HikariCP connection pool.", e);
            dataSource = null;
        }
    }
    /**
     * Returns a connection from the pool.
     * Existing DAOs continue to use this method seamlessly.
     */
    public static Connection getConnection() throws SQLException {
        if (dataSource == null) {
            throw new SQLException("Database connection pool is not available. Check MySQL and DB settings.");
        }
        return dataSource.getConnection();
    }

    /**
     * Closes the data source. Call this when application stops.
     */
    public static void shutdown() {
        if (dataSource != null) {
            dataSource.close();
            LOGGER.info("HikariCP connection pool shut down successfully.");
        }
    }
}
