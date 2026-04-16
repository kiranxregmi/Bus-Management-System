<%@ include file="../common/header.jsp" %>
    <%@ page import="java.util.List, model.Schedule" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

            <% List<Schedule> buses = (List<Schedule>) request.getAttribute("buses");
                    String source = (String) request.getAttribute("source");
                    String destination = (String) request.getAttribute("destination");

                    if (source == null) source = "";
                    if (destination == null) destination = "";
                    %>

                    <div class="container" style="padding: 2rem 1rem;">
                        <h2 style="color: var(--primary);">Available Buses from <%= source %> to <%= destination %>
                        </h2>
                        <p style="margin-bottom: 2rem;">
                            <%= buses !=null ? buses.size() : 0 %> buses found
                        </p>

                        <c:choose>
                            <c:when test="${not empty buses}">
                                <c:forEach items="${buses}" var="schedule">
                                    <div class="bus-card">
                                        <div class="bus-info">
                                            <h3>${schedule.bus.busName}</h3>
                                            <span class="bus-number">${schedule.bus.busNumber}</span>
                                            <span class="bus-type">${schedule.bus.busType}</span>
                                        </div>

                                        <div class="bus-timing">
                                            <span>${schedule.departureTime}</span>
                                            <span> to </span>
                                            <span>${schedule.arrivalTime}</span>
                                        </div>

                                        <div>
                                            <span class="seats-available">${schedule.availableSeats} seats
                                                Available</span>
                                        </div>

                                        <div class="fare">NPR ${schedule.bus.farePerSeat}</div>

                                        <a href="${pageContext.request.contextPath}/customer/bookSeat.jsp?scheduleId=${schedule.id}&fare=${schedule.bus.farePerSeat}&busName=${schedule.bus.busName}&departure=${schedule.departureTime}&arrival=${schedule.arrivalTime}&source=${schedule.route.source}&destination=${schedule.route.destination}"
                                            class="book-btn">Book Now</a>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div
                                    style="text-align: center; padding: 3rem; background: var(--white); border-radius: 10px;">
                                    <p style="font-size: 1.2rem;">No buses found for this route and date.</p>
                                    <a href="${pageContext.request.contextPath}/index.jsp" class="btn"
                                        style="width: auto; margin-top: 1rem;">Search Again</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%@ include file="../common/footer.jsp" %>