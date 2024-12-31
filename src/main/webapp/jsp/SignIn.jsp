<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.util.HashMap" %>

<% 
    // Check for error messages set in request attribute
    String errorMessage = (String) request.getAttribute("errorMessage");

    // Get session variable for login attempts
    Integer attempts = (Integer) session.getAttribute("attempts");
    if (attempts == null) {
        attempts = 0;
    }

    // Locked message if there are 3 failed attempts
    String LOCKED_MESSAGE = "Your account has been locked due to too many failed login attempts.";
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/SignIn.css">
   
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    
    <script>

    function toggleInputModeCustom() {
        const useEmail = document.getElementById('toggleEmail').checked;
        const inputField = document.getElementById('sigIn-Input');

        if (useEmail) {
            inputField.placeholder = 'example@mail.com';
            inputField.type = 'email';
            inputField.removeAttribute('oninput'); // Remove phone formatting
        } else {
            inputField.placeholder = '+1 000 000 0000';
            inputField.type = 'text';
            inputField.setAttribute('oninput', 'detectInput()'); // Add phone formatting
        }
    }

    function detectInput() {
        const inputField = document.getElementById("sigIn-Input");
        const inputValue = inputField.value;

        // If the input contains '@', treat it as email and stop formatting
        if (inputValue.includes("@")) {
            inputField.value = inputValue; // Keep email input as-is
            return;
        }

        // If input starts with digits, format as a phone number
        if (/^\d/.test(inputValue.replace(/\D/g, ""))) {
            inputField.value = formatPhoneNumber(inputValue);
        }
    }

    function formatPhoneNumber(input) {
        // Remove all non-digit characters
        let phoneValue = input.replace(/\D/g, "");

        // Ensure it starts with "1" for US numbers
        if (!phoneValue.startsWith("1")) {
            phoneValue = "1" + phoneValue;
        }

        // Limit the value to 11 digits (1 for country code + 10 for phone number)
        phoneValue = phoneValue.substring(0, 11);

        // Format as "+1 000 000 0000"
        const formatted = phoneValue
            .replace(/^1/, "+1 ") // Add "+1 " prefix
            .replace(/(\d{3})(\d{0,3})(\d{0,4})/, (match, p1, p2, p3) => {
                let formattedNumber = p1; // Area code
                if (p2) formattedNumber += " " + p2; // First part
                if (p3) formattedNumber += " " + p3; // Last part
                return formattedNumber;
            });

        return formatted.trim(); // Ensure no trailing spaces
    }

    document.addEventListener("DOMContentLoaded", function () {
        const togglePassword = document.getElementById('togglePassword-custom');
        const passwordField = document.getElementById('passwordInput-custom');

        togglePassword.addEventListener('click', function () {
            // Toggle password visibility
            const type = passwordField.type === 'password' ? 'text' : 'password';
            passwordField.type = type;

            // Toggle the eye icon
            this.classList.toggle('fa-eye-slash');
        });
    });

    </script>
</head>
 <%@ include file="/jsp/Navigation.jsp" %>


<body>
    <div class="wrapper">
        <span class="bg-animate"></span>
        <div class="form-box login">
            <h2>Sign In</h2>
            
             <div id="error-message" class="error-message-custom"></div>
<% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <div class="alert alert-danger" style="color: red; margin-top: 10px;">
        <%= errorMessage %>
    </div>
<% } %>
            
            <div id="error-message" class="error-message-custom"></div>
            <form id="login-form-custom" action="<%=request.getContextPath()%>/LoginServlet" method="post">

            
            <div class="form-group-custom">
    <label for="sigIn-Input">Phone Number or Email *</label>
    <div class="toggle-container">
        <label class="switch">
            <input type="checkbox" id="toggleEmail" onchange="toggleInputModeCustom()">
            <span class="slider"></span>
        </label>
        <label for="toggleEmail">Use Email ID?</label>
    </div>
    <input
        type="text"
        id="sigIn-Input"
        name="SignInInput"
        placeholder="+1 000 000 0000"
        required
        oninput="detectInput()"
    />
</div>

            <div class="form-group-custom">
                <label for="passwordInput-custom">Password</label>
                <div class="password-container">
                    <input type="password" id="passwordInput-custom" name="password" required>
                    <i class="fas fa-eye toggle-password" id="togglePassword-custom"></i>
                </div>
            </div>
            <button type="submit" class="btnon">Sign In</button>
            
                <!-- Remember Me checkbox -->
                <div class="remember-link">
                    <label for="remember-me">
                        <input type="checkbox" id="remember-me" name="remember-me">
                        Remember me
                    </label>
                    <a href="<%=request.getContextPath()%>/jsp/ForgotPassword.jsp" class="forgot-password">Forgot Password?</a>
                </div>

                <div class="logreg-link">
                    <p>Don't have an account? <a href="<%=request.getContextPath()%>/jsp/SignUp.jsp">Register Here</a></p>
                </div>
            </form>

            <!-- Info-text section -->
            <div class="info-text login">
                <h6>Welcome Back!</h6>
                <p>We appreciate your loyalty. Thanks for returning to &copy; ND Bengali Food.</p>
            </div>
        </div>
    </div>
   <%@ include file="/jsp/footer.jsp" %>

</body>
</html>
