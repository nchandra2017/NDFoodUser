package javaPage.contol;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import dataBasedConnection.DataBConnection;
import dataBasedConnection.EmailUtility;

@WebServlet("/OrderConfirmationServlet")
public class OrderConfirmationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(OrderConfirmationServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        ObjectMapper mapper = new ObjectMapper();

        try {
            logger.info("Processing order confirmation...");

            // Parse request payload
            BufferedReader reader = request.getReader();
            Map<String, Object> payload = mapper.readValue(reader, new TypeReference<Map<String, Object>>() {});
            logger.info("Received payload: " + payload);

            String paymentIntentId = (String) payload.get("paymentIntentId");
            if (paymentIntentId == null) {
                handleErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Missing paymentIntentId.");
                return;
            }

            // Retrieve required session attributes
            @SuppressWarnings("unchecked")
            List<Map<String, Object>> cartItems = (List<Map<String, Object>>) session.getAttribute("orderCartItems");
            BigDecimal totalAmount = (BigDecimal) session.getAttribute("totalAmount");
            String uniqueOrderId = (String) session.getAttribute("uniqueOrderId");
            String billingName = (String) session.getAttribute("billing_name");
            String addressLine1 = (String) session.getAttribute("billing_address_line1");
            String addressLine2 = (String) session.getAttribute("billing_address_line2");
            String city = (String) session.getAttribute("billing_address_city");
            String state = (String) session.getAttribute("billing_address_state");
            String zip = (String) session.getAttribute("billing_address_zip");
            String orderMethod = (String) session.getAttribute("order_method");
            String rawOrderTime = (String) session.getAttribute("order_time");
            String orderAddress = (String) session.getAttribute("orderAddress");
            String deliveryDate = (String) session.getAttribute("deliveryorpickup_date");
            String userEmail = (String) session.getAttribute("userEmail");

            if (cartItems == null || totalAmount == null || uniqueOrderId == null || billingName == null || rawOrderTime == null || deliveryDate == null) {
                handleErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Order details are incomplete.");
                return;
            }

            // Convert date to database format
            try {
                deliveryDate = convertToDatabaseDateFormat(deliveryDate);
                logger.info("Converted delivery date: " + deliveryDate);
            } catch (ParseException e) {
                logger.log(Level.SEVERE, "Error converting delivery date to database format", e);
                handleErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid date format.");
                return;
            }

            // Convert order time to 24-hour format
            String orderTime;
            try {
                orderTime = convertTo24HourFormat(rawOrderTime);
            } catch (ParseException e) {
                logger.log(Level.SEVERE, "Error converting order time to 24-hour format", e);
                handleErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid time format.");
                return;
            }

            // Insert order into the database
            try (Connection conn = DataBConnection.getConnection()) {
                conn.setAutoCommit(false);

                String insertOrderSQL = "INSERT INTO orders (user_id, total_amount, billing_name, address_line1, address_line2, city, state, zip, order_date, order_time, order_method, order_address, deliveryorpickup_date, unique_order_id) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?)";
                try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                    psOrder.setInt(1, (Integer) session.getAttribute("userId"));
                    psOrder.setBigDecimal(2, totalAmount);
                    psOrder.setString(3, billingName);
                    psOrder.setString(4, addressLine1);
                    psOrder.setString(5, addressLine2);
                    psOrder.setString(6, city);
                    psOrder.setString(7, state);
                    psOrder.setString(8, zip);
                    psOrder.setString(9, orderTime);
                    psOrder.setString(10, orderMethod);
                    psOrder.setString(11, orderAddress);
                    psOrder.setString(12, deliveryDate);
                    psOrder.setString(13, uniqueOrderId);

                    psOrder.executeUpdate();
                }

                conn.commit();
                logger.info("Order inserted successfully with uniqueOrderId: " + uniqueOrderId);
            }

            // Send confirmation email if userEmail is present
            if (userEmail != null && !userEmail.isEmpty()) {
                logger.info("Sending order confirmation email to: " + userEmail);
                EmailUtility.sendOrderConfirmationEmail(userEmail, billingName, uniqueOrderId, totalAmount.doubleValue(), cartItems);
            } else {
                logger.warning("No userEmail found in session. Skipping email sending.");
            }

            // Respond with success
            sendJsonResponse(response, Map.of("success", true));
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during order confirmation", e);
            handleErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, mapDatabaseErrorToMessage(e.getMessage()));
        }
    }

    private String convertToDatabaseDateFormat(String dateInMMDDYYYY) throws ParseException {
        SimpleDateFormat inputFormat = new SimpleDateFormat("MM-dd-yyyy");
        SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd");
        return outputFormat.format(inputFormat.parse(dateInMMDDYYYY));
    }

    private String convertTo24HourFormat(String timeIn12HourFormat) throws ParseException {
        SimpleDateFormat inputFormat = new SimpleDateFormat("hh:mm a");
        SimpleDateFormat outputFormat = new SimpleDateFormat("HH:mm:ss");
        return outputFormat.format(inputFormat.parse(timeIn12HourFormat));
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(new ObjectMapper().writeValueAsString(data));
    }

    private void handleErrorResponse(HttpServletResponse response, int statusCode, String errorMessage) throws IOException {
        logger.log(Level.SEVERE, "Error response sent to client: " + errorMessage);
        response.setContentType("application/json");
        response.setStatus(statusCode);
        response.getWriter().write(new ObjectMapper().writeValueAsString(Map.of("error", errorMessage)));
    }

    private String mapDatabaseErrorToMessage(String errorMessage) {
        if (errorMessage.contains("constraint_violation")) {
            return "The order details failed to meet the database constraints. Please check your input.";
        } else if (errorMessage.contains("data_truncation")) {
            return "Some input data was too long or invalid. Please verify your details.";
        } else {
            return "An unexpected error occurred while processing your order. Please try again.";
        }
    }
}
