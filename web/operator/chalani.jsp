<%@ include file="../common/header.jsp" %>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.hasRole("ADMIN", "OPERATOR")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    BusSetupDAO setupDAO = new BusSetupDAO();
    SeatDAO seatDAO = new SeatDAO();
    RouteDAO routeDAO = new RouteDAO();
    List<BusSetup> setups = setupDAO.getAllBusSetups();
    List<Route> routes = routeDAO.getAllRoutes();
    int setupId = request.getParameter("setupId") != null && !request.getParameter("setupId").isBlank()
            ? Integer.parseInt(request.getParameter("setupId"))
            : (setups.isEmpty() ? 0 : setups.get(0).getId());
    BusSetup setup = setupId > 0 ? setupDAO.getBusSetupById(setupId) : null;
    List<Seat> seats = setupId > 0 ? seatDAO.getSeatsByBusSetup(setupId) : Collections.emptyList();
    double fare = setup != null && setup.getTripPrice() != null ? setup.getTripPrice().doubleValue() : 0;
%>

<div class="container" style="padding:2rem 1rem;">
    <div style="display:flex;justify-content:space-between;gap:1rem;align-items:center;margin-bottom:1.5rem;">
        <div>
            <h2 style="color:var(--primary);">Chalani Seat Booking</h2>
            <p style="color:var(--gray);">Green available, purple booked online/counter, red locked.</p>
        </div>
        <a href="${pageContext.request.contextPath}/operator/dashboard.jsp" class="btn" style="width:auto;background:var(--gray);">Back</a>
    </div>

    <% if (request.getParameter("success") != null) { %><div class="success-message"><%= request.getParameter("success") %></div><% } %>
    <% if (request.getParameter("error") != null) { %><div class="error-message"><%= request.getParameter("error") %></div><% } %>

    <form method="get" class="admin-panel" style="margin-bottom:1rem;">
        <div class="form-grid four">
            <div class="form-group">
                <label>Select Configured Bus</label>
                <select name="setupId" onchange="this.form.submit()">
                    <% for (BusSetup item : setups) { %>
                        <option value="<%= item.getId() %>" <%= item.getId() == setupId ? "selected" : "" %>>
                            <%= item.getBusNumber() != null ? item.getBusNumber().getRegistrationNumber() : "Setup " + item.getId() %>
                            - <%= item.getSeatLayout() != null ? item.getSeatLayout().getName() : "" %>
                        </option>
                    <% } %>
                </select>
            </div>
        </div>
    </form>

    <% if (setup == null) { %>
        <div class="error-message">No bus setup found. Configure a bus first.</div>
    <% } else { %>
        <div class="chalani-layout">
            <section class="admin-panel">
                <div class="seat-legend">
                    <span><i class="legend available"></i> Available</span>
                    <span><i class="legend booked"></i> Booked</span>
                    <span><i class="legend locked"></i> Locked</span>
                </div>

                <form id="bookingForm" action="${pageContext.request.contextPath}/operator/seat-action" method="post">
                    <input type="hidden" name="setupId" value="<%= setupId %>">
                    <input type="hidden" name="totalFare" id="totalFareInput" value="0">
                    <div class="visual-seat-map">
                        <% for (Seat seat : seats) {
                            boolean available = "AVAILABLE".equals(seat.getStatus());
                            boolean booked = "BOOKED".equals(seat.getStatus());
                            boolean locked = "LOCKED".equals(seat.getStatus());
                        %>
                            <div class="seat-tile <%= seat.getStatus().toLowerCase() %>">
                                <% if (available) { %>
                                    <input type="checkbox" name="selectedSeats" value="<%= seat.getSeatNumber() %>" id="seat_<%= seat.getId() %>" onchange="updateFare()">
                                    <label for="seat_<%= seat.getId() %>"><%= seat.getSeatNumber() %></label>
                                <% } else { %>
                                    <span><%= seat.getSeatNumber() %></span>
                                <% } %>
                                <% if (!booked) { %>
                                    <button type="submit"
                                            form="lockForm_<%= seat.getId() %>"
                                            class="seat-lock-btn"
                                            title="<%= locked ? "Unlock seat" : "Lock seat" %>"><%= locked ? "Unlock" : "Lock" %></button>
                                <% } %>
                            </div>
                        <% } %>
                    </div>

                    <div class="booking-panel">
                        <h3>Passenger Details</h3>
                        <p>Selected: <strong id="selectedSeatsText">None</strong></p>
                        <p>Total: <strong>NPR <span id="fareText">0.00</span></strong></p>
                        <div class="form-grid two">
                            <div class="form-group">
                                <label>Passenger Name</label>
                                <input type="text" name="passengerName" required>
                            </div>
                            <div class="form-group">
                                <label>Passenger Phone</label>
                                <input type="tel" name="passengerPhone" required>
                            </div>
                            <div class="form-group">
                                <label>Passenger Email</label>
                                <input type="email" name="passengerEmail">
                            </div>
                            <div class="form-group">
                                <label>Route</label>
                                <select name="routeId">
                                    <option value="">No route selected</option>
                                    <% for (Route route : routes) { %>
                                        <option value="<%= route.getId() %>"><%= route.getSource() %> -> <%= route.getDestination() %></option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        <button type="submit" class="btn" style="width:auto;padding:.85rem 2rem;" onclick="return validateSeatBooking()">Save Booking</button>
                    </div>
                </form>

                <% for (Seat seat : seats) {
                    if (!"BOOKED".equals(seat.getStatus())) { %>
                    <form id="lockForm_<%= seat.getId() %>" action="${pageContext.request.contextPath}/operator/seat-action" method="post">
                        <input type="hidden" name="action" value="toggleLock">
                        <input type="hidden" name="setupId" value="<%= setupId %>">
                        <input type="hidden" name="seatNumber" value="<%= seat.getSeatNumber() %>">
                        <input type="hidden" name="currentStatus" value="<%= seat.getStatus() %>">
                    </form>
                <% }} %>
            </section>
        </div>
    <% } %>
</div>

<script>
    const farePerSeat = <%= fare %>;
    function updateFare() {
        const selected = Array.from(document.querySelectorAll('input[name="selectedSeats"]:checked')).map(input => input.value);
        const total = selected.length * farePerSeat;
        document.getElementById('selectedSeatsText').textContent = selected.length ? selected.join(', ') : 'None';
        document.getElementById('fareText').textContent = total.toFixed(2);
        document.getElementById('totalFareInput').value = total.toFixed(2);
    }
    function validateSeatBooking() {
        if (!document.querySelector('input[name="selectedSeats"]:checked')) {
            alert('Please select at least one available seat.');
            return false;
        }
        return true;
    }
</script>

<%@ include file="../common/footer.jsp" %>
