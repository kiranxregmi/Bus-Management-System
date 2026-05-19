package model;

import java.sql.Timestamp;
import java.util.List;

public class Booking {
    private int id;
    private int userId;
    private int scheduleId;
    private int busSetupId;
    private int routeId;
    private String passengerName;
    private String passengerPhone;
    private String passengerEmail;
    private String seatNumbers;
    private double totalFare;
    private Timestamp bookingDate;
    private BookingStatus status;

    // For display purposes
    private User user;
    private Schedule schedule;
    private List<String> seatList;

    // Constructors
    public Booking() {
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getScheduleId() {
        return scheduleId;
    }

    public void setScheduleId(int scheduleId) {
        this.scheduleId = scheduleId;
    }

    public int getBusSetupId() {
        return busSetupId;
    }

    public void setBusSetupId(int busSetupId) {
        this.busSetupId = busSetupId;
    }

    public int getRouteId() {
        return routeId;
    }

    public void setRouteId(int routeId) {
        this.routeId = routeId;
    }

    public String getPassengerName() {
        return passengerName;
    }

    public void setPassengerName(String passengerName) {
        this.passengerName = passengerName;
    }

    public String getPassengerPhone() {
        return passengerPhone;
    }

    public void setPassengerPhone(String passengerPhone) {
        this.passengerPhone = passengerPhone;
    }

    public String getPassengerEmail() {
        return passengerEmail;
    }

    public void setPassengerEmail(String passengerEmail) {
        this.passengerEmail = passengerEmail;
    }

    public String getSeatNumbers() {
        return seatNumbers;
    }

    public void setSeatNumbers(String seatNumbers) {
        this.seatNumbers = seatNumbers;
    }

    public double getTotalFare() {
        return totalFare;
    }

    public void setTotalFare(double totalFare) {
        this.totalFare = totalFare;
    }

    public Timestamp getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Timestamp bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStatus() {
        return status != null ? status.name() : null;
    }

    public void setStatus(String status) {
        this.status = BookingStatus.fromString(status);
    }

    public BookingStatus getStatusEnum() {
        return status;
    }

    public void setStatusEnum(BookingStatus status) {
        this.status = status;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Schedule getSchedule() {
        return schedule;
    }

    public void setSchedule(Schedule schedule) {
        this.schedule = schedule;
    }

    public List<String> getSeatList() {
        return seatList;
    }

    public void setSeatList(List<String> seatList) {
        this.seatList = seatList;
    }

    @Override
    public String toString() {
        return "Booking [id=" + id + ", userId=" + userId + ", scheduleId=" + scheduleId + "]";
    }
}
