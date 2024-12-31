package javaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import dataBasedConnection.DataBConnection;

@WebServlet("/LoadCategoriesServletItem")
public class LoadCategoriesServletItem extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<Category> categories = new ArrayList<>();
        try (Connection conn = DataBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("SELECT category_id, category_name FROM categories")) {

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                categories.add(new Category(rs.getInt("category_id"), rs.getString("category_name")));
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(categories));
    }

    class Category {
        private int category_id; 
        private String category_name;

        public Category(int category_id, String category_name) {
            this.category_id = category_id;
            this.category_name = category_name;
        }

        public int getCategory_id() {
            return category_id;
        }

        public String getCategory_name() {
            return category_name;
        }
    }
}
