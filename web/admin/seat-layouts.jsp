<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.SeatLayout, dao.SeatLayoutDAO" %>
<%@ include file="/common/header.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"OPERATOR".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    SeatLayoutDAO layoutDAO = new SeatLayoutDAO();
    List<SeatLayout> layouts = layoutDAO.getAllSeatLayouts();
%>

<div class="container mx-auto mt-10 p-6">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-bold">Seat Layout Management</h2>
        <a href="${pageContext.request.contextPath}/admin/management-center.jsp" class="bg-gray-500 text-white px-4 py-2 rounded">Back</a>
    </div>

    <% if ("ADMIN".equals(user.getRole())) { %>
    <div class="bg-white p-6 rounded shadow mb-8">
        <h3 class="text-xl font-bold mb-4">Define Seat Layout</h3>
        <form action="${pageContext.request.contextPath}/admin/add-seat-layout" method="post" class="grid grid-cols-1 md:grid-cols-5 gap-4">
            <div>
                <label class="block font-semibold mb-1">Layout Name</label>
                <input type="text" name="name" required class="w-full border px-3 py-2 rounded" />
            </div>
            <div>
                <label class="block font-semibold mb-1">Type</label>
                <select name="type" required class="w-full border px-3 py-2 rounded">
                    <option value="">Select Type</option>
                    <option value="2X2_SOFA">2x2 Sofa</option>
                    <option value="2X2_SOFA_WITH_SLEEPER">2x2 Sofa with Sleeper</option>
                    <option value="2X1_SOFA">2x1 Sofa</option>
                </select>
            </div>
            <div>
                <label class="block font-semibold mb-1">Total Seats</label>
                <input type="number" name="totalSeats" required min="20" max="60" class="w-full border px-3 py-2 rounded" />
            </div>
            <div>
                <label class="block font-semibold mb-1">Rows</label>
                <input type="number" name="rows" required min="2" max="20" class="w-full border px-3 py-2 rounded" />
            </div>
            <div>
                <label class="block font-semibold mb-1">Columns</label>
                <input type="number" name="columns" required min="2" max="6" class="w-full border px-3 py-2 rounded" />
            </div>
            <button type="submit" class="col-span-1 md:col-span-5 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Add Layout</button>
        </form>
    </div>
    <% } else { %>
    <div class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-8 rounded shadow-sm" role="alert">
        <p class="font-bold">Notice</p>
        <p>You are logged in as an Operator. Only Administrators have permission to define new seat layouts.</p>
    </div>
    <% } %>

    <div class="bg-white p-6 rounded shadow">
        <h3 class="text-xl font-bold mb-4">Seat Layouts</h3>
        <% if (layouts.isEmpty()) { %>
            <p class="text-gray-600">No seat layouts found.</p>
        <% } else { %>
            <table class="w-full border-collapse">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="border p-2 text-left">Name</th>
                        <th class="border p-2 text-left">Type</th>
                        <th class="border p-2 text-left">Total Seats</th>
                        <th class="border p-2 text-left">Rows x Cols</th>
                        <th class="border p-2 text-left">Preview</th>
                        <th class="border p-2 text-left">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (SeatLayout layout : layouts) { %>
                        <tr class="border">
                            <td class="border p-2"><%= layout.getName() %></td>
                            <td class="border p-2"><%= layout.getType() %></td>
                            <td class="border p-2"><%= layout.getTotalSeats() %></td>
                            <td class="border p-2"><%= layout.getRows() %> x <%= layout.getColumns() %></td>
                            <td class="border p-2">
                                <div class="mini-seat-layout <%= layout.getType().toLowerCase() %>">
                                    <% for (int i = 1; i <= Math.min(layout.getColumns() * 3, 12); i++) { %>
                                        <span></span>
                                    <% } %>
                                </div>
                            </td>
                            <td class="border p-2">
                                <% if ("ADMIN".equals(user.getRole())) { %>
                                    <a href="${pageContext.request.contextPath}/admin/edit-seat-layout?id=<%= layout.getId() %>" class="text-blue-600 hover:underline">Edit</a> |
                                    <a href="${pageContext.request.contextPath}/admin/delete-seat-layout?id=<%= layout.getId() %>" class="text-red-600 hover:underline" onclick="return confirm('Delete this layout?')">Delete</a>
                                <% } else { %>
                                    <span class="text-gray-400">View Only</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
