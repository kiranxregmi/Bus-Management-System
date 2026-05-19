package model;

import java.sql.Timestamp;

public class BusNumber {
    private int id;
    private int busNameId;
    private String registrationNumber;
    private BusNumberStatus status; // ACTIVE, INACTIVE, MAINTENANCE
    private Timestamp createdAt;
    private BusName busName; // For convenience

    public BusNumber() {}

    public BusNumber(int busNameId, String registrationNumber) {
        this.busNameId = busNameId;
        this.registrationNumber = registrationNumber;
        this.status = BusNumberStatus.ACTIVE;
    }

    public BusNumber(int busNameId, String registrationNumber, BusNumberStatus status) {
        this.busNameId = busNameId;
        this.registrationNumber = registrationNumber;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBusNameId() { return busNameId; }
    public void setBusNameId(int busNameId) { this.busNameId = busNameId; }

    public String getRegistrationNumber() { return registrationNumber; }
    public void setRegistrationNumber(String registrationNumber) { this.registrationNumber = registrationNumber; }

    public String getStatus() { return status != null ? status.name() : null; }
    public void setStatus(String status) { this.status = BusNumberStatus.fromString(status); }

    public BusNumberStatus getStatusEnum() { return status; }
    public void setStatusEnum(BusNumberStatus status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public BusName getBusName() { return busName; }
    public void setBusName(BusName busName) { this.busName = busName; }
}
