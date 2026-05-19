package model;

public enum BusNumberStatus {
    ACTIVE,
    INACTIVE,
    MAINTENANCE;

    public static BusNumberStatus fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return BusNumberStatus.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
