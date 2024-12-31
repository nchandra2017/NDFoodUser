package utils;

import com.stripe.Stripe;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;

import java.util.Map;

public class StripeClientUtil {

    // Initialize Stripe API Key
    static {
        Stripe.apiKey = "sk_test_51OjSIqCxMKfcbczjwnVdNtvf9PiThNHotn4rMD9YjBg3jbFZ18nY27D5TWbFZnhYFOSpwB3w7eZyQQDqzgRzwY9700J1uHJ1xt"; // Replace with your Stripe secret key
    }

    /**
     * Creates a PaymentIntent with the specified amount and currency.
     * 
     * @param amount   The amount to charge in the smallest currency unit (e.g., cents for USD).
     * @param currency The currency of the payment (e.g., "usd").
     * @param metadata Additional metadata to attach to the PaymentIntent.
     * @return The PaymentIntent client secret.
     * @throws Exception If there's an error during the creation process.
     */
    public String createPaymentIntent(long amount, String currency, Map<String, String> metadata) throws Exception {
        if (amount <= 0) {
            throw new IllegalArgumentException("Amount must be greater than zero.");
        }

        PaymentIntentCreateParams.Builder paramsBuilder = PaymentIntentCreateParams.builder()
                .setAmount(amount)
                .setCurrency(currency);

        if (metadata != null) {
            paramsBuilder.putAllMetadata(metadata);
        }

        PaymentIntent paymentIntent = PaymentIntent.create(paramsBuilder.build());
        return paymentIntent.getClientSecret();
    }


    /**
     * Handles post-payment actions (e.g., confirming status or logging).
     * 
     * @param paymentIntentId The ID of the PaymentIntent.
     * @return The status of the PaymentIntent.
     * @throws Exception If there's an error retrieving the PaymentIntent.
     */
    public String retrievePaymentStatus(String paymentIntentId) throws Exception {
        PaymentIntent paymentIntent = PaymentIntent.retrieve(paymentIntentId);
        return paymentIntent.getStatus();
    }
}
