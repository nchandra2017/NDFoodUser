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
    <title>Admin Panel</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/AdminPanel.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/ProfileStyle.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    
    <script>
        var sessionTimeout = 5 * 60 * 1000; // 5 minutes

        // Auto logout after session timeout
        setTimeout(function() {
            alert('Your session has expired due to inactivity. You will be logged out.');
            window.location.href = '<%= request.getContextPath() %>/jsp/admin_control/adminlogin.jsp';
        }, sessionTimeout);

        // Open modal for profile picture change
        function openProfilePicModal() {
            document.getElementById("editProfileModal").style.display = "block";
        }

        function closeProfilePicModal() {
            document.getElementById("editProfileModal").style.display = "none";
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            var modal = document.getElementById("editProfileModal");
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</head>
<body>
    <div class="admin-dashboard">
        <!-- Sidebar -->
        <nav class="sidebar">
            <div class="sidebar-content">
                <ul>
                    <li><a href="#"><i class="fas fa-box"></i> Product</a></li>
                    <li><a href="#"><i class="fas fa-list"></i> Order List</a></li>
                    <li><a href="#"><i class="fas fa-chart-line"></i> Analytics</a></li>
                    <li><a href="#"><i class="fas fa-warehouse"></i> Stock</a></li>
                    <li><a href="#"><i class="fas fa-receipt"></i> Total Order</a></li>
                    <li><a href="#"><i class="fas fa-users"></i> Team</a></li>
                    <li><a href="#"><i class="fas fa-envelope"></i> Messages</a></li>
                    <li><a href="<%= request.getContextPath() %>/jsp/admin_control/admin-store-control.jsp"><i class="fa-solid fa-shop"></i> Store Control</a></li>
                    <li><a href="<%= request.getContextPath() %>/jsp/admin_control/Update.jsp"><i class="fas fa-sync-alt"></i> Update</a></li>
                    <li><a href="<%= request.getContextPath() %>/jsp/admin_control/adminlogout.jsp"><i class="fas fa-sign-out-alt"></i> Log Out</a></li>
                </ul>
            </div>

            <!-- Main Content at the Bottom Inside the Sidebar -->
            <div class="sidebar-bottom main-content">
                <div class="profile-frame" onclick="openProfilePicModal()">
                    <img src="<%= request.getContextPath() + profilePicture %>" alt="Profile Picture">
                    <div class="edit-picture-overlay">
                        Change Picture
                    </div>
                </div>
                <div class="profile-info">
                    <h2><%= name %></h2>
                    
                </div>
            </div>
        </nav>
    </div>

    <!-- The Modal for profile picture change -->
    <div id="editProfileModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeProfilePicModal()">&times;</span>
            <h3>Your Profile</h3>
            <!-- Display profile information as plain text inside modal -->
            <div class="profile-info">
                <p>Name: <%= name %></p>
                <p>Phone: <%= phone %></p>
            </div>
            <hr>
            <h3>Change Profile Picture</h3>
            <form method="post" action="<%= request.getContextPath() %>/UpdateAdminSettingsServlet" enctype="multipart/form-data">
                <label for="profilePic">Profile Picture:</label>
                <input type="file" name="profilePic" accept="image/*"><br><br>
                <!-- Hidden fields to retain name and phone during picture update -->
                <input type="hidden" name="currentName" value="<%= name %>">
                <input type="hidden" name="currentPhone" value="<%= phone %>">
                
                <button type="submit">Save Changes</button>
            </form>
        </div>
    </div>
</body>
</html>
