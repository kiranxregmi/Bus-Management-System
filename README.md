# Bus Management System
BMS APL project

MANDATORY TECHNOLOGIES (Non-Negotiable)

Frontend:  JSP + CSS (NO Bootstrap, use Flexbox/Grid)
Backend:   Java + Java EE + MVC Architecture
Database:  MySQL
Server:    Apache Tomcat (or similar J2EE server)
Tools:     XAMPP/WAMP + GitHub

# Kalpana Travels — Bus Management System

A full-stack Java EE web application for managing bus bookings, schedules, routes, and administration for *Kalpana Travels*. Built with JSP + Servlets following the MVC architecture pattern.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | JSP, CSS (Flexbox/Grid — no Bootstrap) |
| Backend | Java 21, Jakarta Servlet API 6.0 |
| Database | MySQL (kalpana_travels) |
| Server | Apache Tomcat 10.1 (via Cargo Maven plugin) |
| DB Pooling | HikariCP |
| Build Tool | Maven |
| Architecture | MVC (Model–View–Controller) |

---

## Prerequisites

Before running the project, make sure you have the following installed:

- *Java 21* or higher (java -version)
- *Maven 3.8+* (mvn -version)
- *MySQL* running locally on port 3306
- Internet access (Cargo downloads Tomcat automatically on first run)

---

## Database Setup

*1. Start MySQL* (via XAMPP, WAMP, or standalone MySQL service).

*2. Create the database and import the schema:*

sql
CREATE DATABASE kalpana_travels;


Then import the SQL dump:

bash
mysql -u root -p kalpana_travels < web/WEB-INF/kalpana_travels.sql


Or open the file in phpMyAdmin and run it against the kalpana_travels database.

*3. Verify your DB credentials* in src/util/DBConnection.java:

java
private static final String URL  = "jdbc:mysql://localhost:3306/kalpana_travels";
private static final String USER = "root";
private static final String PASSWORD = "";   // ← update if you have a MySQL password


---

## Running the Application

bash
mvn clean package cargo:run


Cargo will automatically download Tomcat 10.1 on the first run (requires internet). Subsequent runs use the cached download.

Once started, open your browser at:


http://localhost:8080/bus


To stop the server, press Ctrl + C in the terminal.

---

## Default Login Credentials

The SQL seed data includes two ready-to-use accounts:

| Role | Email | Password |
|---|---|---|
| Admin | admin@kalpana.com | admin123 |
| Customer | customer@kalpana.com | customer123 |

> Passwords are stored as SHA-256 hashes in the database.

---

## Project Structure


Bus-Management-System/
│
├── pom.xml                          ← Maven build config (Cargo + Tomcat 10)
│
├── src/                             ← All Java source files
│   ├── controller/                  ← Servlets — handle HTTP requests
│   ├── service/                     ← Business logic layer
│   ├── dao/                         ← Database access (JDBC/SQL)
│   ├── model/                       ← POJOs (User, Bus, Route, Schedule, Booking)
│   ├── filter/                      ← Authentication & authorization filters
│   └── util/                        ← DBConnection, PasswordUtil, ValidationUtil
│
├── web/                             ← View layer (JSP, CSS, static files)
│   ├── index.jsp                    ← Public homepage with bus search
│   ├── login.jsp
│   ├── register.jsp
│   ├── about.jsp
│   ├── contact.jsp
│   ├── rental.jsp                   ← Bus charter/rental enquiry
│   ├── eventReservation.jsp         ← Event bus reservation form
│   ├── admin/                       ← Admin-only JSP pages
│   ├── customer/                    ← Logged-in customer JSP pages
│   ├── common/                      ← Shared header, footer, error page
│   ├── css/style.css                ← All custom styles
│   └── WEB-INF/
│       ├── web.xml                  ← Servlet/filter configuration
│       └── kalpana_travels.sql      ← Database schema + seed data
│
└── target/                          ← Maven build output (auto-generated)


---

## Architecture

The project follows a strict *4-layer MVC pattern*:


Browser → Filter → Controller (Servlet) → Service → DAO → MySQL
                                 ↓
                              JSP (View)


| Layer | Package | Role |
|---|---|---|
| *Model* | model/ | Plain Java objects mapping to DB tables |
| *View* | web/*.jsp | JSP pages that render HTML |
| *Controller* | controller/ | Servlets that receive requests and call services |
| *Service* | service/ | Business rules, validation, orchestration |
| *DAO* | dao/ | All SQL queries via JDBC |
| *Filter* | filter/ | Security — intercepts requests before servlets |
| *Util* | util/ | DB connection pool, password hashing, validation helpers |

---

## Features

### Public (No Login Required)
- Homepage with bus search by source, destination, and date
- View search results with available buses
- User registration and login
- About and Contact pages
- Event/charter bus reservation enquiry form
- Bus rental enquiry page

### Customer (Login Required)
- Customer dashboard with booking summary
- Select a schedule and pick seats from a visual seat grid
- View booking confirmation with full trip details
- View and print ticket
- View full booking history
- Cancel confirmed upcoming bookings
- Manage account profile

### Admin (Admin Role Required)
- Admin dashboard with system statistics (total buses, users, bookings, revenue)
- Add, edit, and delete buses
- Add, edit, and delete routes
- Add, edit, and delete schedules (assign buses to routes with dates/times)
- View all customer bookings across the system
- Manage bus rental requests
- Generate reports (revenue, booking statistics)
- View trip sheets (passenger manifests per schedule)

---

## Servlets (URL Mapping)

| Servlet | URL | Purpose |
|---|---|---|
| LoginServlet | /login | Authenticate user, create session |
| LogoutServlet | /logout | Invalidate session, clear cookies |
| RegisterServlet | /register | Register new customer account |
| BusServlet | /bus | Public bus search |
| BookingServlet | /booking | Process seat booking, view/cancel bookings |
| AdminBusServlet | /admin/bus | Admin CRUD for buses |
| AdminRouteServlet | /admin/route | Admin CRUD for routes |
| AdminScheduleServlet | /admin/schedule | Admin CRUD for schedules |
| AdminRentalServlet | /admin/rental | Admin manage rental requests |
| ReportServlet | /admin/report | Generate revenue/booking reports |
| TripSheetServlet | /admin/tripsheet | Passenger manifest per schedule |
| EventReservationServlet | /eventReservation | Submit event bus reservation |

---

## Security — Sessions and Cookies

### Session (HttpSession)

The HttpSession is the core of the authentication system.

*On login*, the authenticated User object is stored in the session:
java
session.setAttribute("user", user);


*On logout*, the entire session is destroyed immediately:
java
session.invalidate();


*Post-login redirect* — if a user tries to access a protected page while logged out, AuthenticationFilter saves their intended URL in the session so they are sent there after logging in:
java
session.setAttribute("redirectAfterLogin", path);
// ... after login succeeds:
session.removeAttribute("redirectAfterLogin");
response.sendRedirect(contextPath + redirectUrl);


### Cookie

One persistent cookie is used — *Remember Me*:

- *Set* on login when the user checks "Remember Me" — stores the email address for 7 days:
  java
  Cookie emailCookie = new Cookie("userEmail", email);
  emailCookie.setMaxAge(7 * 24 * 60 * 60); // 7 days
  response.addCookie(emailCookie);
  
- *Cleared* on logout:
  java
  emailCookie.setMaxAge(0); // deletes the cookie
  

> The cookie stores only the email (not the password) and is used to pre-fill the login form.

### Filters

Two servlet filters secure every request:

*AuthenticationFilter* — Applied to all URLs (/*). Checks for session.getAttribute("user") on every protected path. If not authenticated, redirects to /login.jsp. Public paths (homepage, login, register, CSS, etc.) are whitelisted and pass through freely.

*AdminFilter* — Applied to /admin/*. After authentication passes, casts the session user and checks user.getRole().equals("ADMIN"). Non-admin users are forwarded to the error page with an "Access Denied" message.

---

## Database Schema


users        → id, full_name, email, password (SHA-256), phone, role (ADMIN/CUSTOMER)
buses        → id, bus_number, bus_name, capacity, bus_type, fare_per_seat, status
routes       → id, source, destination, distance, duration
schedules    → id, bus_id, route_id, departure_time, arrival_time, travel_date, available_seats
bookings     → id, user_id, schedule_id, seat_numbers, total_fare, booking_date, status


Foreign key relationships:
- schedules.bus_id → buses.id
- schedules.route_id → routes.id
- bookings.user_id → users.id (CASCADE DELETE)
- bookings.schedule_id → schedules.id (CASCADE DELETE)

---

## Connection Pooling

The application uses *HikariCP* for database connection pooling (configured in DBConnection.java):

- Max pool size: 10 connections
- Min idle connections: 2
- Connection timeout: 30 seconds
- Max connection lifetime: 30 minutes

The pool is pre-warmed at application startup via AppContextListener and cleanly shut down when the application stops.

---

## Troubleshooting

*Port 8080 already in use*
Change the port in pom.xml:
xml
<cargo.servlet.port>9090</cargo.servlet.port>


*Database connection failed on startup*
- Confirm MySQL is running on port 3306
- Confirm the kalpana_travels database exists and the SQL was imported
- Check the username/password in src/util/DBConnection.java

*mvn clean package cargo:run fails to download Tomcat*
- Check internet connectivity — Cargo downloads Tomcat from archive.apache.org on first run
- If behind a proxy, configure Maven proxy settings in ~/.m2/settings.xml

*404 on all pages after startup*
- Confirm the context path — the app deploys to /bus, so use [http://localhost:8080/bus](http://localhost:8082/BusManagementSystem/)

---

## Authors

Developed as part of the APL (Advanced Programming Languages) coursework project.

- *Database:* kalpana_travels — Kalpana Travels Bus Company

