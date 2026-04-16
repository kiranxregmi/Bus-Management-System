<%@ include file="common/header.jsp" %>
    <%@ page import="model.User" %>
        <% 
        // Redirect if already logged in 
        if (session.getAttribute("user") != null) { 
            User user = (User) session.getAttribute("user"); 
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin/adminDashboard.jsp"); 
            } else { 
                response.sendRedirect("customer/dashboard.jsp");
            } 
            return; 
        } 
        
        // Pre-fill email if cookie exists 
        String savedEmail=""; 
        Cookie[] cookies = request.getCookies();
        if (cookies != null) { 
            for (Cookie cookie : cookies) { 
                if ("userEmail".equals(cookie.getName())) {
                    savedEmail=cookie.getValue(); 
                    break; 
                } 
            } 
        } 
        %>

            <div class="auth-container">
                <h2>Welcome Back</h2>
                <p>Sign in to your account</p>

                <% if (request.getAttribute("error") !=null) { %>
                    <div class="error-message">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>
                        <% if (request.getParameter("registered") !=null) { %>
                            <div class="success-message">Registration successful! Please login.</div>
                            <% } %>

                                <form action="${pageContext.request.contextPath}/login" method="POST">
                                    <div class="form-group">
                                        <label>Email Address</label>
                                        <input type="email" name="email" value="<%= savedEmail %>"
                                            placeholder="your@email.com" required>
                                    </div>

                                    <div class="form-group">
                                        <label>Password</label>
                                        <input type="password" name="password" placeholder="Enter your password"
                                            required>
                                    </div>

                                    <div class="form-options">
                                        <label><input type="checkbox" name="remember"> Remember me</label>
                                        <a href="#" style="color: var(--primary);">Forgot password?</a>
                                    </div>

                                    <button type="submit" class="btn">Login</button>
                                </form>

                                <p style="text-align: center; margin-top: 1rem;">
                                    Don't have an account? <a href="register.jsp"
                                        style="color: var(--primary);">Register</a>
                                </p>

                                <div
                                    style="margin-top: 2rem; padding: 1rem; background: var(--light); border-radius: 5px; font-size: 0.9rem;">
                                    <p><strong>Demo Accounts:</strong></p>
                                    <p>Customer: customer@kalpana.com / customer123</p>
                                    <p>Admin: admin@kalpana.com / admin123</p>
                                </div>
            </div>

            <%@ include file="common/footer.jsp" %>