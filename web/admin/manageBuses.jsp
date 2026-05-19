<%@ include file="../common/header.jsp" %>
    <%@ page import="model.User, service.BusService, model.Bus, java.util.List" %>
        <% User user=(User) session.getAttribute("user"); if (user==null || (!"ADMIN".equals(user.getRole()) && !"OPERATOR".equals(user.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BusService busService=new
            BusService(); List<Bus> buses = busService.getAllBuses();
            %>

            <div class="container" style="padding: 2rem 1rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <h2 style="color: var(--primary);">Manage Buses</h2>
                    <% if ("ADMIN".equals(user.getRole())) { %>
                        <a href="addBus.jsp" class="btn" style="width: auto; padding: 0.75rem 2rem;">➕ Add New Bus</a>
                    <% } %>
                </div>

                <% if (request.getParameter("deleted") !=null) { %>
                    <div class="success-message">Bus deleted successfully!</div>
                    <% } %>
                        <% if (request.getParameter("added") !=null) { %>
                            <div class="success-message">Bus added successfully!</div>
                            <% } %>

                                <div class="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>ID</th>
                                                <th>Bus Number</th>
                                                <th>Bus Name</th>
                                                <th>Capacity</th>
                                                <th>Type</th>
                                                <th>Fare (NPR)</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% for (Bus bus : buses) { %>
                                                <tr>
                                                    <td>
                                                        <%= bus.getId() %>
                                                    </td>
                                                    <td>
                                                        <%= bus.getBusNumber() %>
                                                    </td>
                                                    <td>
                                                        <%= bus.getBusName() %>
                                                    </td>
                                                    <td>
                                                        <%= bus.getCapacity() %>
                                                    </td>
                                                    <td>
                                                        <%= bus.getBusType() %>
                                                    </td>
                                                    <td>
                                                        <%= bus.getFarePerSeat() %>
                                                    </td>
                                                    <td>
                                                        <span style="color: <%= " ACTIVE".equals(bus.getStatus())
                                                            ? "var(--success)" : "var(--danger)" %>;">
                                                            <%= bus.getStatus() %>
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <% if ("ADMIN".equals(user.getRole())) { %>
                                                            <a href="#" class="action-btn btn-edit">Edit</a>
                                                            <a href="${pageContext.request.contextPath}/admin/bus?action=delete&id=<%= bus.getId() %>"
                                                                class="action-btn btn-delete"
                                                                onclick="return confirm('Delete this bus?')">Delete</a>
                                                        <% } else { %>
                                                            <span class="text-gray-400">View Only</span>
                                                        <% } %>
                                                    </td>
                                                </tr>
                                                <% } %>
                                        </tbody>
                                    </table>
                                </div>

                                <div style="margin-top: 2rem;">
                                    <a href="adminDashboard.jsp" class="btn"
                                        style="width: auto; padding: 0.75rem 2rem; background: var(--gray);">← Back to
                                        Dashboard</a>
                                </div>
            </div>

            <%@ include file="../common/footer.jsp" %>