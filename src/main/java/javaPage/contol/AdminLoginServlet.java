package javaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import dataBasedConnection.DataBConnection;
import java.security.MessageDigest;

@WebServlet("/ALoginServlet")  // This should match your form action in the login JSP
public class AdminLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();  // Creating a session if one does not exist
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DataBConnection.getConnection();

            // Query to check if admin exists in the database
            String query = "SELECT * FROM admins WHERE username = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                String storedHashedPassword = rs.getString("password");

                // Compare entered password after hashing with the stored hashed password
                if (storedHashedPassword.equals(hashPassword(password))) {
                    // **SET SESSION VARIABLE** if login is successful
                    session.setAttribute("adminUser", username);  // Storing the admin username in the session
                    response.sendRedirect(request.getContextPath() + "/jsp/admin_control/Admin_Panel.jsp");
                } else {
                    // Password does not match, show error
                    request.setAttribute("errorMessage", "Invalid username or password.");
                    request.getRequestDispatcher("/jsp/admin_control/adminlogin.jsp").forward(request, response);
                }
            } else {
                // Username not found, show error
                request.setAttribute("errorMessage", "Invalid username or password.");
                request.getRequestDispatcher("/jsp/admin_control/adminlogin.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "An error occurred. Please try again.");
            request.getRequestDispatcher("/jsp/admin_control/adminlogin.jsp").forward(request, response);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    // Hash the password using SHA-256
    private String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            hexString.append(String.format("%02x", b));
        }
        return hexString.toString();
    }
}
