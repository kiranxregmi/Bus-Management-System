<%@ include file="../common/header.jsp" %>
    <%@ page import="model.Booking, model.User" %>
        <% 
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String bookingId = request.getParameter("bookingId");
        String scheduleId = request.getParameter("scheduleId");
        String seats = request.getParameter("seats");
        String totalFare = request.getParameter("totalFare");
        String busName = request.getParameter("busName");
        String departure = request.getParameter("departure");
        String arrival = request.getParameter("arrival");
        String source = request.getParameter("source");
        String destination = request.getParameter("destination");
        %>

        <div class="container" style="padding: 3rem 1rem; max-width: 900px;">
            <!-- Success Header -->
            <div style="text-align: center; margin-bottom: 3rem;">
                <div style="font-size: 4rem; margin-bottom: 1rem; animation: slideDown 0.6s ease;">
                    ✓
                </div>
                <h1 style="color: var(--primary); font-size: 2.5rem; margin: 0;">Booking Confirmed!</h1>
                <p style="color: var(--gray); font-size: 1.1rem; margin-top: 0.5rem;">Your booking has been successfully confirmed</p>
            </div>

            <!-- Main Content Grid -->
            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem; margin-bottom: 3rem;">
                <!-- Left: Confirmation Details -->
                <div style="background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); overflow: hidden;">
                    <!-- Header -->
                    <div style="background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%); color: white; padding: 2rem;">
                        <h2 style="margin: 0; font-size: 1.5rem;">Booking Confirmation</h2>
                        <p style="margin: 0.5rem 0 0 0; opacity: 0.9;">Booking Reference: #<%= bookingId %></p>
                    </div>

                    <!-- Journey Details -->
                    <div style="padding: 2rem; border-bottom: 1px solid #eee;">
                        <h3 style="color: var(--primary); margin-top: 0; margin-bottom: 1.5rem;">Journey Details</h3>
                        
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
                            <div>
                                <p style="color: var(--gray); font-size: 0.9rem; margin: 0;">FROM</p>
                                <p style="font-size: 1.3rem; font-weight: bold; color: var(--primary); margin: 0.5rem 0 0 0;"><%= source %></p>
                            </div>
                            <div>
                                <p style="color: var(--gray); font-size: 0.9rem; margin: 0;">TO</p>
                                <p style="font-size: 1.3rem; font-weight: bold; color: var(--primary); margin: 0.5rem 0 0 0;"><%= destination %></p>
                            </div>
                        </div>
                    </div>

                    <!-- Bus & Time Details -->
                    <div style="padding: 2rem; border-bottom: 1px solid #eee;">
                        <h3 style="color: var(--primary); margin-top: 0; margin-bottom: 1.5rem;">Bus & Time</h3>
                        
                        <div style="background: var(--light); padding: 1.5rem; border-radius: 10px; margin-bottom: 1rem;">
                            <p style="margin: 0 0 0.5rem 0; color: var(--gray); font-size: 0.9rem;">Bus Name</p>
                            <p style="font-size: 1.2rem; font-weight: bold; color: var(--dark); margin: 0;"><%= busName %></p>
                        </div>

                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div style="background: var(--light); padding: 1rem; border-radius: 8px;">
                                <p style="margin: 0 0 0.3rem 0; color: var(--gray); font-size: 0.85rem;">Departure</p>
                                <p style="font-size: 1.1rem; font-weight: bold; color: var(--dark); margin: 0;"><%= departure %></p>
                            </div>
                            <div style="background: var(--light); padding: 1rem; border-radius: 8px;">
                                <p style="margin: 0 0 0.3rem 0; color: var(--gray); font-size: 0.85rem;">Arrival</p>
                                <p style="font-size: 1.1rem; font-weight: bold; color: var(--dark); margin: 0;"><%= arrival %></p>
                            </div>
                        </div>
                    </div>

                    <!-- Seats & Fare -->
                    <div style="padding: 2rem;">
                        <h3 style="color: var(--primary); margin-top: 0; margin-bottom: 1.5rem;">Seats & Fare</h3>
                        
                        <div style="background: var(--light); padding: 1.5rem; border-radius: 10px; margin-bottom: 1rem;">
                            <p style="margin: 0 0 0.5rem 0; color: var(--gray); font-size: 0.9rem;">Selected Seats</p>
                            <p style="font-size: 1.1rem; font-weight: bold; color: var(--primary); margin: 0;"><%= seats %></p>
                        </div>

                        <div style="background: var(--light); padding: 1.5rem; border-radius: 10px;">
                            <p style="margin: 0 0 0.5rem 0; color: var(--gray); font-size: 0.9rem;">Number of Seats</p>
                            <p style="font-size: 1.1rem; font-weight: bold; color: var(--dark); margin: 0;"><%= seats.split(",").length %> Seat(s)</p>
                        </div>
                    </div>
                </div>

                <!-- Right: Payment Summary -->
                <div>
                    <!-- Price Box -->
                    <div style="background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); padding: 2rem; margin-bottom: 2rem;">
                        <h3 style="color: var(--primary); margin-top: 0;">Payment Summary</h3>
                        
                        <div style="padding: 1.5rem; background: var(--light); border-radius: 10px; margin-bottom: 1.5rem;">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 1rem; padding-bottom: 1rem; border-bottom: 1px solid #ddd;">
                                <span style="color: var(--gray);">Subtotal</span>
                                <span style="font-weight: bold;">NPR <%= totalFare %></span>
                            </div>
                            <div style="display: flex; justify-content: space-between; margin-bottom: 1rem; padding-bottom: 1rem; border-bottom: 1px solid #ddd;">
                                <span style="color: var(--gray);">Tax (0%)</span>
                                <span style="font-weight: bold;">NPR 0</span>
                            </div>
                            <div style="display: flex; justify-content: space-between;">
                                <span style="font-weight: bold; font-size: 1.1rem;">Total</span>
                                <span style="font-size: 1.3rem; font-weight: bold; color: var(--primary);">NPR <%= totalFare %></span>
                            </div>
                        </div>

                        <div style="background: #e8f5e9; border-left: 4px solid var(--success); padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">
                            <p style="margin: 0; color: var(--success); font-weight: bold;">Payment Status: CONFIRMED</p>
                        </div>

                        <a href="${pageContext.request.contextPath}/customer/myBookings.jsp" class="btn" style="width: 100%; padding: 0.75rem; text-align: center; display: block;">View My Bookings</a>
                    </div>

                    <!-- Info Box -->
                    <div style="background: white; border-radius: 15px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); padding: 1.5rem;">
                        <h4 style="color: var(--primary); margin-top: 0;">Important Info</h4>
                        <ul style="margin: 0; padding-left: 1.5rem; font-size: 0.95rem; color: var(--gray); line-height: 1.8;">
                            <li>Check your email for booking confirmation</li>
                            <li>Arrive 30 minutes before departure</li>
                            <li>Carry a valid ID proof</li>
                            <li>Keep your booking reference for check-in</li>
                        </ul>
                    </div>
                </div>
            </div>

            <!-- Action Buttons -->
            <div style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/index.jsp" class="btn" style="width: auto; padding: 0.75rem 2rem; background: var(--secondary);">Search Another Trip</a>
                <a href="${pageContext.request.contextPath}/customer/dashboard.jsp" class="btn" style="width: auto; padding: 0.75rem 2rem; background: var(--gray);">Back to Dashboard</a>
            </div>
        </div>

        <style>
            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .btn {
                background: var(--primary);
                color: white;
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 8px;
                cursor: pointer;
                text-decoration: none;
                font-weight: bold;
                transition: all 0.3s ease;
            }

            .btn:hover {
                background: var(--secondary);
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            }
        </style>

        <%@ include file="../common/footer.jsp" %>
