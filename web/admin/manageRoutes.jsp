<%@ include file="../common/header.jsp" %>
<%@ page import="model.Route, java.util.List" %>
<%
    List<Route> routes = (List<Route>) request.getAttribute("routes");
    String success = request.getParameter("success");
%>

<div class="container" style="padding: 2rem 1rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2 style="color: var(--primary);">Manage Routes</h2>
        <div>
            <a href="adminDashboard.jsp" class="btn" style="width: auto; padding: 0.5rem 1.5rem; background: var(--gray); margin-right: 1rem;">Back</a>
            <a href="addRoute.jsp" class="btn" style="width: auto; padding: 0.5rem 1.5rem;">Add New Route</a>
        </div>
    </div>

    <% if (success != null) { %>
        <div class="success-message"><%= success %></div>
    <% } %>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Source</th>
                    <th>Destination</th>
                    <th>Distance (km)</th>
                    <th>Duration</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (routes != null && !routes.isEmpty()) { 
                    for (Route r : routes) { %>
                <tr>
                    <td><%= r.getSource() %></td>
                    <td><%= r.getDestination() %></td>
                    <td><%= r.getDistance() %> km</td>
                    <td><%= r.getDuration() %></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/route?action=delete&id=<%= r.getId() %>" 
                           class="action-btn btn-delete" 
                           onclick="return confirm('Are you sure you want to delete this route?')">Delete</a>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="5" style="text-align: center;">No routes found.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
