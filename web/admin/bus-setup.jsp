<%@ include file="../common/header.jsp" %>
<%@ page import="java.util.*, model.*, dao.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !user.hasRole("ADMIN")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    BusNameDAO busNameDAO = new BusNameDAO();
    BusNumberDAO busNumberDAO = new BusNumberDAO();
    SeatLayoutDAO seatLayoutDAO = new SeatLayoutDAO();
    StaffDAO staffDAO = new StaffDAO();
    BusSetupDAO busSetupDAO = new BusSetupDAO();
    List<BusName> busNames = busNameDAO.getAllBusNames();
    List<BusNumber> busNumbers = busNumberDAO.getAllBusNumbers();
    List<SeatLayout> layouts = seatLayoutDAO.getAllSeatLayouts();
    List<Staff> staffList = staffDAO.getAllStaff();
    List<BusSetup> setups = busSetupDAO.getAllBusSetups();
%>

<div class="container" style="padding:2rem 1rem;">
    <div style="display:flex;justify-content:space-between;gap:1rem;align-items:center;margin-bottom:1.5rem;">
        <div>
            <h2 style="color:var(--primary);">Bus Setup</h2>
            <p style="color:var(--gray);">Assign bus number, staff, seat layout, trip price, and departure time.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/management-center.jsp" class="btn" style="width:auto;background:var(--gray);">Back</a>
    </div>

    <% if (request.getParameter("success") != null) { %><div class="success-message"><%= request.getParameter("success") %></div><% } %>
    <% if (request.getParameter("error") != null) { %><div class="error-message"><%= request.getParameter("error") %></div><% } %>

    <form action="${pageContext.request.contextPath}/admin/save-bus-setup" method="post" class="admin-panel">
        <div class="form-grid four">
            <div class="form-group">
                <label>Select Bus Name</label>
                <select id="busNameSelect">
                    <option value="">All bus names</option>
                    <% for (BusName busName : busNames) { %>
                        <option value="<%= busName.getId() %>"><%= busName.getName() %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>Select Bus Number</label>
                <select name="busNumberId" id="busNumberSelect" required>
                    <option value="">Choose bus number</option>
                    <% for (BusNumber busNumber : busNumbers) { %>
                        <option value="<%= busNumber.getId() %>" data-bus-name="<%= busNumber.getBusNameId() %>">
                            <%= busNumber.getRegistrationNumber() %> - <%= busNumber.getBusName() != null ? busNumber.getBusName().getName() : "" %>
                        </option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>Select Seat Layout</label>
                <select name="seatLayoutId" required>
                    <option value="">Choose layout</option>
                    <% for (SeatLayout layout : layouts) { %>
                        <option value="<%= layout.getId() %>"><%= layout.getName() %> (<%= layout.getTotalSeats() %> seats)</option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>Edit Trip Price</label>
                <input type="number" name="tripPrice" min="0" step="0.01" required>
            </div>
            <div class="form-group">
                <label>Change Trip Time</label>
                <input type="time" name="tripTime" required>
            </div>
        </div>

        <h3 style="margin:1rem 0;color:var(--primary);">Assign Staff</h3>
        <div class="checkbox-grid">
            <% for (Staff staff : staffList) { %>
                <label class="checkbox-card">
                    <input type="checkbox" name="staffIds" value="<%= staff.getId() %>">
                    <span><strong><%= staff.getName() %></strong><br><small><%= staff.getRole() %></small></span>
                </label>
            <% } %>
        </div>

        <button type="submit" class="btn" style="width:auto;margin-top:1.5rem;padding:.85rem 2rem;">Save Setup</button>
    </form>

    <div class="table-container">
        <h3 style="color:var(--primary);margin-bottom:1rem;">Configured Buses</h3>
        <table>
            <thead><tr><th>Bus Number</th><th>Layout</th><th>Trip Price</th><th>Trip Time</th><th>Action</th></tr></thead>
            <tbody>
            <% for (BusSetup setup : setups) { %>
                <tr>
                    <td><%= setup.getBusNumber() != null ? setup.getBusNumber().getRegistrationNumber() : setup.getBusNumberId() %></td>
                    <td><%= setup.getSeatLayout() != null ? setup.getSeatLayout().getName() : setup.getSeatLayoutId() %></td>
                    <td>NPR <%= setup.getTripPrice() != null ? setup.getTripPrice() : "0" %></td>
                    <td><%= setup.getTripTime() != null ? setup.getTripTime() : "-" %></td>
                    <td><a class="action-btn btn-view" href="${pageContext.request.contextPath}/operator/chalani.jsp?setupId=<%= setup.getId() %>">Open Chalani</a></td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<script>
    document.getElementById('busNameSelect').addEventListener('change', function () {
        const selected = this.value;
        document.querySelectorAll('#busNumberSelect option[data-bus-name]').forEach(function (option) {
            option.hidden = selected && option.dataset.busName !== selected;
        });
        document.getElementById('busNumberSelect').value = '';
    });
</script>

<%@ include file="../common/footer.jsp" %>
