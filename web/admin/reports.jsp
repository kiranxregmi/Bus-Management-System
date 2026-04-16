<%@ include file="../common/header.jsp" %>
<%@ page import="java.util.List, java.util.Map, java.sql.Date" %>
<%
    Map<String, Object> summary = (Map<String, Object>) request.getAttribute("summary");
    List<Map<String, Object>> routePerformance = (List<Map<String, Object>>) request.getAttribute("routePerformance");
    List<Map<String, Object>> busPerformance = (List<Map<String, Object>>) request.getAttribute("busPerformance");
    List<Map<String, Object>> revenueTrend = (List<Map<String, Object>>) request.getAttribute("revenueTrend");
    Date startDate = (Date) request.getAttribute("startDate");
    Date endDate = (Date) request.getAttribute("endDate");
%>

<div class="container" style="padding: 2rem 1rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <div>
            <h2 style="color: var(--primary);">Business Reports</h2>
            <p style="color: var(--gray);">Performance analytics for <%= startDate %> to <%= endDate %></p>
        </div>
        <div style="display: flex; gap: 1rem;">
            <a href="${pageContext.request.contextPath}/admin/reports?startDate=<%= startDate %>&endDate=<%= endDate %>&export=csv" class="btn" style="width: auto; background: var(--success);">Export CSV</a>
            <a href="adminDashboard.jsp" class="btn" style="width: auto; background: var(--gray);">Back</a>
        </div>
    </div>

    <!-- Filters -->
    <div style="background: var(--light); padding: 1.5rem; border-radius: 10px; margin-bottom: 2rem;">
        <form action="${pageContext.request.contextPath}/admin/reports" method="GET" style="display: flex; align-items: flex-end; gap: 1rem;">
            <div style="flex: 1;">
                <label class="search-card-label">Start Date</label>
                <input type="date" name="startDate" value="<%= startDate %>" style="padding: 0.6rem; border-radius: 5px; border: 1px solid #ddd; width: 100%;">
            </div>
            <div style="flex: 1;">
                <label class="search-card-label">End Date</label>
                <input type="date" name="endDate" value="<%= endDate %>" style="padding: 0.6rem; border-radius: 5px; border: 1px solid #ddd; width: 100%;">
            </div>
            <button type="submit" class="btn" style="width: auto; padding: 0.6rem 2rem;">Update Reports</button>
        </form>
    </div>

    <!-- Summary Cards -->
    <div class="stats-grid" style="margin-bottom: 3rem;">
        <div class="stat-card">
            <h3>Total Trips</h3>
            <div class="stat-number"><%= summary != null ? summary.get("totalTrips") : 0 %></div>
        </div>
        <div class="stat-card">
            <h3>Revenue (NPR)</h3>
            <div class="stat-number">Rs. <%= summary != null ? String.format("%.0f", summary.get("totalRevenue")) : 0 %></div>
        </div>
    </div>

    <!-- Charts & Tables -->
    <div style="display: grid; grid-template-columns: 1fr; gap: 2rem;">
        
        <!-- Revenue Trend Chart (Simple CSS Bar) -->
        <div style="background: var(--white); padding: 1.5rem; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
            <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Revenue Trend</h3>
            <div class="chart-container" style="height: 300px; display: flex; align-items: flex-end; gap: 10px; overflow-x: auto; padding-bottom: 1rem;">
                <% if (revenueTrend != null && !revenueTrend.isEmpty()) { 
                    double maxRev = 1;
                    for (Map<String, Object> t : revenueTrend) maxRev = Math.max(maxRev, (double)t.get("revenue"));
                    
                    for (Map<String, Object> t : revenueTrend) {
                        int barHeight = (int) (((double)t.get("revenue") / maxRev) * 200);
                %>
                    <div style="display: flex; flex-direction: column; align-items: center; min-width: 40px;">
                        <span style="font-size: 0.6rem; margin-bottom: 5px;">Rs. <%= String.format("%.0f", t.get("revenue")) %></span>
                        <div style="width: 30px; height: <%= barHeight %>px; background: var(--secondary); border-radius: 5px 5px 0 0;"></div>
                        <span style="font-size: 0.6rem; margin-top: 5px; transform: rotate(-45deg); white-space: nowrap;"><%= t.get("date") %></span>
                    </div>
                <% } } else { %>
                    <p style="text-align: center; width: 100%; color: var(--gray);">No trend data available for this range.</p>
                <% } %>
            </div>
        </div>

        <!-- Tables Row -->
        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
            <!-- Route Performance -->
            <div style="background: var(--white); padding: 1.5rem; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                <h3 style="color: var(--primary); margin-bottom: 1rem;">Top Routes</h3>
                <table style="font-size: 0.9rem;">
                    <thead>
                        <tr><th>Route</th><th>Trips</th><th>Revenue</th></tr>
                    </thead>
                    <tbody>
                        <% if (routePerformance != null) { for (Map<String, Object> r : routePerformance) { %>
                        <tr>
                            <td><%= r.get("route") %></td>
                            <td><%= r.get("trips") %></td>
                            <td>Rs. <%= String.format("%.0f", r.get("revenue")) %></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>

            <!-- Bus Performance -->
            <div style="background: var(--white); padding: 1.5rem; border-radius: 10px; box-shadow: 0 4px 15px rgba(0,0,0,0.05);">
                <h3 style="color: var(--primary); margin-bottom: 1rem;">Bus Utilization</h3>
                <table style="font-size: 0.9rem;">
                    <thead>
                        <tr><th>Bus #</th><th>Trips</th><th>Revenue</th></tr>
                    </thead>
                    <tbody>
                        <% if (busPerformance != null) { for (Map<String, Object> b : busPerformance) { %>
                        <tr>
                            <td><%= b.get("busNumber") %></td>
                            <td><%= b.get("trips") %></td>
                            <td>Rs. <%= String.format("%.0f", b.get("revenue")) %></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
