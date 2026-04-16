<%@ include file="../common/header.jsp" %>
    <%@ page import="model.User, service.BookingService, model.Booking, java.util.List" %>
        <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } BookingService bookingService=new
            BookingService(); List<Booking> bookings = bookingService.getAllBookings();
            %>

            <div class="container" style="padding: 2rem 1rem;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <h2 style="color: var(--primary);">All Bookings</h2>
                    <a href="adminDashboard.jsp" class="btn"
                        style="width: auto; padding: 0.75rem 2rem; background: var(--gray);">← Back to Dashboard</a>
                </div>

                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Customer</th>
                                <th>Bus</th>
                                <th>Route</th>
                                <th>Date</th>
                                <th>Seats</th>
                                <th>Fare</th>
                                <th>Status</th>
                                <th>Booked On</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Booking booking : bookings) { %>
                                <tr>
                                    <td>#<%= booking.getId() %>
                                    </td>
                                    <td>
                                        <%= booking.getUser() !=null ? booking.getUser().getFullName() : "N/A" %>
                                    </td>
                                    <td>
                                        <%= booking.getSchedule() !=null && booking.getSchedule().getBus() !=null ?
                                            booking.getSchedule().getBus().getBusName() : "N/A" %>
                                    </td>
                                    <td>
                                        <%= booking.getSchedule() !=null && booking.getSchedule().getRoute() !=null ?
                                            booking.getSchedule().getRoute().getSource() + " → " +
                                            booking.getSchedule().getRoute().getDestination() : "N/A" %>
                                    </td>
                                    <td>
                                        <%= booking.getSchedule() !=null ? booking.getSchedule().getTravelDate() : "N/A"
                                            %>
                                    </td>
                                    <td>
                                        <%= booking.getSeatNumbers() %>
                                    </td>
                                    <td>NPR <%= booking.getTotalFare() %>
                                    </td>
                                    <td>
                                        <span style="color: <%= " CONFIRMED".equals(booking.getStatus())
                                            ? "var(--success)" : "var(--danger)" %>;">
                                            <%= booking.getStatus() %>
                                        </span>
                                    </td>
                                    <td>
                                        <%= booking.getBookingDate() %>
                                    </td>
                                </tr>
                                <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <%@ include file="../common/footer.jsp" %>