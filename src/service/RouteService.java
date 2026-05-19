package service;

import dao.RouteDAO;
import model.DropPoint;
import model.PickupPoint;
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

    public int addRouteWithPoints(Route route, List<PickupPoint> pickupPoints, List<DropPoint> dropPoints) throws SQLException {
        if (route.getDepartureLocationId() == route.getArrivalLocationId()) {
            throw new IllegalArgumentException("Departure and arrival locations cannot be the same.");
        }
        if (routeDAO.checkDuplicateByLocation(route.getDepartureLocationId(), route.getArrivalLocationId())) {
            throw new IllegalArgumentException("Route already exists for these locations.");
        }
        return routeDAO.addRouteWithPoints(route, pickupPoints, dropPoints);
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

    public int getRouteCount() throws SQLException {
        return routeDAO.getRouteCount();
    }

    public boolean updateRouteBusSetup(int routeId, Integer busSetupId) throws SQLException {
        return routeDAO.updateRouteBusSetup(routeId, busSetupId);
    }
}
