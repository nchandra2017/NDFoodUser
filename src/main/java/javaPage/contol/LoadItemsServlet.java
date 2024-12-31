package javaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import dataBasedConnection.DataBConnection;

@WebServlet("/LoadItemsServlet")
public class LoadItemsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String categoryId = request.getParameter("categoryId");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Database query to get items
        String query = "SELECT item_id, item_name FROM items WHERE category_id = ?";
        List<Item> items = new ArrayList<>();

        try (Connection conn = DataBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, Integer.parseInt(categoryId));
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                Item item = new Item(rs.getInt("item_id"), rs.getString("item_name"));
                items.add(item);
            }

            String jsonResponse = new Gson().toJson(items);
            response.getWriter().write(jsonResponse);

        } catch (SQLException | NumberFormatException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Error fetching items");
        }
    }

    // Helper class for items
    class Item {
        private int item_id;
        private String item_name;

        public Item(int item_id, String item_name) {
            this.item_id = item_id;
            this.item_name = item_name;
        }

        public int getItem_id() {
            return item_id;
        }

        public String getItem_name() {
            return item_name;
        }
    }
}
