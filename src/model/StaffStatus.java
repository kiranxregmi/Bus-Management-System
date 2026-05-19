package model;

public enum StaffStatus {
    ACTIVE,
    INACTIVE;

    public static StaffStatus fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return StaffStatus.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
