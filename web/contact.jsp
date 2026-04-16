<%@ include file="common/header.jsp" %>

    <div class="container" style="padding: 3rem 1rem;">
        <h2 style="color: var(--primary); text-align: center; margin-bottom: 2rem;">Contact Us</h2>

        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; max-width: 1000px; margin: 0 auto;">

            <div
                style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Get In Touch</h3>

                <form action="#" method="POST">
                    <div class="form-group">
                        <label>Your Name</label>
                        <input type="text" name="name" placeholder="Enter your name" required>
                    </div>

                    <div class="form-group">
                        <label>Email Address</label>
                        <input type="email" name="email" placeholder="your@email.com" required>
                    </div>

                    <div class="form-group">
                        <label>Subject</label>
                        <input type="text" name="subject" placeholder="What is this about?">
                    </div>

                    <div class="form-group">
                        <label>Message</label>
                        <textarea name="message" rows="4"
                            style="width: 100%; padding: 0.75rem; border: 1px solid #ddd; border-radius: 5px;"
                            placeholder="Your message..."></textarea>
                    </div>

                    <button type="submit" class="btn">Send Message</button>
                </form>
            </div>

            <div
                style="background: var(--white); padding: 2rem; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                <h3 style="color: var(--primary); margin-bottom: 1.5rem;">Contact Information</h3>

                <div style="margin-bottom: 2rem;">
                    <h4 style="color: var(--primary); margin-bottom: 0.5rem;">HEAD OFFICE</h4>
                    <p>Kalanki, Kathmandu, Nepal</p>
                </div>

                <div style="margin-bottom: 2rem;">
                    <h4 style="color: var(--primary); margin-bottom: 0.5rem;">PHONE</h4>
                    <p>+977-1-5234567</p>
                    <p>+977-9800000000 (WhatsApp)</p>
                </div>

                <div style="margin-bottom: 2rem;">
                    <h4 style="color: var(--primary); margin-bottom: 0.5rem;">EMAIL</h4>
                    <p>info@kalpanatravels.com</p>
                    <p>support@kalpanatravels.com</p>
                </div>

                <div>
                    <h4 style="color: var(--primary); margin-bottom: 0.5rem;">OFFICE HOURS</h4>
                    <p>Sunday - Friday: 6:00 AM - 8:00 PM</p>
                    <p>Saturday: 8:00 AM - 2:00 PM</p>
                </div>
            </div>
        </div>
    </div>

    <%@ include file="common/footer.jsp" %>