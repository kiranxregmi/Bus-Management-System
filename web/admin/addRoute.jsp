<%@ include file="../common/header.jsp" %>
<%
    String error = (String) request.getAttribute("error");
%>

<div class="auth-container" style="max-width: 600px;">
    <h2>Add New Route</h2>
    <p>Define a new city pair for the bus network.</p>

    <% if (error != null) { %>
        <div class="error-message"><%= error %></div>
    <% } %>

    <form action="${pageContext.request.contextPath}/admin/route" method="POST">
        <input type="hidden" name="action" value="add">
        
        <div class="form-group">
            <label for="source">Source City</label>
            <input type="text" id="source" name="source" required placeholder="e.g., Kathmandu">
        </div>

        <div class="form-group">
            <label for="destination">Destination City</label>
            <input type="text" id="destination" name="destination" required placeholder="e.g., Pokhara">
        </div>

        <div class="form-group">
            <label for="distance">Distance (km)</label>
            <input type="number" id="distance" name="distance" required placeholder="e.g., 200">
        </div>

        <div class="form-group">
            <label for="duration">Duration (HH:mm)</label>
            <input type="text" id="duration" name="duration" required placeholder="e.g., 06:30" pattern="[0-9]{2}:[0-9]{2}">
            <small style="color: var(--gray);">Format: 06:30 (hours:minutes)</small>
        </div>

        <div style="display: flex; gap: 1rem; margin-top: 1rem;">
            <button type="submit" class="btn">Save Route</button>
            <a href="manageRoutes.jsp" class="btn" style="background: var(--gray); text-align: center;">Cancel</a>
        </div>
    </form>
</div>

<%@ include file="../common/footer.jsp" %>
