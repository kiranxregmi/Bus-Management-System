package model;

public enum SeatStatus {
    AVAILABLE,
    BOOKED,
    LOCKED;

    public static SeatStatus fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return SeatStatus.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
