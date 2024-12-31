<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dataBasedConnection.DataBConnection" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%
    // Check if the session is valid
    if (session == null || session.getAttribute("adminUser") == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/admin_control/adminlogin.jsp");
        return;
    }

    String username = (String) session.getAttribute("adminUser");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String name = "Admin";  // Default name
    String phone = "";      // Default phone number
    String profilePicture = "/images/default.png";  // Default profile picture

    try {
        conn = DataBConnection.getConnection();
        String query = "SELECT name, phone_number, profile_picture FROM admins WHERE username = ?";
        pstmt = conn.prepareStatement(query);
        pstmt.setString(1, username);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            name = rs.getString("name");
            phone = rs.getString("phone_number");
            profilePicture = rs.getString("profile_picture");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Sidebar</title>
    
     
    <!-- CSS link for Admin Panel -->
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/AdminPanel.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/ProfileStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<body>
    <div class="admin-dashboard">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-content">
 <ul>
    <!-- Home Icon -->
    <li><a href="<%= request.getContextPath() %>/jsp/admin_control/Admin_Panel.jsp"><i class="fas fa-home"></i> Home</a></li>
    <!-- Product Icon -->
    <li><a href="#"><i class="fas fa-box"></i> Product</a></li>
    <!-- Order List Icon -->
    <li><a href="#"><i class="fas fa-list"></i> Order List</a></li>
    <!-- Analytics Icon -->
    <li><a href="#"><i class="fas fa-chart-line"></i> Analytics</a></li>
    <!-- Stock Icon -->
    <li><a href="#"><i class="fas fa-warehouse"></i> Stock</a></li>
    <!-- Total Order Icon -->
    <li><a href="#"><i class="fas fa-receipt"></i> Total Order</a></li>
    <!-- Team Icon -->
    <li><a href="#"><i class="fas fa-users"></i> Team</a></li>
    <!-- Messages Icon -->
    <li><a href="#"><i class="fas fa-envelope"></i> Messages</a></li>
    <!-- Update Icon -->
    <li><a href="<%= request.getContextPath() %>/jsp/admin_control/Update.jsp"><i class="fas fa-sync-alt"></i> Update</a></li>
    <!-- Log Out Icon -->
    <li><a href="<%= request.getContextPath() %>/jsp/admin_control/adminlogout.jsp"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
</ul>
            </div>

            <!-- Main Content at the Bottom Inside the Sidebar -->
            <div class="sidebar-bottom main-content">
                <div class="profile-frame">
                    <img src="<%= request.getContextPath() + profilePicture %>" alt="Profile Picture" width="100px" height="100px">
                </div>
                <div class="profile-info">
                    <h2><%= name %>!</h2>
                </div>
            </div>
        </nav>
    </div>
</body>
</html>
