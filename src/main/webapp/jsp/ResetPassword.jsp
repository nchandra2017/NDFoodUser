<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/ResetPassword.css"> <!-- Link to your CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"> <!-- FontAwesome -->
</head>
<%@ include file="/jsp/Navigation.jsp" %>
<body>
    <div class="reset-password-container">
        <h2>Reset Password</h2>

        <!-- Feedback Messages -->
        <% if (request.getAttribute("error") != null) { %>
            <p style="color: red; font-weight: bold; text-align: center;">
                <%= request.getAttribute("error") %>
            </p>
        <% } else if (request.getAttribute("message") != null) { %>
            <p style="color: green; font-weight: bold; text-align: center;">
                <%= request.getAttribute("message") %>
            </p>
        <% } %>

        <!-- Reset Password Form -->
        <form action="<%=request.getContextPath()%>/ResetPasswordServlet" method="POST">
            <input type="hidden" name="token" value="<%= request.getParameter("token") %>"> <!-- Token from URL -->
            
            <!-- New Password Field -->
            <div class="form-group">
                <label for="newPassword">New Password</label>
                <div class="password-wrapper">
                    <input type="password" id="newPassword" name="newPassword" placeholder="Enter new password" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('newPassword')"></i>
                </div>
            </div>
            
            <!-- Confirm Password Field -->
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <div class="password-wrapper">
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm new password" required>
                    <i class="fas fa-eye toggle-password" onclick="togglePassword('confirmPassword')"></i>
                </div>
            </div>
            
            <button type="submit" class="btn">Reset Password</button>
        </form>

         <p>Already have an account? <a href="<%=request.getContextPath()%>/jsp/SignIn.jsp">Log In Here</a></p>
    </div>
    
    
    <%@ include file="/jsp/footer.jsp" %>

    <!-- JavaScript to Toggle Password Visibility -->
    <script>
        function togglePassword(fieldId) {
            const passwordField = document.getElementById(fieldId);
            const icon = passwordField.nextElementSibling;

            if (passwordField.type === "password") {
                passwordField.type = "text";
                icon.classList.remove("fa-eye");
                icon.classList.add("fa-eye-slash");
            } else {
                passwordField.type = "password";
                icon.classList.remove("fa-eye-slash");
                icon.classList.add("fa-eye");
            }
        }
    </script>
</body>
</html>
