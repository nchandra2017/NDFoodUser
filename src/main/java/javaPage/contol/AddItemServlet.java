package javaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import dataBasedConnection.DataBConnection;

@WebServlet("/AddItemServlet")
public class AddItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Max file size limit
    private static final int MEMORY_THRESHOLD = 1024 * 1024 * 3; // 3MB
    private static final int MAX_FILE_SIZE = 1024 * 1024 * 40;    // 40MB
    private static final int MAX_REQUEST_SIZE = 1024 * 1024 * 50; // 50MB

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if it's a multipart/form-data request
        if (!ServletFileUpload.isMultipartContent(request)) {
            response.getWriter().write("Error: Form must have enctype=multipart/form-data.");
            return;
        }

        // Configure upload settings
        DiskFileItemFactory factory = new DiskFileItemFactory();
        // Sets memory threshold - beyond which files are stored in disk
        factory.setSizeThreshold(MEMORY_THRESHOLD);
        // Set file size limit
        ServletFileUpload upload = new ServletFileUpload(factory);
        // Set overall request size constraint
        upload.setSizeMax(MAX_REQUEST_SIZE);

        String categoryId = null;
        String itemName = null;
        String itemPrice = null;
        String itemDescription = null;

        try {
            // Parse the request
            List<FileItem> formItems = upload.parseRequest(request);

            for (FileItem item : formItems) {
                // Process regular form fields
                if (item.isFormField()) {
                    String fieldName = item.getFieldName();
                    String fieldValue = item.getString();

                    // Debugging: Print the received field values
                    System.out.println("Field Name: " + fieldName + ", Field Value: " + fieldValue);

                    switch (fieldName) {
                        case "category_for_item":
                            categoryId = fieldValue;
                            break;
                        case "new_item_name":
                            itemName = fieldValue;
                            break;
                        case "new_item_price":
                            itemPrice = fieldValue;
                            break;
                        case "new_item_description":
                            itemDescription = fieldValue;
                            break;
                    }
                }
                // Handle file uploads (if needed)
                else {
                    // If you are handling files, you can get the file's data here.
                    // String fileName = new File(item.getName()).getName();
                    // File storeFile = new File("upload directory path" + File.separator + fileName);
                    // item.write(storeFile); // Writes the file to the directory.
                }
            }

            // Validation
            if (categoryId == null || itemName == null || itemPrice == null || itemDescription == null ||
                categoryId.isEmpty() || itemName.isEmpty() || itemPrice.isEmpty() || itemDescription.isEmpty()) {
                response.getWriter().write("Error: Missing input values. Please fill in all fields.");
                return;
            }

            // Insert the data into the database
            String insertItemQuery = "INSERT INTO items (category_id, item_name, item_price, item_description) VALUES (?, ?, ?, ?)";
            try (Connection conn = DataBConnection.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(insertItemQuery)) {

                pstmt.setInt(1, Integer.parseInt(categoryId));
                pstmt.setString(2, itemName);
                pstmt.setDouble(3, Double.parseDouble(itemPrice));
                pstmt.setString(4, itemDescription);

                int result = pstmt.executeUpdate();
                if (result > 0) {
                    response.getWriter().write("Item added successfully!");
                } else {
                    response.getWriter().write("Failed to add item.");
                }
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                response.getWriter().write("Database error occurred: " + e.getMessage());
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error: " + e.getMessage());
        }
    }
}
