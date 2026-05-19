package model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private UserRole role;
    private Timestamp createdAt;

    // Constructors
    public User() {
    }

    public User(String fullName, String email, String password, String phone, String role) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        setRole(role);
    }

    public User(String fullName, String email, String password, String phone, UserRole role) {
        this.fullName = fullName;
        this.email = email;
        this.password = password;
        this.phone = phone;
        this.role = role;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role != null ? role.name() : null;
    }

    public void setRole(String role) {
        this.role = UserRole.fromString(role);
    }

    public UserRole getRoleEnum() {
        return role;
    }

    public void setRoleEnum(UserRole role) {
        this.role = role;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public boolean hasRole(String... roles) {
        if (this.role == null || roles == null) {
            return false;
        }
        for (String allowedRole : roles) {
            if (this.role.name().equalsIgnoreCase(allowedRole)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public String toString() {
        return "User [id=" + id + ", fullName=" + fullName + ", email=" + email + ", role=" + (role != null ? role.name() : null) + "]";
    }
}
