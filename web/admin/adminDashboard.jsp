<%@ include file="../common/header.jsp" %>
    <%@ page
        import="model.User, service.BusService, service.BookingService, service.UserService"
        %>
        <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BusService busService=new
            BusService(); BookingService bookingService=new BookingService(); UserService userService=new UserService();
            int totalBuses=busService.getBusCount(); int totalBookings=bookingService.getBookingCount(); int
            totalCustomers=userService.getUserCount(); %>

            <div class="container" style="padding: 2rem 1rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <h2 style="color: var(--primary);">Admin Dashboard</h2>
                    <a href="${pageContext.request.contextPath}/logout" class="btn"
                        style="width: auto; padding: 0.5rem 1.5rem; background: var(--danger);">Logout</a>
                </div>

                <p style="margin-bottom: 2rem;">Welcome back, <%= user.getFullName() %>! Here's what's happening with
                        Kalpana Travels today.</p>

                <div class="stats-grid">
                    <div class="stat-card">
                        <h3>Total Buses</h3>
                        <div class="stat-number">
                            <%= totalBuses %>
                        </div>
                    </div>
                    <div class="stat-card">
                        <h3>Total Routes</h3>
                        <div class="stat-number">18</div>
                    </div>
                    <div class="stat-card">
                        <h3>Total Staff</h3>
                        <div class="stat-number">56</div>
                    </div>
                    <div class="stat-card">
                        <h3>Total Customers</h3>
                        <div class="stat-number">
                            <%= totalCustomers %>
                        </div>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin: 2rem 0;">
                    <a href="manageBuses.jsp" class="stat-card" style="text-decoration: none;">
                        <h3>Manage Buses</h3>
                        <p>Add, edit, or remove buses</p>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/schedule?action=list" class="stat-card" style="text-decoration: none;">
                        <h3>Manage Schedules</h3>
                        <p>Assign buses to routes and times</p>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/route?action=list" class="stat-card" style="text-decoration: none;">
                        <h3>Manage Routes</h3>
                        <p>Define city pairs and distances</p>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/trip-sheet" class="stat-card" style="text-decoration: none;">
                        <h3>Daily Trip Sheet</h3>
                        <p>Track live bus operations</p>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/bus?action=viewBookings" class="stat-card" style="text-decoration: none;">
                        <h3>View All Bookings</h3>
                        <p>See all customer bookings</p>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/reports" class="stat-card" style="text-decoration: none;">
                        <h3>System Reports</h3>
                        <p>Business analytics and revenue</p>
                    </a>
                </div>

                <div style="background: var(--white); padding: 1.5rem; border-radius: 10px;">
                    <h3 style="color: var(--primary); margin-bottom: 1rem;">Booking Analytics</h3>
                    <p style="color: var(--gray);">Monthly bookings and revenue</p>

                    <div class="chart-container" style="margin-top: 2rem;">
                        <% String[] months={"Jan", "Feb" , "Mar" , "Apr" , "May" , "Jun" }; int[] bookings={850, 920,
                            1100, 1250, 1400, 1650}; int[] revenue={680000, 736000, 880000, 1000000, 1120000, 1320000};
                            int maxRevenue=1320000; for (int i=0; i < months.length; i++) { int
                            bookingHeight=(bookings[i] * 100) / 2000; int revenueHeight=(revenue[i] * 100) / maxRevenue;
                            %>
                            <div class="chart-bar-wrapper">
                                <div style="display: flex; gap: 5px; align-items: flex-end; height: 200px;">
                                    <div class="chart-bar" style="--height: <%= bookingHeight %>px; --bg: var(--primary);">
                                    </div>
                                    <div class="chart-bar" style="--height: <%= revenueHeight %>px; --bg: var(--secondary);">
                                    </div>
                                </div>
                                <span style="margin-top: 0.5rem;">
                                    <%= months[i] %>
                                </span>
                            </div>
                            <% } %>
                    </div>

                    <div style="display: flex; justify-content: center; gap: 2rem; margin-top: 1rem;">
                        <span><span style="background: var(--primary); padding: 0 10px;">&nbsp;</span> Bookings</span>
                        <span><span style="background: var(--secondary); padding: 0 10px;">&nbsp;</span> Revenue
                            (NPR)</span>
                    </div>
                </div>

                <div style="background: var(--white); padding: 1.5rem; border-radius: 10px; margin-top: 2rem;">
                    <h3 style="color: var(--primary); margin-bottom: 1rem;">Recent Bookings</h3>
                    <p>Total confirmed bookings: <strong>
                            <%= totalBookings %>
                        </strong></p>
                    <p style="margin-top: 1rem;"><a
                            href="${pageContext.request.contextPath}/admin/bus?action=viewBookings"
                            style="color: var(--secondary);">View all bookings</a></p>
                </div>
            </div>

            <%@ include file="../common/footer.jsp" %>