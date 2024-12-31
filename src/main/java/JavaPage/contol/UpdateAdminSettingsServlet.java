package JavaPage.contol;
//Import the necessary libraries
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import dataBasedConnection.DataBConnection;

@WebServlet("/UpdateAdminSettingsServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
              maxFileSize = 1024 * 1024 * 10,      // 10MB
              maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UpdateAdminSettingsServlet extends HttpServlet {
 private static final long serialVersionUID = 1L;

 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     Connection conn = null;
     PreparedStatement pstmt = null;
     String message = "";

     String username = (String) request.getSession().getAttribute("adminUser");
     String currentName = request.getParameter("currentName");
     String currentPhone = request.getParameter("currentPhone");

     // Handle the profile picture upload
     Part profilePicPart = request.getPart("profilePic");
     String fileName = extractFileName(profilePicPart); // Extract file name

     // If no new file is uploaded, keep the existing picture
     if (fileName.isEmpty()) {
         fileName = getCurrentProfilePicture(username); // Retrieve the current profile picture from the DB
     } else {
         // Save the new profile picture
         String uploadPath = "C:/Users/nchan/OneDrive/Desktop/img for project/" + fileName;
         profilePicPart.write(uploadPath);  // Save new image
     }

     try {
         try {
			conn = DataBConnection.getConnection();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
         String updateQuery = "UPDATE admins SET profile_picture = ? WHERE username = ?";
         pstmt = conn.prepareStatement(updateQuery);
         pstmt.setString(1, "/images/" + fileName);  // Update profile picture path (keep old if not changed)
         pstmt.setString(2, username);

         int result = pstmt.executeUpdate();
         if (result > 0) {
             message = "Profile updated successfully!";
         } else {
             message = "Failed to update profile.";
         }

     } catch (SQLException e) {
         e.printStackTrace();
         message = "Error updating profile: " + e.getMessage();
     } finally {
         try {
             if (pstmt != null) pstmt.close();
             if (conn != null) conn.close();
         } catch (SQLException e) {
             e.printStackTrace();
         }
     }

     // Pass the updated data back to the JSP
     request.setAttribute("name", currentName);
     request.setAttribute("phone", currentPhone);
     request.setAttribute("profilePicture", "/images/" + fileName);
     request.setAttribute("message", message);
     request.getRequestDispatcher("/jsp/admin_control/Admin_Panel.jsp").forward(request, response);
 }

 // Helper method to retrieve the current profile picture from the database
 private String getCurrentProfilePicture(String username) {
     // Implementation of getting the current profile picture from the DB
     // ...
     return "/images/default.png"; // Placeholder for example
 }

 // Helper method to extract the file name from the part header
 private String extractFileName(Part part) {
     String contentDisp = part.getHeader("content-disposition");
     String[] items = contentDisp.split(";");
     for (String s : items) {
         if (s.trim().startsWith("filename")) {
             return s.substring(s.indexOf("=") + 2, s.length() - 1);
         }
     }
     return ""; // Return empty string if no file is uploaded
 }
}
