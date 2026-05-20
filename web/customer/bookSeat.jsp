<%@ include file="../common/header.jsp" %>
    <% String scheduleId=request.getParameter("scheduleId"); String fare=request.getParameter("fare"); String
        busName=request.getParameter("busName"); String departure=request.getParameter("departure"); String
        arrival=request.getParameter("arrival"); String source=request.getParameter("source"); String
        destination=request.getParameter("destination"); if (scheduleId==null) { response.sendRedirect(request.getContextPath()
        + "/index.jsp" ); return; } 
        
        java.util.List<String> bookedSeats = new java.util.ArrayList<>();
        try {
            bookedSeats = new dao.BookingDAO().getBookedSeatsBySchedule(Integer.parseInt(scheduleId));
        } catch (Exception e) {
            e.printStackTrace();
        }
        %>

        <div class="container" style="padding: 2rem 1rem; margin-bottom: 8rem;">
            <h2 style="color: var(--primary); margin-bottom: 2rem; text-align: center;">Select Your Seats</h2>

            <div style="display: grid; grid-template-columns: 1fr; gap: 2rem; max-width: 900px; margin: 0 auto;">
                <!-- Journey Details -->
                <div style="background: var(--white); padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 1rem;">
                    <h3 style="color: var(--primary); margin-bottom: 1rem; font-size: 1.2rem; border-bottom: 2px solid #f0f2f5; padding-bottom: 0.5rem;">Journey Details</h3>
                    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1.5rem;">
                        <div>
                            <p style="color: var(--gray); font-size: 0.85rem; margin: 0;">Bus</p>
                            <p style="font-weight: bold; margin: 2px 0 0 0;"><%= busName %></p>
                        </div>
                        <div>
                            <p style="color: var(--gray); font-size: 0.85rem; margin: 0;">Fare per Seat</p>
                            <p style="font-weight: bold; color: var(--secondary); margin: 2px 0 0 0;">NPR <%= fare %></p>
                        </div>
                        <div>
                            <p style="color: var(--gray); font-size: 0.85rem; margin: 0;">Route</p>
                            <p style="font-weight: bold; margin: 2px 0 0 0;"><%= source != null ? source : "N/A" %> to <%= destination != null ? destination : "N/A" %></p>
                        </div>
                        <div>
                            <p style="color: var(--gray); font-size: 0.85rem; margin: 0;">Departure</p>
                            <p style="font-weight: bold; margin: 2px 0 0 0;"><%= departure %></p>
                        </div>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/booking" method="POST" id="bookingForm">
                    <input type="hidden" name="scheduleId" value="<%= scheduleId %>">
                    <input type="hidden" name="busName" value="<%= busName %>">
                    <input type="hidden" name="departure" value="<%= departure %>">
                    <input type="hidden" name="arrival" value="<%= arrival %>">
                    <input type="hidden" name="fare" value="<%= fare %>">
                    <input type="hidden" name="source" value="<%= source != null ? source : "" %>">
                    <input type="hidden" name="destination" value="<%= destination != null ? destination : "" %>">

                    <!-- Premium Seat Selector Cabin -->
                    <div style="background: var(--white); padding: 2rem; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 2rem;">
                        
                        <!-- Legends -->
                        <div style="background: var(--light); padding: 1rem; border-radius: 8px; margin-bottom: 2rem; display: flex; justify-content: center; gap: 2rem; font-size: 0.9rem;">
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <svg width="22" height="22" viewBox="0 0 100 100" fill="#6aa84f"><path d="M20,35 L80,35 C85,35 88,38 88,42 L88,75 C88,80 85,83 80,83 L20,83 C15,83 12,80 12,75 L12,42 C12,38 15,35 20,35 Z M25,15 L75,15 C79,15 82,18 82,22 L82,35 L18,35 L18,22 C18,18 21,15 25,15 Z M8,42 L18,42 C20,42 21,44 21,46 L21,75 C21,77 20,78 18,78 L8,78 C6,78 5,77 5,75 L5,46 C5,44 6,42 8,42 Z M82,42 L92,42 C94,42 95,44 95,46 L95,75 C95,77 94,78 92,78 L82,78 C80,78 79,77 79,75 L79,46 C79,44 80,42 82,42 Z" /></svg>
                                <span>Available</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <svg width="22" height="22" viewBox="0 0 100 100" fill="#ffd100"><path d="M20,35 L80,35 C85,35 88,38 88,42 L88,75 C88,80 85,83 80,83 L20,83 C15,83 12,80 12,75 L12,42 C12,38 15,35 20,35 Z M25,15 L75,15 C79,15 82,18 82,22 L82,35 L18,35 L18,22 C18,18 21,15 25,15 Z M8,42 L18,42 C20,42 21,44 21,46 L21,75 C21,77 20,78 18,78 L8,78 C6,78 5,77 5,75 L5,46 C5,44 6,42 8,42 Z M82,42 L92,42 C94,42 95,44 95,46 L95,75 C95,77 94,78 92,78 L82,78 C80,78 79,77 79,75 L79,46 C79,44 80,42 82,42 Z" /></svg>
                                <span>Selected</span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 0.5rem;">
                                <svg width="22" height="22" viewBox="0 0 100 100" fill="#ccd1d9"><path d="M20,35 L80,35 C85,35 88,38 88,42 L88,75 C88,80 85,83 80,83 L20,83 C15,83 12,80 12,75 L12,42 C12,38 15,35 20,35 Z M25,15 L75,15 C79,15 82,18 82,22 L82,35 L18,35 L18,22 C18,18 21,15 25,15 Z M8,42 L18,42 C20,42 21,44 21,46 L21,75 C21,77 20,78 18,78 L8,78 C6,78 5,77 5,75 L5,46 C5,44 6,42 8,42 Z M82,42 L92,42 C94,42 95,44 95,46 L95,75 C95,77 94,78 92,78 L82,78 C80,78 79,77 79,75 L79,46 C79,44 80,42 82,42 Z" /></svg>
                                <span>Booked</span>
                            </div>
                        </div>

                        <!-- Bus cabin wrapper -->
                        <div class="bus-cabin-border">
                            <!-- Steering wheel row -->
                            <div class="steering-wheel-wrapper">
                                <svg width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="#e85d04" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <circle cx="12" cy="12" r="10"/>
                                    <line x1="12" y1="2" x2="12" y2="22"/>
                                    <line x1="2" y1="12" x2="22" y2="12"/>
                                </svg>
                            </div>

                            <!-- Cabin Row (Cabin-A to Cabin-D) -->
                            <div class="cabin-row">
                                <% String[] cabins = {"Cabin-A", "Cabin-B", "Cabin-C", "Cabin-D"};
                                   for (String cabin : cabins) { 
                                       boolean isBooked = bookedSeats.contains(cabin); %>
                                    <div>
                                        <% if (!isBooked) { %>
                                            <input type="checkbox" name="seats" value="<%= cabin %>" id="seat_<%= cabin %>" style="display: none;" onchange="updateBooking()">
                                        <% } %>
                                        <label for="seat_<%= cabin %>" class="armchair-label <%= isBooked ? "booked" : "" %>">
                                            <span class="seat-text"><%= cabin %></span>
                                            <svg class="armchair-icon" width="40" height="40" viewBox="0 0 100 100">
                                                <path d="M20,35 L80,35 C85,35 88,38 88,42 L88,75 C88,80 85,83 80,83 L20,83 C15,83 12,80 12,75 L12,42 C12,38 15,35 20,35 Z M25,15 L75,15 C79,15 82,18 82,22 L82,35 L18,35 L18,22 C18,18 21,15 25,15 Z M8,42 L18,42 C20,42 21,44 21,46 L21,75 C21,77 20,78 18,78 L8,78 C6,78 5,77 5,75 L5,46 C5,44 6,42 8,42 Z M82,42 L92,42 C94,42 95,44 95,46 L95,75 C95,77 94,78 92,78 L82,78 C80,78 79,77 79,75 L79,46 C79,44 80,42 82,42 Z" />
                                            </svg>
                                        </label>
                                    </div>
                                <% } %>
                            </div>

                            <!-- Passenger Seats Grid -->
                            <div class="passenger-row-grid">
                                <% for (int r = 1; r <= 8; r++) { 
                                    // Left column 1
                                    String seatL1 = "A" + (2*r - 1);
                                    boolean isBookedL1 = bookedSeats.contains(seatL1);
                                    
                                    // Left column 2
                                    String seatL2 = "A" + (2*r);
                                    boolean isBookedL2 = bookedSeats.contains(seatL2);
                                    
                                    // Right column 1
                                    String seatR1 = "B" + (2*r - 1);
                                    boolean isBookedR1 = bookedSeats.contains(seatR1);
                                    
                                    // Right column 2
                                    String seatR2 = "B" + (2*r);
                                    boolean isBookedR2 = bookedSeats.contains(seatR2);
                                %>
                                    <!-- Seat L1 -->
                                    <div>
                                        <% if (!isBookedL1) { %>
                                            <input type="checkbox" name="seats" value="<%= seatL1 %>" id="seat_<%= seatL1 %>" style="display: none;" onchange="updateBooking()">
                                        <% } %>
                                        <label for="seat_<%= seatL1 %>" class="armchair-label <%= isBookedL1 ? "booked" : "" %>">
                                            <span class="seat-text"><%= seatL1 %></span>
                                            <svg class="armchair-icon" width="38" height="38" viewBox="0 0 100 100">
                                                <path d="M20,35 L80,35 C85,35 88,38 88,42 L88,75 C88,80 85,83 80,83 L20,83 C15,83 12,80 12,75 L12,42 C12,38 15,35 20,35 Z M25,15 L75,15 C79,15 82,18 82,22 L82,35 L18,35 L18,22 C18,18 21,15 25,15 Z M8,42 L18,42 C20,42 21,44 21,46 L21,75 C21,77 20,78 18,78 L8,78 C6,78 5,77 5,75 L5,46 C5,44 6,42 8,42 Z M82,42 L92,42 C94,42 95,44 95,46 L95,75 C95,77 94,78 92,78 L82,78 C80,78 79,77 79,75 L79,46 C79,44 80,42 82,42 Z" />
                                            </svg>
                                        </label>
                                    </div>
                                    
                                    <!-- Seat L2 -->
                                    <div>
                                        <% if (!isBookedL2) { %>
                                            <input type="checkbox" name="seats" value="<%= seatL2 %>" id="seat_<%= seatL2 %>" style="display: none;" onchange="updateBooking()">
                                        <% } %>
                                        <label for="seat_<%= seatL2 %>" class="armchair-label <%= isBookedL2 ? "booked" : "" %>">
                                            <span class="seat-text"><%= seatL2 %></span>
                                            <svg class="armchair-icon" width="38" height="38" viewBox="0 0 100 100">
                                                <path d="M20,35 L80,35 C85,35 88,38 88,42 L88,75 C88,80 85,83 80,83 L20,83 C15,83 12,80 12,75 L12,42 C12,38 15,35 20,35 Z M25,15 L75,15 C79,15 82,18 82,22 L82,35 L18,35 L18,22 C18,18 21,15 25,15 Z M8,42 L18,42 C20,42 21,44 21,46 L21,75 C21,77 20,78 18,78 L8,78 C6,78 5,77 5,75 L5,46 C5,44 6,42 8,42 Z M82,42 L92,42 C94,42 95,44 95,46 L95,75 C95,77 94,78 92,78 L82,78 C80,78 79,77 79,75 L79,46 C79,44 80,42 82,42 Z" />
                                            </svg>
                                        </label>
                                    </div>

                                    <!-- Aisle Spacer -->
                                    <div class="aisle-spacer"></div>

                                    <!-- Seat R1 -->
                                    <div>
                                        <% if (!isBookedR1) { %>
                                            <input type="checkbox" name="seats" value="<%= seatR1 %>" id="seat_<%= seatR1 %>" style="display: none;" onchange="updateBooking()">
                                        <% } %>
                                        <label for="seat_<%= seatR1 %>" class="armchair-label <%= isBookedR1 ? "booked" : "" %>">
                                            <span class="seat-text"><%= seatR1 %></span>
                                            <svg class="armchair-icon" width="38" height="38" viewBox="0 0 100 100">
                                                <path d="M20,35 L80,35 C85,35 88,38 88,42 L88,75 C88,80 85,83 80,83 L20,83 C15,83 12,80 12,75 L12,42 C12,38 15,35 20,35 Z M25,15 L75,15 C79,15 82,18 82,22 L82,35 L18,35 L18,22 C18,18 21,15 25,15 Z M8,42 L18,42 C20,42 21,44 21,46 L21,75 C21,77 20,78 18,78 L8,78 C6,78 5,77 5,75 L5,46 C5,44 6,42 8,42 Z M82,42 L92,42 C94,42 95,44 95,46 L95,75 C95,77 94,78 92,78 L82,78 C80,78 79,77 79,75 L79,46 C79,44 80,42 82,42 Z" />
                                            </svg>
                                        </label>
                                    </div>
                                    
                                    <!-- Seat R2 -->
                                    <div>
                                        <% if (!isBookedR2) { %>
                                            <input type="checkbox" name="seats" value="<%= seatR2 %>" id="seat_<%= seatR2 %>" style="display: none;" onchange="updateBooking()">
                                        <% } %>
                                        <label for="seat_<%= seatR2 %>" class="armchair-label <%= isBookedR2 ? "booked" : "" %>">
                                            <span class="seat-text"><%= seatR2 %></span>
                                            <svg class="armchair-icon" width="38" height="38" viewBox="0 0 100 100">
                                                <path d="M20,35 L80,35 C85,35 88,38 88,42 L88,75 C88,80 85,83 80,83 L20,83 C15,83 12,80 12,75 L12,42 C12,38 15,35 20,35 Z M25,15 L75,15 C79,15 82,18 82,22 L82,35 L18,35 L18,22 C18,18 21,15 25,15 Z M8,42 L18,42 C20,42 21,44 21,46 L21,75 C21,77 20,78 18,78 L8,78 C6,78 5,77 5,75 L5,46 C5,44 6,42 8,42 Z M82,42 L92,42 C94,42 95,44 95,46 L95,75 C95,77 94,78 92,78 L82,78 C80,78 79,77 79,75 L79,46 C79,44 80,42 82,42 Z" />
                                            </svg>
                                        </label>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                    <!-- Passenger Details -->
                    <div style="background: var(--white); padding: 2rem; border-radius: 15px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); margin-bottom: 2rem;">
                        <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Passenger Information</h3>

                        <div class="form-group" style="margin-bottom: 1.25rem;">
                            <label style="font-weight: 600; margin-bottom: 0.5rem; display: block;">Contact Phone Number</label>
                            <input type="tel" name="contactPhone" style="width: 100%; padding: 0.8rem; border: 1.5px solid #ddd; border-radius: 8px; font-size: 1rem;" placeholder="Enter your 10-digit phone number" value="<%= session.getAttribute("user") != null ? ((model.User)session.getAttribute("user")).getPhone() : "" %>" required>
                        </div>

                        <div class="form-group" style="margin-bottom: 1.25rem;">
                            <label style="font-weight: 600; margin-bottom: 0.5rem; display: block;">Email Address</label>
                            <input type="email" name="contactEmail" style="width: 100%; padding: 0.8rem; border: 1.5px solid #ddd; border-radius: 8px; font-size: 1rem;" placeholder="your@email.com" value="<%= session.getAttribute("user") != null ? ((model.User)session.getAttribute("user")).getEmail() : "" %>" required>
                        </div>

                        <div id="passengerNames" style="margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px dashed #ddd;"></div>
                    </div>

                    <!-- Sticky Bottom Bar -->
                    <div class="sticky-booking-bar">
                        <div>
                            <p style="margin: 0; font-size: 0.85rem; opacity: 0.85; font-weight: 500;">Selected Seat(s)</p>
                            <p style="margin: 3px 0 0 0; font-weight: 800; font-size: 1.25rem;" id="selectedSeatsDisplay">None</p>
                        </div>
                        <div style="display: flex; align-items: center; gap: 1.5rem;">
                            <div style="text-align: right;">
                                <p style="margin: 0; font-size: 0.85rem; opacity: 0.85; font-weight: 500;">Total Fare</p>
                                <p style="margin: 3px 0 0 0; font-weight: 800; font-size: 1.25rem; color: #ffd100;">NPR <span id="totalFareDisplay">0.00</span></p>
                            </div>
                            <button type="button" class="btn" style="background: #2ec4b6; color: white; border: none; padding: 0.8rem 2.2rem; border-radius: 8px; font-weight: bold; cursor: pointer; transition: all 0.2s;" onclick="showConfirmModal()">Book</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Premium Custom HTML Modal Dialog for Confirmation -->
        <div id="confirmModal" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(10, 20, 50, 0.6); z-index: 100000; align-items: center; justify-content: center; backdrop-filter: blur(5px);">
            <div style="background: white; padding: 2.2rem; border-radius: 20px; max-width: 460px; width: 90%; box-shadow: 0 15px 40px rgba(0,0,0,0.25); text-align: center; animation: modalZoomIn 0.35s cubic-bezier(0.34, 1.56, 0.64, 1) both; border: 1px solid rgba(0,0,0,0.08);">
                <div style="font-size: 3.5rem; margin-bottom: 0.5rem;">🎟️</div>
                <h3 style="margin: 0 0 1rem 0; color: #1a3e6f; font-size: 1.5rem; font-weight: 800;">Confirm Booking</h3>
                <p style="color: var(--gray); font-size: 0.95rem; margin-bottom: 1.5rem;">Please review your reservation details below before confirming.</p>
                
                <div style="background: #f8fafc; padding: 1.25rem; border-radius: 12px; margin-bottom: 2rem; text-align: left; font-size: 0.95rem; border: 1px solid #e2e8f0; line-height: 1.6;">
                    <p style="margin: 0 0 0.6rem 0;"><strong style="color: #4e5564;">Selected Seats:</strong> <span id="modalSeats" style="color: #0055a5; font-weight: bold;"></span></p>
                    <p style="margin: 0 0 0.6rem 0;"><strong style="color: #4e5564;">Total Amount:</strong> <span style="color: #2ec4b6; font-weight: 800; font-size: 1.1rem;">NPR <span id="modalFare"></span></span></p>
                    <p style="margin: 0;"><strong style="color: #4e5564;">Passengers:</strong> <span id="modalNames" style="color: #2b2d42; font-weight: 600;"></span></p>
                </div>
                
                <div style="display: flex; gap: 1rem; justify-content: center;">
                    <button type="button" class="btn" style="background: #ccd1d9; color: #4e5564; padding: 0.8rem 1.8rem; border-radius: 8px; font-weight: bold; border: none; cursor: pointer; transition: all 0.2s;" onclick="closeConfirmModal()">Cancel</button>
                    <button type="button" class="btn" style="background: #2ec4b6; color: white; padding: 0.8rem 2.2rem; border-radius: 8px; font-weight: bold; border: none; cursor: pointer; transition: all 0.2s;" onclick="submitBookingForm()">Confirm & Pay</button>
                </div>
            </div>
        </div>

        <style>
            .bus-cabin-border {
                border: 4px solid #1a3e6f;
                border-radius: 24px;
                padding: 2rem 1.5rem;
                background: #f8fafc;
                max-width: 460px;
                margin: 0 auto 2rem;
                box-shadow: inset 0 0 20px rgba(0,0,0,0.06);
            }
            .steering-wheel-wrapper {
                display: flex;
                justify-content: flex-end;
                margin-bottom: 1rem;
                padding-right: 0.5rem;
            }
            .cabin-row {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 0.5rem;
                margin-bottom: 1.5rem;
                border-bottom: 2px dashed #ccd1d9;
                padding-bottom: 1.5rem;
            }
            .passenger-row-grid {
                display: grid;
                grid-template-columns: 1fr 1fr 0.4fr 1fr 1fr;
                gap: 1.25rem 0.5rem;
                align-items: center;
            }
            .aisle-spacer {
                height: 100%;
            }
            .armchair-label {
                display: flex;
                flex-direction: column;
                align-items: center;
                cursor: pointer;
                transition: all 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                user-select: none;
            }
            .armchair-icon {
                fill: #6aa84f; /* Leaf green armchair */
                transition: all 0.2s ease;
                filter: drop-shadow(0 2px 4px rgba(0,0,0,0.12));
            }
            .seat-text {
                font-size: 0.72rem;
                font-weight: 800;
                color: #2b2d42;
                margin-bottom: 0.25rem;
            }
            /* Hover effect */
            .armchair-label:hover .armchair-icon {
                fill: #558c3d;
                transform: scale(1.08);
            }
            /* Checked/Selected State */
            input[type="checkbox"]:checked + .armchair-label .armchair-icon {
                fill: #ffd100; /* Bright yellow like the first image */
            }
            input[type="checkbox"]:checked + .armchair-label .seat-text {
                color: #b58900;
                font-weight: 900;
            }
            /* Booked State */
            .armchair-label.booked {
                cursor: not-allowed;
                opacity: 0.55;
            }
            .armchair-label.booked .armchair-icon {
                fill: #ccd1d9 !important;
                filter: grayscale(1);
            }
            .armchair-label.booked .seat-text {
                color: #8e9bb0;
            }
            .armchair-label.booked:hover .armchair-icon {
                transform: none;
            }
            
            .sticky-booking-bar {
                position: fixed;
                bottom: 0;
                left: 0;
                right: 0;
                background: #0055a5;
                color: white;
                padding: 1.2rem 2.5rem;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-top-left-radius: 20px;
                border-top-right-radius: 20px;
                box-shadow: 0 -8px 30px rgba(0,0,0,0.2);
                z-index: 9999;
                max-width: 900px;
                margin: 0 auto;
                animation: slideUpBar 0.4s cubic-bezier(0.16, 1, 0.3, 1) both;
            }
            
            @keyframes slideUpBar {
                from { transform: translateY(100%); }
                to { transform: translateY(0); }
            }

            @keyframes modalZoomIn {
                from { transform: scale(0.9); opacity: 0; }
                to { transform: scale(1); opacity: 1; }
            }
        </style>

        <script>
            var farePerSeat = <%= fare %>;

            function updateBooking() {
                var checkboxes = document.querySelectorAll('input[name="seats"]:checked');
                var selectedSeats = [];
                
                checkboxes.forEach(function (cb) {
                    selectedSeats.push(cb.value);
                });

                var count = selectedSeats.length;
                var total = (count * farePerSeat).toFixed(2);
                
                document.getElementById('selectedSeatsDisplay').textContent = count > 0 ? selectedSeats.join(', ') : 'None';
                document.getElementById('totalFareDisplay').textContent = total;
                
                // Generate passenger name fields
                var container = document.getElementById('passengerNames');
                if (count > 0) {
                    var html = '<label style="color: var(--primary); font-weight: bold; margin-bottom: 1rem; display: block; font-size: 1.05rem;">Passenger Names (for seats: ' + selectedSeats.join(', ') + ')</label>';
                    for (var i = 0; i < count; i++) {
                        html += '<div class="form-group" style="margin-bottom: 1rem;"><label style="font-weight: 500; display: block; margin-bottom: 0.35rem;">Passenger ' + (i + 1) + ' Name (' + selectedSeats[i] + ')</label><input type="text" name="passengerName_' + (i + 1) + '" style="width: 100%; padding: 0.75rem; border: 1.5px solid #ddd; border-radius: 8px; font-size: 0.95rem;" placeholder="Full name" required></div>';
                    }
                    container.innerHTML = html;
                } else {
                    container.innerHTML = '';
                }
            }

            function showConfirmModal() {
                var selected = document.querySelectorAll('input[name="seats"]:checked');
                if (selected.length === 0) {
                    alert('Please select at least one seat!');
                    return;
                }
                
                // Get selected seat names
                var selectedSeats = [];
                selected.forEach(function (cb) {
                    selectedSeats.push(cb.value);
                });
                
                // Get passenger names and validate
                var passengerNames = [];
                for (var i = 1; i <= selected.length; i++) {
                    var input = document.querySelector('input[name="passengerName_' + i + '"]');
                    if (input && input.value.trim() !== '') {
                        passengerNames.push(input.value.trim());
                    } else {
                        alert('Please fill in all passenger names!');
                        if (input) input.focus();
                        return;
                    }
                }
                
                // Check contact details
                var phone = document.querySelector('input[name="contactPhone"]').value.trim();
                var email = document.querySelector('input[name="contactEmail"]').value.trim();
                if (phone === '' || email === '') {
                    alert('Please enter your contact details!');
                    return;
                }

                // Update modal elements
                document.getElementById('modalSeats').textContent = selectedSeats.join(', ');
                document.getElementById('modalFare').textContent = (selected.length * farePerSeat).toFixed(2);
                document.getElementById('modalNames').textContent = passengerNames.join(', ');
                
                // Show modal
                document.getElementById('confirmModal').style.display = 'flex';
            }

            function closeConfirmModal() {
                document.getElementById('confirmModal').style.display = 'none';
            }

            function submitBookingForm() {
                document.getElementById('bookingForm').submit();
            }

            // Initialize on page load
            updateBooking();
        </script>

        <%@ include file="../common/footer.jsp" %>