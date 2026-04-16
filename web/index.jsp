<%@ include file="common/header.jsp" %>

    <!-- ===== HERO SECTION ===== -->
    <section class="hero">

        <!-- Headline block -->
        <div class="hero-content">
            <span class="hero-badge"> Nepal's Trusted Bus Network </span>
            <h1>Your Journey, <span>Our Priority</span></h1>
            <p class="hero-subtitle">
                Travel comfortably across Nepal with Kalpana Travels - book in seconds,
                ride with confidence.
            </p>
        </div>

        <!-- Glassmorphism Search Card -->
        <div class="hero-search-card">
            <form action="${pageContext.request.contextPath}/bus" method="GET" class="search-form">
                <input type="hidden" name="action" value="search">

                <div class="search-form-perfect-row">
                    <!-- FROM -->
                    <div class="field-pill">
                        <div class="pill-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#666" stroke-width="2">
                                <path
                                    d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-1.1 0-2 .9-2 2v7c0 .6.4 1 1 1h1M19 17a2 2 0 1 1-4 0M5 17a2 2 0 1 1-4 0" />
                            </svg>
                        </div>
                        <select id="source" name="source" required>
                            <option value="" disabled selected>From</option>
                            <option value="Kathmandu">Kathmandu</option>
                            <option value="Pokhara">Pokhara</option>
                            <option value="Chitwan">Chitwan</option>
                            <option value="Lumbini">Lumbini</option>
                            <option value="Biratnagar">Biratnagar</option>
                        </select>
                    </div>

                    <!-- SWAP -->
                    <button type="button" class="swap-pill-btn" id="swapBtn">
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                            stroke-width="2">
                            <path d="M7 16l-4-4 4-4M3 12h18M17 8l4 4-4 4" />
                        </svg>
                    </button>

                    <!-- TO -->
                    <div class="field-pill">
                        <div class="pill-icon">
                            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#2563eb"
                                stroke-width="2">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z" />
                                <circle cx="12" cy="10" r="3" />
                            </svg>
                        </div>
                        <select id="destination" name="destination" required>
                            <option value="" disabled selected>To</option>
                            <option value="Pokhara">Pokhara</option>
                            <option value="Kathmandu">Kathmandu</option>
                            <option value="Chitwan">Chitwan</option>
                            <option value="Lumbini">Lumbini</option>
                            <option value="Biratnagar">Biratnagar</option>
                        </select>
                    </div>

                    <!-- DATE -->
                    <div class="date-pill">
                        <input type="date" id="travelDate" name="travelDate" required>
                    </div>

                    <!-- SHORTCUTS -->
                    <div class="shortcuts-group-pill">
                        <button type="button" class="s-btn-pill" id="dBtn0"><span class="n"></span><span
                                class="d"></span></button>
                        <button type="button" class="s-btn-pill" id="dBtn1"><span class="n"></span><span
                                class="d"></span></button>
                        <button type="button" class="s-btn-pill" id="dBtn2"><span class="n"></span><span
                                class="d"></span></button>
                        <button type="button" class="s-btn-pill" id="dBtn3"><span class="n"></span><span
                                class="d"></span></button>
                        <button type="button" class="s-btn-pill" id="dBtn4"><span class="n"></span><span
                                class="d"></span></button>
                    </div>

                    <!-- SEARCH -->
                    <button type="submit" class="search-pill-btn">Search</button>
                </div>
            </form>
        </div>

        <!-- Trust Badges -->
        <div class="trust-badges">
            <div class="trust-badge">
                <span class="badge-icon">🚌</span>
                <span>50+ Buses</span>
            </div>
            <div class="trust-badge">
                <span class="badge-icon">⭐</span>
                <span>4.8 Rating</span>
            </div>
            <div class="trust-badge">
                <span class="badge-icon">👥</span>
                <span>10k+ Travelers</span>
            </div>
        </div>

    </section>

    <!-- Swap script: swaps the selected values between the two dropdowns -->
    <script>
        // Get today's date and setup min date
        var today = new Date();
        var todayString = today.toISOString().split('T')[0];
        document.getElementById('travelDate').setAttribute('min', todayString);
        document.getElementById('travelDate').value = todayString; // Set default to today

        // Function to format date as YYYY-MM-DD
        function formatDate(date) {
            var d = new Date(date);
            var month = '' + (d.getMonth() + 1);
            var day = '' + d.getDate();
            var year = d.getFullYear();

            if (month.length < 2) month = '0' + month;
            if (day.length < 2) day = '0' + day;

            return [year, month, day].join('-');
        }

        // Function to get day of week abbreviation
        function getDayAbbr(date) {
            var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            return days[date.getDay()];
        }

        // Helper to find next occurrence of a day (0=Sun, i=index)
        function getDayAbbrShort(date) {
            var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
            return days[date.getDay()];
        }

        // Setup exact 5 date shortcuts from today
        for (var i = 0; i <= 4; i++) {
            (function (index) {
                var btn = document.getElementById('dBtn' + index);
                if (!btn) return;
                var date = new Date(today);
                date.setDate(today.getDate() + index);
                var dateStr = formatDate(date);

                btn.querySelector('.n').textContent = date.getDate();
                btn.querySelector('.d').textContent = getDayAbbrShort(date);
                btn.setAttribute('data-date', dateStr);

                if (index === 0) btn.classList.add('active');

                btn.addEventListener('click', function (e) {
                    e.preventDefault();
                    document.getElementById('travelDate').value = dateStr;
                    document.querySelectorAll('.s-btn-pill').forEach(function (b) { b.classList.remove('active'); });
                    btn.classList.add('active');
                });
            })(i);
        }

        // Swap button functionality
        document.getElementById('swapBtn').addEventListener('click', function (e) {
            e.preventDefault();
            var src = document.getElementById('source');
            var dst = document.getElementById('destination');
            var tmp = src.value;
            src.value = dst.value;
            dst.value = tmp;
            // Visual feedback
            this.style.transform = 'rotate(180deg)';
            setTimeout(function () {
                document.getElementById('swapBtn').style.transform = '';
            }, 350);
        });

        // Update active button when date input is manually changed
        document.getElementById('travelDate').addEventListener('change', function () {
            var selectedDate = this.value;
            dateButtons.forEach(function (btn, index) {
                if (btn.getAttribute('data-date') === selectedDate) {
                    dateButtons.forEach(function (b) { b.classList.remove('active'); });
                    btn.classList.add('active');
                }
            });
        });
    </script>

    <!-- ===== FEATURES SECTION ===== -->
    <section class="features">
        <div class="feature-card">
            <span class="feature-icon">🛡️</span>
            <h3>Safe Travel</h3>
            <p>Your safety is our top priority. We use well-maintained buses and conduct regular safety audits for a
                worry-free journey.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">⏰</span>
            <h3>On-Time Departure</h3>
            <p>We value your time. Our fleet follows strict schedules to ensure you reach your destination exactly when
                expected.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">✨</span>
            <h3>Easy Booking</h3>
            <p>Experience the smoothest booking process in Nepal. Reserve your seats in just a few clicks from any
                device.</p>
        </div>
    </section>

    <%@ include file="common/footer.jsp" %>