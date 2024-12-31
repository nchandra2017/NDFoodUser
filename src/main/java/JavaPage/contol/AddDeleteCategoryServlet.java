package JavaPage.contol;

import java.io.File;
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

@WebServlet("/AddDeleteCategoryServlet")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class AddDeleteCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        Connection conn = null;
        PreparedStatement pstmt = null;
        String message = "";

        try {
            conn = DataBConnection.getConnection(); // Get DB connection

            // Add New Category
            if ("addCategory".equals(action)) {
                String categoryName = request.getParameter("new_category_name");
                Part categoryImagePart = request.getPart("category_image");

                // File upload logic (save the image)
                String fileName = extractFileName(categoryImagePart);
                String uploadDir = getServletContext().getRealPath("/") + "images/menu-category/"; // Specify the server-side path
                File uploadDirFile = new File(uploadDir);
                
                if (!uploadDirFile.exists()) {
                    uploadDirFile.mkdirs(); // Create directories if they don't exist
                }
                
                String filePath = uploadDir + fileName; // Full path where the file will be saved
                categoryImagePart.write(filePath); // Save the uploaded image to the server directory

                // Store the relative path in the database
                String dbFilePath = "/images/menu-category/" + fileName;

                // Insert the category into the database
                String insertQuery = "INSERT INTO categories (category_name, category_image) VALUES (?, ?)";
                pstmt = conn.prepareStatement(insertQuery);
                pstmt.setString(1, categoryName);
                pstmt.setString(2, dbFilePath); // Save the relative path in the DB

                int result = pstmt.executeUpdate();
                message = result > 0 ? "Category added successfully!" : "Failed to add category!";
            }

            // Delete Existing Category
            else if ("deleteCategory".equals(action)) {
                String categoryToDelete = request.getParameter("category_to_delete");

                // Delete the category from the database
                String deleteQuery = "DELETE FROM categories WHERE category_name = ?";
                pstmt = conn.prepareStatement(deleteQuery);
                pstmt.setString(1, categoryToDelete);

                int result = pstmt.executeUpdate();
                message = result > 0 ? "Category deleted successfully!" : "Failed to delete category!";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            message = "Database error: " + e.getMessage();
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Set a message and redirect back to the JSP page
        request.setAttribute("message", message);
        request.getRequestDispatcher("/jsp/admin_control/updateDeleteCategory.jsp").forward(request, response); 
    }

    // Method to extract file name from the part header
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
