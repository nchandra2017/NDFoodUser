<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/ForgotPassword.css"> <!-- Link to your CSS -->
    <style>
        .toggle-container {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .toggle-container label {
            margin-right: 10px;
        }

        .toggle-container input[type="checkbox"] {
            appearance: none;
            width: 40px;
            height: 20px;
            background-color: #ccc;
            border-radius: 10px;
            position: relative;
            outline: none;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .toggle-container input[type="checkbox"]::before {
            content: "";
            position: absolute;
            top: 2px;
            left: 2px;
            width: 16px;
            height: 16px;
            background-color: white;
            border-radius: 50%;
            transition: left 0.3s ease;
        }

        .toggle-container input[type="checkbox"]:checked {
            background-color: #0073e6;
        }

        .toggle-container input[type="checkbox"]:checked::before {
            left: 22px;
        }
    </style>
    <script>
        function validateInput() {
            const inputField = document.getElementById("resetInput");
            const isEmail = document.getElementById("useEmail").checked; // Check toggle state
            const inputValue = inputField.value.trim();
            const phonePattern = /^\+1 \d{3} \d{3} \d{4}$/; // Regex for phone number
            const emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/; // Regex for email

            if (isEmail && emailPattern.test(inputValue)) {
                // Valid email format
                return true;
            } else if (!isEmail && phonePattern.test(inputValue)) {
                // Valid phone number format
                return true;
            } else {
                // Invalid input
                alert(isEmail 
                    ? "Please enter a valid email address (e.g., example@example.com)."
                    : "Please enter a valid phone number (e.g., +1 000 000 0000)."
                );
                return false;
            }
        }

        function formatInput() {
            const inputField = document.getElementById("resetInput");
            const isEmail = document.getElementById("useEmail").checked;

            if (isEmail) {
                // Switch to email format
                inputField.placeholder = "Enter your email (e.g., example@example.com)";
                inputField.value = ""; // Clear any existing phone number
            } else {
                // Switch to phone number format
                inputField.placeholder = "Enter your phone number (e.g., +1 000 000 0000)";
                inputField.value = ""; // Clear any existing email
            }
        }

        function formatPhoneNumber() {
            const inputField = document.getElementById("resetInput");
            const isEmail = document.getElementById("useEmail").checked;

            if (!isEmail) {
                let value = inputField.value.replace(/\D/g, ""); // Remove all non-numeric characters

                // Ensure the number starts with "1" for country code +1
                if (!value.startsWith("1")) {
                    value = "1" + value;
                }

                // Format as +1 000 000 0000
                const formatted = value
                    .replace(/^1/, "+1 ")
                    .replace(/(\d{3})(\d{3})(\d{0,4})/, "$1 $2 $3")
                    .trim();

                inputField.value = formatted;
            }
        }
    </script>
</head>
 <%@ include file="/jsp/Navigation.jsp" %>
<body>
    <div class="forgot-password-container">
        <h2>Forgot Password</h2>
        <p>Enter your email address or phone number, and we'll send you a link to reset your password.</p>

        <!-- Feedback Messages -->
        <% if (request.getAttribute("message") != null) { %>
            <p style="color: green; font-weight: bold; text-align: center;">
                <%= request.getAttribute("message") %>
            </p>
        <% } else if (request.getAttribute("error") != null) { %>
            <p style="color: red; font-weight: bold; text-align: center;">
                <%= request.getAttribute("error") %>
            </p>
        <% } %>

        <!-- Forgot Password Form -->
        <form action="<%=request.getContextPath()%>/ForgotPasswordServlet" method="POST" onsubmit="return validateInput()">
            <div class="toggle-container">
                <label for="useEmail">Use Email?</label>
                <input type="checkbox" id="useEmail" onclick="formatInput()">
            </div>
            
            <label for="resetInput">Enter Phone Number:</label>
            <input 
                type="text" 
                id="resetInput" 
                name="resetInput" 
                placeholder="Enter your phone number (e.g., +1 000 000 0000)" 
                oninput="formatPhoneNumber()" 
                required>
            
            <button type="submit">Send Reset Link</button>
        </form>

        <!-- Back to Login Link -->
        <a href="<%=request.getContextPath()%>/jsp/SignIn.jsp">Back to Login</a>
    </div>
    <%@ include file="/jsp/footer.jsp" %>
</body>
</html>
