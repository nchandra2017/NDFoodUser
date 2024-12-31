package javaPage.contol;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class TrackOrderServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String trackingNumber = request.getParameter("trackingNumber");
        String trackingURL = "https://www.shippingcompany.com/track?number=" + trackingNumber;
        response.sendRedirect(trackingURL);
    }
}
