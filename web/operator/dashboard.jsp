<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/common/header.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"OPERATOR".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<div class="container" style="padding: 2rem 1rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
        <h2 style="color: var(--primary);">Operator Dashboard</h2>
        <a href="${pageContext.request.contextPath}/logout" class="btn"
            style="width: auto; padding: 0.5rem 1.5rem; background: var(--danger);">Logout</a>
    </div>

    <p style="margin-bottom: 2rem;">Welcome, <%= user.getFullName() %>! Manage your bus operations below.</p>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin: 2rem 0;">
        <a href="${pageContext.request.contextPath}/operator/bus-setup.jsp" class="stat-card" style="text-decoration: none;">
            <h3>Bus Setup</h3>
            <p>Assign buses and configure seating</p>
        </a>
        <a href="${pageContext.request.contextPath}/operator/chalani.jsp" class="stat-card" style="text-decoration: none;">
            <h3>Seat Layout</h3>
            <p>View and manage seat configurations</p>
        </a>
        <a href="${pageContext.request.contextPath}/operator/chalani.jsp" class="stat-card" style="text-decoration: none;">
            <h3>Chalani (Booking)</h3>
            <p>Book seats and manage bookings</p>
        </a>
        <a href="${pageContext.request.contextPath}/operator/chalani.jsp?mode=lock" class="stat-card" style="text-decoration: none;">
            <h3>Lock/Unlock Seats</h3>
            <p>Control seat availability</p>
        </a>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
