package model;

public enum BusType {
    STANDARD,
    SEMI_DELUXE,
    AC_DELUXE,
    SUPER_DELUXE;

    public static BusType fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return BusType.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
