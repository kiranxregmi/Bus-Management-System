package model;

import java.math.BigDecimal;
import java.sql.Time;
import java.sql.Timestamp;

public class BusSetup {
    private int id;
    private int busNumberId;
    private int seatLayoutId;
    private BigDecimal tripPrice;
    private Time tripTime;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    
    // For convenience
    private BusNumber busNumber;
    private SeatLayout seatLayout;

    public BusSetup() {}

    public BusSetup(int busNumberId, int seatLayoutId) {
        this.busNumberId = busNumberId;
        this.seatLayoutId = seatLayoutId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBusNumberId() { return busNumberId; }
    public void setBusNumberId(int busNumberId) { this.busNumberId = busNumberId; }

    public int getSeatLayoutId() { return seatLayoutId; }
    public void setSeatLayoutId(int seatLayoutId) { this.seatLayoutId = seatLayoutId; }

    public BigDecimal getTripPrice() { return tripPrice; }
    public void setTripPrice(BigDecimal tripPrice) { this.tripPrice = tripPrice; }

    public Time getTripTime() { return tripTime; }
    public void setTripTime(Time tripTime) { this.tripTime = tripTime; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public BusNumber getBusNumber() { return busNumber; }
    public void setBusNumber(BusNumber busNumber) { this.busNumber = busNumber; }

    public SeatLayout getSeatLayout() { return seatLayout; }
    public void setSeatLayout(SeatLayout seatLayout) { this.seatLayout = seatLayout; }
}
