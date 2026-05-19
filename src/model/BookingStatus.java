package model;

public enum BookingStatus {
    CONFIRMED,
    CANCELLED,
    PENDING;

    public static BookingStatus fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return BookingStatus.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
