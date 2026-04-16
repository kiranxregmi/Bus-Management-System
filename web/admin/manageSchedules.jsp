<%@ include file="../common/header.jsp" %>
<%@ page import="model.Schedule, java.util.List, java.sql.Date" %>
<%
    List<Schedule> schedules = (List<Schedule>) request.getAttribute("schedules");
    Date selectedDate = (Date) request.getAttribute("selectedDate");
    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<div class="container" style="padding: 2rem 1rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2 style="color: var(--primary);">Bus Schedules</h2>
        <div>
            <a href="adminDashboard.jsp" class="btn" style="width: auto; padding: 0.5rem 1.5rem; background: var(--gray); margin-right: 1rem;">Back</a>
            <a href="${pageContext.request.contextPath}/admin/schedule?action=add" class="btn" style="width: auto; padding: 0.5rem 1.5rem;">Add New Schedule</a>
        </div>
    </div>

    <!-- Date selector -->
    <div style="background: var(--light); padding: 1.5rem; border-radius: 10px; margin-bottom: 2rem;">
        <form action="${pageContext.request.contextPath}/admin/schedule" method="GET" style="display: flex; align-items: flex-end; gap: 1rem;">
            <input type="hidden" name="action" value="list">
            <div style="flex: 1;">
                <label class="search-card-label">View Date</label>
                <input type="date" name="date" value="<%= selectedDate %>" onchange="this.form.submit()" style="padding: 0.6rem; border-radius: 5px; border: 1px solid #ddd; width: 100%;">
            </div>
            <button type="submit" class="btn" style="width: auto; padding: 0.6rem 2rem;">Filter</button>
        </form>
    </div>

    <% if (success != null) { %>
        <div class="success-message"><%= success %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="error-message"><%= error %></div>
    <% } %>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Bus</th>
                    <th>Route</th>
                    <th>Departure</th>
                    <th>Arrival</th>
                    <th>Seats Left</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (schedules != null && !schedules.isEmpty()) { 
                    for (Schedule s : schedules) { %>
                <tr>
                    <td>
                        <strong><%= s.getBus().getBusNumber() %></strong><br>
                        <small><%= s.getBus().getBusName() %></small>
                    </td>
                    <td>
                        <%= s.getRoute().getSource() %> &rarr; <%= s.getRoute().getDestination() %>
                    </td>
                    <td><%= s.getDepartureTime() %></td>
                    <td><%= s.getArrivalTime() %></td>
                    <td><%= s.getAvailableSeats() %> / <%= s.getBus().getCapacity() %></td>
                    <td>
                        <span class="bus-type" style="background: <%= "CANCELLED".equals(s.getStatus()) ? "#ffcccc" : "#e8f5e9" %>;">
                            <%= s.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/schedule?action=delete&id=<%= s.getId() %>&date=<%= selectedDate %>" 
                           class="action-btn btn-delete" 
                           onclick="return confirm('Delete this schedule?')">Delete</a>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="7" style="text-align: center;">No schedules for this date.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
