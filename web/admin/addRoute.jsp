<%@ include file="../common/header.jsp" %>
<%@ page import="java.util.*, model.Location, dao.LocationDAO" %>
<%
    String error = (String) request.getAttribute("error");
    List<Location> locations = (List<Location>) request.getAttribute("locations");
    if (locations == null) {
        locations = new LocationDAO().getAllLocations();
    }
%>

<div class="container" style="padding: 2rem 1rem;">
    <div style="display:flex;justify-content:space-between;gap:1rem;align-items:center;margin-bottom:1.5rem;">
        <div>
            <h2 style="color:var(--primary);">Route Setup</h2>
            <p style="color:var(--gray);">Configure a route with pickup and drop points, timings, and prices.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/route?action=list" class="btn" style="width:auto;background:var(--gray);">Back</a>
    </div>

    <% if (error != null) { %>
        <div class="error-message"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/admin/route" method="POST" class="panel-form">
        <input type="hidden" name="action" value="add">

        <section class="admin-panel">
            <h3>Route Details</h3>
            <div class="form-grid four">
                <div class="form-group">
                    <label>Departure Route</label>
                    <select name="departureLocationId" required>
                        <option value="">Select departure</option>
                        <% for (Location loc : locations) { %>
                            <option value="<%= loc.getId() %>"><%= loc.getName() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Arrival Route</label>
                    <select name="arrivalLocationId" required>
                        <option value="">Select arrival</option>
                        <% for (Location loc : locations) { %>
                            <option value="<%= loc.getId() %>"><%= loc.getName() %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Duration (Hours)</label>
                    <input type="number" name="durationHours" min="0.25" step="0.25" required>
                </div>
                <div class="form-group">
                    <label>Distance (Km)</label>
                    <input type="number" name="distanceKm" min="1" step="0.1" required>
                </div>
            </div>
            <div class="form-group">
                <label>Remarks</label>
                <textarea name="remarks" rows="3" placeholder="Optional notes for this route"></textarea>
            </div>
        </section>

        <section class="admin-panel">
            <div class="section-heading">
                <h3>Pickup Points</h3>
                <button type="button" class="btn btn-small" onclick="addPoint('pickup')">Add Pickup Point</button>
            </div>
            <div id="pickupRows" class="dynamic-rows"></div>
        </section>

        <section class="admin-panel">
            <div class="section-heading">
                <h3>Drop Points</h3>
                <button type="button" class="btn btn-small" onclick="addPoint('drop')">Add Drop Point</button>
            </div>
            <div id="dropRows" class="dynamic-rows"></div>
        </section>

        <button type="submit" class="btn" style="width:auto;padding:.85rem 2rem;">Save Route Setup</button>
    </form>
</div>

<template id="locationOptions">
    <option value="">Select location</option>
    <% for (Location loc : locations) { %>
        <option value="<%= loc.getId() %>"><%= loc.getName() %></option>
    <% } %>
</template>

<script>
    function addPoint(type) {
        const rows = document.getElementById(type + 'Rows');
        const options = document.getElementById('locationOptions').innerHTML;
        const isPickup = type === 'pickup';
        const row = document.createElement('div');
        row.className = 'dynamic-row';
        row.innerHTML =
            '<div class="form-group"><label>' + (isPickup ? 'Pickup Point' : 'Drop Point') + '</label><select name="' + type + 'LocationId" required>' + options + '</select></div>' +
            '<div class="form-group"><label>' + (isPickup ? 'Pickup Route' : 'Drop Route') + '</label><input type="text" name="' + type + 'Route" required placeholder="Counter / stop detail"></div>' +
            '<div class="form-group"><label>Time</label><input type="time" name="' + type + 'Time" required></div>' +
            '<div class="form-group"><label>Price</label><input type="number" name="' + type + 'Price" min="0" step="0.01" required></div>' +
            '<button type="button" class="action-btn btn-delete" onclick="this.parentElement.remove()">Remove</button>';
        rows.appendChild(row);
    }

    addPoint('pickup');
    addPoint('drop');
</script>

<%@ include file="../common/footer.jsp" %>
