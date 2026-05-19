package model;

public enum StaffRole {
    DRIVER,
    CONDUCTOR,
    HELPER;

    public static StaffRole fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return StaffRole.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
