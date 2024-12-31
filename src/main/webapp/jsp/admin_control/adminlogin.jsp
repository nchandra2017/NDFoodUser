<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.HashMap" %>

<html>
<head>
    <title>Admin Login</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/AdminLogin.css">
</head>
<body>

    <div class="login-container">
        <div class="login-box">
            <h2 class="login-title">ADMIN LOGIN</h2>

            <!-- Display error message if available -->
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null) {
            %>
                <p class="error-message"><%= errorMessage %></p>
            <%
                }
            %>

            <form action="<%= request.getContextPath() %>/ALoginServlet" method="POST">
                <div class="input-group">
                    <input type="text" name="username" placeholder="Email" required>
                </div>
                <div class="input-group">
                    <input type="password" name="password" placeholder="Password" required>
                </div>
                <button type="submit" class="login-btn">Login</button>
            </form>
        </div>
    </div>
   
</body>

</html>
