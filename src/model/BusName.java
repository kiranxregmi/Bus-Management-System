package model;

import java.sql.Timestamp;

public class BusName {
    private int id;
    private String name;
    private BusNameType busType; // SLEEPER, DELUXE, SOFA_SEATER
    private int capacity;
    private Timestamp createdAt;

    public BusName() {}

    public BusName(String name, String busType, int capacity) {
        this.name = name;
        setBusType(busType);
        this.capacity = capacity;
    }

    public BusName(String name, BusNameType busType, int capacity) {
        this.name = name;
        this.busType = busType;
        this.capacity = capacity;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBusType() { return busType != null ? busType.name() : null; }
    public void setBusType(String busType) { this.busType = BusNameType.fromString(busType); }

    public BusNameType getBusTypeEnum() { return busType; }
    public void setBusTypeEnum(BusNameType busType) { this.busType = busType; }

    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
