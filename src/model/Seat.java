package model;

import java.sql.Timestamp;

public class Seat {
    private int id;
    private int busSetupId;
    private String seatNumber;
    private SeatStatus status; // AVAILABLE, BOOKED, LOCKED
    private Timestamp createdAt;

    public Seat() {}

    public Seat(int busSetupId, String seatNumber) {
        this.busSetupId = busSetupId;
        this.seatNumber = seatNumber;
        this.status = SeatStatus.AVAILABLE;
    }

    public Seat(int busSetupId, String seatNumber, SeatStatus status) {
        this.busSetupId = busSetupId;
        this.seatNumber = seatNumber;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBusSetupId() { return busSetupId; }
    public void setBusSetupId(int busSetupId) { this.busSetupId = busSetupId; }

    public String getSeatNumber() { return seatNumber; }
    public void setSeatNumber(String seatNumber) { this.seatNumber = seatNumber; }

    public String getStatus() { return status != null ? status.name() : null; }
    public void setStatus(String status) { this.status = SeatStatus.fromString(status); }

    public SeatStatus getStatusEnum() { return status; }
    public void setStatusEnum(SeatStatus status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
