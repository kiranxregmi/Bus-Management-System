<%@ include file="../common/header.jsp" %>
    <% String scheduleId=request.getParameter("scheduleId"); String fare=request.getParameter("fare"); String
        busName=request.getParameter("busName"); String departure=request.getParameter("departure"); String
        arrival=request.getParameter("arrival"); if (scheduleId==null) { response.sendRedirect(request.getContextPath()
        + "/index.jsp" ); return; } %>

        <div class="container" style="padding: 2rem 1rem;">
            <h2 style="color: var(--primary); margin-bottom: 2rem;">Select Your Seats</h2>

            <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem;">
                <!-- Left Column: Seat Selection -->
                <div>
                    <div style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 2rem;">
                        <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Journey Details</h3>
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                            <div>
                                <p style="color: var(--gray); font-size: 0.9rem;">Bus</p>
                                <p style="font-weight: bold;"><%= busName %></p>
                            </div>
                            <div>
                                <p style="color: var(--gray); font-size: 0.9rem;">Fare per Seat</p>
                                <p style="font-weight: bold;">NPR <%= fare %></p>
                            </div>
                            <div>
                                <p style="color: var(--gray); font-size: 0.9rem;">Departure</p>
                                <p style="font-weight: bold;"><%= departure %></p>
                            </div>
                            <div>
                                <p style="color: var(--gray); font-size: 0.9rem;">Arrival</p>
                                <p style="font-weight: bold;"><%= arrival %></p>
                            </div>
                        </div>
                    </div>

                    <form action="${pageContext.request.contextPath}/booking" method="POST">
                        <input type="hidden" name="scheduleId" value="<%= scheduleId %>">
                        <input type="hidden" name="busName" value="<%= busName %>">
                        <input type="hidden" name="departure" value="<%= departure %>">
                        <input type="hidden" name="arrival" value="<%= arrival %>">
                        <input type="hidden" name="fare" value="<%= fare %>">

                        <div style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 2rem;">
                            <h3 style="color: var(--primary); margin-bottom: 1rem;">Select Your Seats</h3>
                            
                            <div style="background: var(--light); padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem; display: flex; gap: 2rem; font-size: 0.9rem;">
                                <div style="display: flex; align-items: center; gap: 0.5rem;">
                                    <div style="width: 20px; height: 20px; border: 2px solid #ddd; border-radius: 4px;"></div>
                                    <span>Available</span>
                                </div>
                                <div style="display: flex; align-items: center; gap: 0.5rem;">
                                    <div style="width: 20px; height: 20px; background: var(--primary); border-radius: 4px;"></div>
                                    <span>Selected</span>
                                </div>
                                <div style="display: flex; align-items: center; gap: 0.5rem;">
                                    <div style="width: 20px; height: 20px; background: #ccc; border-radius: 4px;"></div>
                                    <span>Booked</span>
                                </div>
                            </div>

                            <div class="seat-grid" style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 2rem;">
                                <% for (int i=1; i <=20; i++) { %>
                                    <div>
                                        <input type="checkbox" name="seats" value="<%= i %>" id="seat<%= i %>"
                                            style="display: none;" onchange="updateBooking()">
                                        <label for="seat<%= i %>" class="seat-label" style="display: block; padding: 1rem; text-align: center; border: 2px solid #ddd; border-radius: 8px; cursor: pointer; background: white; font-weight: bold; transition: all 0.3s ease;">
                                            <%= i %>
                                        </label>
                                    </div>
                                    <% } %>
                            </div>

                            <div style="background: var(--light); padding: 1rem; border-radius: 8px; margin-bottom: 2rem;">
                                <p style="margin: 0;">Selected Seats: <strong id="selectedSeatsDisplay">None</strong></p>
                                <p style="margin: 0.5rem 0 0 0;">Total Fare: <strong style="color: var(--primary); font-size: 1.2rem;">NPR <span id="totalFareDisplay">0.00</span></strong></p>
                            </div>
                        </div>

                        <!-- Passenger Details -->
                        <div style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                            <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Passenger Information</h3>

                            <div class="form-group">
                                <label>Contact Phone Number</label>
                                <input type="tel" name="contactPhone" placeholder="Enter your 10-digit phone number" value="<%= session.getAttribute("user") != null ? ((model.User)session.getAttribute("user")).getPhone() : "" %>" required>
                            </div>

                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" name="contactEmail" placeholder="your@email.com" value="<%= session.getAttribute("user") != null ? ((model.User)session.getAttribute("user")).getEmail() : "" %>" required>
                            </div>

                            <div id="passengerNames" style="margin-top: 2rem; padding-top: 2rem; border-top: 1px solid #ddd;"></div>

                            <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                                <a href="${pageContext.request.contextPath}/index.jsp" class="btn" style="width: auto; background: var(--gray);">Back</a>
                                <button type="submit" class="btn" style="width: auto; padding: 0.75rem 2rem;" onclick="return validateBooking()">Confirm Booking</button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Right Column: Summary -->
                <div style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); height: fit-content;">
                    <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Booking Summary</h3>
                    
                    <div style="display: flex; flex-direction: column; gap: 1rem;">
                        <div style="display: flex; justify-content: space-between; padding: 0.75rem 0; border-bottom: 1px solid #eee;">
                            <span>Bus Type:</span>
                            <strong><%= busName %></strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 0.75rem 0; border-bottom: 1px solid #eee;">
                            <span>Seats Selected:</span>
                            <strong id="seatCount">0</strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 0.75rem 0; border-bottom: 1px solid #eee;">
                            <span>Fare per Seat:</span>
                            <strong>NPR <%= fare %></strong>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding: 1rem 0; border-top: 2px solid var(--primary); border-bottom: 2px solid var(--primary); margin: 1rem 0;">
                            <span style="font-weight: bold;">Total Amount:</span>
                            <strong style="color: var(--primary); font-size: 1.3rem;">NPR <span id="totalAmount">0.00</span></strong>
                        </div>
                    </div>

                    <div style="background: var(--light); padding: 1rem; border-radius: 8px; margin-top: 1.5rem; font-size: 0.9rem;">
                        <p style="margin: 0; color: var(--gray);"><strong>Note:</strong> Please provide accurate passenger details for ticket generation.</p>
                    </div>
                </div>
            </div>
        </div>

        <style>
            .seat-label:hover {
                border-color: var(--primary);
                background: var(--light);
            }
            
            input[type="checkbox"]:checked + .seat-label {
                background: var(--primary);
                color: white;
                border-color: var(--primary);
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
                document.getElementById('seatCount').textContent = count;
                document.getElementById('totalAmount').textContent = total;
                
                // Generate passenger name fields
                var container = document.getElementById('passengerNames');
                if (count > 0) {
                    var html = '<label style="color: var(--primary); font-weight: bold; margin-bottom: 1rem; display: block;">Passenger Names (for seats: ' + selectedSeats.join(', ') + ')</label>';
                    for (var i = 0; i < count; i++) {
                        html += '<div class="form-group"><label>Passenger ' + (i + 1) + ' Name</label><input type="text" name="passengerName_' + (i + 1) + '" placeholder="Full name" required></div>';
                    }
                    container.innerHTML = html;
                } else {
                    container.innerHTML = '';
                }
            }

            function validateBooking() {
                var selected = document.querySelectorAll('input[name="seats"]:checked');
                if (selected.length === 0) {
                    alert('Please select at least one seat!');
                    return false;
                }
                return confirm('Confirm booking for ' + selected.length + ' seat(s)? Total: NPR ' + (selected.length * farePerSeat).toFixed(2));
            }

            // Initialize on page load
            updateBooking();
        </script>

        <%@ include file="../common/footer.jsp" %>