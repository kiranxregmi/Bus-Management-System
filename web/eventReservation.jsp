<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    String eventType = request.getParameter("eventType");
    if (eventType == null) {
        eventType = "";
    }
    
    HttpSession session2 = request.getSession(false);
    boolean isLoggedIn = session2 != null && session2.getAttribute("user") != null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Event Reservation - Kalpana Travels</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .event-container {
            max-width: 900px;
            margin: 40px auto;
            padding: 20px;
        }
        
        .event-header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .event-header h1 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .event-header p {
            color: #666;
            font-size: 0.95em;
        }
        
        .event-form {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .form-section {
            margin-bottom: 30px;
            border-bottom: 1px solid #ecf0f1;
            padding-bottom: 20px;
        }
        
        .form-section:last-child {
            border-bottom: none;
        }
        
        .section-title {
            color: #2c3e50;
            font-size: 1.2em;
            margin-bottom: 15px;
            font-weight: bold;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group.required label::after {
            content: " *";
            color: red;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 0.95em;
            font-family: Arial, sans-serif;
            box-sizing: border-box;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #16a085;
            box-shadow: 0 0 5px rgba(22, 160, 133, 0.3);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
        
        .wedding-banner {
            background: linear-gradient(135deg, #fff5f7 0%, #ffe8ed 100%);
            border: 2px solid #e74c3c;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .wedding-banner h3 {
            color: #e74c3c;
            margin: 0;
        }
        
        .wedding-banner p {
            color: #c0392b;
            margin: 5px 0 0 0;
            font-size: 0.9em;
        }
        
        .submit-btn {
            background-color: #16a085;
            color: white;
            padding: 12px 40px;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
            margin-right: 10px;
        }
        
        .submit-btn:hover {
            background-color: #138d75;
        }
        
        .cancel-btn {
            background-color: #95a5a6;
            color: white;
            padding: 12px 40px;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-decoration: none;
            display: inline-block;
        }
        
        .cancel-btn:hover {
            background-color: #7f8c8d;
        }
        
        .form-buttons {
            margin-top: 30px;
            text-align: center;
        }
        
        .login-message {
            background-color: #fff3cd;
            border: 1px solid #ffc107;
            color: #856404;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .login-message a {
            color: #0c5460;
            text-decoration: none;
            font-weight: bold;
        }
        
        .success-message {
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
            color: #155724;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .error-message {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            color: #721c24;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .help-text {
            font-size: 0.85em;
            color: #7f8c8d;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <%@ include file="common/header.jsp" %>
    
    <div class="event-container">
        <div class="event-header">
            <% if ("WEDDING".equals(eventType)) { %>
                <h1>💒 Wedding Bus Reservation</h1>
                <p>Book our premium buses for your wedding guest transportation</p>
            <% } else { %>
                <h1>🚌 Event Bus Reservation</h1>
                <p>Book buses for your corporate events, tours, parties, and group travels</p>
            <% } %>
        </div>
        
        <% if (!isLoggedIn) { %>
            <div class="login-message">
                Please <a href="${pageContext.request.contextPath}/login.jsp">login</a> to book an event reservation
            </div>
        <% } else { %>
        
        <% 
            String successMsg = request.getParameter("success");
            String errorMsg = request.getParameter("error");
        %>
        
        <% if ("true".equals(successMsg)) { %>
            <div class="success-message">
                ✓ Your event reservation has been submitted successfully! Our team will review your request and contact you within 24 hours.
            </div>
        <% } %>
        
        <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="error-message">
                ✗ Error: <%= errorMsg %>
            </div>
        <% } %>
        
        <form action="${pageContext.request.contextPath}/eventReservation" method="POST" class="event-form">
            <% if ("WEDDING".equals(eventType)) { %>
                <div class="wedding-banner">
                    <h3>💝 Premium Wedding Package</h3>
                    <p>Includes: Red carpet decoration, professional drivers, complimentary refreshments, and wedding coordination support</p>
                </div>
                <input type="hidden" name="eventType" value="WEDDING">
            <% } else { %>
                <!-- Event Type Selection -->
                <div class="form-section">
                    <div class="section-title">Event Details</div>
                    
                    <div class="form-group required">
                        <label for="eventType">Event Type:</label>
                        <select id="eventType" name="eventType" required>
                            <option value="">-- Select Event Type --</option>
                            <option value="WEDDING">Wedding Reservation</option>
                            <option value="CORPORATE">Corporate Event</option>
                            <option value="TOUR">Group Tour</option>
                            <option value="PARTY">Birthday/Party Event</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                </div>
            <% } %>
            
            <!-- Basic Information -->
            <div class="form-section">
                <div class="section-title">Basic Information</div>
                
                <div class="form-group required">
                    <label for="eventName">Event Name:</label>
                    <input type="text" id="eventName" name="eventName" placeholder="e.g., Johnson Family Wedding" required>
                </div>
                
                <div class="form-row">
                    <div class="form-group required">
                        <label for="eventDate">Event Date:</label>
                        <input type="date" id="eventDate" name="eventDate" required>
                    </div>
                    
                    <div class="form-group required">
                        <label for="requiredDate">Service Required Date:</label>
                        <input type="date" id="requiredDate" name="requiredDate" required>
                        <div class="help-text">Date when you need bus transportation</div>
                    </div>
                </div>
            </div>
            
            <!-- Passenger & Bus Details -->
            <div class="form-section">
                <div class="section-title">Passenger & Bus Requirements</div>
                
                <div class="form-row">
                    <div class="form-group required">
                        <label for="numberOfPassengers">Total Passengers:</label>
                        <input type="number" id="numberOfPassengers" name="numberOfPassengers" min="1" max="5000" placeholder="e.g., 100" required>
                    </div>
                    
                    <div class="form-group required">
                        <label for="numberOfBuses">Number of Buses Needed:</label>
                        <input type="number" id="numberOfBuses" name="numberOfBuses" min="1" max="100" placeholder="e.g., 2" required>
                    </div>
                </div>
                
                <div class="form-group required">
                    <label for="preferredBusType">Preferred Bus Type:</label>
                    <select id="preferredBusType" name="preferredBusType" required>
                        <option value="">-- Select Bus Type --</option>
                        <option value="Regular">Regular Seating (50 seats)</option>
                        <option value="Sleeper">Sleeper Configuration (48 beds)</option>
                        <option value="Luxury">Luxury Sleeper (36 deluxe beds)</option>
                        <option value="Any">Any Available</option>
                    </select>
                </div>
            </div>
            
            <!-- Location & Route Details -->
            <div class="form-section">
                <div class="section-title">Travel Details</div>
                
                <div class="form-group required">
                    <label for="pickupLocation">Pickup Location:</label>
                    <input type="text" id="pickupLocation" name="pickupLocation" placeholder="Address or landmark" required>
                </div>
                
                <div class="form-group required">
                    <label for="dropoffLocation">Dropoff Location:</label>
                    <input type="text" id="dropoffLocation" name="dropoffLocation" placeholder="Address or landmark" required>
                </div>
            </div>
            
            <!-- Additional Requirements -->
            <div class="form-section">
                <div class="section-title">Special Requirements</div>
                
                <div class="form-group">
                    <label for="description">Special Requests & Notes:</label>
                    <textarea id="description" name="description" placeholder="Any special requirements, preferences, or notes for our team..."></textarea>
                    <div class="help-text">E.g., decoration preferences, meal arrangements, specific timing, accessibility needs</div>
                </div>
            </div>
            
            <!-- Consent -->
            <div class="form-section">
                <div class="form-group required">
                    <label for="agree" style="display: flex; align-items: center;">
                        <input type="checkbox" id="agree" name="agree" required style="width: auto; margin-right: 10px;">
                        <span>I agree to the booking terms and conditions. Our team will contact me within 24 hours to confirm the reservation and provide a quote.</span>
                    </label>
                </div>
            </div>
            
            <!-- Submit Buttons -->
            <div class="form-buttons">
                <button type="submit" class="submit-btn">Submit Reservation Request</button>
                <a href="${pageContext.request.contextPath}/" class="cancel-btn">Cancel</a>
            </div>
        </form>
        
        <% } %>
    </div>
    
    <%@ include file="common/footer.jsp" %>
</body>
</html>
