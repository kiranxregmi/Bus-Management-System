<%@ include file="../common/header.jsp" %>
<%@ page import="model.User, service.BusService, service.BookingService, service.RouteService, dao.EventReservationDAO, model.EventReservation, java.util.*, java.time.*, java.time.format.TextStyle" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"OPERATOR".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    BusService busService = new BusService();
    RouteService routeService = new RouteService();
    BookingService bookingService = new BookingService();

    int totalBuses = busService.getBusCount();
    int totalRoutes = routeService.getRouteCount();
    int todayBookings = bookingService.getTodayBookingCount();
    double todayRevenue = bookingService.getTodayRevenue();
    List<Map<String, Object>> chartRows = bookingService.getLast7DayBookingStats();
    List<Map<String, Object>> recentBookings = bookingService.getRecentBookingRows(10);
    List<EventReservation> recentRentals = new ArrayList<>();
    try {
        recentRentals = new EventReservationDAO().getAll();
    } catch (Exception e) {
        e.printStackTrace();
    }

    Map<LocalDate, Integer> countsByDate = new HashMap<>();
    for (Map<String, Object> row : chartRows) {
        java.sql.Date date = (java.sql.Date) row.get("date");
        countsByDate.put(date.toLocalDate(), (Integer) row.get("count"));
    }
    StringBuilder chartLabels = new StringBuilder();
    StringBuilder chartCounts = new StringBuilder();
    for (int i = 6; i >= 0; i--) {
        LocalDate day = LocalDate.now().minusDays(i);
        if (chartLabels.length() > 0) {
            chartLabels.append(",");
            chartCounts.append(",");
        }
        chartLabels.append("'").append(day.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH)).append("'");
        chartCounts.append(countsByDate.getOrDefault(day, 0));
    }
%>

<div class="admin-shell" id="adminShell">
    <div class="container" style="padding:2rem 1rem;">
        <div class="dashboard-topbar">
            <div>
                <h2>Admin Dashboard</h2>
                <p>Welcome back, <%= user.getFullName() %>. Here is today's operating snapshot.</p>
            </div>
            <div class="topbar-actions">
                <button class="btn btn-small" type="button" onclick="toggleDashboardTheme()">Dark / Light</button>
                <a href="${pageContext.request.contextPath}/admin/management-center.jsp" class="btn btn-small">Management Center</a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-small danger">Logout</a>
            </div>
        </div>

        <div class="kpi-grid">
            <div class="kpi-card"><span>Total Bus</span><strong><%= totalBuses %></strong></div>
            <div class="kpi-card"><span>Total Route</span><strong><%= totalRoutes %></strong></div>
            <div class="kpi-card"><span>Today's Booking</span><strong><%= todayBookings %></strong></div>
            <div class="kpi-card"><span>Today's Revenue</span><strong>NPR <%= String.format("%,.2f", todayRevenue) %></strong></div>
        </div>

        <div class="dashboard-grid">
            <section class="admin-panel">
                <h3>Last 7 Days Seat Booking</h3>
                <canvas id="bookingChart" height="120"></canvas>
            </section>

            <section class="admin-panel quick-links">
                <h3>Admin Sections</h3>
                <a href="${pageContext.request.contextPath}/admin/buses.jsp">Bus Management</a>
                <a href="${pageContext.request.contextPath}/admin/bus-numbers.jsp">Bus Numbers</a>
                <a href="${pageContext.request.contextPath}/admin/staff.jsp">Staff Management</a>
                <a href="${pageContext.request.contextPath}/admin/passengers.jsp">Passenger Management</a>
                <a href="${pageContext.request.contextPath}/admin/locations.jsp">Locations</a>
                <a href="${pageContext.request.contextPath}/admin/route?action=list">Route Setup</a>
                <a href="${pageContext.request.contextPath}/admin/seat-layouts.jsp">Seat Layouts</a>
                <a href="${pageContext.request.contextPath}/admin/bus-setup.jsp">Bus Setup</a>
                <a href="${pageContext.request.contextPath}/admin/rentals">Event Rentals</a>
                <% if ("ADMIN".equals(user.getRole())) { %>
                    <a href="${pageContext.request.contextPath}/admin/addOperator.jsp">Create Operator</a>
                <% } %>
            </section>
        </div>

        <section class="admin-panel">
            <h3>Recent Bookings</h3>
            <div class="table-container flat">
                <table>
                    <thead>
                        <tr>
                            <th>Passenger Name</th>
                            <th>Bus Name</th>
                            <th>Route</th>
                            <th>Booking Date</th>
                            <th>Price</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (recentBookings.isEmpty()) { %>
                        <tr><td colspan="6" style="text-align:center;">No bookings yet.</td></tr>
                    <% } else {
                        for (Map<String, Object> booking : recentBookings) { %>
                            <tr>
                                <td><%= booking.get("passengerName") != null ? booking.get("passengerName") : "-" %></td>
                                <td><%= booking.get("busName") != null ? booking.get("busName") : "-" %></td>
                                <td><%= booking.get("routeFrom") != null ? booking.get("routeFrom") : "-" %> -> <%= booking.get("routeTo") != null ? booking.get("routeTo") : "-" %></td>
                                <td><%= booking.get("bookingDate") %></td>
                                <td>NPR <%= String.format("%,.2f", (Double) booking.get("price")) %></td>
                                <td><span class="status-pill"><%= booking.get("status") %></span></td>
                            </tr>
                    <% }} %>
                    </tbody>
                </table>
            </div>
        </section>

        <section class="admin-panel" style="margin-top: 2rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                <h3>Recent Event Rental Requests</h3>
                <a href="${pageContext.request.contextPath}/admin/rentals" class="btn btn-small">Manage Rentals</a>
            </div>
            <div class="table-container flat">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Event Name</th>
                            <th>Type</th>
                            <th>Service Date</th>
                            <th>Passengers / Buses</th>
                            <th>Route</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (recentRentals.isEmpty()) { %>
                        <tr><td colspan="7" style="text-align:center;">No rental requests yet.</td></tr>
                    <% } else {
                        for (EventReservation res : recentRentals) { %>
                            <tr>
                                <td><%= res.getId() %></td>
                                <td><strong><%= res.getEventName() %></strong></td>
                                <td><%= res.getEventType() %></td>
                                <td><%= res.getRequiredDate() %></td>
                                <td>Pax: <%= res.getNumberOfPassengers() %>, Buses: <%= res.getNumberOfBuses() %></td>
                                <td><%= res.getPickupLocation() %> -> <%= res.getDropoffLocation() %></td>
                                <td><span class="status-pill"><%= res.getStatus() %></span></td>
                            </tr>
                    <% }} %>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    new Chart(document.getElementById('bookingChart'), {
        type: 'bar',
        data: {
            labels: [<%= chartLabels %>],
            datasets: [{
                label: 'Booked seats',
                data: [<%= chartCounts %>],
                backgroundColor: '#1a3e6f',
                borderRadius: 8
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: { y: { beginAtZero: true, ticks: { precision: 0 } } }
        }
    });

    function toggleDashboardTheme() {
        document.getElementById('adminShell').classList.toggle('dark');
    }
</script>

<%@ include file="../common/footer.jsp" %>
