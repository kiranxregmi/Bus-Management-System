<%@ include file="common/header.jsp" %>
    <% 
    // Redirect if already logged in 
    if (session.getAttribute("user") != null) { 
        response.sendRedirect("index.jsp");
        return; 
    } 
    %>

        <div class="auth-container">
            <h2>Create Account</h2>
            <p>Join Kalpana Travels today</p>

            <% if (request.getAttribute("error") !=null) { %>
                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>
                <% } %>

                    <form action="${pageContext.request.contextPath}/register" method="POST"
                        onsubmit="return validateForm()">
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="fullName" id="fullName" placeholder="Enter your full name"
                                required>
                        </div>

                        <div class="form-group">
                            <label>Email Address</label>
                            <input type="email" name="email" id="email" placeholder="your@email.com" required>
                        </div>

                        <div class="form-group">
                            <label>Phone Number</label>
                            <input type="tel" name="phone" id="phone" placeholder="10-digit mobile number"
                                pattern="[0-9]{10}" required>
                        </div>

                        <div class="form-group">
                            <label>Password</label>
                            <input type="password" name="password" id="password" placeholder="At least 6 characters"
                                minlength="6" required>
                        </div>

                        <div class="form-group">
                            <label>Confirm Password</label>
                            <input type="password" name="confirmPassword" id="confirmPassword"
                                placeholder="Re-enter password" required>
                        </div>

                        <button type="submit" class="btn">Register</button>
                    </form>

                    <p style="text-align: center; margin-top: 1rem;">
                        Already have an account? <a href="login.jsp" style="color: var(--primary);">Login</a>
                    </p>
        </div>

        <script>
            function validateForm() {
                var password = document.getElementById("password").value;
                var confirm = document.getElementById("confirmPassword").value;
                if (password !== confirm) {
                    alert("Passwords do not match!");
                    return false;
                }
                if (password.length < 6) {
                    alert("Password must be at least 6 characters!");
                    return false;
                }
                return true;
            }
        </script>

        <%@ include file="common/footer.jsp" %>