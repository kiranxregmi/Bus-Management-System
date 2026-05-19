<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/common/header.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"OPERATOR".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<div class="container mx-auto mt-10 p-6">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-bold">Admin Control Panel</h2>
        <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp" class="bg-gray-500 text-white px-4 py-2 rounded">Back to Dashboard</a>
    </div>

    <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
        <a href="${pageContext.request.contextPath}/admin/buses.jsp" class="bg-blue-100 p-4 rounded shadow hover:shadow-lg">
            <h3 class="font-bold text-blue-900">Bus Management</h3>
            <p class="text-sm">Manage bus names and types</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/bus-numbers.jsp" class="bg-green-100 p-4 rounded shadow hover:shadow-lg">
            <h3 class="font-bold text-green-900">Bus Numbers</h3>
            <p class="text-sm">Manage individual bus numbers</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/staff.jsp" class="bg-purple-100 p-4 rounded shadow hover:shadow-lg">
            <h3 class="font-bold text-purple-900">Staff Management</h3>
            <p class="text-sm">Drivers, Conductors, Helpers</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/passengers.jsp" class="bg-pink-100 p-4 rounded shadow hover:shadow-lg">
            <h3 class="font-bold text-pink-900">Passenger Management</h3>
            <p class="text-sm">View passengers & loyalty points</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/locations.jsp" class="bg-yellow-100 p-4 rounded shadow hover:shadow-lg">
            <h3 class="font-bold text-yellow-900">Locations</h3>
            <p class="text-sm">Bus stop locations</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/seat-layouts.jsp" class="bg-indigo-100 p-4 rounded shadow hover:shadow-lg">
            <h3 class="font-bold text-indigo-900">Seat Layouts</h3>
            <p class="text-sm">Define seating configurations</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/route?action=list" class="bg-red-100 p-4 rounded shadow hover:shadow-lg">
            <h3 class="font-bold text-red-900">Routes Setup</h3>
            <p class="text-sm">Configure routes with pickup/drop points</p>
        </a>
        <a href="${pageContext.request.contextPath}/admin/bus-setup.jsp" class="bg-cyan-100 p-4 rounded shadow hover:shadow-lg">
            <h3 class="font-bold text-cyan-900">Bus Setup</h3>
            <p class="text-sm">Assign buses, staff, and seating</p>
        </a>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
