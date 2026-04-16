package service;

import dao.UserDAO;
import model.User;
import util.PasswordUtil;
import util.ValidationUtil;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserService {

    private UserDAO userDAO = new UserDAO();

    public boolean registerUser(User user) throws SQLException {
        // Validation
        List<String> errors = validateUser(user);
        if (!errors.isEmpty()) {
            throw new IllegalArgumentException(String.join(", ", errors));
        }

        // Check if email already exists
        if (userDAO.checkEmailExists(user.getEmail())) {
            throw new IllegalArgumentException("Email already registered");
        }

        // Hash password before saving
        String hashedPassword = PasswordUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);

        // Set default role if not specified
        if (user.getRole() == null) {
            user.setRole("CUSTOMER");
        }

        return userDAO.registerUser(user);
    }

    public User authenticateUser(String email, String password) throws SQLException {
        // Get user by email
        User user = userDAO.loginUser(email);

        if (user != null) {
            // Verify password
            boolean passwordMatch = PasswordUtil.verifyPassword(password, user.getPassword());
            if (passwordMatch) {
                // Don't send password back to client
                user.setPassword(null);
                return user;
            }
        }
        return null;
    }

    public User getUserById(int id) throws SQLException {
        User user = userDAO.getUserById(id);
        if (user != null) {
            user.setPassword(null); // Hide password
        }
        return user;
    }

    public int getUserCount() throws SQLException {
        return userDAO.getUserCount();
    }

    private List<String> validateUser(User user) {
        List<String> errors = new ArrayList<>();

        if (!ValidationUtil.isNotEmpty(user.getFullName())) {
            errors.add("Full name is required");
        }

        if (!ValidationUtil.isValidEmail(user.getEmail())) {
            errors.add("Invalid email format");
        }

        if (!ValidationUtil.isValidPhone(user.getPhone())) {
            errors.add("Phone number must be 10 digits");
        }

        if (!ValidationUtil.isValidPassword(user.getPassword())) {
            errors.add("Password must be at least 6 characters");
        }

        return errors;
    }
}
