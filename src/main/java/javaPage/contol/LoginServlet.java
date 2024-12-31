package javaPage.contol;

import dataBasedConnection.DataBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        try {
            // Extract parameters from the form
            String emailOrPhone = request.getParameter("SignInInput");
            String password = request.getParameter("password");
            String hashedPassword = hashPassword(password);

            // Validate if input is phone or email
            boolean isPhone = emailOrPhone.matches("^\\+1 \\d{3} \\d{3} \\d{4}$");
            String sql = isPhone
                    ? "SELECT id, firstname FROM users WHERE phone = ? AND password = ?"
                    : "SELECT id, firstname FROM users WHERE email = ? AND password = ?";

            try (Connection conn = DataBConnection.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, emailOrPhone);
                stmt.setString(2, hashedPassword);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) { 
                    // Login successful
                    int userId = rs.getInt("id");
                    String firstName = rs.getString("firstname");

                    HttpSession session = request.getSession();
                    session.setAttribute("userId", userId); // Save user ID in session
                    session.setAttribute("userFirstName", firstName); // Save user first name in session

                    System.out.println("User logged in: ID = " + userId + ", First Name = " + firstName);

                    // Retrieve redirect target from session
                    String redirectURL = (String) session.getAttribute("redirectAfterLogin");
                    if (redirectURL != null) {
                        session.removeAttribute("redirectAfterLogin"); // Clear the attribute
                        response.sendRedirect(redirectURL); // Redirect to the originating page
                    } else {
                        response.sendRedirect(request.getContextPath() + "/jsp/UserAccount.jsp"); // Redirect to User Account
                    }
                } else {
                    // Login failed
                    request.setAttribute("errorMessage", "Invalid credentials. Please try again.");
                    request.getRequestDispatcher("/jsp/SignIn.jsp").forward(request, response);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An unexpected error occurred. Please try again.");
            request.getRequestDispatcher("/jsp/SignIn.jsp").forward(request, response);
        }
    }

    private String hashPassword(String password) {
        try {
            String salt = "ACTUAL_SALT_USED_DURING_REGISTRATION";
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest((salt + password).getBytes("UTF-8"));
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                hexString.append(String.format("%02x", b));
            }
            return hexString.toString();
        } catch (Exception e) {
            throw new RuntimeException("Password hashing failed.", e);
        }
    }
}
