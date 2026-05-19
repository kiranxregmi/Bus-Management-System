<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.BusNumber, model.BusName, dao.BusNumberDAO, dao.BusNameDAO" %>
<%@ include file="/common/header.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"OPERATOR".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    BusNumberDAO busNumberDAO = new BusNumberDAO();
    BusNameDAO busNameDAO = new BusNameDAO();
    List<BusNumber> busNumbers = busNumberDAO.getAllBusNumbers();
    List<BusName> busNames = busNameDAO.getAllBusNames();
%>

<div class="container mx-auto mt-10 p-6">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-bold">Bus Number Management</h2>
        <a href="${pageContext.request.contextPath}/admin/management-center.jsp" class="bg-gray-500 text-white px-4 py-2 rounded">Back</a>
    </div>

    <% if ("ADMIN".equals(user.getRole())) { %>
    <div class="bg-white p-6 rounded shadow mb-8">
        <h3 class="text-xl font-bold mb-4">Add Bus Number</h3>
        <form action="${pageContext.request.contextPath}/admin/add-bus-number" method="post" class="grid grid-cols-1 md:grid-cols-3 gap-4">
            <div>
                <label class="block font-semibold mb-1">Select Bus Name</label>
                <select name="busNameId" required class="w-full border px-3 py-2 rounded">
                    <option value="">Choose a bus name</option>
                    <% for (BusName bn : busNames) { %>
                        <option value="<%= bn.getId() %>"><%= bn.getName() %></option>
                    <% } %>
                </select>
            </div>
            <div>
                <label class="block font-semibold mb-1">Registration Number (e.g., GA 1 KHA 4702)</label>
                <input type="text" name="registrationNumber" required placeholder="GA 1 KHA 4702" class="w-full border px-3 py-2 rounded" />
            </div>
            <button type="submit" class="col-span-1 md:col-span-1 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Add Bus Number</button>
        </form>
    </div>
    <% } else { %>
    <div class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-8 rounded shadow-sm" role="alert">
        <p class="font-bold">Notice</p>
        <p>You are logged in as an Operator. Only Administrators have permission to add new bus registration numbers.</p>
    </div>
    <% } %>

    <div class="bg-white p-6 rounded shadow">
        <h3 class="text-xl font-bold mb-4">Bus Numbers</h3>
        <% if (busNumbers.isEmpty()) { %>
            <p class="text-gray-600">No bus numbers found.</p>
        <% } else { %>
            <table class="w-full border-collapse">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="border p-2 text-left">Bus Name</th>
                        <th class="border p-2 text-left">Registration #</th>
                        <th class="border p-2 text-left">Status</th>
                        <th class="border p-2 text-left">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (BusNumber bn : busNumbers) { %>
                        <tr class="border">
                            <td class="border p-2"><%= bn.getBusName() != null ? bn.getBusName().getName() : "N/A" %></td>
                            <td class="border p-2"><%= bn.getRegistrationNumber() %></td>
                            <td class="border p-2"><span class="bg-green-200 text-green-800 px-2 py-1 rounded"><%= bn.getStatus() %></span></td>
                            <td class="border p-2">
                                <% if ("ADMIN".equals(user.getRole())) { %>
                                    <a href="${pageContext.request.contextPath}/admin/edit-bus-number?id=<%= bn.getId() %>" class="text-blue-600 hover:underline">Edit</a> |
                                    <a href="${pageContext.request.contextPath}/admin/delete-bus-number?id=<%= bn.getId() %>" class="text-red-600 hover:underline" onclick="return confirm('Delete this bus number?')">Delete</a>
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
