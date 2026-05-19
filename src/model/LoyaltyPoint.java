package model;

import java.sql.Timestamp;

public class LoyaltyPoint {
    private int id;
    private int userId;
    private int pointsBalance;
    private int totalPointsEarned;
    private Timestamp lastUpdated;

    public LoyaltyPoint() {}

    public LoyaltyPoint(int userId) {
        this.userId = userId;
        this.pointsBalance = 0;
        this.totalPointsEarned = 0;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getPointsBalance() { return pointsBalance; }
    public void setPointsBalance(int pointsBalance) { this.pointsBalance = pointsBalance; }

    public int getTotalPointsEarned() { return totalPointsEarned; }
    public void setTotalPointsEarned(int totalPointsEarned) { this.totalPointsEarned = totalPointsEarned; }

    public Timestamp getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(Timestamp lastUpdated) { this.lastUpdated = lastUpdated; }

    public void addPoints(int points) {
        this.pointsBalance += points;
        this.totalPointsEarned += points;
    }
}
