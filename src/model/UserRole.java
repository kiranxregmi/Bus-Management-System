package model;

public enum UserRole {
    ADMIN,
    OPERATOR,
    CUSTOMER;

    public static UserRole fromString(String value) {
        if (value == null) {
            return null;
        }
        try {
            return UserRole.valueOf(value.toUpperCase());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
}
