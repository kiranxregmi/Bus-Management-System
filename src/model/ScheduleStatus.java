package model;

public enum ScheduleStatus {
    SCHEDULED,
    DELAYED,
    COMPLETED,
    CANCELLED;

    public static ScheduleStatus fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return ScheduleStatus.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
