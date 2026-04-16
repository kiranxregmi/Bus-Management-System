<%@ include file="../common/header.jsp" %>
<%@ page import="model.Schedule, model.User, java.util.List, java.util.Map, java.sql.Date" %>
<%
    List<Schedule> schedules = (List<Schedule>) request.getAttribute("schedules");
    Map<Integer, Integer> passengerCounts = (Map<Integer, Integer>) request.getAttribute("passengerCounts");
    Date selectedDate = (Date) request.getAttribute("selectedDate");
    List<User> drivers = (List<User>) request.getAttribute("drivers");
    List<User> conductors = (List<User>) request.getAttribute("conductors");
    String success = request.getParameter("success");
%>

<div class="container" style="padding: 2rem 1rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2 style="color: var(--primary);">Daily Trip Sheet</h2>
        <a href="adminDashboard.jsp" class="btn" style="width: auto; padding: 0.5rem 1.5rem; background: var(--gray);">Back to Dashboard</a>
    </div>

    <!-- Date selector -->
    <div style="background: var(--light); padding: 1.5rem; border-radius: 10px; margin-bottom: 2rem;">
        <form action="${pageContext.request.contextPath}/admin/trip-sheet" method="GET" style="display: flex; align-items: flex-end; gap: 1rem;">
            <div style="flex: 1;">
                <label class="search-card-label">Operational Date</label>
                <input type="date" name="date" value="<%= selectedDate %>" onchange="this.form.submit()" style="padding: 0.6rem; border-radius: 5px; border: 1px solid #ddd; width: 100%;">
            </div>
            <button type="submit" class="btn" style="width: auto; padding: 0.6rem 2rem;">Refresh</button>
        </form>
    </div>

    <% if (success != null) { %>
        <div class="success-message"><%= success %></div>
    <% } %>

    <div class="table-container">
        <table>
            <thead>
                <tr>
                    <th>Bus & Route</th>
                    <th>Time</th>
                    <th>Staff</th>
                    <th>Pax</th>
                    <th>Status</th>
                    <th>Operational Actions</th>
                </tr>
            </thead>
            <tbody>
                <% if (schedules != null && !schedules.isEmpty()) { 
                    for (Schedule s : schedules) { 
                        int pax = passengerCounts != null ? passengerCounts.getOrDefault(s.getId(), 0) : 0;
                %>
                <tr>
                    <td>
                        <strong><%= s.getBus().getBusNumber() %></strong><br>
                        <small><%= s.getRoute().getSource() %> &rarr; <%= s.getRoute().getDestination() %></small>
                    </td>
                    <td>
                        <small>Sch: <%= s.getDepartureTime() %></small><br>
                        <% if (s.getActualDeparture() != null) { %>
                            <small style="color: var(--success);">Act: <%= s.getActualDeparture() %></small>
                        <% } %>
                    </td>
                    <td>
                        <% if (s.getDriverId() == null) { %>
                            <span style="color: var(--danger); font-size: 0.8rem;">No Staff Assigned</span>
                        <% } else { %>
                            <small>D: <%= s.getDriverId() %></small><br>
                            <small>C: <%= s.getConductorId() %></small>
                        <% } %>
                    </td>
                    <td>
                        <span style="font-weight: bold; color: var(--primary);"><%= pax %></span>
                        <small>/ <%= s.getBus().getCapacity() %></small>
                    </td>
                    <td>
                        <span class="bus-type" style="background: <%= getStatusColor(s.getStatus()) %>;">
                            <%= s.getStatus() %>
                        </span>
                    </td>
                    <td>
                        <div style="display: flex; flex-direction: column; gap: 5px;">
                            <!-- Assignment Button -->
                            <button type="button" class="action-btn btn-edit" onclick="showStaffModal(<%= s.getId() %>)" style="margin: 0;">Assign Staff</button>
                            
                            <!-- Status Update Actions -->
                            <form action="${pageContext.request.contextPath}/admin/trip-sheet" method="POST" style="margin: 0;">
                                <input type="hidden" name="scheduleId" value="<%= s.getId() %>">
                                <input type="hidden" name="date" value="<%= selectedDate %>">
                                <input type="hidden" name="action" value="updateStatus">
                                
                                <% if ("SCHEDULED".equals(s.getStatus()) || "DRIVER_ASSIGNED".equals(s.getStatus())) { %>
                                    <button type="submit" name="status" value="BOARDING" class="action-btn" style="background: var(--warning); color: #000; width: 100%; margin: 0;">Start Boarding</button>
                                <% } else if ("BOARDING".equals(s.getStatus())) { %>
                                    <button type="submit" name="status" value="DEPARTED" class="action-btn" style="background: var(--primary); color: #fff; width: 100%; margin: 0;">Depart</button>
                                <% } else if ("DEPARTED".equals(s.getStatus())) { %>
                                    <button type="submit" name="status" value="ARRIVED" class="action-btn" style="background: var(--success); color: #fff; width: 100%; margin: 0;">Arrive</button>
                                <% } %>
                            </form>
                        </div>
                    </td>
                </tr>
                <% } } else { %>
                <tr>
                    <td colspan="6" style="text-align: center;">No trips scheduled for this date.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Simple Staff Assignment Modal (Hidden by default) -->
<div id="staffModal" style="display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.5); z-index: 2000; align-items: center; justify-content: center;">
    <div class="auth-container" style="max-width: 400px; margin: 0;">
        <h3>Assign Staff</h3>
        <form action="${pageContext.request.contextPath}/admin/trip-sheet" method="POST">
            <input type="hidden" name="action" value="assignStaff">
            <input type="hidden" name="scheduleId" id="modalScheduleId">
            <input type="hidden" name="date" value="<%= selectedDate %>">
            
            <div class="form-group">
                <label>Select Driver</label>
                <select name="driverId" required style="width: 100%; padding: 0.75rem;">
                    <% for (User d : drivers) { %>
                        <option value="<%= d.getId() %>"><%= d.getFullName() %></option>
                    <% } %>
                </select>
            </div>
            
            <div class="form-group">
                <label>Select Conductor</label>
                <select name="conductorId" required style="width: 100%; padding: 0.75rem;">
                    <% for (User c : conductors) { %>
                        <option value="<%= c.getId() %>"><%= c.getFullName() %></option>
                    <% } %>
                </select>
            </div>
            
            <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                <button type="submit" class="btn">Assign</button>
                <button type="button" class="btn" onclick="hideStaffModal()" style="background: var(--gray);">Cancel</button>
            </div>
        </form>
    </div>
</div>

<script>
    function showStaffModal(id) {
        document.getElementById('modalScheduleId').value = id;
        document.getElementById('staffModal').style.display = 'flex';
    }
    function hideStaffModal() {
        document.getElementById('staffModal').style.display = 'none';
    }
</script>

<%!
    String getStatusColor(String status) {
        if (status == null) return "#eee";
        switch (status) {
            case "SCHEDULED": return "#e0e0e0";
            case "DRIVER_ASSIGNED": return "#bbdefb";
            case "BOARDING": return "#fff9c4";
            case "DEPARTED": return "#c8e6c9";
            case "ARRIVED": return "#a5d6a7";
            case "CANCELLED": return "#ffcdd2";
            default: return "#eee";
        }
    }
%>

<%@ include file="../common/footer.jsp" %>
