package model;

public enum SeatLayoutType {
    _2X2_SOFA("2X2_SOFA"),
    _2X2_SOFA_WITH_SLEEPER("2X2_SOFA_WITH_SLEEPER"),
    _2X1_SOFA("2X1_SOFA");

    private final String dbValue;

    SeatLayoutType(String dbValue) {
        this.dbValue = dbValue;
    }

    public String getDbValue() {
        return dbValue;
    }

    public static SeatLayoutType fromString(String value) {
        if (value == null) {
            return null;
        }
        String clean = value.toUpperCase().replace("2X", "_2X");
        try {
            return SeatLayoutType.valueOf(clean);
        } catch (IllegalArgumentException e) {
            // fallback: check dbValue
            for (SeatLayoutType type : values()) {
                if (type.dbValue.equalsIgnoreCase(value)) {
                    return type;
                }
            }
            return null;
        }
    }
}
