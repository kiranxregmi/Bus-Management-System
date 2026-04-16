package controller;

import model.Route;
import model.User;
import service.RouteService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
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
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void listRoutes(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Route> routes = routeService.getAllRoutes();
        request.setAttribute("routes", routes);
        request.getRequestDispatcher("/admin/manageRoutes.jsp").forward(request, response);
    }

    private void addRoute(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
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
            request.getRequestDispatcher("/admin/addRoute.jsp").forward(request, response);
        }
    }

    private void deleteRoute(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        routeService.deleteRoute(id);
        response.sendRedirect(request.getContextPath() + "/admin/route?action=list&success=Route deleted successfully");
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User user = (User) session.getAttribute("user");
        return user != null && "ADMIN".equals(user.getRole());
    }
}
