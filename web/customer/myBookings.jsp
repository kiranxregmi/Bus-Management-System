<%@ include file="../common/header.jsp" %>
    <%@ page import="java.util.List, model.Booking" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

            <% List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                    %>

                    <div class="container" style="padding: 2rem 1rem;">
                        <h2 style="color: var(--primary); margin-bottom: 2rem;">My Bookings</h2>

                        <c:if test="${param.booked == 'true'}">
                            <div class="success-message">Booking confirmed successfully!</div>
                        </c:if>
                        <c:if test="${param.cancelled == 'true'}">
                            <div class="success-message">Booking cancelled successfully.</div>
                        </c:if>

                        <c:choose>
                            <c:when test="${not empty bookings}">
                                <div class="table-container">
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Booking ID</th>
                                                <th>Bus</th>
                                                <th>Route</th>
                                                <th>Date</th>
                                                <th>Seats</th>
                                                <th>Fare</th>
                                                <th>Status</th>
                                                <th>Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${bookings}" var="booking">
                                                <tr>
                                                    <td>#${booking.id}</td>
                                                    <td>${booking.schedule.bus.busName}</td>
                                                    <td>${booking.schedule.route.source} to
                                                        ${booking.schedule.route.destination}</td>
                                                    <td>${booking.schedule.travelDate}</td>
                                                    <td>${booking.seatNumbers}</td>
                                                    <td>NPR ${booking.totalFare}</td>
                                                    <td>
                                                        <span
                                                            style="color: ${booking.status == 'CONFIRMED' ? 'var(--success)' : 'var(--danger)'};">
                                                            ${booking.status}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <c:if test="${booking.status == 'CONFIRMED'}">
                                                            <a href="${pageContext.request.contextPath}/booking?action=cancel&id=${booking.id}"
                                                                class="action-btn btn-delete"
                                                                onclick="return confirm('Cancel this booking?')">Cancel</a>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div
                                    style="text-align: center; padding: 3rem; background: var(--white); border-radius: 10px;">
                                    <p>You have no bookings yet.</p>
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn"
                                        style="width: auto; margin-top: 1rem;">Book a Trip</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%@ include file="../common/footer.jsp" %>