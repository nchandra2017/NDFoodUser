package JavaPage.contol;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.core.type.TypeReference;
import com.stripe.exception.StripeException;

import dataBasedConnection.DataBConnection;
import dataBasedConnection.EmailUtility;
import utils.StripeClientUtil;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(PaymentServlet.class.getName());
    private final StripeClientUtil stripeClientUtil = new StripeClientUtil();

    private String generateUniqueOrderId() {
        int randomNum = 2173; // Static prefix number (e.g., 2173)
        String randomFormat = String.format("%04d-%04d", (int)(Math.random() * 10000), (int)(Math.random() * 10000));
        return randomNum + "" + randomFormat; // Example: 2173-1234-5678
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        ObjectMapper mapper = new ObjectMapper();
        Connection conn = null;

        try {
            // Retrieve userId from session
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                logger.severe("User ID is missing from the session.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"User not logged in.\"}");
                return;
            }

            logger.info("User ID: " + userId);

            // Parse JSON request payload
            BufferedReader reader = request.getReader();
            Map<String, Object> payload = mapper.readValue(reader, new TypeReference<Map<String, Object>>() {});
            logger.info("Received payload: " + payload);

            // Extract payment and billing details
            String amountStr = (String) payload.get("amount");
            String billingName = (String) payload.get("billing_name");
            String addressLine1 = (String) payload.get("billing_address_line1");
            String addressLine2 = (String) payload.get("billing_address_line2");
            String city = (String) payload.get("billing_address_city");
            String state = (String) payload.get("billing_address_state");
            String zip = (String) payload.get("billing_address_zip");
            String orderMethod = (String) payload.get("order_method");
            String rawDeliveryDate = (String) payload.get("deliveryorpickup_date");
            String rawOrderTime = (String) payload.get("order_time");
            String orderAddress = (String) payload.get("order_address");

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> cartItemsData = (List<Map<String, Object>>) payload.get("cartItems");

            if (amountStr == null || billingName == null || cartItemsData == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Missing required fields.\"}");
                return;
            }

            if (cartItemsData.isEmpty()) {
                logger.warning("Cart is empty for order from user ID: " + userId);
            }

            // Convert date format from MM-DD-YYYY to YYYY-MM-DD for deliveryorpickup_date
            String deliveryDate;
            try {
                SimpleDateFormat inputDateFormat = new SimpleDateFormat("MM-dd-yyyy");
                SimpleDateFormat outputDateFormat = new SimpleDateFormat("yyyy-MM-dd");
                deliveryDate = outputDateFormat.format(inputDateFormat.parse(rawDeliveryDate));
            } catch (ParseException e) {
                logger.severe("Error parsing delivery date: " + e.getMessage());
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid delivery date format provided.\"}");
                return;
            }

            // Convert time format from 12-hour to 24-hour
            String orderTime;
            try {
                SimpleDateFormat inputTimeFormat = new SimpleDateFormat("hh:mm a");
                SimpleDateFormat outputTimeFormat = new SimpleDateFormat("HH:mm:ss");
                orderTime = outputTimeFormat.format(inputTimeFormat.parse(rawOrderTime));
            } catch (ParseException e) {
                logger.severe("Error parsing time: " + e.getMessage());
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid time format provided.\"}");
                return;
            }

            // Set current date and time as order_date
            String orderDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

            // Retrieve user details
            String userFirstName = null, userLastName = null, userEmail = null;

            conn = DataBConnection.getConnection();
            String userQuery = "SELECT firstname, lastname, email FROM users WHERE id = ?";
            try (PreparedStatement psUser = conn.prepareStatement(userQuery)) {
                psUser.setInt(1, userId);
                try (ResultSet rs = psUser.executeQuery()) {
                    if (rs.next()) {
                        userFirstName = rs.getString("firstname");
                        userLastName = rs.getString("lastname");
                        userEmail = rs.getString("email");

                        session.setAttribute("userFirstName", userFirstName);
                        session.setAttribute("userLastName", userLastName);
                    } else {
                        throw new Exception("User details not found for ID: " + userId);
                    }
                }
            }

            // Convert amount to BigDecimal for precision
            BigDecimal totalAmount = new BigDecimal(amountStr);
            long amountInCents = totalAmount.multiply(new BigDecimal("100")).longValueExact();

            // Create Stripe PaymentIntent
            String clientSecret = stripeClientUtil.createPaymentIntent(amountInCents, "usd", null);
            logger.info("PaymentIntent created successfully.");

            // Insert order into 'orders' table
            conn.setAutoCommit(false);
            String uniqueOrderId = generateUniqueOrderId();
            int orderId = 0;
            String insertOrderSQL = "INSERT INTO orders (user_id, total_amount, billing_name, address_line1, address_line2, city, state, zip, order_date, order_time, order_method, order_address, deliveryorpickup_date, unique_order_id) "
                                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, userId);
                psOrder.setBigDecimal(2, totalAmount);
                psOrder.setString(3, billingName);
                psOrder.setString(4, addressLine1);
                psOrder.setString(5, addressLine2); // Can be null
                psOrder.setString(6, city);
                psOrder.setString(7, state);
                psOrder.setString(8, zip);
                psOrder.setString(9, orderDate); // Current timestamp
                psOrder.setString(10, orderTime); // Converted order time
                psOrder.setString(11, orderMethod);
                psOrder.setString(12, orderAddress);
                psOrder.setString(13, deliveryDate);
                psOrder.setString(14, uniqueOrderId);

                psOrder.executeUpdate();

                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                    }
                }
            }

            // Insert items into `order_items` table
            String getItemIdSQL = "SELECT item_id FROM items WHERE item_name = ?";
            String insertOrderItemsSQL = "INSERT INTO order_items (order_id, item_id, item_name, price, quantity) VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement psGetItemId = conn.prepareStatement(getItemIdSQL);
                 PreparedStatement psOrderItems = conn.prepareStatement(insertOrderItemsSQL)) {

                for (Map<String, Object> item : cartItemsData) {
                    String itemName = (String) item.get("itemName");
                    psGetItemId.setString(1, itemName);

                    int itemId = 0;
                    try (ResultSet rsItem = psGetItemId.executeQuery()) {
                        if (rsItem.next()) {
                            itemId = rsItem.getInt("item_id");
                        } else {
                            throw new Exception("Item not found in database: " + itemName);
                        }
                    }

                    Object priceObject = item.get("itemPrice");
                    double price = (priceObject instanceof Integer) 
                        ? ((Integer) priceObject).doubleValue() 
                        : (Double) priceObject;

                    psOrderItems.setInt(1, orderId);
                    psOrderItems.setInt(2, itemId);
                    psOrderItems.setString(3, itemName);
                    psOrderItems.setDouble(4, price);
                    psOrderItems.setInt(5, (Integer) item.get("quantity"));
                    psOrderItems.addBatch();
                }

                psOrderItems.executeBatch();
            }

            conn.commit();

            // Set session attributes for order confirmation
            session.setAttribute("uniqueOrderId", uniqueOrderId);
            session.setAttribute("orderCartItems", cartItemsData);
            session.setAttribute("totalAmount", totalAmount);
            session.setAttribute("userFirstName", userFirstName);
            session.setAttribute("userLastName", userLastName);

            logger.info("Session attributes set successfully for order confirmation.");

            EmailUtility.sendOrderConfirmationEmail(
                userEmail,
                userFirstName + " " + userLastName,
                uniqueOrderId,
                totalAmount.doubleValue(),
                cartItemsData
            );
            logger.info("Order confirmation email sent successfully.");

            response.getWriter().write("{\"clientSecret\": \"" + clientSecret + "\", \"success\": true}");
        } catch (StripeException e) {
            logger.severe("Stripe error: " + e.getMessage());
            response.getWriter().write("{\"error\": \"Stripe error: " + e.getMessage() + "\"}");
        } catch (MessagingException e) {
            logger.severe("Email sending failed: " + e.getMessage());
            response.getWriter().write("{\"error\": \"Email confirmation failed.\"}");
        } catch (Exception e) {
            logger.severe("Error: " + e.getMessage());
            response.getWriter().write("{\"error\": \"An unexpected error occurred.\"}");
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignored) {}
        }
    }
}
