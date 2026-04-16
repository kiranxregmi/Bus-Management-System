<%@ include file="../common/header.jsp" %>
<%@ page import="model.Bus, model.Route, java.util.List" %>
<%
    List<Bus> buses = (List<Bus>) request.getAttribute("buses");
    List<Route> routes = (List<Route>) request.getAttribute("routes");
    String error = (String) request.getAttribute("error");
%>

<div class="auth-container" style="max-width: 700px;">
    <h2>Create New Schedule</h2>
    <p>Assign a bus to a route on a specific date and time.</p>

    <% if (error != null) { %>
        <div class="error-message"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/admin/schedule" method="POST">
        <input type="hidden" name="action" value="add">
        
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
            <!-- BUS Selection -->
            <div class="form-group">
                <label for="busId">Select Bus</label>
                <select id="busId" name="busId" required style="width: 100%; padding: 0.75rem; border-radius: 5px; border: 1px solid #ddd;">
                    <option value="">-- Select Bus --</option>
                    <% if (buses != null) { for (Bus b : buses) { %>
                        <option value="<%= b.getId() %>"><%= b.getBusNumber() %> - <%= b.getBusName() %> (<%= b.getCapacity() %> seats)</option>
                    <% } } %>
                </select>
            </div>

            <!-- ROUTE Selection -->
            <div class="form-group">
                <label for="routeId">Select Route</label>
                <select id="routeId" name="routeId" required style="width: 100%; padding: 0.75rem; border-radius: 5px; border: 1px solid #ddd;">
                    <option value="">-- Select Route --</option>
                    <% if (routes != null) { for (Route r : routes) { %>
                        <option value="<%= r.getId() %>"><%= r.getSource() %> &rarr; <%= r.getDestination() %></option>
                    <% } } %>
                </select>
            </div>

            <!-- DATE Selection -->
            <div class="form-group">
                <label for="travelDate">Travel Date</label>
                <input type="date" id="travelDate" name="travelDate" required>
            </div>

            <!-- FARE Selection -->
            <div class="form-group">
                <label for="fare">Fare (NPR)</label>
                <input type="number" id="fare" name="fare" required placeholder="e.g., 1500" min="0">
            </div>

            <!-- TIME Selection -->
            <div class="form-group">
                <label for="departureTime">Departure Time</label>
                <input type="time" id="departureTime" name="departureTime" required>
            </div>

            <div class="form-group">
                <label for="arrivalTime">Arrival Time</label>
                <input type="time" id="arrivalTime" name="arrivalTime" required>
            </div>
        </div>

        <!-- BULK CREATE Option -->
        <div style="background: #eef2f7; padding: 1.25rem; border-radius: 10px; margin: 1.5rem 0; border-left: 5px solid var(--primary);">
            <h4 style="margin-bottom: 0.5rem; color: var(--primary);">Bulk Schedule (Optional)</h4>
            <p style="font-size: 0.85rem; color: var(--gray); margin-bottom: 1rem;">Automatically repeat this schedule for future dates.</p>
            
            <div style="display: flex; gap: 1.5rem;">
                <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                    <input type="radio" name="bulkCreate" value="none" checked> No Bulk
                </label>
                <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                    <input type="radio" name="bulkCreate" value="1week"> Daily for 1 Week
                </label>
                <label style="display: flex; align-items: center; gap: 0.5rem; cursor: pointer;">
                    <input type="radio" name="bulkCreate" value="4weeks"> Daily for 4 Weeks
                </label>
            </div>
        </div>

        <div style="display: flex; gap: 1rem; margin-top: 2rem;">
            <button type="submit" class="btn">Create Schedule</button>
            <a href="${pageContext.request.contextPath}/admin/schedule?action=list" class="btn" style="background: var(--gray); text-align: center;">Cancel</a>
        </div>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>
