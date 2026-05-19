<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*, model.Staff, dao.StaffDAO" %>
<%@ include file="/common/header.jsp" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"OPERATOR".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    
    StaffDAO staffDAO = new StaffDAO();
    List<Staff> staffList = staffDAO.getAllStaff();
%>

<div class="container mx-auto mt-10 p-6">
    <div class="flex justify-between items-center mb-6">
        <h2 class="text-3xl font-bold">Staff Management</h2>
        <a href="${pageContext.request.contextPath}/admin/management-center.jsp" class="bg-gray-500 text-white px-4 py-2 rounded">Back</a>
    </div>

    <% if ("ADMIN".equals(user.getRole())) { %>
    <div class="bg-white p-6 rounded shadow mb-8">
        <h3 class="text-xl font-bold mb-4">Add Staff Member</h3>
        <form action="${pageContext.request.contextPath}/admin/add-staff" method="post" class="grid grid-cols-1 md:grid-cols-4 gap-4">
            <div>
                <label class="block font-semibold mb-1">Name</label>
                <input type="text" name="name" required class="w-full border px-3 py-2 rounded" />
            </div>
            <div>
                <label class="block font-semibold mb-1">Role</label>
                <select name="role" required class="w-full border px-3 py-2 rounded">
                    <option value="">Select Role</option>
                    <option value="DRIVER">Driver</option>
                    <option value="CONDUCTOR">Conductor</option>
                    <option value="HELPER">Helper</option>
                </select>
            </div>
            <div>
                <label class="block font-semibold mb-1">Phone</label>
                <input type="text" name="phone" required class="w-full border px-3 py-2 rounded" />
            </div>
            <button type="submit" class="col-span-1 md:col-span-1 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Add Staff</button>
        </form>
    </div>
    <% } else { %>
    <div class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-700 p-4 mb-8 rounded shadow-sm" role="alert">
        <p class="font-bold">Notice</p>
        <p>You are logged in as an Operator. Only Administrators have permission to add new staff members.</p>
    </div>
    <% } %>

    <div class="bg-white p-6 rounded shadow">
        <h3 class="text-xl font-bold mb-4">Staff List</h3>
        <% if (staffList.isEmpty()) { %>
            <p class="text-gray-600">No staff found.</p>
        <% } else { %>
            <table class="w-full border-collapse">
                <thead>
                    <tr class="bg-gray-200">
                        <th class="border p-2 text-left">Name</th>
                        <th class="border p-2 text-left">Role</th>
                        <th class="border p-2 text-left">Phone</th>
                        <th class="border p-2 text-left">Status</th>
                        <th class="border p-2 text-left">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Staff staff : staffList) { %>
                        <tr class="border">
                            <td class="border p-2"><%= staff.getName() %></td>
                            <td class="border p-2"><%= staff.getRole() %></td>
                            <td class="border p-2"><%= staff.getPhone() %></td>
                            <td class="border p-2"><span class="bg-green-200 text-green-800 px-2 py-1 rounded"><%= staff.getStatus() %></span></td>
                            <td class="border p-2">
                                <% if ("ADMIN".equals(user.getRole())) { %>
                                    <a href="${pageContext.request.contextPath}/admin/edit-staff?id=<%= staff.getId() %>" class="text-blue-600 hover:underline">Edit</a> |
                                    <a href="${pageContext.request.contextPath}/admin/delete-staff?id=<%= staff.getId() %>" class="text-red-600 hover:underline" onclick="return confirm('Delete this staff?')">Delete</a>
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
