<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bus Rental - Kalpana Travels</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .rental-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 20px;
        }
        
        .rental-header {
            text-align: center;
            margin-bottom: 50px;
        }
        
        .rental-header h1 {
            color: #333;
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .rental-header p {
            color: #666;
            font-size: 1.1em;
        }
        
        .rental-options {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-bottom: 40px;
        }
        
        @media (max-width: 768px) {
            .rental-options {
                grid-template-columns: 1fr;
            }
        }
        
        .rental-card {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            padding: 30px;
            text-align: center;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .rental-card:hover {
            border-color: #2c3e50;
            box-shadow: 0 5px 15px rgba(0,0,0,0.15);
            transform: translateY(-5px);
        }
        
        .rental-card-icon {
            font-size: 3em;
            margin-bottom: 15px;
        }
        
        .rental-card h2 {
            color: #2c3e50;
            margin-bottom: 15px;
            font-size: 1.8em;
        }
        
        .rental-card p {
            color: #666;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .rental-card ul {
            text-align: left;
            margin: 20px 0;
            display: inline-block;
        }
        
        .rental-card ul li {
            padding: 8px 0;
            color: #555;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .rental-card ul li:last-child {
            border-bottom: none;
        }
        
        .rental-btn {
            background-color: #16a085;
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 5px;
            font-size: 1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
            text-decoration: none;
            display: inline-block;
            margin-top: 15px;
        }
        
        .rental-btn:hover {
            background-color: #138d75;
        }
        
        .wedding-highlight {
            background: linear-gradient(135deg, #fff5f7 0%, #ffe8ed 100%);
            border: 2px solid #e74c3c;
        }
        
        .wedding-highlight:hover {
            border-color: #c0392b;
        }
        
        .wedding-badge {
            display: inline-block;
            background-color: #e74c3c;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            margin-bottom: 10px;
            font-weight: bold;
        }
        
        .wedding-highlight h2 {
            color: #e74c3c;
        }
        
        .wedding-features {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
            text-align: left;
        }
        
        .wedding-features h3 {
            color: #e74c3c;
            margin-bottom: 15px;
        }
        
        .wedding-features ul {
            margin-left: 20px;
        }
        
        .wedding-features li {
            padding: 8px 0;
            color: #555;
        }
        
        .info-section {
            background: #ecf0f1;
            padding: 30px;
            border-radius: 10px;
            margin-top: 40px;
        }
        
        .info-section h2 {
            color: #2c3e50;
            margin-bottom: 20px;
        }
        
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        
        .info-box {
            background: white;
            padding: 20px;
            border-radius: 8px;
            border-left: 4px solid #16a085;
        }
        
        .info-box h3 {
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .info-box p {
            color: #666;
            font-size: 0.95em;
        }
    </style>
</head>
<body>
    <%@ include file="common/header.jsp" %>
    
    <div class="rental-container">
        <div class="rental-header">
            <h1>🚌 Bus Rental Services</h1>
            <p>Book our buses for your special events, corporate travels, and group tours</p>
        </div>
        
        <div class="rental-options">
            <!-- Wedding Reservation Card -->
            <div class="rental-card wedding-highlight">
                <div class="wedding-badge">✨ SPECIAL OFFER ✨</div>
                <div class="rental-card-icon">💒</div>
                <h2>Wedding Reservation</h2>
                <p>Make your wedding day memorable with dedicated bus transportation for your guests</p>
                
                <div class="wedding-features">
                    <h3>What's Included:</h3>
                    <ul>
                        <li>✓ Dedicated luxury buses for guest transport</li>
                        <li>✓ Red carpet decoration service</li>
                        <li>✓ Professional drivers & personnel</li>
                        <li>✓ Flexible routing & timing</li>
                        <li>✓ Complimentary refreshments</li>
                        <li>✓ Special wedding coordination support</li>
                    </ul>
                </div>
                
                <a href="${pageContext.request.contextPath}/eventReservation.jsp?eventType=WEDDING" class="rental-btn" style="background-color: #e74c3c; margin-top: 20px;">
                    Reserve for Wedding
                </a>
            </div>
            
            <!-- Corporate & Event Rental Card -->
            <div class="rental-card">
                <div class="rental-card-icon">🏢</div>
                <h2>Corporate & Event Rental</h2>
                <p>Ideal for corporate events, tours, parties, and group travels with professional service</p>
                
                <ul>
                    <li>Corporate team outings</li>
                    <li>Educational tours</li>
                    <li>Birthday & anniversary parties</li>
                    <li>Family reunions</li>
                    <li>Group pilgrimages</li>
                    <li>Sports team transportation</li>
                </ul>
                
                <p style="color: #16a085; font-weight: bold; margin-top: 15px;">
                    Flexible scheduling & competitive pricing
                </p>
                
                <a href="${pageContext.request.contextPath}/eventReservation.jsp" class="rental-btn">
                    Book Your Event
                </a>
            </div>
        </div>
        
        <!-- Information Section -->
        <div class="info-section">
            <h2>📋 Rental Information & Benefits</h2>
            <div class="info-grid">
                <div class="info-box">
                    <h3>🎯 Flexible Fleet</h3>
                    <p>Choose from regular seating, sleeper configurations, and luxury options based on your needs</p>
                </div>
                
                <div class="info-box">
                    <h3>✅ Quick Approval</h3>
                    <p>Simple booking process with fast confirmation. Our team reviews requests within 24 hours</p>
                </div>
                
                <div class="info-box">
                    <h3>📞 24/7 Support</h3>
                    <p>Dedicated support team available round-the-clock for your rental inquiries and assistance</p>
                </div>
                
                <div class="info-box">
                    <h3>💰 Best Pricing</h3>
                    <p>Competitive rates with special discounts for bulk bookings and long-duration rentals</p>
                </div>
                
                <div class="info-box">
                    <h3>🛡️ Safety First</h3>
                    <p>All buses regularly maintained with professional drivers trained in passenger safety</p>
                </div>
                
                <div class="info-box">
                    <h3>🗓️ Easy Scheduling</h3>
                    <p>Choose your preferred dates and times. We accommodate special time requirements</p>
                </div>
            </div>
        </div>
        
        <div style="background: white; padding: 30px; border-radius: 10px; margin-top: 40px; text-align: center; border: 2px solid #16a085;">
            <h2 style="color: #2c3e50; margin-bottom: 15px;">Need Help? Contact Our Team</h2>
            <p style="color: #666; margin-bottom: 15px;">Call us for personalized booking assistance and special package quotes</p>
            <p style="font-size: 1.1em; color: #16a085; font-weight: bold;">📱 Phone: +91-XXXX-XXXX-XX | 📧 Email: rentals@kalpanatravel.com</p>
        </div>
    </div>
    
    <%@ include file="common/footer.jsp" %>
</body>
</html>
