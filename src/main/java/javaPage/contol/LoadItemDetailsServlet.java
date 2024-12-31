package javaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import dataBasedConnection.DataBConnection;

@WebServlet("/LoadItemDetailsServlet")
public class LoadItemDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String itemId = request.getParameter("itemId");

        if (itemId == null || itemId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing itemId parameter");
            return;
        }

        String query = "SELECT item_price, item_description FROM items WHERE item_id = ?";

        try (Connection conn = DataBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, Integer.parseInt(itemId));
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                double price = rs.getDouble("item_price");
                String description = rs.getString("item_description");

                // Create an object to hold the item details 
                ItemDetails itemDetails = new ItemDetails(price, description);

                // Convert item details to JSON and send response
                String json = new Gson().toJson(itemDetails);
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(json);
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Item not found");
            }

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Database error: " + e.getMessage());
        }
    }

    // Class to represent the item details
    class ItemDetails {
        double price;
        String description;

        ItemDetails(double price, String description) {
            this.price = price;
            this.description = description;
        }
    }
}
