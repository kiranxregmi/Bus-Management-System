package controller;

import dao.LocationDAO;
import model.Route;
import model.User;
import model.Location;
import model.PickupPoint;
import model.DropPoint;
import service.RouteService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin/route")
public class AdminRouteServlet extends HttpServlet {
    private RouteService routeService = new RouteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "delete":
                    deleteRoute(request, response);
                    break;
                case "add":
                    showAddRoute(request, response);
                    break;
                case "list":
                default:
                    listRoutes(request, response);
                    break;

            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                addRoute(request, response);
            } else if ("settings".equals(action)) {
                saveRouteSettings(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listRoutes(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Route> routes = routeService.getAllRoutes();
        request.setAttribute("routes", routes);
        
        // Load data needed for settings modal
        request.setAttribute("busNames", new dao.BusNameDAO().getAllBusNames());
        request.setAttribute("busNumbers", new dao.BusNumberDAO().getAllBusNumbers());
        request.setAttribute("seatLayouts", new dao.SeatLayoutDAO().getAllSeatLayouts());
        request.setAttribute("staffList", new dao.StaffDAO().getAllStaff());
        
        request.getRequestDispatcher("/admin/manageRoutes.jsp").forward(request, response);
    }

    private void showAddRoute(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        request.setAttribute("locations", new LocationDAO().getAllLocations());
        request.getRequestDispatcher("/admin/addRoute.jsp").forward(request, response);
    }

    private void addRoute(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        String departureIdValue = request.getParameter("departureLocationId");
        if (departureIdValue != null && !departureIdValue.isBlank()) {
            addComplexRoute(request, response);
            return;
        }

        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        int distance = Integer.parseInt(request.getParameter("distance"));
        String duration = request.getParameter("duration");

        Route route = new Route(source, destination, distance, duration);
        try {
            routeService.addRoute(route);
            response.sendRedirect(request.getContextPath() + "/admin/route?action=list&success=Route added successfully");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            showAddRoute(request, response);
        }
    }

    private void addComplexRoute(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        try {
            int departureLocationId = Integer.parseInt(request.getParameter("departureLocationId"));
            int arrivalLocationId = Integer.parseInt(request.getParameter("arrivalLocationId"));
            BigDecimal durationHours = new BigDecimal(request.getParameter("durationHours"));
            BigDecimal distanceKm = new BigDecimal(request.getParameter("distanceKm"));

            LocationDAO locationDAO = new LocationDAO();
            Location departure = locationDAO.getLocationById(departureLocationId);
            Location arrival = locationDAO.getLocationById(arrivalLocationId);
            if (departure == null || arrival == null) {
                throw new IllegalArgumentException("Please select valid departure and arrival locations.");
            }

            Route route = new Route();
            route.setDepartureLocationId(departureLocationId);
            route.setArrivalLocationId(arrivalLocationId);
            route.setSource(departure.getName());
            route.setDestination(arrival.getName());
            route.setDurationHours(durationHours);
            route.setDistanceKm(distanceKm);
            route.setDistance(distanceKm.intValue());
            route.setDuration(durationHours + " hours");
            route.setRemarks(request.getParameter("remarks"));

            routeService.addRouteWithPoints(route, parsePickupPoints(request), parseDropPoints(request));
            response.sendRedirect(request.getContextPath() + "/admin/route?action=list&success=Route configured successfully");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Duration, distance, locations, and prices must be valid numbers.");
            showAddRoute(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            showAddRoute(request, response);
        }
    }

    private List<PickupPoint> parsePickupPoints(HttpServletRequest request) {
        List<PickupPoint> points = new ArrayList<>();
        String[] locationIds = request.getParameterValues("pickupLocationId");
        String[] routes = request.getParameterValues("pickupRoute");
        String[] times = request.getParameterValues("pickupTime");
        String[] prices = request.getParameterValues("pickupPrice");
        if (locationIds == null) {
            return points;
        }
        for (int i = 0; i < locationIds.length; i++) {
            if (locationIds[i] == null || locationIds[i].isBlank() || times[i] == null || times[i].isBlank()) {
                continue;
            }
            PickupPoint point = new PickupPoint();
            point.setLocationId(Integer.parseInt(locationIds[i]));
            point.setPickupRoute(valueAt(routes, i));
            point.setPickupTime(Time.valueOf(times[i] + ":00"));
            point.setPrice(new BigDecimal(valueAt(prices, i, "0")));
            points.add(point);
        }
        return points;
    }

    private List<DropPoint> parseDropPoints(HttpServletRequest request) {
        List<DropPoint> points = new ArrayList<>();
        String[] locationIds = request.getParameterValues("dropLocationId");
        String[] routes = request.getParameterValues("dropRoute");
        String[] times = request.getParameterValues("dropTime");
        String[] prices = request.getParameterValues("dropPrice");
        if (locationIds == null) {
            return points;
        }
        for (int i = 0; i < locationIds.length; i++) {
            if (locationIds[i] == null || locationIds[i].isBlank() || times[i] == null || times[i].isBlank()) {
                continue;
            }
            DropPoint point = new DropPoint();
            point.setLocationId(Integer.parseInt(locationIds[i]));
            point.setDropRoute(valueAt(routes, i));
            point.setDropTime(Time.valueOf(times[i] + ":00"));
            point.setPrice(new BigDecimal(valueAt(prices, i, "0")));
            points.add(point);
        }
        return points;
    }

    private String valueAt(String[] values, int index) {
        return valueAt(values, index, "");
    }

    private String valueAt(String[] values, int index, String defaultValue) {
        if (values == null || index >= values.length || values[index] == null || values[index].isBlank()) {
            return defaultValue;
        }
        return values[index].trim();
    }

    private void deleteRoute(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        routeService.deleteRoute(id);
        response.sendRedirect(request.getContextPath() + "/admin/route?action=list&success=Route deleted successfully");
    }

    private void saveRouteSettings(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int routeId = Integer.parseInt(request.getParameter("routeId"));
        int busNumberId = Integer.parseInt(request.getParameter("busNumberId"));
        int seatLayoutId = Integer.parseInt(request.getParameter("seatLayoutId"));
        BigDecimal tripPrice = new BigDecimal(request.getParameter("tripPrice"));
        String tripTimeStr = request.getParameter("tripTime");
        if (tripTimeStr.length() == 5) {
            tripTimeStr += ":00";
        }
        java.sql.Time tripTime = java.sql.Time.valueOf(tripTimeStr);

        String[] staffIdsStr = request.getParameterValues("staffIds");
        List<Integer> staffIds = new ArrayList<>();
        if (staffIdsStr != null) {
            for (String idStr : staffIdsStr) {
                staffIds.add(Integer.parseInt(idStr));
            }
        }

        model.BusSetup setup = new model.BusSetup();
        setup.setBusNumberId(busNumberId);
        setup.setSeatLayoutId(seatLayoutId);
        setup.setTripPrice(tripPrice);
        setup.setTripTime(tripTime);

        dao.BusSetupDAO setupDAO = new dao.BusSetupDAO();
        int setupId = setupDAO.saveOrUpdateBusSetup(setup, staffIds);
        
        routeService.updateRouteBusSetup(routeId, setupId);

        response.sendRedirect(request.getContextPath() + "/admin/route?action=list&success=Route settings saved successfully");
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && user.hasRole("ADMIN");
    }
}
