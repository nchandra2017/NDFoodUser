package javaPage.contol;

import java.io.BufferedReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;

import dataBasedConnection.DataBConnection;
import utils.StripeClientUtil;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final Logger logger = Logger.getLogger(PaymentServlet.class.getName());
    private final StripeClientUtil stripeClientUtil = new StripeClientUtil();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        ObjectMapper mapper = new ObjectMapper();

        try {
            // Parse payload
            BufferedReader reader = request.getReader();
            Map<String, Object> payload = mapper.readValue(reader, new TypeReference<Map<String, Object>>() {});

            // Extract details from the payload
            BigDecimal totalAmount = new BigDecimal(payload.get("amount").toString());
            long amountInCents = totalAmount.multiply(new BigDecimal("100")).longValueExact();

            // Retrieve user ID from session
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) {
                throw new Exception("User ID not found in session.");
            }

            // Retrieve user details
            String userFirstName = null, userLastName = null, userEmail = null;

            try (Connection conn = DataBConnection.getConnection()) {
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
                            session.setAttribute("userEmail", userEmail);
                        } else {
                            throw new Exception("User details not found for ID: " + userId);
                        }
                    }
                }
            }

            // Create Stripe PaymentIntent
            PaymentIntent paymentIntent = stripeClientUtil.createPaymentIntent(amountInCents, "usd", null);
            String clientSecret = paymentIntent.getClientSecret();

            // Save order details to session
            session.setAttribute("billing_name", payload.get("billing_name"));
            session.setAttribute("billing_address_line1", payload.get("billing_address_line1"));
            session.setAttribute("billing_address_city", payload.get("billing_address_city"));
            session.setAttribute("billing_address_state", payload.get("billing_address_state"));
            session.setAttribute("billing_address_zip", payload.get("billing_address_zip"));
            session.setAttribute("orderCartItems", payload.get("cartItems"));
            session.setAttribute("totalAmount", totalAmount);
            session.setAttribute("uniqueOrderId", generateUniqueOrderId());
            session.setAttribute("order_method", payload.get("order_method"));
            session.setAttribute("deliveryorpickup_date", payload.get("deliveryorpickup_date"));
            session.setAttribute("order_time", payload.get("order_time"));
            session.setAttribute("orderAddress", payload.get("order_address"));

            logger.info("Session attributes successfully set for the order.");

            // Respond with PaymentIntent clientSecret
            sendJsonResponse(response, Map.of("clientSecret", clientSecret, "success", true));
        } catch (StripeException e) {
            String errorCode = e.getStripeError().getCode();
            String userFriendlyMessage = mapStripeErrorCodeToMessage(errorCode);
            logger.log(Level.SEVERE, "Stripe error occurred: " + errorCode, e);
            handleErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, userFriendlyMessage);
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error during payment processing", e);
            handleErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Payment processing error: " + e.getMessage());
        }
    }

    private String mapStripeErrorCodeToMessage(String errorCode) {
        switch (errorCode) {
            case "card_declined":
                return "Your card was declined. Please use another card.";
            case "incorrect_number":
                return "The card number is incorrect. Please try again.";
            case "invalid_number":
                return "The card number is invalid. Ensure you have entered it correctly.";
            case "expired_card":
                return "The card has expired. Use a valid card.";
            case "insufficient_funds":
                return "Insufficient funds on the card.";
            default:
                return "Payment failed. Please check your card details and try again.";
        }
    }

    private void sendJsonResponse(HttpServletResponse response, Object data) throws IOException {
        response.setContentType("application/json");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().write(new ObjectMapper().writeValueAsString(data));
    }

    private void handleErrorResponse(HttpServletResponse response, int statusCode, String errorMessage) throws IOException {
        response.setContentType("application/json");
        response.setStatus(statusCode);
        response.getWriter().write(new ObjectMapper().writeValueAsString(Map.of("error", errorMessage)));
    }

    private String generateUniqueOrderId() {
        int randomNum = 2173; // Static prefix number (e.g., 2173)
        String randomFormat = String.format("%04d-%04d", (int)(Math.random() * 10000), (int)(Math.random() * 10000));
        return randomNum + "" + randomFormat; // Example: 2173-1234-5678
    }
}
