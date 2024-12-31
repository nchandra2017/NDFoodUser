package JavaPage.contol;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import dataBasedConnection.DataBConnection;

@WebServlet("/FetchStoreHoursServlet")
public class FetchStoreHoursServlet extends HttpServlet {

   
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String updateSuccess = request.getParameter("updateSuccess");
        
        if (updateSuccess != null) {
            // Forward to JSP with a success message if redirected from UpdateStoreHoursServlet
            request.setAttribute("updateSuccess", "true".equals(updateSuccess));
            request.getRequestDispatcher("/jsp/admin_control/admin-store-control.jsp").forward(request, response);
            return;
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (Connection conn = DataBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM store_hours WHERE id = 1")) {
            ResultSet rs = pstmt.executeQuery();

            JSONObject json = new JSONObject();
            if (rs.next()) {
                json.put("morningOpeningTime", rs.getString("morning_opening_time"));
                json.put("morningClosingTime", rs.getString("morning_closing_time"));
                json.put("eveningOpeningTime", rs.getString("evening_opening_time"));
                json.put("eveningClosingTime", rs.getString("evening_closing_time"));
            }

            try (PrintWriter out = response.getWriter()) {
                out.print(json.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                JSONObject errorJson = new JSONObject();
                errorJson.put("error", "Unable to retrieve store hours data.");
                out.print(errorJson.toString());
            }
        }
    }
}
