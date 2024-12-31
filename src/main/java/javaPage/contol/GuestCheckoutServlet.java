package javaPage.contol;

import dataBasedConnection.DataBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/GuestCheckoutServlet")
public class GuestCheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger LOGGER = Logger.getLogger(GuestCheckoutServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String firstName = request.getParameter("guestFirstName");
        String lastName = request.getParameter("guestLastName");
        String email = request.getParameter("guestEmail");
        String phone = request.getParameter("guestPhone");
        String password = request.getParameter("password");

        // Validate that names only contain letters and spaces
        if (!firstName.matches("[a-zA-Z\\s]+") || !lastName.matches("[a-zA-Z\\s]+")) {
            response.getWriter().println("First Name and Last Name should only contain letters.");
            return;
        }

        // Additional validation logic for other fields...

        try (Connection conn = DataBConnection.getConnection()) {
            String sql = "INSERT INTO users (first_name, last_name, email, phone, password) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, email);
                ps.setString(4, phone);
                ps.setString(5, password != null && !password.isEmpty() ? hashPassword(password) : null);

                int result = ps.executeUpdate();
                if (result > 0) {
                    response.sendRedirect("paymentPage.jsp");
                } else {
                    response.getWriter().println("Failed to save user details.");
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Database connection error", e);
            response.getWriter().println("Error: " + e.getMessage());
        }
    }


    private String hashPassword(String password) {
        try {
            java.security.MessageDigest md = java.security.MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (java.security.NoSuchAlgorithmException e) {
            LOGGER.log(Level.SEVERE, "Password hashing error", e);
            throw new RuntimeException(e);
        }
    }
}
