package javaPage.contol;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

            // Validate paymentIntentId
            String paymentIntentId = (String) payload.get("paymentIntentId");
            if (paymentIntentId == null) {
                handleErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Missing paymentIntentId.");
                return;
            }

            // Retrieve session attributes
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

            // Validate mandatory details
            if (cartItems == null || totalAmount == null || uniqueOrderId == null || billingName == null || rawOrderTime == null || deliveryDate == null) {
                handleErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Order details are incomplete.");
                return;
            }

            // Convert date and time to proper formats
            try {
                deliveryDate = convertToDatabaseDateFormat(deliveryDate);
                rawOrderTime = convertTo24HourFormat(rawOrderTime);
            } catch (ParseException e) {
                logger.log(Level.SEVERE, "Error converting date/time format", e);
                handleErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid date or time format.");
                return;
            }

            // Insert order and order items into the database
            try (Connection conn = DataBConnection.getConnection()) {
                conn.setAutoCommit(false);

                // Insert order details
                int orderId = insertOrder(conn, session, totalAmount, billingName, addressLine1, addressLine2, city, state, zip, rawOrderTime, orderMethod, orderAddress, deliveryDate, uniqueOrderId);

                // Insert order items
                insertOrderItems(conn, cartItems, orderId);

                conn.commit();
                logger.info("Order and items inserted successfully with uniqueOrderId: " + uniqueOrderId);
            }

            // **Send confirmation email if userEmail is present**
            if (userEmail != null && !userEmail.isEmpty()) {
                logger.info("Sending order confirmation email to: " + userEmail);
                EmailUtility.sendOrderConfirmationEmail(userEmail, billingName, uniqueOrderId, totalAmount.doubleValue(), cartItems);
            } else {
                logger.warning("No userEmail found in session. Skipping email sending.");
            }

            // **Respond with success**
            sendJsonResponse(response, Map.of("success", true));
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during order confirmation", e);
            handleErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, mapDatabaseErrorToMessage(e.getMessage()));
        }
    }

    private int insertOrder(Connection conn, HttpSession session, BigDecimal totalAmount, String billingName,
                            String addressLine1, String addressLine2, String city, String state, String zip,
                            String orderTime, String orderMethod, String orderAddress, String deliveryDate,
                            String uniqueOrderId) throws Exception {
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

            try (ResultSet rs = psOrder.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                } else {
                    throw new Exception("Failed to retrieve generated order ID.");
                }
            }
        }
    }

    private void insertOrderItems(Connection conn, List<Map<String, Object>> cartItems, int orderId) throws Exception {
        String fetchItemIdSQL = "SELECT item_id FROM items WHERE item_name = ?";
        String insertItemsSQL = "INSERT INTO order_items (order_id, item_id, quantity, price, item_name) VALUES (?, ?, ?, ?, ?)";

        try (PreparedStatement psFetchItemId = conn.prepareStatement(fetchItemIdSQL);
             PreparedStatement psInsertItems = conn.prepareStatement(insertItemsSQL)) {

            logger.info("Cart items received for insertion: " + cartItems);

            for (Map<String, Object> item : cartItems) {
                // Extract required fields
                String itemName = (String) item.get("itemName");
                Integer quantity = (Integer) item.get("quantity");
                BigDecimal price = new BigDecimal(item.get("price").toString());

                // Validate fields
                if (itemName == null || quantity == null || price == null) {
                    logger.severe("Invalid cart item data: " + item);
                    throw new Exception("Cart item contains null or invalid values: " + item);
                }

                // Fetch itemId from the database
                psFetchItemId.setString(1, itemName);
                try (ResultSet rs = psFetchItemId.executeQuery()) {
                    if (!rs.next()) {
                        throw new Exception("Item not found in database: " + itemName);
                    }
                    int itemId = rs.getInt("item_id");

                    // Bind values to the SQL statement
                    psInsertItems.setInt(1, orderId);
                    psInsertItems.setInt(2, itemId);
                    psInsertItems.setInt(3, quantity);
                    psInsertItems.setBigDecimal(4, price);
                    psInsertItems.setString(5, itemName);

                    psInsertItems.addBatch();
                }
            }

            // Execute batch insertion
            psInsertItems.executeBatch();
            logger.info("Order items successfully inserted for orderId: " + orderId);
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

    private String mapDatabaseErrorToMessage(String errorMessage) {
        if (errorMessage.contains("constraint_violation")) {
            return "The order details failed to meet the database constraints. Please check your input.";
        } else if (errorMessage.contains("data_truncation")) {
            return "Some input data was too long or invalid. Please verify your details.";
        } else {
            return "An unexpected error occurred while processing your order. Please try again.";
        }
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
}
