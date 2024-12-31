
package dataBasedConnection;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;

public class SMSUtility {
    public static final String ACCOUNT_SID = ""; // Replace with your SID
    public static final String AUTH_TOKEN = "";   // Replace with your Auth Token
    public static final String TWILIO_PHONE = ""; // Twilio Phone Number

    static {
        Twilio.init(ACCOUNT_SID, AUTH_TOKEN);
    }

    public static void sendSMS(String toPhone, String message) {
        try {
            Message sms = Message.creator(
                    new com.twilio.type.PhoneNumber(toPhone),
                    new com.twilio.type.PhoneNumber(TWILIO_PHONE),
                    message
            ).create();

            System.out.println("SMS Sent! SID: " + sms.getSid());
        } catch (Exception e) {
            System.err.println("Failed to send SMS: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
