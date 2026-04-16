package util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {

    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    
    private static final String URL = "jdbc:mysql://localhost:3306/kalpana_travels";
    private static final String USER = "root";
    private static final String PASSWORD = ""; 

    private static HikariDataSource dataSource;

    static {
        try {
            HikariConfig config = new HikariConfig();
            
            // Basic settings
            config.setJdbcUrl(URL);
            config.setUsername(USER);
            config.setPassword(PASSWORD);
            config.setDriverClassName("com.mysql.cj.jdbc.Driver");

            // Pool configuration
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setConnectionTimeout(30000); // 30 seconds
            config.setIdleTimeout(600000);      // 10 minutes
            config.setMaxLifetime(1800000);     // 30 minutes
            
            // Performance optimizations for MySQL
            config.addDataSourceProperty("cachePrepStmts", "true");
            config.addDataSourceProperty("prepStmtCacheSize", "250");
            config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");

            dataSource = new HikariDataSource(config);
            LOGGER.info("HikariCP connection pool initialized successfully.");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize HikariCP connection pool.", e);
            throw new RuntimeException("Could not initialize database connection pool.", e);
        }
    }

    /**
     * Returns a connection from the pool.
     * Existing DAOs continue to use this method seamlessly.
     */
    public static Connection getConnection() throws SQLException {
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
