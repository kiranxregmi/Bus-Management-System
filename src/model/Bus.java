package model;

public class Bus {
    private int id;
    private String busNumber;
    private String busName;
    private int capacity;
    private BusType busType;
    private double farePerSeat;
    private BusStatus status;

    // Constructors
    public Bus() {
    }

    public Bus(String busNumber, String busName, int capacity, String busType, double farePerSeat) {
        this.busNumber = busNumber;
        this.busName = busName;
        this.capacity = capacity;
        setBusType(busType);
        this.farePerSeat = farePerSeat;
        this.status = BusStatus.ACTIVE;
    }

    public Bus(String busNumber, String busName, int capacity, BusType busType, double farePerSeat, BusStatus status) {
        this.busNumber = busNumber;
        this.busName = busName;
        this.capacity = capacity;
        this.busType = busType;
        this.farePerSeat = farePerSeat;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getBusNumber() {
        return busNumber;
    }

    public void setBusNumber(String busNumber) {
        this.busNumber = busNumber;
    }

    public String getBusName() {
        return busName;
    }

    public void setBusName(String busName) {
        this.busName = busName;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getBusType() {
        return busType != null ? busType.name() : null;
    }

    public void setBusType(String busType) {
        this.busType = BusType.fromString(busType);
    }

    public BusType getBusTypeEnum() {
        return busType;
    }

    public void setBusTypeEnum(BusType busType) {
        this.busType = busType;
    }

    public double getFarePerSeat() {
        return farePerSeat;
    }

    public void setFarePerSeat(double farePerSeat) {
        this.farePerSeat = farePerSeat;
    }

    public String getStatus() {
        return status != null ? status.name() : null;
    }

    public void setStatus(String status) {
        this.status = BusStatus.fromString(status);
    }

    public BusStatus getStatusEnum() {
        return status;
    }

    public void setStatusEnum(BusStatus status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "Bus [id=" + id + ", busNumber=" + busNumber + ", busName=" + busName + "]";
    }
}
