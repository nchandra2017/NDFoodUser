package dataBasedConnection;


	import java.sql.Connection;
	import java.sql.DriverManager;
	import java.sql.SQLException;

	public class DataBConnection {

	    private static final String URL = "jdbc:mysql://localhost:3306/nandita_fast_food";
	    private static final String USER = "root";  // Replace with your MySQL username
	    private static final String PASSWORD = "Nandita2017$";  // Replace with your MySQL password

	    public static Connection getConnection() throws SQLException, ClassNotFoundException {
	        Class.forName("com.mysql.cj.jdbc.Driver");
	        return DriverManager.getConnection(URL, USER, PASSWORD);
	    }
	}


