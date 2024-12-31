package javaPage.contol;

import dataBasedConnection.DataBConnection;
import dataBasedConnection.EmailUtility;
import dataBasedConnection.SMSUtility;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Base64;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String resetInput = request.getParameter("resetInput"); // Input from the form

        boolean isEmail = resetInput.contains("@");
        boolean isValid = (isEmail && resetInput.matches("^\\S+@\\S+\\.\\S+$")) ||
                (!isEmail && resetInput.matches("^\\+1 \\d{3} \\d{3} \\d{4}$")); // Validate input format

        if (isValid) {
            // Generate Reset Token
            String token = generateToken();
            long expiryTime = System.currentTimeMillis() + 30 * 60 * 1000; // 30 minutes from now

            try (Connection conn = DataBConnection.getConnection()) {
                String sql = isEmail
                        ? "UPDATE users SET reset_token = ?, reset_token_expiry = ? WHERE email = ?"
                        : "UPDATE users SET reset_token = ?, reset_token_expiry = ? WHERE phone = ?";

                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, token);
                    stmt.setTimestamp(2, new java.sql.Timestamp(expiryTime));
                    stmt.setString(3, resetInput);

                    int rowsUpdated = stmt.executeUpdate();
                    if (rowsUpdated > 0) {
                        // Generate Reset Link
                        String resetLink = request.getRequestURL().toString().replace("ForgotPasswordServlet", "/jsp/ResetPassword.jsp") + "?token=" + token;

                        if (isEmail) {
                            // Send the reset link via email
                            try {
                                EmailUtility.sendEmail(resetInput, "Reset Your Password", "Click the link below to reset your password:\n\n" + resetLink);
                                request.setAttribute("message", "A reset link has been sent to your email successfully. Please check your inbox or junk folder.");
                            } catch (Exception e) {
                                e.printStackTrace();
                                request.setAttribute("error", "Failed to send reset email. Please try again.");
                            }
                        } else {
                            // Send the reset link via SMS
                            try {
                                String smsMessage = "Reset your password using this link: " + resetLink;
                                SMSUtility.sendSMS(resetInput, smsMessage); // Send SMS
                                request.setAttribute("message", "A reset link has been sent to your phone.");
                            } catch (Exception e) {
                                e.printStackTrace();
                                request.setAttribute("error", "Failed to send reset SMS. Please try again.");
                            }
                        }
                    } else {
                        request.setAttribute("error", "No account found with the provided email/phone.");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Failed to generate reset token. Please try again. Error: " + e.getMessage());
            }
        } else {
            request.setAttribute("error", "Invalid email or phone number. Please try again.");
        }

        // Forward back to Forgot Password JSP
        request.getRequestDispatcher("/jsp/ForgotPassword.jsp").forward(request, response);
    }

    private String generateToken() {
        SecureRandom random = new SecureRandom();
        byte[] bytes = new byte[24];
        random.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
