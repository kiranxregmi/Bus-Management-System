<%@ include file="../common/header.jsp" %>
    <%@ page import="model.User" %>
        <% User user=(User) session.getAttribute("user"); if (user==null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp"); return; } %>

            <div class="container" style="padding: 2rem 1rem; max-width: 800px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                    <h2 style="color: var(--primary);">My Account</h2>
                    <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="btn"
                        style="width: auto; background: var(--gray);">Back to Dashboard</a>
                </div>

                <div style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 2rem;">
                    <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Profile Information</h3>

                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" value="<%= user.getFullName() %>" disabled
                            style="background: #f5f5f5; color: #666;">
                    </div>

                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" value="<%= user.getEmail() %>" disabled
                            style="background: #f5f5f5; color: #666;">
                    </div>

                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="tel" value="<%= user.getPhone() %>" disabled
                            style="background: #f5f5f5; color: #666;">
                    </div>

                    <div class="form-group">
                        <label>Account Type</label>
                        <input type="text" value="<%= user.getRole() %>" disabled
                            style="background: #f5f5f5; color: #666;">
                    </div>

                    <div class="form-group">
                        <label>Member Since</label>
                        <input type="text" value="<%= user.getCreatedAt() != null ? user.getCreatedAt() : "N/A" %>" disabled
                            style="background: #f5f5f5; color: #666;">
                    </div>

                    <div style="margin-top: 2rem; padding-top: 2rem; border-top: 1px solid #ddd;">
                        <p style="color: var(--gray); margin-bottom: 1rem;">To edit your account details, please contact
                            support.</p>
                        <a href="mailto:support@kalpanatravels.com" class="btn"
                            style="width: auto; background: var(--secondary);">Contact Support</a>
                    </div>
                </div>

                <div style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                    <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Quick Stats</h3>

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
                        <div style="text-align: center; padding: 1rem; background: var(--light); border-radius: 8px;">
                            <div style="font-size: 2rem; color: var(--primary); font-weight: bold;">0</div>
                            <p style="color: var(--gray); margin-top: 0.5rem;">Total Bookings</p>
                        </div>
                        <div style="text-align: center; padding: 1rem; background: var(--light); border-radius: 8px;">
                            <div style="font-size: 2rem; color: var(--primary); font-weight: bold;">0</div>
                            <p style="color: var(--gray); margin-top: 0.5rem;">Total Spent (NPR)</p>
                        </div>
                    </div>
                </div>
            </div>

            <%@ include file="../common/footer.jsp" %>
