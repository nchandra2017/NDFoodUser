package javaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dataBasedConnection.DataBConnection;

@WebServlet("/DeleteItemServlet")
public class DeleteItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemId = request.getParameter("item_to_delete");

        // Debugging: Log the received item ID
        System.out.println("Received Item ID: " + itemId);

        // Validation
        if (itemId == null || itemId.isEmpty()) {
            response.getWriter().write("Error: Missing item ID. Please select an item to delete.");
            return;
        }

        // Proceed with database deletion
        String deleteItemQuery = "DELETE FROM items WHERE item_id = ?";
        
        try (Connection conn = DataBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(deleteItemQuery)) {

            pstmt.setInt(1, Integer.parseInt(itemId));  // Convert item ID to integer

            int result = pstmt.executeUpdate();
            if (result > 0) {
                response.getWriter().write("Item deleted successfully!");
            } else {
                response.getWriter().write("Failed to delete item. Item might not exist.");
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().write("Database error occurred: " + e.getMessage());
        }
    }
}
