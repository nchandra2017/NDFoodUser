package JavaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dataBasedConnection.DataBConnection;

@WebServlet("/GetItemsByCategory")
public class GetItemsByCategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryId = request.getParameter("categoryId");  // Expecting categoryId as a parameter
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DataBConnection.getConnection();

            // SQL query to get items by category_id
            String query = "SELECT item_id, item_name, item_price, item_description FROM items WHERE category_id = ?";
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(categoryId));  // Use categoryId as an integer parameter
            rs = pstmt.executeQuery();

            // Build the JSON or HTML response with item details
            StringBuilder itemsOptions = new StringBuilder();
            while (rs.next()) {
                int itemId = rs.getInt("item_id");
                String itemName = rs.getString("item_name");
                double itemPrice = rs.getDouble("item_price");
                String itemDescription = rs.getString("item_description");

                // Use data attributes to store item details in the dropdown
                itemsOptions.append("<option value=\"" + itemId + "\" data-name=\"" + itemName + "\" data-price=\"" + itemPrice + "\" data-description=\"" + itemDescription + "\">" + itemName + "</option>");
            }

            // Send the response with the <option> elements
            response.setContentType("text/html");
            response.getWriter().write(itemsOptions.toString());

        } catch (Exception e) {
            e.printStackTrace();
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
}
