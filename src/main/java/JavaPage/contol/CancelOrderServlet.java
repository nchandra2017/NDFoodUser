package JavaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.*;
import javax.servlet.http.*;
import dataBasedConnection.DataBConnection;

public class CancelOrderServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int orderId = Integer.parseInt(request.getParameter("orderId"));

        try (Connection conn = DataBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement("UPDATE orders SET order_status = 'Cancelled', is_cancelable = FALSE WHERE order_id = ?")) {
            
            stmt.setInt(1, orderId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("UserOrdersServlet");
    }
}
