package utils;

import com.squareup.square.Environment;
import com.squareup.square.SquareClient;
import com.squareup.square.exceptions.ApiException;
import com.squareup.square.models.CreatePaymentRequest;
import com.squareup.square.models.Money;
import com.squareup.square.models.Payment;

import java.io.IOException;
import java.util.UUID;

public class SquareClientUtil {

    // Replace these with your actual access token and location ID
    private static final String ACCESS_TOKEN = "";
    private static final String LOCATION_ID = "";

    // Square Client instance
    private final SquareClient squareClient;

    // Constructor to initialize Square Client
    @SuppressWarnings("deprecation")
	public SquareClientUtil() {
        this.squareClient = new SquareClient.Builder()
                .environment(Environment.SANDBOX) // Use Environment.PRODUCTION for live transactions
                .accessToken(ACCESS_TOKEN)
                .build();
    }

    /**
     * Processes a payment using Square's API.
     *
     * @param nonce  The payment nonce from the frontend.
     * @param amount The payment amount in dollars.
     * @return The payment object containing details of the successful payment.
     * @throws ApiException If the API request fails.
     * @throws IOException  If there is an issue with network communication.
     */
    public Payment createPayment(String nonce, double amount) throws ApiException, IOException {
        // Convert the amount from dollars to cents
        Money money = new Money.Builder()
                .amount((long) (amount * 100)) // Convert dollars to cents
                .currency("USD") // Specify the currency
                .build();

        // Generate a unique idempotency key for the transaction
        String idempotencyKey = UUID.randomUUID().toString();

        // Create the payment request
        CreatePaymentRequest paymentRequest = new CreatePaymentRequest.Builder(nonce, idempotencyKey)
                .sourceId(nonce) // Payment source nonce from the frontend
                .amountMoney(money) // Specify the payment amount
                .idempotencyKey(idempotencyKey) // Idempotency key to ensure unique transactions
                .locationId(LOCATION_ID) // Location ID for the transaction
                .build();

        try {
            System.out.println("Sending payment request to Square API...");
            Payment payment = squareClient.getPaymentsApi().createPayment(paymentRequest).getPayment();
            System.out.println("Payment processed successfully. Payment ID: " + payment.getId());
            return payment;

        } catch (ApiException e) {
            System.err.println("Square API Exception occurred: " + e.getErrors());
            throw e; // Re-throw the exception to handle it in the servlet or higher level
        } catch (IOException e) {
            System.err.println("IO Exception occurred while communicating with Square API: " + e.getMessage());
            throw e;
        }
    }
}
