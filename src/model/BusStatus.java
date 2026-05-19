package model;

public enum BusStatus {
    ACTIVE,
    INACTIVE;

    public static BusStatus fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return BusStatus.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
