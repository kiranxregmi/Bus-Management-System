package service;

import dao.RouteDAO;
import model.Route;
import java.sql.SQLException;
import java.util.List;
import java.util.Set;

public class RouteService {
    private RouteDAO routeDAO = new RouteDAO();

    public boolean addRoute(Route route) throws SQLException {
        if (route.getSource().equalsIgnoreCase(route.getDestination())) {
            throw new IllegalArgumentException("Source and destination cannot be the same.");
        }
        if (routeDAO.checkDuplicate(route.getSource(), route.getDestination())) {
            throw new IllegalArgumentException("Route already exists.");
        }
        return routeDAO.addRoute(route);
    }

    public List<Route> getAllRoutes() throws SQLException {
        return routeDAO.getAllRoutes();
    }

    public Set<String> getAllCities() throws SQLException {
        return routeDAO.getAllCities();
    }

    public Route getRouteById(int id) throws SQLException {
        return routeDAO.getRouteById(id);
    }

    public boolean deleteRoute(int id) throws SQLException {
        return routeDAO.deleteRoute(id);
    }
}
