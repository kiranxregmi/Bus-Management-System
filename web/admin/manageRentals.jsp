<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.EventReservation, java.util.List" %>
<%@ include file="../common/header.jsp" %>

<%
    User sUser = (User) session.getAttribute("user");
    if (sUser == null || !"ADMIN".equals(sUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<EventReservation> rentals = (List<EventReservation>) request.getAttribute("rentals");
%>

<div class="container" style="padding: 2rem 1rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2 style="color: var(--primary);">Manage Event Rentals</h2>
        <a href="adminDashboard.jsp" class="btn" style="width: auto; padding: 0.5rem 1.5rem; background: var(--gray);">Dashboard</a>
    </div>

    <% if (request.getParameter("success") != null) { %>
        <div class="success-message"><%= request.getParameter("success") %></div>
    <% } %>
    <% if (request.getParameter("error") != null) { %>
        <div class="error-message"><%= request.getParameter("error") %></div>
    <% } %>

    <div class="table-container" style="background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
        <table style="width: 100%; border-collapse: collapse; text-align: left;">
            <thead style="background: var(--primary); color: white;">
                <tr>
                    <th style="padding: 1rem;">ID</th>
                    <th style="padding: 1rem;">Event & Type</th>
                    <th style="padding: 1rem;">Date</th>
                    <th style="padding: 1rem;">Passengers/Buses</th>
                    <th style="padding: 1rem;">Location</th>
                    <th style="padding: 1rem;">Status</th>
                    <th style="padding: 1rem;">Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (rentals == null || rentals.isEmpty()) { %>
                    <tr>
                        <td colspan="7" style="padding: 2rem; text-align: center; color: var(--gray);">No event reservations found.</td>
                    </tr>
                <% } else { 
                    for (EventReservation res : rentals) { 
                        String statusColor = "var(--gray)";
                        if ("APPROVED".equals(res.getStatus())) statusColor = "var(--success)";
                        else if ("REJECTED".equals(res.getStatus())) statusColor = "var(--danger)";
                        else if ("PENDING".equals(res.getStatus())) statusColor = "var(--warning)";
                %>
                    <tr style="border-bottom: 1px solid #eee;">
                        <td style="padding: 1rem;"><%= res.getId() %></td>
                        <td style="padding: 1rem;">
                            <strong><%= res.getEventName() %></strong><br>
                            <small style="color: var(--gray);"><%= res.getEventType() %></small>
                        </td>
                        <td style="padding: 1rem;">
                            Event: <%= res.getEventDate() %><br>
                            <small>Service: <%= res.getRequiredDate() %></small>
                        </td>
                        <td style="padding: 1rem;">
                            Pax: <%= res.getNumberOfPassengers() %><br>
                            Buses: <%= res.getNumberOfBuses() %> (<%= res.getPreferredBusType() %>)
                        </td>
                        <td style="padding: 1rem;">
                            From: <%= res.getPickupLocation() %><br>
                            To: <%= res.getDropoffLocation() %>
                        </td>
                        <td style="padding: 1rem;">
                            <span style="padding: 0.3rem 0.8rem; border-radius: 20px; background: <%= statusColor %>; color: white; font-size: 0.85rem; font-weight: bold;">
                                <%= res.getStatus() %>
                            </span>
                        </td>
                        <td style="padding: 1rem;">
                            <div style="display: flex; gap: 0.5rem;">
                                <form action="${pageContext.request.contextPath}/admin/rentals" method="POST" style="margin: 0;">
                                    <input type="hidden" name="id" value="<%= res.getId() %>">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <select name="status" onchange="this.form.submit()" style="padding: 0.3rem; border-radius: 5px; border: 1px solid #ddd;">
                                        <option value="PENDING" <%= "PENDING".equals(res.getStatus()) ? "selected" : "" %>>Pending</option>
                                        <option value="APPROVED" <%= "APPROVED".equals(res.getStatus()) ? "selected" : "" %>>Approve</option>
                                        <option value="REJECTED" <%= "REJECTED".equals(res.getStatus()) ? "selected" : "" %>>Reject</option>
                                        <option value="COMPLETED" <%= "COMPLETED".equals(res.getStatus()) ? "selected" : "" %>>Completed</option>
                                    </select>
                                </form>
                                <button onclick="alert('Notes: <%= res.getDescription() != null ? res.getDescription().replace("'", "\\'") : "None" %>')" 
                                        class="btn" style="width: auto; padding: 0.3rem 0.6rem; font-size: 0.8rem; background: var(--secondary);">📝</button>
                            </div>
                        </td>
                    </tr>
                <% } } %>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
