<%@ include file="../common/header.jsp" %>
    <%@ page import="model.User, model.LoyaltyPoint, dao.LoyaltyPointDAO, dao.BookingDAO" %>
        <% User user=(User) session.getAttribute("user"); if (user==null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } %>
        <% BookingDAO bookingDAO = new BookingDAO(); LoyaltyPointDAO loyaltyDAO = new LoyaltyPointDAO();
           int bookingCount = bookingDAO.getBookingCountByUser(user.getId());
           LoyaltyPoint loyalty = loyaltyDAO.getLoyaltyPointsByUserId(user.getId());
           int loyaltyPoints = loyalty != null ? loyalty.getPointsBalance() : 0; %>

            <div class="container" style="padding: 3rem 1rem;">
                <h2 style="color: var(--primary); margin-bottom: 2rem;">Welcome back, <%= user.getFullName() %>!</h2>

                <div class="stats-grid">
                    <div class="stat-card">
                        <h3>Total Bookings</h3>
                        <div class="stat-number"><%= bookingCount %></div>
                    </div>
                    <div class="stat-card">
                        <h3>Loyalty Points</h3>
                        <div class="stat-number"><%= loyaltyPoints %></div>
                    </div>
                    <div class="stat-card">
                        <h3>Member Role</h3>
                        <div class="stat-number" style="font-size:1.5rem;"><%= user.getRole() %></div>
                    </div>
                </div>

                <div style="display: flex; gap: 1rem; margin: 2rem 0;">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn"
                        style="width: auto; padding: 0.75rem 2rem;">Search Buses</a>
                    <a href="${pageContext.request.contextPath}/booking?action=mybookings" class="btn"
                        style="width: auto; padding: 0.75rem 2rem; background: var(--success);">My Bookings</a>
                </div>

                <div
                    style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                    <h3 style="color: var(--primary); margin-bottom: 1rem;">Recent Bookings</h3>
                    <p>You have no recent bookings. <a href="${pageContext.request.contextPath}/index.jsp"
                            style="color: var(--secondary);">Book a trip now!</a></p>
                </div>
            </div>

            <%@ include file="../common/footer.jsp" %>
