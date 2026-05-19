package model;

import java.math.BigDecimal;
import java.sql.Time;
import java.sql.Timestamp;

public class DropPoint {
    private int id;
    private int routeId;
    private int locationId;
    private String dropRoute;
    private Time dropTime;
    private BigDecimal price;
    private BigDecimal priceMultiplier;
    private int sequenceOrder;
    private Timestamp createdAt;
    private Location location; // For convenience

    public DropPoint() {}

    public DropPoint(int routeId, int locationId, Time dropTime) {
        this.routeId = routeId;
        this.locationId = locationId;
        this.dropTime = dropTime;
        this.priceMultiplier = new BigDecimal("1.0");
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRouteId() { return routeId; }
    public void setRouteId(int routeId) { this.routeId = routeId; }

    public int getLocationId() { return locationId; }
    public void setLocationId(int locationId) { this.locationId = locationId; }

    public String getDropRoute() { return dropRoute; }
    public void setDropRoute(String dropRoute) { this.dropRoute = dropRoute; }

    public Time getDropTime() { return dropTime; }
    public void setDropTime(Time dropTime) { this.dropTime = dropTime; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public BigDecimal getPriceMultiplier() { return priceMultiplier; }
    public void setPriceMultiplier(BigDecimal priceMultiplier) { this.priceMultiplier = priceMultiplier; }

    public int getSequenceOrder() { return sequenceOrder; }
    public void setSequenceOrder(int sequenceOrder) { this.sequenceOrder = sequenceOrder; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Location getLocation() { return location; }
    public void setLocation(Location location) { this.location = location; }
}
