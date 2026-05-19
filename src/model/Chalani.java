package model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Chalani {
    private int id;
    private int busSetupId;
    private Integer operatorId;
    private Date bookingDate;
    private int totalSeatsBooked;
    private BigDecimal totalRevenue;
    private Timestamp createdAt;

    public Chalani() {}

    public Chalani(int busSetupId, Date bookingDate) {
        this.busSetupId = busSetupId;
        this.bookingDate = bookingDate;
        this.totalSeatsBooked = 0;
        this.totalRevenue = BigDecimal.ZERO;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBusSetupId() { return busSetupId; }
    public void setBusSetupId(int busSetupId) { this.busSetupId = busSetupId; }

    public Integer getOperatorId() { return operatorId; }
    public void setOperatorId(Integer operatorId) { this.operatorId = operatorId; }

    public Date getBookingDate() { return bookingDate; }
    public void setBookingDate(Date bookingDate) { this.bookingDate = bookingDate; }

    public int getTotalSeatsBooked() { return totalSeatsBooked; }
    public void setTotalSeatsBooked(int totalSeatsBooked) { this.totalSeatsBooked = totalSeatsBooked; }

    public BigDecimal getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(BigDecimal totalRevenue) { this.totalRevenue = totalRevenue; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
