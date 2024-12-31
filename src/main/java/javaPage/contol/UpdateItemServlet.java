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


@WebServlet("/UpdateItemServlet")
public class UpdateItemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemId = request.getParameter("itemId");
        String itemPrice = request.getParameter("itemPrice");
        String itemDescription = request.getParameter("itemDescription");

        // Log received parameters to verify
        System.out.println("Received Item ID: " + itemId);
        System.out.println("Received Price: " + itemPrice);
        System.out.println("Received Description: " + itemDescription);

        if (itemId == null || itemPrice == null || itemDescription == null) {
            response.getWriter().write("Invalid input data");
            return;
        }

        String updateQuery = "UPDATE items SET item_price = ?, item_description = ? WHERE item_id = ?";

        try (Connection conn = DataBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(updateQuery)) {

            pstmt.setDouble(1, Double.parseDouble(itemPrice));
            pstmt.setString(2, itemDescription);
            pstmt.setInt(3, Integer.parseInt(itemId));

            int result = pstmt.executeUpdate();

            if (result > 0) {
                response.getWriter().write("Item updated successfully!");
            } else {
                response.getWriter().write("Failed to update item.");
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().write("Database error occurred: " + e.getMessage());
        }
    }
}
