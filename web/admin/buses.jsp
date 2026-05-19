<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.BusName, dao.BusNameDAO" %>
<%@ include file="/common/header.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    BusNameDAO busNameDAO = new BusNameDAO();
    List<BusName> busNames = busNameDAO.getAllBusNames();
%>

<div class="container mx-auto mt-10 p-6">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-bold">Bus Management</h2>
        <a href="${pageContext.request.contextPath}/admin/management-center.jsp" class="bg-gray-500 text-white px-4 py-2 rounded">Back</a>
    </div>

    <div class="bg-white p-6 rounded shadow mb-8">
        <h3 class="text-xl font-bold mb-4">Add New Bus</h3>
        <form action="${pageContext.request.contextPath}/admin/add-bus" method="post" class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block font-semibold mb-1">Bus Name</label>
                <select name="busName" required class="w-full border px-3 py-2 rounded">
                    <option value="">Select Bus</option>
                    <option value="Kalpana Airbus">Kalpana Airbus</option>
                    <option value="Syangja Gandaki">Syangja Gandaki</option>
                    <option value="Syangja Aadhiganga">Syangja Aadhiganga</option>
                </select>
            </div>
            <div>
                <label class="block font-semibold mb-1">Bus Type</label>
                <select name="busType" required class="w-full border px-3 py-2 rounded">
                    <option value="">Select Type</option>
                    <option value="SLEEPER">Sleeper</option>
                    <option value="DELUXE">Deluxe</option>
                    <option value="SOFA_SEATER">Sofa Seater</option>
                </select>
            </div>
            <div>
                <label class="block font-semibold mb-1">Capacity</label>
                <input type="number" name="capacity" required min="20" max="60" class="w-full border px-3 py-2 rounded" />
            </div>
            <button type="submit" class="col-span-1 md:col-span-3 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Add Bus</button>
        </form>
    </div>

    <div class="bg-white p-6 rounded shadow">
        <h3 class="text-xl font-bold mb-4">Existing Buses</h3>
        <% if (busNames.isEmpty()) { %>
            <p class="text-gray-600">No buses found. Add one above.</p>
        <% } else { %>
            <table class="w-full border-collapse">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="border p-2 text-left">Bus Name</th>
                        <th class="border p-2 text-left">Type</th>
                        <th class="border p-2 text-left">Capacity</th>
                        <th class="border p-2 text-left">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BusName bus : busNames) { %>
                        <tr class="border">
                            <td class="border p-2"><%= bus.getName() %></td>
                            <td class="border p-2"><%= bus.getBusType() %></td>
                            <td class="border p-2"><%= bus.getCapacity() %></td>
                            <td class="border p-2">
                                <a href="${pageContext.request.contextPath}/admin/edit-bus?id=<%= bus.getId() %>" class="text-blue-600 hover:underline">Edit</a> |
                                <a href="${pageContext.request.contextPath}/admin/delete-bus?id=<%= bus.getId() %>" class="text-red-600 hover:underline" onclick="return confirm('Delete this bus?')">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>
</div>

<%@ include file="/common/footer.jsp" %>
