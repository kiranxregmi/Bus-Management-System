<%@ include file="../common/header.jsp" %>
<%@ page import="model.Route, model.BusSetup, model.BusName, model.BusNumber, model.SeatLayout, model.Staff, java.util.*, java.sql.*" %>
<%
    List<Route> routes = (List<Route>) request.getAttribute("routes");
    List<BusName> busNames = (List<BusName>) request.getAttribute("busNames");
    List<BusNumber> busNumbers = (List<BusNumber>) request.getAttribute("busNumbers");
    List<SeatLayout> seatLayouts = (List<SeatLayout>) request.getAttribute("seatLayouts");
    List<Staff> staffList = (List<Staff>) request.getAttribute("staffList");
    String success = request.getParameter("success");
%>

<div class="container" style="padding: 2.5rem 1rem; max-width: 1200px;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.5rem;">
        <div>
            <h2 style="color: var(--primary); font-size: 2rem; font-weight: 800; margin-bottom: 0.25rem;">Configured Routes</h2>
            <p style="color: var(--gray); font-size: 0.95rem;">Manage active route lines, assign buses, layouts, and staff.</p>
        </div>
        <div style="display: flex; gap: 1rem;">
            <a href="adminDashboard.jsp" class="btn" style="width: auto; padding: 0.7rem 1.8rem; background: var(--gray); border-radius: 8px;">Back</a>
            <a href="${pageContext.request.contextPath}/admin/route?action=add" class="btn" style="width: auto; padding: 0.7rem 1.8rem; border-radius: 8px; box-shadow: 0 4px 12px rgba(26,62,111,0.2);">Add New Route</a>
        </div>
    </div>

    <% if (success != null) { %>
        <div class="success-message" style="margin-bottom: 1.5rem; border-left: 5px solid var(--success); font-weight: 600;"><%= success %></div>
    <% } %>

    <div class="routes-grid">
        <% if (routes != null && !routes.isEmpty()) { 
            for (Route r : routes) { 
                BusSetup setup = null;
                int booked = 0;
                int online = 0;
                int counter = 0;
                int available = 0;
                String staffIdsStr = "";
                
                if (r.getBusSetupId() != null && r.getBusSetupId() > 0) {
                    setup = new dao.BusSetupDAO().getBusSetupById(r.getBusSetupId());
                    if (setup != null) {
                        // Query real-time booking statistics
                        try (Connection conn = util.DBConnection.getConnection()) {
                            // Available seats
                            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM seats WHERE bus_setup_id = ? AND status = 'AVAILABLE'")) {
                                ps.setInt(1, setup.getId());
                                try (ResultSet rs = ps.executeQuery()) {
                                    if (rs.next()) available = rs.getInt(1);
                                }
                            }
                            // Booked seats
                            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM seats WHERE bus_setup_id = ? AND status = 'BOOKED'")) {
                                ps.setInt(1, setup.getId());
                                try (ResultSet rs = ps.executeQuery()) {
                                    if (rs.next()) booked = rs.getInt(1);
                                }
                            }
                            // Online vs Counter bookings
                            try (PreparedStatement ps = conn.prepareStatement(
                                "SELECT u.role, COUNT(*) FROM bookings b JOIN users u ON b.user_id = u.id WHERE b.bus_setup_id = ? GROUP BY u.role")) {
                                ps.setInt(1, setup.getId());
                                try (ResultSet rs = ps.executeQuery()) {
                                    while (rs.next()) {
                                        String role = rs.getString(1);
                                        int count = rs.getInt(2);
                                        if ("CUSTOMER".equals(role)) {
                                            online += count;
                                        } else {
                                            counter += count;
                                        }
                                    }
                                }
                            }
                        } catch (Exception e) {}

                        // Staff IDs list
                        Set<Integer> assignedStaff = new dao.BusSetupDAO().getAssignedStaffIds(setup.getId());
                        StringBuilder sb = new StringBuilder();
                        for (Integer sid : assignedStaff) {
                            if (sb.length() > 0) sb.append(",");
                            sb.append(sid);
                        }
                        staffIdsStr = sb.toString();
                    }
                }
                
                // Formulate Route Header info
                String deptName = r.getDepartureLocationName() != null ? r.getDepartureLocationName() : r.getSource();
                String arrName = r.getArrivalLocationName() != null ? r.getArrivalLocationName() : r.getDestination();
                String timeStr = (setup != null && setup.getTripTime() != null) ? 
                    new java.text.SimpleDateFormat("hh:mm a").format(setup.getTripTime()) : "n/a";
                String routeHeader = deptName + " - " + arrName + " (" + timeStr + ")";
                
                // Bus info
                String busNameVal = (setup != null && setup.getBusNumber() != null && setup.getBusNumber().getBusName() != null) ? 
                    setup.getBusNumber().getBusName().getName() : "n/a";
                String seatConfigVal = (setup != null && setup.getSeatLayout() != null) ? 
                    setup.getSeatLayout().getName() : "n/a";
                String busNoVal = (setup != null && setup.getBusNumber() != null) ? 
                    setup.getBusNumber().getRegistrationNumber() : "n/a";
                String priceVal = (setup != null && setup.getTripPrice() != null) ? 
                    "Rs " + setup.getTripPrice() : "n/a";
                int totalSeatsVal = (setup != null && setup.getSeatLayout() != null) ? 
                    setup.getSeatLayout().getTotalSeats() : 0;
        %>
            <div class="route-card">
                <div class="route-card-header">
                    <h3><%= routeHeader %></h3>
                    <div class="route-actions-top">
                        <button class="route-icon-btn" title="Settings" 
                                onclick="openSettingsModal(this)"
                                data-route-id="<%= r.getId() %>"
                                data-bus-name-id="<%= (setup != null && setup.getBusNumber() != null) ? setup.getBusNumber().getBusNameId() : "" %>"
                                data-bus-number-id="<%= (setup != null) ? setup.getBusNumberId() : "" %>"
                                data-layout-id="<%= (setup != null) ? setup.getSeatLayoutId() : "" %>"
                                data-price="<%= (setup != null && setup.getTripPrice() != null) ? setup.getTripPrice() : "" %>"
                                data-time="<%= (setup != null && setup.getTripTime() != null) ? new java.text.SimpleDateFormat("HH:mm").format(setup.getTripTime()) : "" %>"
                                data-staff-ids="<%= staffIdsStr %>">⚙️</button>
                        <% if (setup != null) { %>
                            <a href="${pageContext.request.contextPath}/admin/report?action=chalani&busSetupId=<%= setup.getId() %>" class="route-icon-btn" title="Chalani Report">📄</a>
                        <% } %>
                        <a href="${pageContext.request.contextPath}/admin/route?action=delete&id=<%= r.getId() %>" 
                           class="route-icon-btn" style="background: rgba(208,0,0,0.2);" title="Delete Route"
                           onclick="return confirm('Are you sure you want to delete this route?')">&times;</a>
                    </div>
                </div>
                <div class="route-card-body">
                    <div class="route-detail-row">
                        <span class="route-detail-label">Bus Name:</span>
                        <span class="route-detail-value"><%= busNameVal %></span>
                    </div>
                    <div class="route-detail-row">
                        <span class="route-detail-label">Seat Configuration:</span>
                        <span class="route-detail-value"><%= seatConfigVal %></span>
                    </div>
                    <div class="route-detail-row">
                        <span class="route-detail-label">Bus Number:</span>
                        <span class="route-detail-value"><%= busNoVal %></span>
                    </div>
                    <div class="route-detail-row">
                        <span class="route-detail-label">Ticket Price:</span>
                        <span class="route-detail-value" style="color: var(--primary);"><%= priceVal %></span>
                    </div>
                    <div class="route-detail-row">
                        <span class="route-detail-label">Total Seats:</span>
                        <span class="route-detail-value"><%= totalSeatsVal %></span>
                    </div>
                    
                    <div class="route-status-indicators">
                        <div class="status-indicator booked">
                            <span><%= booked %></span>Booked
                        </div>
                        <div class="status-indicator" style="color: #007bff;">
                            <span><%= online %></span>Online
                        </div>
                        <div class="status-indicator" style="color: var(--warning);">
                            <span><%= counter %></span>Counter
                        </div>
                        <div class="status-indicator available">
                            <span><%= available > 0 ? available : (setup != null ? totalSeatsVal : 0) %></span>Available
                        </div>
                    </div>
                </div>
            </div>
        <% } } else { %>
            <div style="grid-column: 1 / -1; text-align: center; padding: 3rem; background: #fff; border-radius: 12px; border: 1px dashed #ddd;">
                <p style="color: var(--gray); font-size: 1.1rem; margin-bottom: 1rem;">No configured routes found.</p>
                <a href="${pageContext.request.contextPath}/admin/route?action=add" class="btn" style="width: auto; padding: 0.5rem 1.5rem;">Add First Route</a>
            </div>
        <% } %>
    </div>
</div>

<!-- ==========================================
     ROUTE CONFIGURATION / SETTINGS MODAL
     ========================================== -->
<div id="routeSettingsModal" class="location-picker-modal" style="display:none; align-items: flex-start; padding-top: 5vh;">
    <div class="location-picker-content" style="max-width: 500px;">
        <div class="location-picker-header">
            <h3>Route Configuration Settings</h3>
            <button type="button" class="lp-close-btn" onclick="closeSettingsModal()">&times;</button>
        </div>
        <form action="${pageContext.request.contextPath}/admin/route" method="POST" style="padding: 1.5rem; display: flex; flex-direction: column; gap: 1.25rem;">
            <input type="hidden" name="action" value="settings">
            <input type="hidden" id="modalRouteId" name="routeId">
            
            <!-- Bus Name Selection -->
            <div class="form-group" style="margin-bottom:0;">
                <label for="modalBusName">Select Bus Name</label>
                <select id="modalBusName" onchange="filterBusNumbers()" required style="width:100%; padding:0.75rem; border-radius:6px; border:1px solid #ccc;">
                    <option value="">-- Select Bus Name --</option>
                    <% if (busNames != null) { for (BusName bn : busNames) { %>
                        <option value="<%= bn.getId() %>"><%= bn.getName() %> (<%= bn.getBusType() %>)</option>
                    <% } } %>
                </select>
            </div>

            <!-- Bus Number Selection -->
            <div class="form-group" style="margin-bottom:0;">
                <label for="modalBusNumber">Select Bus Number</label>
                <select id="modalBusNumber" name="busNumberId" required style="width:100%; padding:0.75rem; border-radius:6px; border:1px solid #ccc;">
                    <option value="">-- Select Bus Number --</option>
                </select>
            </div>

            <!-- Seat Layout Selection -->
            <div class="form-group" style="margin-bottom:0;">
                <label for="modalLayout">Seat Layout Selection</label>
                <select id="modalLayout" name="seatLayoutId" required style="width:100%; padding:0.75rem; border-radius:6px; border:1px solid #ccc;">
                    <option value="">-- Select Layout --</option>
                    <% if (seatLayouts != null) { for (SeatLayout sl : seatLayouts) { %>
                        <option value="<%= sl.getId() %>"><%= sl.getName() %> (<%= sl.getTotalSeats() %> seats)</option>
                    <% } } %>
                </select>
            </div>

            <!-- Ticket Price and Departure Time -->
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group" style="margin-bottom:0;">
                    <label for="modalPrice">Ticket Price (Rs)</label>
                    <input type="number" id="modalPrice" name="tripPrice" min="0" step="0.01" required style="width:100%; padding:0.75rem; border-radius:6px; border:1px solid #ccc;">
                </div>
                <div class="form-group" style="margin-bottom:0;">
                    <label for="modalTime">Departure Time</label>
                    <input type="time" id="modalTime" name="tripTime" required style="width:100%; padding:0.75rem; border-radius:6px; border:1px solid #ccc;">
                </div>
            </div>

            <!-- Bus Staff Assignment -->
            <div class="form-group" style="margin-bottom:0;">
                <label>Bus Staff Assignment</label>
                <div style="max-height: 120px; overflow-y: auto; border: 1px solid #ccc; border-radius: 6px; padding: 0.5rem; display: flex; flex-direction: column; gap: 0.35rem; background: #fff;">
                    <% if (staffList != null) { for (Staff st : staffList) { %>
                        <label style="display: flex; align-items: center; gap: 0.5rem; font-weight: normal; cursor: pointer; font-size: 0.9rem;">
                            <input type="checkbox" name="staffIds" value="<%= st.getId() %>" class="modal-staff-checkbox">
                            <%= st.getName() %> (<span style="color: var(--secondary); font-weight:600;"><%= st.getRole() %></span>)
                        </label>
                    <% } } %>
                </div>
            </div>

            <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                <button type="button" class="btn" style="background: var(--gray);" onclick="closeSettingsModal()">Cancel</button>
                <button type="submit" class="btn">Save Configuration</button>
            </div>
        </form>
    </div>
</div>

<script>
    // JS list of all bus numbers to dynamic filtering
    const allBusNumbers = [
        <% if (busNumbers != null) { for (BusNumber bn : busNumbers) { %>
            { id: <%= bn.getId() %>, busNameId: <%= bn.getBusNameId() %>, regNo: '<%= bn.getRegistrationNumber() %>' },
        <% } } %>
    ];

    function filterBusNumbers(selectedBusNumberId = null) {
        const busNameSelect = document.getElementById('modalBusName');
        const busNumberSelect = document.getElementById('modalBusNumber');
        const selectedNameId = parseInt(busNameSelect.value, 10);
        
        busNumberSelect.innerHTML = '<option value="">-- Select Bus Number --</option>';
        
        if (!isNaN(selectedNameId)) {
            const filtered = allBusNumbers.filter(bn => bn.busNameId === selectedNameId);
            filtered.forEach(bn => {
                const opt = document.createElement('option');
                opt.value = bn.id;
                opt.textContent = bn.regNo;
                if (selectedBusNumberId && bn.id === parseInt(selectedBusNumberId, 10)) {
                    opt.selected = true;
                }
                busNumberSelect.appendChild(opt);
            });
        }
    }

    function openSettingsModal(btn) {
        const routeId = btn.dataset.routeId;
        const busNameId = btn.dataset.busNameId;
        const busNumberId = btn.dataset.busNumberId;
        const layoutId = btn.dataset.layoutId;
        const price = btn.dataset.price;
        const time = btn.dataset.time;
        const staffIds = btn.dataset.staffIds ? btn.dataset.staffIds.split(',') : [];

        document.getElementById('modalRouteId').value = routeId;
        document.getElementById('modalBusName').value = busNameId;
        document.getElementById('modalLayout').value = layoutId;
        document.getElementById('modalPrice').value = price;
        document.getElementById('modalTime').value = time;

        // Filter and set selected bus number
        filterBusNumbers(busNumberId);

        // Pre-check staff checkboxes
        const checkboxes = document.querySelectorAll('.modal-staff-checkbox');
        checkboxes.forEach(cb => {
            cb.checked = staffIds.includes(cb.value);
        });

        document.getElementById('routeSettingsModal').style.display = 'flex';
    }

    function closeSettingsModal() {
        document.getElementById('routeSettingsModal').style.display = 'none';
    }
</script>

<%@ include file="../common/footer.jsp" %>
