package dataBasedConnection;

import java.util.List;
import java.util.Map;
import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailUtility {

    private static final String FROM_EMAIL = "nchandra244@gmail.com"; // Your email
    private static final String PASSWORD = "vjqc fwjn dttp fbkk";  // Your email password (or app password)

    // Method to send an email
    public static void sendEmail(String toEmail, String subject, String messageBody) throws MessagingException {
        // SMTP Configuration
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        // Create a session with authentication
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        // Create the email message
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setText(messageBody);

        // Send the email
        Transport.send(message);
    }

    // Method to send a Password Reset Request Email
    public static void sendPasswordResetEmail(String toEmail, String resetLink) {
        String subject = "Password Reset Request";
        String messageBody = "Hi,\n\nWe received a request to reset your password. "
                + "You can reset your password using the following link:\n\n" + resetLink
                + "\n\nIf you didn't request a password reset, please ignore this email.\n\nThanks,\nND Bangali Food Team";

        try {
            sendEmail(toEmail, subject, messageBody);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    // Method to send Order Confirmation Email with Item Details
    public static void sendOrderConfirmationEmail(String toEmail, String userName, String orderId, double totalAmount, List<Map<String, Object>> cartItemsData) {
        String subject = "Order Confirmation - " + orderId;

        // Build the email body with HTML
        StringBuilder itemsHtml = new StringBuilder();
        for (Map<String, Object> item : cartItemsData) {
            itemsHtml.append("<tr>")
                     .append("<td style='padding:8px; border:1px solid #ddd;'>").append(item).append("</td>")
                     .append("</tr>");
        }

        String messageBody = "<!DOCTYPE html>"
                + "<html lang='en'>"
                + "<head>"
                + "<meta charset='UTF-8'>"
                + "<title>Order Confirmation</title>"
                + "<style>"
                + "body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }"
                + ".email-container { background-color: #ffffff; margin: 20px auto; padding: 20px; max-width: 600px; border-radius: 5px; box-shadow: 0px 4px 6px #ccc; }"
                + ".header { text-align: center; margin-bottom: 20px; }"
                + ".header img { width: 100px; }"
                + ".header h2 { color: #333333; }"
                + ".order-details, .items-table { width: 100%; border-collapse: collapse; margin-top: 10px; }"
                + ".order-details th, .order-details td { padding: 10px; text-align: left; border: 1px solid #ddd; }"
                + ".order-summary { margin-top: 20px; font-size: 1.1em; }"
                + ".footer { text-align: center; margin-top: 30px; color: #777; font-size: 0.9em; }"
                + "</style>"
                + "</head>"
                + "<body>"
                + "  <div class='email-container'>"
                + "    <div class='header'>"
                + "      <img src='http://localhost:8089/bangalifood/images/R%20Logo.png' alt='ND Bangali Food Logo' />"
                + "      <h2>Thank You for Your Order!</h2>"
                + "    </div>"
                + "    <p>Dear <b>" + userName + "</b>,</p>" // Include user's name dynamically
                + "    <p>Your order has been successfully placed. Below are the details of your order:</p>"
                + "    <table class='order-details'>"
                + "      <tr><th>Order ID</th><td>" + orderId + "</td></tr>"
                + "      <tr><th>Total Amount</th><td>$" + String.format("%.2f", totalAmount) + "</td></tr>"
                + "    </table>"
                + "    <h3>Order Items</h3>"
                + "    <table class='items-table'>"
                + itemsHtml.toString()
                + "    </table>"
                + "    <p class='order-summary'>We hope you enjoy your meal!</p>"
                + "    <div class='footer'>"
                + "      <p>&copy; ND Bngali Food Team | For support, contact: <a href='mailto:support@ndbangalifood.com'>support@ndbangalifood.com</a></p>"
                + "    </div>"
                + "  </div>"
                + "</body>"
                + "</html>";

        // Send the HTML email
        try {
            sendEmailWithHtml(toEmail, subject, messageBody);
        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("Failed to send order confirmation email: " + e.getMessage());
        }
    }

    // Updated sendEmail method to handle HTML content
    private static void sendEmailWithHtml(String toEmail, String subject, String htmlBody) throws MessagingException {
        Properties properties = new Properties();
        properties.put("mail.smtp.host", "smtp.gmail.com");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        // Email session
        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
            }
        });

        // Build the email
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(htmlBody, "text/html; charset=UTF-8");

        // Send the email
        Transport.send(message);
    }

}
