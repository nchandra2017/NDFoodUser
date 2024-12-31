package JavaPage.contol;

import dataBasedConnection.DataBConnection;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String token = request.getParameter("token");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate inputs
        if (token == null || token.isEmpty()) {
            request.setAttribute("error", "Invalid token. Please try again.");
            request.getRequestDispatcher("/jsp/ResetPassword.jsp").forward(request, response);
            return;
        }

        if (newPassword == null || newPassword.isEmpty() || confirmPassword == null || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Password fields cannot be empty.");
            request.getRequestDispatcher("/jsp/ResetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match. Please try again.");
            request.getRequestDispatcher("/jsp/ResetPassword.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DataBConnection.getConnection()) {
            // Validate the token
            String sql = "SELECT email FROM users WHERE reset_token = ? AND reset_token_expiry > ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, token);
                stmt.setTimestamp(2, new java.sql.Timestamp(System.currentTimeMillis()));

                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
                    // Valid token
                    String email = rs.getString("email");

                    // Hash the new password
                    String hashedPassword = hashPassword(newPassword);

                    // Update the password and clear the token
                    String updateSql = "UPDATE users SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE email = ?";
                    try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                        updateStmt.setString(1, hashedPassword);
                        updateStmt.setString(2, email);

                        int rowsUpdated = updateStmt.executeUpdate();
                        if (rowsUpdated > 0) {
                            request.setAttribute("message", "Your password has been reset successfully. You can now log in.");
                            request.getRequestDispatcher("/jsp/ResetPassword.jsp").forward(request, response); // Redirect to login page
                            return;
                        } else {
                            request.setAttribute("error", "Failed to reset password. Please try again.");
                        }
                    }
                } else {
                    request.setAttribute("error", "Invalid or expired token. Please try resetting your password again.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred while resetting your password. Please try again.");
        }

        // Forward back to Reset Password JSP with error
        request.getRequestDispatcher("/jsp/ResetPassword.jsp").forward(request, response);
    }

    /**
     * Hash the password using SHA-256 with the same salt used in registration.
     *
     * @param password The plain text password.
     * @return The hashed password.
     */
    private String hashPassword(String password) {
        final String SALT = "ACTUAL_SALT_USED_DURING_REGISTRATION"; // Replace with your salt
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest((SALT + password).getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException | IOException e) {
            throw new RuntimeException("Error hashing password: " + e.getMessage(), e);
        }
    }
}
