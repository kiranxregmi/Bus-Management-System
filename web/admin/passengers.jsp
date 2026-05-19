<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.User, dao.UserDAO, model.LoyaltyPoint, dao.LoyaltyPointDAO, dao.BookingDAO" %>
<%@ include file="/common/header.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    UserDAO userDAO = new UserDAO();
    List<User> passengers = userDAO.getAllCustomers();
    LoyaltyPointDAO loyaltyDAO = new LoyaltyPointDAO();
    BookingDAO bookingDAO = new BookingDAO();
%>

<div class="container mx-auto mt-10 p-6">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-bold">Passenger Management</h2>
        <a href="${pageContext.request.contextPath}/admin/management-center.jsp" class="bg-gray-500 text-white px-4 py-2 rounded">Back</a>
    </div>

    <div class="bg-white p-6 rounded shadow">
        <h3 class="text-xl font-bold mb-4">All Passengers (sorted by Loyalty Points)</h3>
        <% if (passengers.isEmpty()) { %>
            <p class="text-gray-600">No passengers found.</p>
        <% } else { %>
            <% if (request.getParameter("success") != null) { %><div class="success-message"><%= request.getParameter("success") %></div><% } %>
            <% if (request.getParameter("error") != null) { %><div class="error-message"><%= request.getParameter("error") %></div><% } %>
            <table class="w-full border-collapse text-sm">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="border p-2 text-left">Name</th>
                        <th class="border p-2 text-left">Email</th>
                        <th class="border p-2 text-center">Total Bookings</th>
                        <th class="border p-2 text-center">Loyalty Points</th>
                        <th class="border p-2 text-left">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (User p : passengers) {
                        LoyaltyPoint loyalty = loyaltyDAO.getLoyaltyPointsByUserId(p.getId());
                        int points = loyalty != null ? loyalty.getPointsBalance() : 0;
                    %>
                        <tr class="border">
                            <td class="border p-2"><%= p.getFullName() %></td>
                            <td class="border p-2"><%= p.getEmail() %></td>
                            <td class="border p-2 text-center"><%= bookingDAO.getBookingCountByUser(p.getId()) %></td>
                            <td class="border p-2 text-center font-bold"><%= points %> pts</td>
                            <td class="border p-2">
                                <a href="${pageContext.request.contextPath}/admin/add-loyalty-points?userId=<%= p.getId() %>" class="text-green-600 hover:underline">+5 Points</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
