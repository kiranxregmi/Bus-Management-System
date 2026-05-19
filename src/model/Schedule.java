package model;

import java.sql.Date;
import java.sql.Time;

public class Schedule {
    private int id;
    private int busId;
    private int routeId;
    private Time departureTime;
    private Time arrivalTime;
    private Date travelDate;
    private int availableSeats;
    private Time actualDeparture;
    private Time actualArrival;
    private Integer driverId;
    private Integer conductorId;
    private ScheduleStatus status;
    private double fare;

    // For JOIN queries
    private Bus bus;
    private Route route;

    // Constructors
    public Schedule() {
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getBusId() {
        return busId;
    }

    public void setBusId(int busId) {
        this.busId = busId;
    }

    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
    }

    public Time getDepartureTime() {
        return departureTime;
    }

    public void setDepartureTime(Time departureTime) {
        this.departureTime = departureTime;
    }

    public Time getArrivalTime() {
        return arrivalTime;
    }

    public void setArrivalTime(Time arrivalTime) {
        this.arrivalTime = arrivalTime;
    }

    public Date getTravelDate() {
        return travelDate;
    }

    public void setTravelDate(Date travelDate) {
        this.travelDate = travelDate;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }

    public Bus getBus() {
        return bus;
    }

    public void setBus(Bus bus) {
        this.bus = bus;
    }

    public Route getRoute() {
        return route;
    }

    public void setRoute(Route route) {
        this.route = route;
    }

    public Time getActualDeparture() {
        return actualDeparture;
    }

    public void setActualDeparture(Time actualDeparture) {
        this.actualDeparture = actualDeparture;
    }

    public Time getActualArrival() {
        return actualArrival;
    }

    public void setActualArrival(Time actualArrival) {
        this.actualArrival = actualArrival;
    }

    public Integer getDriverId() {
        return driverId;
    }

    public void setDriverId(Integer driverId) {
        this.driverId = driverId;
    }

    public Integer getConductorId() {
        return conductorId;
    }

    public void setConductorId(Integer conductorId) {
        this.conductorId = conductorId;
    }

    public String getStatus() {
        return status != null ? status.name() : null;
    }

    public void setStatus(String status) {
        this.status = ScheduleStatus.fromString(status);
    }

    public ScheduleStatus getStatusEnum() {
        return status;
    }

    public void setStatusEnum(ScheduleStatus status) {
        this.status = status;
    }

    public double getFare() {
        return fare;
    }

    public void setFare(double fare) {
        this.fare = fare;
    }

    @Override
    public String toString() {
        return "Schedule [id=" + id + ", busId=" + busId + ", routeId=" + routeId + ", status=" + (status != null ? status.name() : null) + "]";
    }
}
