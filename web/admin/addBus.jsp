<%@ include file="../common/header.jsp" %>
    <%@ page import="model.User" %>
        <% User user=(User) session.getAttribute("user"); if (user==null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp" ); return; } %>

            <div class="container" style="padding: 2rem 1rem; max-width: 600px;">
                <h2 style="color: var(--primary); margin-bottom: 2rem;">Add New Bus</h2>

                <% if (request.getAttribute("error") !=null) { %>
                    <div class="error-message">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>

                        <div
                            style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                            <form action="${pageContext.request.contextPath}/admin/bus" method="POST">
                                <input type="hidden" name="action" value="add">

                                <div class="form-group">
                                    <label>Bus Number</label>
                                    <input type="text" name="busNumber" placeholder="e.g., GA-6006"
                                        pattern="[A-Z]{2}-[0-9]{3,4}" required>
                                    <small style="color: var(--gray);">Format: XX-000 or XX-0000 (e.g., GA-6006)</small>
                                </div>

                                <div class="form-group">
                                    <label>Bus Name</label>
                                    <input type="text" name="busName" placeholder="e.g., Kalpana Express" required>
                                </div>

                                <div class="form-group">
                                    <label>Capacity (Number of Seats)</label>
                                    <input type="number" name="capacity" min="1" max="100" required>
                                </div>

                                <div class="form-group">
                                    <label>Bus Type</label>
                                    <select name="busType" required>
                                        <option value="">Select Type</option>
                                        <option value="STANDARD">Standard</option>
                                        <option value="SEMI_DELUXE">Semi Deluxe</option>
                                        <option value="AC_DELUXE">AC Deluxe</option>
                                        <option value="SUPER_DELUXE">Super Deluxe</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label>Fare per Seat (NPR)</label>
                                    <input type="number" name="farePerSeat" min="0" step="0.01" required>
                                </div>

                                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                                    <button type="submit" class="btn">Add Bus</button>
                                    <a href="manageBuses.jsp" class="btn" style="background: var(--gray);">Cancel</a>
                                </div>
                            </form>
                        </div>
            </div>

            <%@ include file="../common/footer.jsp" %>