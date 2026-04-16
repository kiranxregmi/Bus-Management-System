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

                <!-- FROM -->
                <div class="search-field">
                    <label class="search-card-label" for="source">From</label>
                    <select id="source" name="source" required>
                        <option value="">Select City</option>
                        <option value="Kathmandu">Kathmandu</option>
                        <option value="Pokhara">Pokhara</option>
                        <option value="Chitwan">Chitwan</option>
                        <option value="Lumbini">Lumbini</option>
                        <option value="Biratnagar">Biratnagar</option>
                        <option value="Butwal">Butwal</option>
                    </select>
                </div>

                <!-- SWAP BUTTON -->
                <div class="swap-wrapper">
                    <button type="button" class="swap-btn" id="swapBtn" title="Swap cities">&#8646;</button>
                </div>

                <!-- TO -->
                <div class="search-field">
                    <label class="search-card-label" for="destination">To</label>
                    <select id="destination" name="destination" required>
                        <option value="">Select City</option>
                        <option value="Pokhara">Pokhara</option>
                        <option value="Kathmandu">Kathmandu</option>
                        <option value="Chitwan">Chitwan</option>
                        <option value="Lumbini">Lumbini</option>
                        <option value="Biratnagar">Biratnagar</option>
                        <option value="Butwal">Butwal</option>
                    </select>
                </div>

                <!-- DATE -->
                <div class="search-field">
                    <label class="search-card-label" for="travelDate">Travel Date</label>
                    <input type="date" id="travelDate" name="travelDate" required>
                </div>

                <!-- SEARCH BUTTON -->
                <div class="search-submit-wrapper">
                    <button type="submit" class="search-btn" id="searchBtn"> Search Buses </button>
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
        document.getElementById('swapBtn').addEventListener('click', function () {
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

        // Set min date to today
        var today = new Date().toISOString().split('T')[0];
        document.getElementById('travelDate').setAttribute('min', today);
    </script>

    <!-- ===== FEATURES SECTION ===== -->
    <section class="features">
        <div class="feature-card">
            <span class="feature-icon">🛡️</span>
            <h3>Safe Travel</h3>
            <p>Your safety is our top priority. We use well-maintained buses and conduct regular safety audits for a worry-free journey.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">⏰</span>
            <h3>On-Time Departure</h3>
            <p>We value your time. Our fleet follows strict schedules to ensure you reach your destination exactly when expected.</p>
        </div>
        <div class="feature-card">
            <span class="feature-icon">✨</span>
            <h3>Easy Booking</h3>
            <p>Experience the smoothest booking process in Nepal. Reserve your seats in just a few clicks from any device.</p>
        </div>
    </section>

    <%@ include file="common/footer.jsp" %>