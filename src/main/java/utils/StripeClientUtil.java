package utils;

import com.stripe.Stripe;
import com.stripe.exception.*;
import com.stripe.model.PaymentIntent;
import com.stripe.param.PaymentIntentCreateParams;
import com.stripe.param.PaymentIntentUpdateParams;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;


public class StripeClientUtil {

    private static final Logger logger = Logger.getLogger(StripeClientUtil.class.getName());
   // private static final String STRIPE_SECRET_KEY = System.getenv("STRIPE_SECRET_KEY");
    private static final String STRIPE_SECRET_KEY = "sk_test_51OjSIqCxMKfcbczjwnVdNtvf9PiThNHotn4rMD9YjBg3jbFZ18nY27D5TWbFZnhYFOSpwB3w7eZyQQDqzgRzwY9700J1uHJ1xt";


    // Initialize Stripe API Key
    static {
      /*   if (STRIPE_SECRET_KEY == null || STRIPE_SECRET_KEY.isEmpty()) {
            logger.log(Level.SEVERE,"STRIPE_SECRET_KEY environment variable is not set. Exiting");
            throw new IllegalArgumentException("STRIPE_SECRET_KEY environment variable is not set.");
         }*/
        Stripe.apiKey = STRIPE_SECRET_KEY;
         logger.info("Stripe API Key is set: " + STRIPE_SECRET_KEY.substring(0,4) + "*****************");
    }


    /**
     * Creates a PaymentIntent with the specified amount and currency.
     *
     * @param amount   The amount to charge in the smallest currency unit (e.g., cents for USD).
     * @param currency The currency of the payment (e.g., "usd").
     * @param metadata Additional metadata to attach to the PaymentIntent.
     * @return The PaymentIntent object.
     * @throws StripeException If there's an error during the creation process.
     */
    public PaymentIntent createPaymentIntent(long amount, String currency, Map<String, String> metadata) throws StripeException {
       if (amount <= 0) {
            logger.log(Level.SEVERE, "Invalid amount: " + amount);
            throw new IllegalArgumentException("Amount must be a positive number");
        }
        if (currency == null || currency.isEmpty()) {
             logger.log(Level.SEVERE, "Invalid currency : " + currency);
            throw new IllegalArgumentException("Currency must be a valid ISO currency code.");
        }
         logger.log(Level.INFO, "Creating PaymentIntent with amount: {0}, currency: {1}, metadata: {2}",
                new Object[]{amount, currency, metadata});

        PaymentIntentCreateParams.Builder paramsBuilder = PaymentIntentCreateParams.builder()
            .setAmount(amount)
            .setCurrency(currency)
            .addPaymentMethodType("card");

        if (metadata != null && !metadata.isEmpty()) {
            paramsBuilder.putAllMetadata(metadata);
        }

        PaymentIntentCreateParams params = paramsBuilder.build();
         PaymentIntent paymentIntent;
         try {
            paymentIntent= PaymentIntent.create(params);
        } catch (StripeException e) {
           logger.log(Level.SEVERE, "Error creating PaymentIntent:", e);
           throw e;
        }
        logger.log(Level.INFO,"Successfully created PaymentIntent: {0}", paymentIntent.getId());
        return paymentIntent;
    }

    /**
     * Retrieves the status of a PaymentIntent.
     *
     * @param paymentIntentId The ID of the PaymentIntent.
     * @return The status of the PaymentIntent.
     * @throws StripeException If there's an error retrieving the PaymentIntent.
     */
    public String retrievePaymentStatus(String paymentIntentId) throws StripeException {
         logger.log(Level.INFO,"Retrieving status of PaymentIntent: {0}", paymentIntentId);
        try {
            PaymentIntent paymentIntent = PaymentIntent.retrieve(paymentIntentId);
            logger.info("PaymentIntent retrieved successfully with status: " + paymentIntent.getStatus());
            return paymentIntent.getStatus();
        }  catch (StripeException e) {
              logger.log(Level.SEVERE, "Error retrieving PaymentIntent: " + e.getMessage(), e);
              throw e;
         }
    }

    /**
     * Retrieves the full PaymentIntent object.
     *
     * @param paymentIntentId The ID of the PaymentIntent.
     * @return The full PaymentIntent object.
     * @throws StripeException If there's an error retrieving the PaymentIntent.
     */
    public PaymentIntent retrievePaymentIntent(String paymentIntentId) throws StripeException {
        logger.log(Level.INFO,"Retrieving PaymentIntent: {0}", paymentIntentId);
        try {
            PaymentIntent paymentIntent = PaymentIntent.retrieve(paymentIntentId);
            logger.info("PaymentIntent retrieved successfully: " + paymentIntent);
            return paymentIntent;
        } catch (StripeException e) {
            logger.log(Level.SEVERE, "Error retrieving PaymentIntent: " + e.getMessage(), e);
           throw e;
        }
    }


    /**
     * Updates the metadata of an existing PaymentIntent.
     *
     * @param paymentIntentId The ID of the PaymentIntent to update.
     * @param metadata        The new metadata to attach.
     * @return The updated PaymentIntent object.
     * @throws StripeException If there's an error updating the PaymentIntent.
     */
    public PaymentIntent updatePaymentIntentMetadata(String paymentIntentId, Map<String, String> metadata) throws StripeException {
          if (metadata == null || metadata.isEmpty()) {
             logger.log(Level.SEVERE, "Metadata is null or empty for PaymentIntent: {0}", paymentIntentId);
            throw new IllegalArgumentException("Metadata cannot be null or empty.");
        }
          logger.log(Level.INFO,"Updating metadata for PaymentIntent: {0}, metadata {1}", new Object[]{paymentIntentId, metadata});
        try {

            PaymentIntentUpdateParams params = PaymentIntentUpdateParams.builder()
                    .putAllMetadata(metadata)
                    .build();
            PaymentIntent paymentIntent = PaymentIntent.retrieve(paymentIntentId);
             PaymentIntent updatedIntent = paymentIntent.update(params);
            logger.info("PaymentIntent updated successfully with new metadata: " + metadata);
            return updatedIntent;
        }  catch (StripeException e) {
             logger.log(Level.SEVERE, "Error updating PaymentIntent metadata: " + e.getMessage(), e);
             throw e;
         }
    }
}