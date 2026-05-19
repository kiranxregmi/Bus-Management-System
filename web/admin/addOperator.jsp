<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/common/header.jsp" %>

<div class="container mx-auto max-w-lg mt-10 p-6 bg-white rounded shadow">
    <h2 class="text-2xl font-bold mb-4">Add Operator Account</h2>
    <form action="${pageContext.request.contextPath}/admin/add-operator" method="post" class="space-y-4">
        <div>
            <label class="block font-semibold mb-1">Full Name</label>
            <input type="text" name="fullName" required class="w-full border px-3 py-2 rounded" />
        </div>
        <div>
            <label class="block font-semibold mb-1">Email</label>
            <input type="email" name="email" required class="w-full border px-3 py-2 rounded" />
        </div>
        <div>
            <label class="block font-semibold mb-1">Phone</label>
            <input type="text" name="phone" required class="w-full border px-3 py-2 rounded" />
        </div>
        <div>
            <label class="block font-semibold mb-1">Password</label>
            <input type="password" name="password" required class="w-full border px-3 py-2 rounded" />
        </div>
        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Create Operator</button>
        <c:if test="${not empty error}">
            <div class="text-red-600 mt-2">${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="text-green-600 mt-2">${success}</div>
        </c:if>
    </form>
</div>

<%@ include file="/common/footer.jsp" %>
