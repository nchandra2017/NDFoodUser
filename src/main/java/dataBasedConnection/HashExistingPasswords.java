package dataBasedConnection;


	import java.security.MessageDigest;
	import java.sql.Connection;
	import java.sql.PreparedStatement;
	import java.sql.ResultSet;
	import dataBasedConnection.DataBConnection;

	public class HashExistingPasswords {
	    public static void main(String[] args) throws Exception {
	        Connection conn = null;
	        PreparedStatement pstmtSelect = null;
	        PreparedStatement pstmtUpdate = null;
	        ResultSet rs = null;

	        try {
	            // Connect to the database
	            conn = DataBConnection.getConnection();

	            // Query to select all users and their plain-text passwords
	            String selectQuery = "SELECT id, username, password FROM admins"; // Assuming id is the primary key
	            pstmtSelect = conn.prepareStatement(selectQuery);
	            rs = pstmtSelect.executeQuery();

	            // Prepare update statement for updating hashed password
	            String updateQuery = "UPDATE admins SET password = ? WHERE id = ?";
	            pstmtUpdate = conn.prepareStatement(updateQuery);

	            while (rs.next()) {
	                int id = rs.getInt("id");
	                String plainPassword = rs.getString("password");

	                // Hash the plain-text password
	                String hashedPassword = hashPassword(plainPassword);

	                // Update the database with the hashed password
	                pstmtUpdate.setString(1, hashedPassword);
	                pstmtUpdate.setInt(2, id);
	                pstmtUpdate.executeUpdate();

	                System.out.println("Updated password for user ID: " + id);
	            }
	        } finally {
	            if (rs != null) rs.close();
	            if (pstmtSelect != null) pstmtSelect.close();
	            if (pstmtUpdate != null) pstmtUpdate.close();
	            if (conn != null) conn.close();
	        }
	    }

	    // Hashing method for SHA-256
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



