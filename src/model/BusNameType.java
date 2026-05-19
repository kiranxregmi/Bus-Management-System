package model;

public enum BusNameType {
    SLEEPER,
    DELUXE,
    SOFA_SEATER;

    public static BusNameType fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return BusNameType.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
