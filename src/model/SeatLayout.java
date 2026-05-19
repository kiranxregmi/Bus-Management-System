package model;

import java.sql.Timestamp;

public class SeatLayout {
    private int id;
    private String name;
    private SeatLayoutType type; // 2X2_SOFA, 2X2_SOFA_WITH_SLEEPER, 2X1_SOFA
    private int totalSeats;
    private int rows;
    private int columns;
    private String layoutJson; // JSON layout representation
    private Timestamp createdAt;

    public SeatLayout() {}

    public SeatLayout(String name, String type, int totalSeats, int rows, int columns) {
        this.name = name;
        setType(type);
        this.totalSeats = totalSeats;
        this.rows = rows;
        this.columns = columns;
    }

    public SeatLayout(String name, SeatLayoutType type, int totalSeats, int rows, int columns) {
        this.name = name;
        this.type = type;
        this.totalSeats = totalSeats;
        this.rows = rows;
        this.columns = columns;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getType() { return type != null ? type.getDbValue() : null; }
    public void setType(String type) { this.type = SeatLayoutType.fromString(type); }

    public SeatLayoutType getTypeEnum() { return type; }
    public void setTypeEnum(SeatLayoutType type) { this.type = type; }

    public int getTotalSeats() { return totalSeats; }
    public void setTotalSeats(int totalSeats) { this.totalSeats = totalSeats; }

    public int getRows() { return rows; }
    public void setRows(int rows) { this.rows = rows; }

    public int getColumns() { return columns; }
    public void setColumns(int columns) { this.columns = columns; }

    public String getLayoutJson() { return layoutJson; }
    public void setLayoutJson(String layoutJson) { this.layoutJson = layoutJson; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
