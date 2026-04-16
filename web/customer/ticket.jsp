<%@ include file="../common/header.jsp" %>
    <%@ page import="model.Booking" %>
        <% Booking booking=(Booking) request.getAttribute("booking"); if (booking==null) {
            response.sendRedirect(request.getContextPath() + "/customer/myBookings.jsp" ); return; } %>

            <div class="container" style="padding: 2rem 1rem; max-width: 600px;">
                <div
                    style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 4px 20px rgba(0,0,0,0.1);">
                    <div
                        style="text-align: center; border-bottom: 2px dashed var(--gray); padding-bottom: 1rem; margin-bottom: 1rem;">
                        <h2 style="color: var(--primary);">Kalpana Travels</h2>
                        <p>E-Ticket / Booking Confirmation</p>
                    </div>

                    <div style="margin-bottom: 1.5rem;">
                        <p><strong>Booking ID:</strong> #<%= booking.getId() %>
                        </p>
                        <p><strong>Booking Date:</strong>
                            <%= booking.getBookingDate() %>
                        </p>
                        <p><strong>Status:</strong> <span style="color: var(--success);">
                                <%= booking.getStatus() %>
                            </span></p>
                    </div>

                    <div style="background: var(--light); padding: 1rem; border-radius: 5px; margin-bottom: 1.5rem;">
                        <h3 style="color: var(--primary); margin-bottom: 0.5rem;">Journey Details</h3>
                        <p><strong>Bus:</strong>
                            <%= booking.getSchedule().getBus().getBusName() %> (<%=
                                    booking.getSchedule().getBus().getBusNumber() %>)
                        </p>
                        <p><strong>Route:</strong>
                            <%= booking.getSchedule().getRoute().getSource() %> to <%=
                                    booking.getSchedule().getRoute().getDestination() %>
                        </p>
                        <p><strong>Date:</strong>
                            <%= booking.getSchedule().getTravelDate() %>
                        </p>
                        <p><strong>Time:</strong>
                            <%= booking.getSchedule().getDepartureTime() %> - <%= booking.getSchedule().getArrivalTime()
                                    %>
                        </p>
                    </div>

                    <div style="margin-bottom: 1.5rem;">
                        <h3 style="color: var(--primary); margin-bottom: 0.5rem;">Passenger Details</h3>
                        <p><strong>Name:</strong>
                            <%= booking.getUser().getFullName() %>
                        </p>
                        <p><strong>Phone:</strong>
                            <%= booking.getUser().getPhone() %>
                        </p>
                        <p><strong>Seats:</strong>
                            <%= booking.getSeatNumbers() %>
                        </p>
                    </div>

                    <div style="border-top: 2px solid var(--gray); padding-top: 1rem; text-align: right;">
                        <p style="font-size: 1.2rem;"><strong>Total Fare:</strong> NPR <%= booking.getTotalFare() %>
                        </p>
                    </div>

                    <div style="margin-top: 2rem; display: flex; gap: 1rem;">
                        <button onclick="window.print()" class="btn" style="flex: 1;">🖨️ Print Ticket</button>
                        <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="btn"
                            style="flex: 1; background: var(--gray);">Back to Dashboard</a>
                    </div>
                </div>
            </div>

            <%@ include file="../common/footer.jsp" %>