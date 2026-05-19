package model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class Route {
    private int id;
    private String source;
    private String destination;
    private int distance;
    private String duration;
    private int departureLocationId;
    private int arrivalLocationId;
    private BigDecimal durationHours;
    private BigDecimal distanceKm;
    private String remarks;
    private String departureLocationName;
    private String arrivalLocationName;
    private List<PickupPoint> pickupPoints = new ArrayList<>();
    private List<DropPoint> dropPoints = new ArrayList<>();
    private Integer busSetupId;

    // Constructors
    public Route() {
    }

    public Route(String source, String destination, int distance, String duration) {
        this.source = source;
        this.destination = destination;
        this.distance = distance;
        this.duration = duration;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getDestination() {
        return destination;
    }

    public void setDestination(String destination) {
        this.destination = destination;
    }

    public int getDistance() {
        return distance;
    }

    public void setDistance(int distance) {
        this.distance = distance;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public int getDepartureLocationId() {
        return departureLocationId;
    }

    public void setDepartureLocationId(int departureLocationId) {
        this.departureLocationId = departureLocationId;
    }

    public int getArrivalLocationId() {
        return arrivalLocationId;
    }

    public void setArrivalLocationId(int arrivalLocationId) {
        this.arrivalLocationId = arrivalLocationId;
    }

    public BigDecimal getDurationHours() {
        return durationHours;
    }

    public void setDurationHours(BigDecimal durationHours) {
        this.durationHours = durationHours;
    }

    public BigDecimal getDistanceKm() {
        return distanceKm;
    }

    public void setDistanceKm(BigDecimal distanceKm) {
        this.distanceKm = distanceKm;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public String getDepartureLocationName() {
        return departureLocationName;
    }

    public void setDepartureLocationName(String departureLocationName) {
        this.departureLocationName = departureLocationName;
    }

    public String getArrivalLocationName() {
        return arrivalLocationName;
    }

    public void setArrivalLocationName(String arrivalLocationName) {
        this.arrivalLocationName = arrivalLocationName;
    }

    public List<PickupPoint> getPickupPoints() {
        return pickupPoints;
    }

    public void setPickupPoints(List<PickupPoint> pickupPoints) {
        this.pickupPoints = pickupPoints;
    }

    public List<DropPoint> getDropPoints() {
        return dropPoints;
    }

    public void setDropPoints(List<DropPoint> dropPoints) {
        this.dropPoints = dropPoints;
    }

    public Integer getBusSetupId() {
        return busSetupId;
    }

    public void setBusSetupId(Integer busSetupId) {
        this.busSetupId = busSetupId;
    }

    @Override
    public String toString() {
        return "Route [id=" + id + ", source=" + source + ", destination=" + destination + "]";
    }
}
