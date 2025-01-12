package javaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dataBasedConnection.DataBConnection;

@WebServlet("/OrderPageServlet")
public class OrderPageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Connection conn = null;

        try {
            String page = request.getParameter("orderPage");
            Integer userId = (Integer) session.getAttribute("userId");

            if (userId == null) {
                System.out.println("Debug: userId is null. Redirecting to SignIn.jsp.");
                response.sendRedirect(request.getContextPath() + "/jsp/SignIn.jsp");
                return;
            }

            conn = DataBConnection.getConnection();

            if ("user_orders".equals(page)) {
                List<Map<String, Object>> userOrdersList = fetchUserOrders(conn, userId);
                request.setAttribute("userOrdersList", userOrdersList);
                request.getRequestDispatcher("/jsp/user_order_page.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid page request.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (Exception ignored) {
                }
            }
        }
    }

    private List<Map<String, Object>> fetchUserOrders(Connection conn, Integer userId) throws Exception {
        String query = "SELECT o.unique_order_id, o.total_amount, o.order_date, o.order_time, o.order_address, "
                     + "oi.item_name, oi.quantity "
                     + "FROM orders o "
                     + "JOIN order_items oi ON o.id = oi.order_id "
                     + "WHERE o.user_id = ? "
                     + "ORDER BY o.order_date DESC";

        try (PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> orders = new ArrayList<>();
                while (rs.next()) {
                    Map<String, Object> order = new HashMap<>();
                    order.put("uniqueOrderId", rs.getString("unique_order_id"));
                    order.put("totalAmount", rs.getDouble("total_amount"));
                    order.put("orderDate", rs.getString("order_date"));
                    order.put("orderTime", rs.getString("order_time"));
                    order.put("orderAddress", rs.getString("order_address"));
                    order.put("itemName", rs.getString("item_name"));
                    order.put("quantity", rs.getInt("quantity"));
                    orders.add(order);
                }
                return orders;
            }
        }
    }
}
