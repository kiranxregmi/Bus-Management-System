package util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.logging.Logger;

@WebListener
public class AppContextListener implements ServletContextListener {

    private static final Logger LOGGER = Logger.getLogger(AppContextListener.class.getName());

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        LOGGER.info("Application starting up...");
        // DBConnection pool will be initialized lazily on first call 
        // to getConnection() or we can force it here.
        try {
            DBConnection.getConnection().close();
            LOGGER.info("Database connection pool pre-warmed.");
        } catch (Exception e) {
            LOGGER.severe("Failed to pre-warm database connection pool: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        LOGGER.info("Application shutting down. Closing connection pool...");
        DBConnection.shutdown();
    }
}
