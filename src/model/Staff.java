package model;

import java.sql.Timestamp;

public class Staff {
    private int id;
    private String name;
    private StaffRole role; // DRIVER, CONDUCTOR, HELPER
    private String phone;
    private String address;
    private String licenseNumber;
    private StaffStatus status; // ACTIVE, INACTIVE
    private Timestamp createdAt;

    public Staff() {}

    public Staff(String name, String role, String phone) {
        this.name = name;
        setRole(role);
        this.phone = phone;
        this.status = StaffStatus.ACTIVE;
    }

    public Staff(String name, StaffRole role, String phone, StaffStatus status) {
        this.name = name;
        this.role = role;
        this.phone = phone;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getRole() { return role != null ? role.name() : null; }
    public void setRole(String role) { this.role = StaffRole.fromString(role); }

    public StaffRole getRoleEnum() { return role; }
    public void setRoleEnum(StaffRole role) { this.role = role; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getLicenseNumber() { return licenseNumber; }
    public void setLicenseNumber(String licenseNumber) { this.licenseNumber = licenseNumber; }

    public String getStatus() { return status != null ? status.name() : null; }
    public void setStatus(String status) { this.status = StaffStatus.fromString(status); }

    public StaffStatus getStatusEnum() { return status; }
    public void setStatusEnum(StaffStatus status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
