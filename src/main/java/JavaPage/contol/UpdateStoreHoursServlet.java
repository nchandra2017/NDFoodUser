package JavaPage.contol;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import dataBasedConnection.DataBConnection;

@WebServlet("/UpdateStoreHoursServlet")
public class UpdateStoreHoursServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String morningOpeningTime = request.getParameter("morningOpeningTime");
        String morningClosingTime = request.getParameter("morningClosingTime");
        String eveningOpeningTime = request.getParameter("eveningOpeningTime");
        String eveningClosingTime = request.getParameter("eveningClosingTime");

        try (Connection conn = DataBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "UPDATE store_hours SET morning_opening_time = ?, morning_closing_time = ?, " +
                 "evening_opening_time = ?, evening_closing_time = ? WHERE id = 1")) {

            pstmt.setString(1, morningOpeningTime);
            pstmt.setString(2, morningClosingTime);
            pstmt.setString(3, eveningOpeningTime);
            pstmt.setString(4, eveningClosingTime);

            int updatedRows = pstmt.executeUpdate();
            if (updatedRows > 0) {
                response.sendRedirect("FetchStoreHoursServlet?updateSuccess=true");
            } else {
                response.sendRedirect("FetchStoreHoursServlet?updateSuccess=false");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("FetchStoreHoursServlet?updateSuccess=false");
        }
    }
}
