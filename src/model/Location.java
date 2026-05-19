package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Location {
    private int id;
    private String name;
    private String district;
    private BigDecimal latitude;
    private BigDecimal longitude;
    private Timestamp createdAt;

    public Location() {}

    public Location(String name, String district) {
        this.name = name;
        this.district = district;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public BigDecimal getLatitude() { return latitude; }
    public void setLatitude(BigDecimal latitude) { this.latitude = latitude; }

    public BigDecimal getLongitude() { return longitude; }
    public void setLongitude(BigDecimal longitude) { this.longitude = longitude; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
