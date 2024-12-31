package dataBasedConnection;

import java.security.MessageDigest;

public class HashPasswordTool {
    public static void main(String[] args) throws Exception {
        // Replace the plain password below with the password you want to hash
        String plainPassword = "Nikhil25"; 
        String hashedPassword = hashPassword(plainPassword);
        System.out.println("Hashed Password: " + hashedPassword);
    }

    // Method to hash the password using SHA-256
    private static String hashPassword(String password) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hash = md.digest(password.getBytes("UTF-8"));
        StringBuilder hexString = new StringBuilder();
        for (byte b : hash) {
            hexString.append(String.format("%02x", b));
        }
        return hexString.toString();
    }
}
