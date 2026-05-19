<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.Location, dao.LocationDAO" %>
<%@ include file="/common/header.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"OPERATOR".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    LocationDAO locationDAO = new LocationDAO();
    List<Location> locations = locationDAO.getAllLocations();
%>

<div class="container mx-auto mt-10 p-6">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-bold">Location Management</h2>
        <a href="${pageContext.request.contextPath}/admin/management-center.jsp" class="bg-gray-500 text-white px-4 py-2 rounded">Back</a>
    </div>

    <% if ("ADMIN".equals(user.getRole())) { %>
    <div class="bg-white p-6 rounded shadow mb-8">
        <h3 class="text-xl font-bold mb-4">Add Location</h3>
        <form action="${pageContext.request.contextPath}/admin/add-location" method="post" class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
                <label class="block font-semibold mb-1">Location Name</label>
                <input type="text" name="name" required class="w-full border px-3 py-2 rounded" />
            </div>
            <div>
                <label class="block font-semibold mb-1">District</label>
                <input type="text" name="district" class="w-full border px-3 py-2 rounded" />
            </div>
            <div>
                <label class="block font-semibold mb-1">Latitude (optional)</label>
                <input type="number" name="latitude" step="0.00000001" class="w-full border px-3 py-2 rounded" />
            </div>
            <div>
                <label class="block font-semibold mb-1">Longitude (optional)</label>
                <input type="number" name="longitude" step="0.00000001" class="w-full border px-3 py-2 rounded" />
            </div>
            <div>
                <button type="submit" class="col-span-1 md:col-span-1 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 h-10">Add Location</button>
            </div>
        </form>
    </div>
    <% } else { %>
    <div class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-8 rounded shadow-sm" role="alert">
        <p class="font-bold">Notice</p>
        <p>You are logged in as an Operator. Only Administrators have permission to add new locations.</p>
    </div>
    <% } %>

    <div class="bg-white p-6 rounded shadow">
        <h3 class="text-xl font-bold mb-4">Locations</h3>
        <% if (locations.isEmpty()) { %>
            <p class="text-gray-600">No locations found.</p>
        <% } else { %>
            <table class="w-full border-collapse">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="border p-2 text-left">Name</th>
                        <th class="border p-2 text-left">District</th>
                        <th class="border p-2 text-left">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Location loc : locations) { %>
                        <tr class="border">
                            <td class="border p-2"><%= loc.getName() %></td>
                            <td class="border p-2"><%= loc.getDistrict() != null ? loc.getDistrict() : "-" %></td>
                            <td class="border p-2">
                                <% if ("ADMIN".equals(user.getRole())) { %>
                                    <a href="${pageContext.request.contextPath}/admin/edit-location?id=<%= loc.getId() %>" class="text-blue-600 hover:underline">Edit</a> |
                                    <a href="${pageContext.request.contextPath}/admin/delete-location?id=<%= loc.getId() %>" class="text-red-600 hover:underline" onclick="return confirm('Delete this location?')">Delete</a>
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
