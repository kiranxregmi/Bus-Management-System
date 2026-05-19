<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ page import="model.User" %>
        <% User sessionUser=(User) session.getAttribute("user"); String userRole=(sessionUser !=null) ?
            sessionUser.getRole() : "" ; %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Kalpana Travels - Bus Management System</title>
                <link rel="preconnect" href="https://fonts.googleapis.com">
                <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css?v=2">
            </head>

            <body>
                <nav class="navbar">
                    <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
                        <span class="logo-icon"><img src="${pageContext.request.contextPath}/gallary/logo.jpeg" alt="Logo" style="height: 35px; width: auto; border-radius: 4px; vertical-align: middle; margin-right: 5px;"></span>Kalpana Travels
                    </a>
                    <button class="nav-toggle" id="navToggle" aria-label="Toggle menu">☰</button>
                    <ul class="nav-links">
                        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
                        <li><a href="${pageContext.request.contextPath}/rental.jsp">Rental</a></li>
                        <li><a href="${pageContext.request.contextPath}/about.jsp">About</a></li>
                        <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>

                        <% if (sessionUser==null) { %>
                            <li><a href="${pageContext.request.contextPath}/login.jsp" class="login-btn">Login</a></li>
                            <% } else { %>
                                <% if ("ADMIN".equals(userRole) || "OPERATOR".equals(userRole)) { %>
                                    <li><a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp">Admin Panel</a></li>
                                    <% } else { %>
                                        <li><a href="${pageContext.request.contextPath}/customer/dashboard.jsp">Dashboard</a></li>
                                        <li><a href="${pageContext.request.contextPath}/customer/myBookings.jsp">My Bookings</a></li>
                                        <% } %>
                                            <li style="position: relative;">
                                                <a href="#" style="display: flex; align-items: center;">Account <span style="margin-left: 5px;">▼</span></a>
                                                <div class="dropdown-menu" style="display: none; position: absolute; top: 100%; right: 0; background: white; border: 1px solid #ddd; border-radius: 5px; min-width: 180px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); z-index: 1000;">
                                                    <a href="${pageContext.request.contextPath}/customer/account.jsp" style="display: block; padding: 0.75rem 1rem; color: var(--dark); text-decoration: none; border-bottom: 1px solid #eee;">My Account</a>
                                                    <% if ("ADMIN".equals(userRole) || "OPERATOR".equals(userRole)) { %>
                                                        <a href="${pageContext.request.contextPath}/admin/adminDashboard.jsp" style="display: block; padding: 0.75rem 1rem; color: var(--dark); text-decoration: none; border-bottom: 1px solid #eee;">Admin Dashboard</a>
                                                    <% } %>
                                                    <a href="${pageContext.request.contextPath}/logout" style="display: block; padding: 0.75rem 1rem; color: var(--danger); text-decoration: none;">Logout</a>
                                                </div>
                                            </li>
                                            <script>
                                                // Dropdown logic
                                                document.querySelector('li[style*="position: relative"] > a').addEventListener('click', function(e) {
                                                    e.preventDefault();
                                                    var menu = this.parentElement.querySelector('.dropdown-menu');
                                                    menu.style.display = menu.style.display === 'none' ? 'block' : 'none';
                                                });

                                                // Mobile menu toggle logic
                                                document.getElementById('navToggle').addEventListener('click', function() {
                                                    const navLinks = document.querySelector('.nav-links');
                                                    navLinks.classList.toggle('active');
                                                    this.textContent = navLinks.classList.contains('active') ? '✕' : '☰';
                                                });

                                                document.addEventListener('click', function(e) {
                                                    var accountLi = document.querySelector('li[style*="position: relative"]');
                                                    if (accountLi && !accountLi.contains(e.target)) {
                                                        const menu = document.querySelector('.dropdown-menu');
                                                        if(menu) menu.style.display = 'none';
                                                    }

                                                    // Close mobile menu when clicking outside
                                                    const navLinks = document.querySelector('.nav-links');
                                                    const navToggle = document.getElementById('navToggle');
                                                    if (navLinks.classList.contains('active') && !navLinks.contains(e.target) && !navToggle.contains(e.target)) {
                                                        navLinks.classList.remove('active');
                                                        navToggle.textContent = '☰';
                                                    }
                                                });
                                            </script>
                                            <% } %>
                    </ul>
                </nav>
                <main>