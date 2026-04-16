# Bus Management System
BMS APL project

MANDATORY TECHNOLOGIES (Non-Negotiable)

Frontend:  JSP + CSS (NO Bootstrap, use Flexbox/Grid)
Backend:   Java + Java EE + MVC Architecture
Database:  MySQL
Server:    Apache Tomcat (or similar J2EE server)
Tools:     XAMPP/WAMP + GitHub








BusManagementSystem/
│
├── src/
│   │
│   ├── model/                              [Model - M of MVC Pattern]
│   │   │                                   ➤ Contains POJOs (Plain Old Java Objects)
│   │   │                                   ➤ Represents database tables as Java objects
│   │   │                                   ➤ Contains only fields, getters, setters, constructors
│   │   │
│   │   ├── User.java                       ➤ User entity with fields: id, fullName, email, password, phone, role(enum: ADMIN/CUSTOMER), createdAt
│   │   │                                   ➤ Used for: Login, Registration, Session management
│   │   │
│   │   ├── Bus.java                        ➤ Bus entity with fields: id, busNumber, busName, capacity, busType(enum: AC/NON_AC/SLEEPER), farePerSeat, status(enum: ACTIVE/INACTIVE)
│   │   │                                   ➤ Used for: Adding buses, Searching buses, Fare calculation
│   │   │
│   │   ├── Route.java                      ➤ Route entity with fields: id, source, destination, distance, duration
│   │   │                                   ➤ Used for: Search functionality, Fare calculation based on distance
│   │   │
│   │   ├── Schedule.java                   ➤ Schedule entity: id, busId, routeId, departureTime, arrivalTime, availableSeats, travelDate
│   │   │                                   ➤ Links Bus + Route with specific timing
│   │   │
│   │   └── Booking.java                    ➤ Booking entity: id, userId, scheduleId, seatNumbers(List), totalFare, bookingDate, status(enum: CONFIRMED/CANCELLED/PENDING)
│   │                                       ➤ Used for: Ticket generation, Booking history
│   │
│   ├── dao/                                [Data Access Object Layer]
│   │   │                                   ➤ Handles ALL database operations (CRUD)
│   │   │                                   ➤ Contains SQL queries and JDBC code
│   │   │                                   ➤ No business logic here - only DB interactions
│   │   │
│   │   ├── UserDAO.java                    ➤ Methods: registerUser(User), loginUser(email, password), getUserById(id), updateProfile(User), checkEmailExists(email)
│   │   │                                   ➤ SQL: INSERT, SELECT, UPDATE on 'users' table
│   │   │
│   │   ├── BusDAO.java                     ➤ Methods: addBus(Bus), updateBus(Bus), deleteBus(id), getAllBuses(), searchBuses(source, dest, date), getBusById(id)
│   │   │                                   ➤ SQL: CRUD on 'buses' and 'schedules' tables
│   │   │
│   │   └── BookingDAO.java                 ➤ Methods: createBooking(Booking), cancelBooking(id), getBookingsByUser(userId), getAllBookings(), checkSeatAvailability(scheduleId, seats)
│   │                                       ➤ SQL: INSERT, UPDATE, SELECT on 'bookings' table
│   │
│   ├── service/                            [Service/Business Logic Layer]
│   │   │                                   ➤ Contains business rules and validation logic
│   │   │                                   ➤ Acts as bridge between Controller and DAO
│   │   │                                   ➤ Required per coursework Page 5, point 5
│   │   │
│   │   ├── UserService.java                ➤ Methods: registerUser(User), authenticateUser(email, password), validateUserData(User)
│   │   │                                   ➤ Business logic: Email format check, Password strength, Phone validation, Calls PasswordUtil for hashing
│   │   │
│   │   ├── BusService.java                 ➤ Methods: searchAvailableBuses(source, dest, date), addNewBus(Bus), validateBusData(Bus), calculateFare(distance, busType)
│   │   │                                   ➤ Business logic: Check if bus number already exists, Validate capacity > 0
│   │   │
│   │   └── BookingService.java             ➤ Methods: processBooking(userId, scheduleId, seats), cancelBooking(bookingId), calculateTotalFare(baseFare, seatCount), validateBooking(scheduleId, seats)
│   │                                       ➤ Business logic: Check if seats available, Calculate total fare, Prevent double booking
│   │
│   ├── controller/                         [Controller - C of MVC Pattern]
│   │   │                                   ➤ Handles HTTP requests/responses
│   │   │                                   ➤ Extends HttpServlet class
│   │   │                                   ➤ Uses @WebServlet annotation for URL mapping
│   │   │
│   │   ├── LoginServlet.java               ➤ @WebServlet("/login")
│   │   │                                   ➤ doPost(): Gets email/password → Calls UserService.authenticateUser() → Creates session → Redirects based on role (ADMIN→/admin/dashboard, CUSTOMER→/customer/dashboard)
│   │   │                                   ➤ doGet(): Displays login page or redirects if already logged in
│   │   │
│   │   ├── RegisterServlet.java            ➤ @WebServlet("/register")
│   │   │                                   ➤ doPost(): Gets form data → Validates via UserService → Calls UserDAO.registerUser() → Redirects to login with success message
│   │   │                                   ➤ doGet(): Displays registration form
│   │   │
│   │   ├── LogoutServlet.java              ➤ @WebServlet("/logout")
│   │   │                                   ➤ doGet(): Invalidates session → Clears cookies → Redirects to index.jsp
│   │   │
│   │   ├── BusServlet.java                 ➤ @WebServlet("/bus")
│   │   │                                   ➤ doGet(): Handles search requests → Calls BusService.searchAvailableBuses() → Forwards to searchResults.jsp
│   │   │                                   ➤ doPost(): Handles admin adding new bus (if role=ADMIN) → Calls BusService.addNewBus()
│   │   │
│   │   ├── BookingServlet.java             ➤ @WebServlet("/booking")
│   │   │                                   ➤ doPost(): Processes booking → Calls BookingService.processBooking() → Forwards to ticket.jsp
│   │   │                                   ➤ doGet(): Displays booking form or user's bookings
│   │   │
│   │   └── AdminBusServlet.java            ➤ @WebServlet("/admin/bus/*")
│   │                                       ➤ doGet(): Lists all buses for admin → Forwards to manageBuses.jsp
│   │                                       ➤ doPost(): Handles bus updates/deletions (protected by AdminFilter)
│   │
│   ├── filter/                             [Servlet Filters - Intercept Requests]
│   │   │                                   ➤ Executes BEFORE request reaches Servlet
│   │   │                                   ➤ Required per coursework Page 4, Section 4.d
│   │   │
│   │   ├── AuthenticationFilter.java       ➤ @WebFilter("/*")  (applies to all URLs)
│   │   │                                   ➤ doFilter(): Checks if HttpSession has "user" attribute for protected URLs
│   │   │                                   ➤ Allows: /login, /register, /index.jsp, /css/*, /about.jsp, /contact.jsp
│   │   │                                   ➤ Redirects to /login if not authenticated and trying to access protected pages
│   │   │
│   │   └── AdminAuthorizationFilter.java   ➤ @WebFilter("/admin/*")
│   │                                       ➤ doFilter(): Checks if session user has role="ADMIN"
│   │                                       ➤ If not admin → Redirects to /common/error.jsp with "Access Denied" message
│   │
│   └── util/                               [Utility/Helper Classes]
│       │                                   ➤ Reusable helper methods across the application
│       │                                   ➤ Required per coursework Page 5, point 4
│       │
│       ├── DBConnection.java               ➤ Provides database connection using JDBC
│       │                                   ➤ Method: getConnection() returns java.sql.Connection
│       │                                   ➤ Contains: DB_URL, DB_USER, DB_PASSWORD constants
│       │                                   ➤ Uses: Class.forName("com.mysql.cj.jdbc.Driver")
│       │
│       ├── PasswordUtil.java               ➤ Security utility for password encryption
│       │                                   ➤ Method: hashPassword(String plainPassword) → Returns hashed string
│       │                                   ➤ Method: verifyPassword(String plainPassword, String hashedPassword) → Returns boolean
│       │                                   ➤ Uses: BCrypt or MessageDigest (SHA-256)
│       │                                   ➤ Required per coursework Page 4, Section 4.c
│       │
│       └── ValidationUtil.java             ➤ Input validation utility
│           │                               ➤ Methods: isValidEmail(String), isValidPhone(String), isNotEmpty(String), isValidPassword(String)
│           │                               ➤ Returns boolean and error messages
│           │                               ➤ Required per coursework Page 7, point 1
│
├── web/                                    [View - V of MVC Pattern]
│   │                                       ➤ Contains all JSP, CSS, JavaScript files
│   │                                       ➤ Accessible via browser (except WEB-INF)
│   │
│   ├── common/                             [Reusable JSP Components]
│   │   │                                   ➤ Included in other JSPs using <%@ include file="" %>
│   │   │
│   │   ├── header.jsp                      ➤ Contains: <head> section, Navigation bar, Logo
│   │   │                                   ➤ Dynamic: Shows "Login/Register" OR "Welcome User/Logout" based on session
│   │   │                                   ➤ Links: Home, About, Contact, Dashboard (if logged in), Admin (if admin)
│   │   │
│   │   ├── footer.jsp                      ➤ Contains: Copyright text, Footer links, Closing </body> and </html> tags
│   │   │
│   │   └── error.jsp                       ➤ Generic error page displayed when exceptions occur
│   │                                       ➤ Shows: Error message from request attribute, "Go Back" button
│   │                                       ➤ Required per coursework Page 7, "Must have error pages"
│   │
│   ├── css/                                [Styling - Custom CSS Only]
│   │   │
│   │   └── style.css                       ➤ ALL styling for the application
│   │                                       ➤ Uses: Flexbox for layouts, CSS Grid for seat selection, Media queries for mobile responsiveness
│   │                                       ➤ NO Bootstrap allowed per coursework Page 5
│   │                                       ➤ Contains styles for: forms, tables, cards, buttons, navigation, seat grid
│   │
│   ├── js/                                 [Client-side JavaScript]
│   │   │
│   │   └── validation.js                   ➤ Client-side form validation (optional per coursework Page 5)
│   │                                       ➤ Functions: validateEmail(), validatePhone(), validatePassword(), checkPasswordMatch()
│   │                                       ➤ Enhances UX before form submission to server
│   │
│   ├── index.jsp                           ➤ Homepage/Landing page
│   │                                       ➤ Contains: Welcome message, Bus Search Form (source, destination, travel date)
│   │                                       ➤ Displays: Featured routes, Promotional banners
│   │                                       ➤ Access: Public (no login required)
│   │
│   ├── login.jsp                           ➤ Login page
│   │                                       ➤ Contains: Email field, Password field, Submit button, Link to Register
│   │                                       ➤ Displays: Error message if login fails (from request attribute)
│   │                                       ➤ Access: Public
│   │
│   ├── register.jsp                        ➤ User registration page
│   │                                       ➤ Contains: Full Name, Email, Phone, Password, Confirm Password fields
│   │                                       ➤ Client-side validation via validation.js
│   │                                       ➤ Displays: Validation errors returned from server
│   │                                       ➤ Access: Public
│   │
│   ├── about.jsp                           ➤ About page
│   │                                       ➤ Contains: Information about the bus company, services offered, team details
│   │                                       ➤ Access: Public
│   │                                       ➤ Required per coursework Page 6, point 7.a (easy 5 marks)
│   │
│   ├── contact.jsp                         ➤ Contact page
│   │                                       ➤ Contains: Contact form (name, email, message), Company address, Phone number, Map placeholder
│   │                                       ➤ Access: Public
│   │                                       ➤ Required per coursework Page 6, point 7.b (easy 5 marks)
│   │
│   ├── customer/                           [Customer/User Specific Pages]
│   │   │                                   ➤ Access restricted to logged-in users with role="CUSTOMER"
│   │   │
│   │   ├── dashboard.jsp                   ➤ Customer dashboard/homepage after login
│   │   │                                   ➤ Displays: Welcome message with user name, Upcoming trips (recent bookings), Quick actions (Search Bus, View Bookings)
│   │   │                                   ➤ Shows: Summary cards (Total bookings, Upcoming trips, Completed trips)
│   │   │
│   │   ├── searchResults.jsp               ➤ Displays available buses matching search criteria
│   │   │                                   ➤ Contains: Table with columns (Bus Number, Bus Type, Departure, Arrival, Fare, Available Seats, Action)
│   │   │                                   ➤ Each row has "Book Now" button linking to bookSeat.jsp with scheduleId
│   │   │
│   │   ├── bookSeat.jsp                    ➤ Seat selection and booking page
│   │   │                                   ➤ Displays: Visual seat grid (CSS Grid), Selected bus details, Fare summary
│   │   │                                   ➤ Contains: Passenger details form (name, age, phone per seat), Proceed to Payment button
│   │   │                                   ➤ Submits to BookingServlet via POST
│   │   │
│   │   ├── ticket.jsp                      ➤ Booking confirmation / Printable ticket
│   │   │                                   ➤ Displays: Booking ID, Passenger details, Bus details, Seat numbers, Journey date/time, Total fare, QR code placeholder, Print button
│   │   │                                   ➤ Access: After successful booking
│   │   │
│   │   └── myBookings.jsp                  ➤ User's booking history
│   │                                       ➤ Contains: Table of all bookings (Upcoming and Past)
│   │                                       ➤ Columns: Booking ID, Bus, Route, Date, Seats, Fare, Status, Action (Cancel button for upcoming bookings)
│   │                                       ➤ Cancel button visible only if booking status = CONFIRMED and travel date > today
│   │
│   └── admin/                              [Administrator Specific Pages]
│       │                                   ➤ Access restricted to logged-in users with role="ADMIN"
│       │                                   ➤ Protected by AdminAuthorizationFilter
│       │
│       ├── adminDashboard.jsp              ➤ Admin dashboard/homepage
│       │                                   ➤ Displays: Summary cards (Total Buses, Total Users, Today's Bookings, Total Revenue)
│       │                                   ➤ Contains: Quick action buttons (Add Bus, Manage Buses, View All Bookings)
│       │                                   ➤ Shows: Recent bookings table, Charts (using CSS only, no external libraries)
│       │
│       ├── addBus.jsp                      ➤ Form to add a new bus to the system
│       │                                   ➤ Fields: Bus Number, Bus Name, Capacity, Bus Type (dropdown), Fare per Seat, Status (Active/Inactive)
│       │                                   ➤ Submits to AdminBusServlet via POST
│       │                                   ➤ Displays validation errors if any
│       │
│       ├── manageBuses.jsp                 ➤ List all buses with CRUD operations
│       │                                   ➤ Contains: Editable table showing all buses
│       │                                   ➤ Actions per row: Edit (opens edit form), Delete (with confirmation popup)
│       │                                   ➤ Option to filter by status (Active/Inactive)
│       │
│       └── viewAllBookings.jsp             ➤ View all bookings across all users
│           │                               ➤ Contains: Filterable table with all bookings
│           │                               ➤ Filters: By date range, By bus, By status
│           │                               ➤ Columns: Booking ID, User Name, Bus Number, Route, Date, Seats, Fare, Status
│           │                               ➤ Admin can cancel bookings from this page
│
└── WEB-INF/                                [Protected Configuration Directory]
    │                                       ➤ NOT directly accessible from browser
    │                                       ➤ Contains deployment descriptor and libraries
    │
    ├── web.xml                             ➤ Deployment Descriptor (DD) file
    │                                       ➤ Configures: Welcome file list (index.jsp)
    │                                       ➤ Defines: Error pages for HTTP error codes
    │                                       │   • <error-page><error-code>404</error-code><location>/common/error.jsp</location>
    │                                       │   • <error-page><error-code>500</error-code><location>/common/error.jsp</location>
    │                                       ➤ Defines: Session timeout (<session-config><session-timeout>30</session-timeout>)
    │                                       ➤ Maps: Filters to URL patterns
    │                                       │   • AuthenticationFilter → /*
    │                                       │   • AdminAuthorizationFilter → /admin/*
    │                                       ➤ Note: Servlets use @WebServlet annotation (no XML mapping needed)
    │
    └── lib/                                [Third-party JAR Libraries]
        │
        └── mysql-connector-java-8.x.x.jar  ➤ MySQL JDBC Driver
                                            ➤ Required for database connectivity
                                            ➤ Download from MySQL official website
