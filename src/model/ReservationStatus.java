package model;

public enum ReservationStatus {
    PENDING,
    APPROVED,
    REJECTED;

    public static ReservationStatus fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return ReservationStatus.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
