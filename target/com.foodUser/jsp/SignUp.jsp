<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Restaurant</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/SignUp.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">



</head>

<body>

    <!-- Include the navbar -->
    <%@ include file="/jsp/Navigation.jsp" %>

    <!-- Sign-Up Form -->
    <div class="signup-container">
        <div class="signup-form-box">
            <h2>Create an Account</h2>
            
         <!-- Display success message -->
<% 
    String successMessage = request.getParameter("success");
    if (successMessage != null && !successMessage.isEmpty()) { 
%>
    <div class="success-message">
        <%= successMessage %> <a href="#" onclick="openModal()">Click here</a>
    </div>
<% 
    } 
%>
<% 
    String errorMessage = request.getParameter("error");
    if (errorMessage != null && !errorMessage.trim().isEmpty()) { 
%>
    <script>
        // JavaScript to trigger a popup with the error message
        window.onload = function () {
            alert("<%= errorMessage %>"); // Show the error message in a popup
        };
    </script>
<% 
    } 
%>


            

            <!-- Sign-up form starts here -->
            <form id="signupForm" action="<%=request.getContextPath()%>/SignUpServlet" method="post" novalidate>

                <!-- First Name -->
                <div class="form-group">
                    <label for="firstname"></label>
                    <input type="text" id="firstname" name="firstname" placeholder="First Name" required />
                    <span id="firstname-error" class="error-message"></span>
                </div>

                <!-- Last Name -->
                <div class="form-group">
                    <label for="lastname"></label>
                    <input type="text" id="lastname" name="lastname" placeholder="Last Name" required />
                    <span id="lastname-error" class="error-message"></span>
                </div>

                <!-- Phone Number -->
                <div class="form-group">
                    <label for="phone"></label>
                    <input type="tel" id="phone" name="phone" placeholder="+1 000 000 0000" required maxlength="15" />
                    <span id="phone-error" class="error-message"></span>
                </div>

               <!-- Email -->
<div class="form-group">
    <label for="email"></label>
    <input type="email" id="email" name="email" placeholder="Email" required 
           pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$"  title="Please enter a valid email address. Example: user@example.com" />
    <span id="email-error" class="error-message"></span>
</div>


               <!-- Password -->
<div class="form-group password-wrapper">
    <label for="password"></label>
    <span id="password-helper" class="helper-message">
        Password must be at least 8 characters long, include 1 uppercase letter, 1 number, and 1 special character.
    </span>
    <input type="password" id="password" name="password" placeholder="Password" required minlength="8" />
    <i class="fas fa-eye" id="togglePassword"></i>
    
    <span id="password-error" class="error-message"></span>
</div>


              <!-- Confirm Password -->
<div class="form-group password-wrapper">
    <label for="confirmPassword"></label>
    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required minlength="6" />
    <i class="fas fa-eye" id="toggleConfirmPassword"></i>
    <span id="confirmPassword-error" class="error-message"></span>
</div>



                <!-- Submit Button -->
                <button type="submit" class="signup-btn">Sign Up</button>
            </form>

            <p>Already have an account? <a href="<%=request.getContextPath()%>/jsp/SignIn.jsp">Log In Here</a></p>
        </div>
    </div>
    
    <div id="errorModal" class="modal" style="display:none;">
    <div class="modal-content">
        <span id="closeModal" class="close">&times;</span>
        <p id="errorMessage"></p>
    </div>
</div>
    

    <!-- Include footer -->
    <%@ include file="/jsp/footer.jsp" %>

    <script>
        // Validate First Name and Last Name fields
        function validateNameInput(inputId, errorId) {
            const input = document.getElementById(inputId);
            const errorSpan = document.getElementById(errorId);

            input.addEventListener('input', function () {
                if (!/^[A-Za-z]+$/.test(input.value)) {
                    errorSpan.textContent = "Only letters are allowed.";
                    errorSpan.style.display = "block";
                } else {
                    errorSpan.textContent = ""; // Clear the error message
                    errorSpan.style.display = "none";
                }
            });

            input.addEventListener('blur', function () {
                if (input.value === "") {
                    errorSpan.textContent = "This field is required.";
                    errorSpan.style.display = "block";
                }
            });
        }

        validateNameInput('firstname', 'firstname-error');
        validateNameInput('lastname', 'lastname-error');

     // Format Phone Number
        const phoneInput = document.getElementById('phone');
        phoneInput.addEventListener('input', function () {
            let value = phoneInput.value.replace(/\D/g, ''); // Remove non-numeric characters
            
            // Ensure the string starts with '1' (for +1)
            if (!value.startsWith('1')) {
                value = '1' + value;
            }

            // Format as +1 000 000 0000
            const formatted = value
                .replace(/^1/, '+1 ') // Add +1
                .replace(/(\d{3})(\d{3})(\d{0,4})/, '$1 $2 $3') // Format as 000 000 0000
                .trim();

            phoneInput.value = formatted;
        });

     // Validate the form before submission
        document.getElementById('signupForm').addEventListener('submit', function (e) {
            const firstname = document.getElementById('firstname');
            const lastname = document.getElementById('lastname');
            const phone = document.getElementById('phone');
            const passwordField = document.getElementById('password');
            const confirmPasswordField = document.getElementById('confirmPassword');
            const password = passwordField.value;
            const confirmPassword = confirmPasswordField.value;

            let isValid = true;

            // First Name validation
            if (!/^[A-Za-z]+$/.test(firstname.value)) {
                document.getElementById('firstname-error').textContent = "Only letters are allowed.";
                document.getElementById('firstname-error').style.display = "block";
                isValid = false;
            }

            // Last Name validation
            if (!/^[A-Za-z]+$/.test(lastname.value)) {
                document.getElementById('lastname-error').textContent = "Only letters are allowed.";
                document.getElementById('lastname-error').style.display = "block";
                isValid = false;
            }

            // Phone validation
            if (!/^\+1 \d{3} \d{3} \d{4}$/.test(phone.value)) {
                document.getElementById('phone-error').textContent = "Enter a valid phone number in +1 000 000 0000 format.";
                document.getElementById('phone-error').style.display = "block";
                isValid = false;
            }

            // Password complexity validation
            const passwordPattern = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
            if (!passwordPattern.test(password)) {
                alert("Password must be at least 8 characters long, include one uppercase letter, one number, and one special character.");
                isValid = false;
            }

            // Password match validation
            if (password !== confirmPassword) {
                confirmPasswordField.nextElementSibling.textContent = "Passwords do not match!";
                confirmPasswordField.nextElementSibling.style.display = "block";
                isValid = false;
            } else {
                confirmPasswordField.nextElementSibling.textContent = "";
                confirmPasswordField.nextElementSibling.style.display = "none";
            }

            if (!isValid) {
                e.preventDefault(); // Prevent form submission if validation fails
            }
        });
        const emailInput = document.getElementById('email');
        const emailError = document.getElementById('email-error');

        emailInput.addEventListener('input', function () {
            const emailPattern = /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$/i; // Email regex
            if (!emailPattern.test(emailInput.value)) {
                emailError.textContent = "Please enter a valid email address.";
                emailError.style.display = "block";
            } else {
                emailError.textContent = "";
                emailError.style.display = "none";
            }
        });

     // Real-time validation for matching passwords
const passwordField = document.getElementById('password');
const passwordError = document.getElementById('password-error');
const passwordHelper = document.getElementById('password-helper');

// Password validation criteria: at least 8 characters, 1 uppercase, 1 number, 1 special character
const passwordCriteria = /^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

passwordField.addEventListener('input', function () {
    if (!passwordCriteria.test(passwordField.value)) {
        passwordError.textContent = "Password must meet the criteria.";
        passwordError.style.display = "block";
    } else {
        passwordError.textContent = "";
        passwordError.style.display = "none";
    }
});



        // Toggle Password Visibility
        document.getElementById('togglePassword').addEventListener('click', function () {
            const passwordField = document.getElementById('password');
            const type = passwordField.type === 'password' ? 'text' : 'password';
            passwordField.type = type;
            this.classList.toggle('fa-eye-slash');
        });

        document.getElementById('toggleConfirmPassword').addEventListener('click', function () {
            const confirmPasswordField = document.getElementById('confirmPassword');
            const type = confirmPasswordField.type === 'password' ? 'text' : 'password';
            confirmPasswordField.type = type;
            this.classList.toggle('fa-eye-slash');
        });

        
     // Automatically hide the success message after 3 seconds
        document.addEventListener("DOMContentLoaded", function () {
            const successMessage = document.querySelector(".success-message");
            if (successMessage) {
                setTimeout(() => {
                    successMessage.classList.add("hidden");
                }, 3000); // 3 seconds delay
            }
        });

        // Function to ensure the login modal opens when clicking the "Log In Here" link
        function openModal() {
            const modal = document.getElementById("navbar-loginModal");
            if (modal) {
                modal.style.display = "block";
            } else {
                console.error("Login modal not found!");
            }
        }
    </script>

</body>

</html>