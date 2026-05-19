// Custom UI controls: Circular Time Picker & Location Selection Modal

document.addEventListener('DOMContentLoaded', function() {
    initCircularTimePicker();
    initLocationSelectionModal();
});

// ==========================================
// 1. CIRCULAR TIME PICKER
// ==========================================
function initCircularTimePicker() {
    // Create the modal HTML
    const modalHtml = `
        <div id="clockPickerModal" class="clock-picker-modal" style="display:none;">
            <div class="clock-picker-content">
                <div class="clock-picker-header">
                    <span id="cpHeaderHour" class="cp-time-part active">12</span>:<span id="cpHeaderMinute" class="cp-time-part">00</span>
                    <div class="cp-am-pm-toggle">
                        <span id="cpBtnAM" class="cp-ampm active">AM</span>
                        <span id="cpBtnPM" class="cp-ampm">PM</span>
                    </div>
                </div>
                <div class="clock-picker-body">
                    <div class="clock-dial" id="clockDial">
                        <div class="clock-hand" id="clockHand">
                            <div class="clock-hand-pin"></div>
                            <div class="clock-hand-line"></div>
                            <div class="clock-hand-pointer"></div>
                        </div>
                        <!-- Numbers will be dynamically generated -->
                    </div>
                </div>
                <div class="clock-picker-footer">
                    <button type="button" class="cp-btn" id="cpBtnCancel">CANCEL</button>
                    <button type="button" class="cp-btn" id="cpBtnOK">OK</button>
                </div>
            </div>
        </div>
    `;
    
    // Append to body if not exists
    if (!document.getElementById('clockPickerModal')) {
        const div = document.createElement('div');
        div.innerHTML = modalHtml.trim();
        document.body.appendChild(div.firstChild);
    }
    
    const modal = document.getElementById('clockPickerModal');
    const dial = document.getElementById('clockDial');
    const hand = document.getElementById('clockHand');
    const headerHour = document.getElementById('cpHeaderHour');
    const headerMinute = document.getElementById('cpHeaderMinute');
    const btnAM = document.getElementById('cpBtnAM');
    const btnPM = document.getElementById('cpBtnPM');
    const btnCancel = document.getElementById('cpBtnCancel');
    const btnOK = document.getElementById('cpBtnOK');
    
    let targetInput = null;
    let mode = 'hour'; // 'hour' or 'minute'
    let selectedHour = 12;
    let selectedMinute = 0;
    let selectedAmPm = 'AM';
    
    // Position numbers on dial
    function populateDial() {
        // Clear previous items except hand
        const items = dial.querySelectorAll('.dial-number');
        items.forEach(el => el.remove());
        
        const count = mode === 'hour' ? 12 : 12;
        const radius = 95; // px
        
        for (let i = 1; i <= 12; i++) {
            const numEl = document.createElement('div');
            numEl.className = 'dial-number';
            
            let val;
            if (mode === 'hour') {
                val = i;
            } else {
                val = (i * 5) % 60;
                if (val === 0) val = '00';
            }
            
            numEl.textContent = val;
            numEl.dataset.value = val;
            
            // Calculate angle: 12 is at top (270 degrees)
            const angle = ((i * 30) - 90) * (Math.PI / 180);
            const x = 110 + radius * Math.cos(angle) - 15; // center is ~110px, half width of element is 15px
            const y = 110 + radius * Math.sin(angle) - 15;
            
            numEl.style.left = `${x}px`;
            numEl.style.top = `${y}px`;
            
            numEl.addEventListener('click', function(e) {
                e.stopPropagation();
                selectValue(parseInt(val, 10));
            });
            
            dial.appendChild(numEl);
        }
        
        updateHand();
    }
    
    function updateHand() {
        let angleDegrees = 0;
        if (mode === 'hour') {
            let hr = selectedHour % 12;
            if (hr === 0) hr = 12;
            angleDegrees = hr * 30;
        } else {
            angleDegrees = selectedMinute * 6; // 360 / 60
        }
        hand.style.transform = `rotate(${angleDegrees}deg)`;
    }
    
    function selectValue(val) {
        if (mode === 'hour') {
            selectedHour = val;
            headerHour.textContent = val < 10 ? '0' + val : val;
            updateHand();
            // Switch to minutes after a short delay
            setTimeout(() => {
                mode = 'minute';
                headerHour.classList.remove('active');
                headerMinute.classList.add('active');
                populateDial();
            }, 300);
        } else {
            selectedMinute = val;
            headerMinute.textContent = val < 10 ? '0' + val : val;
            updateHand();
        }
    }
    
    // Click on header time parts to switch modes
    headerHour.addEventListener('click', () => {
        mode = 'hour';
        headerHour.classList.add('active');
        headerMinute.classList.remove('active');
        populateDial();
    });
    
    headerMinute.addEventListener('click', () => {
        mode = 'minute';
        headerHour.classList.remove('active');
        headerMinute.classList.add('active');
        populateDial();
    });
    
    // AM/PM selection
    btnAM.addEventListener('click', () => {
        selectedAmPm = 'AM';
        btnAM.classList.add('active');
        btnPM.classList.remove('active');
    });
    
    btnPM.addEventListener('click', () => {
        selectedAmPm = 'PM';
        btnPM.classList.add('active');
        btnAM.classList.remove('active');
    });
    
    btnCancel.addEventListener('click', () => {
        modal.style.display = 'none';
    });
    
    btnOK.addEventListener('click', () => {
        if (targetInput) {
            // Format time as HH:MM
            let h = selectedHour;
            if (selectedAmPm === 'PM' && h < 12) h += 12;
            if (selectedAmPm === 'AM' && h === 12) h = 0;
            const hh = h < 10 ? '0' + h : h;
            const mm = selectedMinute < 10 ? '0' + selectedMinute : selectedMinute;
            targetInput.value = `${hh}:${mm}`;
            // Dispatch input/change event
            targetInput.dispatchEvent(new Event('input', { bubbles: true }));
            targetInput.dispatchEvent(new Event('change', { bubbles: true }));
        }
        modal.style.display = 'none';
    });
    
    // Global listener for time inputs
    document.addEventListener('focusin', function(e) {
        if (e.target && e.target.type === 'time') {
            e.target.blur(); // Hide keyboard / default picker
            targetInput = e.target;
            
            // Parse current value if exists
            const val = targetInput.value;
            if (val && val.includes(':')) {
                const parts = val.split(':');
                let h = parseInt(parts[0], 10);
                selectedMinute = parseInt(parts[1], 10);
                if (h >= 12) {
                    selectedAmPm = 'PM';
                    selectedHour = h > 12 ? h - 12 : 12;
                } else {
                    selectedAmPm = 'AM';
                    selectedHour = h === 0 ? 12 : h;
                }
            } else {
                selectedHour = 12;
                selectedMinute = 0;
                selectedAmPm = 'AM';
            }
            
            headerHour.textContent = selectedHour < 10 ? '0' + selectedHour : selectedHour;
            headerMinute.textContent = selectedMinute < 10 ? '0' + selectedMinute : selectedMinute;
            
            if (selectedAmPm === 'AM') {
                btnAM.classList.add('active');
                btnPM.classList.remove('active');
            } else {
                btnPM.classList.add('active');
                btnAM.classList.remove('active');
            }
            
            mode = 'hour';
            headerHour.classList.add('active');
            headerMinute.classList.remove('active');
            
            populateDial();
            
            // Position modal near target or center of screen
            modal.style.display = 'flex';
        }
    });
    
    // Close modal if click outside content
    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            modal.style.display = 'none';
        }
    });
}

// ==========================================
// 2. LOCATION SELECTION MODAL
// ==========================================
function initLocationSelectionModal() {
    // Create the modal HTML
    const modalHtml = `
        <div id="locationPickerModal" class="location-picker-modal" style="display:none;">
            <div class="location-picker-content">
                <div class="location-picker-header">
                    <h3>Select Location</h3>
                    <button type="button" class="lp-close-btn" id="lpCloseBtn">&times;</button>
                </div>
                <div class="location-picker-search">
                    <input type="text" id="lpSearchInput" placeholder="Search locations..." autocomplete="off">
                </div>
                <div class="location-picker-list" id="lpListContainer">
                    <!-- Locations populated dynamically -->
                </div>
            </div>
        </div>
    `;
    
    if (!document.getElementById('locationPickerModal')) {
        const div = document.createElement('div');
        div.innerHTML = modalHtml.trim();
        document.body.appendChild(div.firstChild);
    }
    
    const modal = document.getElementById('locationPickerModal');
    const closeBtn = document.getElementById('lpCloseBtn');
    const searchInput = document.getElementById('lpSearchInput');
    const listContainer = document.getElementById('lpListContainer');
    
    let targetSelect = null;
    let targetButton = null;
    let locations = [];
    
    // Close modal handlers
    closeBtn.addEventListener('click', () => { modal.style.display = 'none'; });
    modal.addEventListener('click', (e) => { if (e.target === modal) modal.style.display = 'none'; });
    
    // Filter list on search
    searchInput.addEventListener('input', function() {
        const query = this.value.toLowerCase().trim();
        const items = listContainer.querySelectorAll('.lp-item');
        items.forEach(item => {
            const text = item.textContent.toLowerCase();
            if (text.includes(query)) {
                item.style.display = 'flex';
            } else {
                item.style.display = 'none';
            }
        });
    });
    
    // Intercept select element focus
    function attachToSelect(selectEl) {
        if (selectEl.dataset.locationAttached) return;
        selectEl.dataset.locationAttached = "true";
        
        // Hide select element visually but keep it for form submission
        selectEl.style.display = 'none';
        
        // Create custom visual button
        const button = document.createElement('button');
        button.type = 'button';
        button.className = 'location-picker-trigger-btn';
        
        // Find initially selected option text
        const selectedOpt = selectEl.options[selectEl.selectedIndex];
        button.innerHTML = `<span class="lp-icon">📍</span> <span class="lp-label">${selectedOpt ? selectedOpt.textContent : 'Select location'}</span>`;
        
        button.addEventListener('click', function() {
            targetSelect = selectEl;
            targetButton = button;
            openModal();
        });
        
        selectEl.parentNode.insertBefore(button, selectEl);
    }
    
    function openModal() {
        // Build locations list from options of the target select
        locations = [];
        for (let i = 0; i < targetSelect.options.length; i++) {
            const opt = targetSelect.options[i];
            if (opt.value !== "") {
                locations.push({
                    id: opt.value,
                    name: opt.textContent
                });
            }
        }
        
        // Populate modal list
        listContainer.innerHTML = '';
        if (locations.length === 0) {
            listContainer.innerHTML = '<div style="padding:1rem;color:var(--gray);text-align:center;">No locations found</div>';
        } else {
            locations.forEach(loc => {
                const item = document.createElement('div');
                item.className = 'lp-item';
                item.innerHTML = `<span class="lp-item-icon">📍</span> <span class="lp-item-name">${loc.name}</span>`;
                item.addEventListener('click', function() {
                    targetSelect.value = loc.id;
                    targetSelect.dispatchEvent(new Event('change', { bubbles: true }));
                    targetButton.innerHTML = `<span class="lp-icon">📍</span> <span class="lp-label">${loc.name}</span>`;
                    modal.style.display = 'none';
                });
                listContainer.appendChild(item);
            });
        }
        
        searchInput.value = '';
        modal.style.display = 'flex';
        searchInput.focus();
    }
    
    // Auto observe select elements representing locations
    const observer = new MutationObserver((mutations) => {
        observeSelects();
    });
    
    function observeSelects() {
        // Match both route fields and dynamically added pickup/drop select fields
        const selects = document.querySelectorAll('select[name="departureLocationId"], select[name="arrivalLocationId"], select[name="pickupLocationId"], select[name="dropLocationId"]');
        selects.forEach(select => {
            attachToSelect(select);
        });
    }
    
    observer.observe(document.body, { childList: true, subtree: true });
    observeSelects();
}
