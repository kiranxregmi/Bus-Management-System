package model;

import java.sql.Date;
import java.sql.Timestamp;

public class EventReservation {
    private int id;
    private int userId;
    private String eventType;
    private String eventName;
    private Date eventDate;
    private Date requiredDate;
    private int numberOfPassengers;
    private int numberOfBuses;
    private BusType preferredBusType;
    private String pickupLocation;
    private String dropoffLocation;
    private String description;
    private ReservationStatus status;
    private Timestamp createdAt;

    // Default constructor
    public EventReservation() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getEventType() { return eventType; }
    public void setEventType(String eventType) { this.eventType = eventType; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public Date getRequiredDate() { return requiredDate; }
    public void setRequiredDate(Date requiredDate) { this.requiredDate = requiredDate; }

    public int getNumberOfPassengers() { return numberOfPassengers; }
    public void setNumberOfPassengers(int numberOfPassengers) { this.numberOfPassengers = numberOfPassengers; }

    public int getNumberOfBuses() { return numberOfBuses; }
    public void setNumberOfBuses(int numberOfBuses) { this.numberOfBuses = numberOfBuses; }

    public String getPreferredBusType() { return preferredBusType != null ? preferredBusType.name() : null; }
    public void setPreferredBusType(String preferredBusType) { this.preferredBusType = BusType.fromString(preferredBusType); }

    public BusType getPreferredBusTypeEnum() { return preferredBusType; }
    public void setPreferredBusTypeEnum(BusType preferredBusType) { this.preferredBusType = preferredBusType; }

    public String getPickupLocation() { return pickupLocation; }
    public void setPickupLocation(String pickupLocation) { this.pickupLocation = pickupLocation; }

    public String getDropoffLocation() { return dropoffLocation; }
    public void setDropoffLocation(String dropoffLocation) { this.dropoffLocation = dropoffLocation; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatus() { return status != null ? status.name() : null; }
    public void setStatus(String status) { this.status = ReservationStatus.fromString(status); }

    public ReservationStatus getStatusEnum() { return status; }
    public void setStatusEnum(ReservationStatus status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
