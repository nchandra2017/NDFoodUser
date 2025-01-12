<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Checkout as Guest</title>
     <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
     
     <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
      <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/checkoutGuest.css">
      
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    
</head>

<%@ include file="/jsp/PaymantNavigation.jsp" %>

<body>


<div class="checkout-container">
      <form id="complete-checkout-form">
        <div class="restaurant-info">
        <h1>ND Bengali Food</h1>
        <p>5504 Cinderlane Pkwy, Orlando, FL-32808</p>
        <p>Phone: 808-807-2025</p>
    </div>

    <!-- Special Notes Section -->
    <!-- Special Notes Section -->
<div id="special-notes">
    <h2>Special Notes</h2>
    <div class="note-item">
        <p>Special Note: Example note here.</p>
        <i class="fas fa-trash-alt delete-note-icon" data-index="0"></i>
    </div>
</div>

    <!-- Order Method Details Section -->
    <div id="order-method-details">
        <div class="details-rows">
            <i class="fas fa-shopping-bag icon order-icon"></i>
            <p>
                <strong>Order Method:</strong> 
                <span class="delivery-or-pickup">N/A</span>
                <a href="#" class="edit-link">Edit</a>
            </p>
        </div>
        <div class="details-rows">
            <i class="fas fa-calendar-alt icon"></i>
            <p><strong>Date:</strong> <span class="date">N/A</span></p>
        </div>
        <div class="details-rows">
            <i class="fas fa-clock icon"></i>
            <p><strong>Time:</strong> <span class="time">N/A</span></p>
        </div>
        <div class="details-rows">
            <i class="fas fa-map-marker-alt icon"></i>
            <p><strong>Address:</strong> <span class="address">N/A</span></p>
        </div>
    </div>

   <!-- Order Summary Section -->
<div id="order-summary-details">
    <div class="order-header">
        <h2>Your Orders (<span id="total-items">0</span>)</h2>
        <span id="toggle-icon" class="toggle-icon">
            <i class="fas fa-chevron-down"></i>
        </span>
    </div>
    
    <div id="order-summary-content" class="hidden">
        <div class="summary-row always-visible" id="first-item-row">
            <!-- First item row details here -->
        </div>
        <div id="orders-lists">
            <!-- Orders list details here -->
        </div>
    </div>
</div>

    

   <!-- Payment Section -->
  <h3> Payment Details</h3>
 <div class="payment-method">
 <p>Accepted Cards: <img src="https://i.imgur.com/IHEKLgm.png" alt="Accepted Cards"></p>
 </div>





<div class="payment-switch">
    <button id="creditCardBtn" class="switch-btn active">Credit Card</button>
    <button id="applePayBtn" class="switch-btn">Apple Pay</button>
    <button id="googlePayBtn" class="switch-btn">Google Pay</button>
</div>

<!-- Payment Sections -->
<div id="creditCardForm" class="payment-section">
    <h2>Credit Card Payment</h2>

    <div class="paymentForm-group">
        <label for="cardName">Full Name</label>
        <input type="text" id="cardName" name="cardName" placeholder="Card Holder Full Name" required>
        <div class="error" id="cardNameError">Cardholder name cannot contain numbers or special characters</div>
    </div>

    <div class="paymentForm-group input-with-icon">
        <label for="cardNumber">Card Number</label>
        <i class="fas fa-credit-card icon"></i>
        <input type="text" id="cardNumber" name="cardNumber" placeholder="0000 0000 0000 0000" required maxlength="19">
        <div class="error" id="cardNumberError">Invalid card number</div>
    </div>

    <div class="paymentForm-group">
        <label for="expiryDate">Expiry Date (MM/YY)</label>
        <input type="text" id="expiryDate" name="expiryDate" placeholder="MM/YY" required maxlength="5">
        <div class="error" id="expiryDateError">Invalid expiry date</div>
    </div>

    <div class="paymentForm-group">
        <label for="cvv">CVV</label>
        <input type="text" id="cvv" name="cvv" placeholder="3-digit CVV" required maxlength="3">
        <div class="error" id="cvvError">Invalid CVV</div>
    </div>

    <div class="paymentForm-group">
        <label for="zipCode">ZIP Code</label>
        <input type="text" id="zipCode" name="zipCode" placeholder="ZIP Code" required>
        <div class="error" id="zipCodeError">ZIP code must be exactly 5 digits.</div>
    </div>
</div>

<!-- Apple Pay Form -->
<div id="applePayForm" class="payment-section hidden">
    <h2> <i class="fab fa-apple-pay apple-icon"></i></h2>
    <p>To pay with Apple Pay, ensure your device supports Apple Pay and follow the instructions below:</p>
    <ul>
        <li>Click the "Proceed with Apple Pay" button below.</li>
        <li>Authenticate using Face ID, Touch ID, or your device passcode.</li>
        <li>Ensure the payment amount matches your total.</li>
    </ul>
   
</div>

<!-- Google Pay Form -->
<div id="googlePayForm" class="payment-section hidden">
    <h2><i class="fab fa-google-pay google-icon"></i></h2>
    <p>To pay with Google Pay, ensure your device supports Google Pay and follow the instructions below:</p>
    <ul>
        <li>Click the "Proceed with Google Pay" button below.</li>
        <li>Authenticate using your Google account.</li>
        <li>Ensure the payment amount matches your total.</li>
    </ul>
    
</div>

       <!-- Guest Information Section -->
<div class="guest-info">
    <h3><i class="fas fa-user-check"></i> Guest Checkout</h3>
    <p>Please fill out the form below to complete your order as a guest.</p>
</div>



        <div class="form-group">
            <label for="guestFirstName">First Name</label>
            <input type="text" id="guestFirstName" name="guestFirstName" placeholder="Enter Your First Name" required oninput="validateName(this, 'firstNameError')">
            <div class="error" id="firstNameError">First Name cannot contain numbers or special characters</div>
        </div>

        <div class="form-group">
            <label for="guestLastName">Last Name</label>
            <input type="text" id="guestLastName" name="guestLastName" placeholder="Enter Your Last Name" required oninput="validateName(this, 'lastNameError')">
            <div class="error" id="lastNameError">Last Name cannot contain numbers or special characters</div>
        </div>

        <div class="form-group">
            <label for="guestEmail">Email</label>
            <input type="email" id="guestEmail" name="guestEmail" placeholder="Enter Your Email" required>
            <div class="error" id="emailError">Please enter a valid email address</div>
        </div>

        <div class="form-group">
            <label for="guestPhone">Phone</label>
            <input type="tel" id="guestPhone" name="guestPhone" placeholder="+1 000 000 0000" maxlength="15" required>
        </div>

      <div class="form-accountOption">
    <input type="checkbox" id="createAccount" name="accountOption">
    <label for="createAccount" class="inline-label">Yes, I'd like to create an account.</label>
</div>

<!-- Password Fields -->
<div class="form-group hidden" id="passwordFields">
    <label for="password">Password</label>
    <input type="password" id="password" name="password" placeholder="Enter Your Password" required>
    <span class="material-icons icon" id="togglePassword">visibility</span>
    <div class="error" id="passwordError">
        Password must contain at least 8 characters, 1 uppercase letter, 1 number, and 1 special character.
    </div>
</div>

<div class="form-group hidden" id="confirmPasswordFields">
    <label for="confirmPassword">Confirm Password</label>
    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm Your Password" required>
    <span class="material-icons icon" id="toggleConfirmPassword">visibility</span>
    <div class="error" id="confirmPasswordError">Passwords do not match.</div>
</div>


   <!-- Tip Section -->
<div class="tip-container">
    <h6> <i class="fas fa-hand-holding-usd tip-icon"></i> Add a Tip</h6>


    <div class="tip-options">
        <div class="tip-option" data-percent="18">18%<br>$<span class="amount">0.00</span></div>
        <div class="tip-option" data-percent="22">22%<br>$<span class="amount">0.00</span></div>
        <div class="tip-option" data-percent="25">25%<br>$<span class="amount">0.00</span></div>
        <div class="tip-option" data-percent="15">15%<br>$<span class="amount">0.00</span></div>
        <div class="tip-option other">
            Other<br>
            <input type="number" id="customTip" placeholder="Enter Tip Amount" class="hidden">
        </div>
    </div>
</div>


 <div class="tav-row">
            <span>Estimated sales tax (7%)</span>
            <span>$<span id="tax">0.00</span></span>
        </div>
        <div class="s-total-row">
            <span>Total (Including Tax)</span>
            <span>$<span id="total-amount">0.00</span></span>
        </div>




        <!-- Submit Button -->
       <button type="submit" class="payment-btn" id="submitButton" disabled>Place Order</button>
    </form>
</div>

<%@ include file="/jsp/footer.jsp" %>

</body>




<script>
const TAX_RATE = 0.07;
let items = [];
let totalQuantity = 0;

document.addEventListener("DOMContentLoaded", function() {
    loadOrderDetails();
    renderOrderList();
    initToggleFeature();
});


function loadOrderDetails() {
    const orderMethod = localStorage.getItem('orderMethod') || 'Pickup';
    const orderDate = localStorage.getItem('orderDate') || 'N/A';
    const orderTime = localStorage.getItem('orderTime') || 'N/A';
    const orderAddress = localStorage.getItem('orderAddress') || 'N/A';

    document.querySelector('.delivery-or-pickup').textContent = orderMethod;
    document.querySelector('.date').textContent = orderDate;
    document.querySelector('.time').textContent = orderTime;
    document.querySelector('.address').textContent = orderAddress;

    // Dynamically update icon based on order method
    const orderIcon = document.querySelector('.order-icon');
    if (orderMethod === 'Delivery') {
        orderIcon.className = 'fas fa-truck icon order-icon'; // Change to delivery icon
    } else {
        orderIcon.className = 'fas fa-shopping-bag icon order-icon'; // Default to pickup icon
    }

    const savedItems = localStorage.getItem('cartItems');
    items = savedItems ? JSON.parse(savedItems) : [];
    console.log('Loaded Items:', items);

    // Retrieve delivery fee
    const deliveryFee = parseFloat(localStorage.getItem('deliveryFee')) || 0;
    console.log('Retrieved Delivery Fee:', deliveryFee);
    return deliveryFee; // Return delivery fee for later use
}



function renderOrderList() {
    const firstItemRow = document.getElementById("first-item-row");
    const orderList = document.getElementById("orders-lists");
    const cartCountElement = document.getElementById("total-items");
    const deliveryFee = loadOrderDetails(); // Retrieve delivery fee

    orderList.innerHTML = "";
    totalQuantity = 0;

    if (items.length === 0) {
        firstItemRow.innerHTML = "<p>Your cart is empty</p>";
        document.getElementById("subtotal").innerText = "0.00";
        document.getElementById("tax").innerText = "0.00";
        cartCountElement.innerText = "0";
        return;
    }

    let subtotal = 0;

    items.forEach((item, index) => {
        const itemTotal = (item.itemPrice * item.quantity).toFixed(2);
        subtotal += parseFloat(itemTotal);
        totalQuantity += item.quantity;

        const itemHTML = `
            <div class="item-details">
                <span>Item:  ` + item.itemName + `</span> x <span>` + item.quantity + `</span>
            </div>
            <div class="item-price">
                <span>$` + itemTotal + `</span>
            </div>
        `;

        if (index === 0) {
            firstItemRow.innerHTML = itemHTML;
        } else {
            const itemElement = document.createElement("div");
            itemElement.classList.add("summary-row");
            itemElement.innerHTML = itemHTML;
            orderList.appendChild(itemElement);
        }
    });

    const tax = (subtotal * TAX_RATE).toFixed(2);
    const totalWithTaxAndDelivery = (subtotal + parseFloat(tax) + deliveryFee).toFixed(2);

    updateSummary(tax, totalWithTaxAndDelivery, deliveryFee);
    cartCountElement.innerText = totalQuantity;
}

document.getElementById('toggle-icon').addEventListener('click', function() {
    const orderSummaryContent = document.getElementById('order-summary-content');
    const icon = this.querySelector('i');

    if (orderSummaryContent.classList.contains('hidden')) {
        orderSummaryContent.classList.remove('hidden');
        orderSummaryContent.classList.add('visible');
        icon.classList.remove('fa-chevron-down');
        icon.classList.add('fa-chevron-up');
    } else {
        orderSummaryContent.classList.remove('visible');
        orderSummaryContent.classList.add('hidden');
        icon.classList.remove('fa-chevron-up');
        icon.classList.add('fa-chevron-down');
    }
});




function initToggleFeature() {
    const toggleIcon = document.getElementById("toggle-icon");
    const orderList = document.getElementById("orders-lists");

    toggleIcon.addEventListener("click", () => {
        const isHidden = orderList.classList.toggle("hidden");
        const icon = toggleIcon.querySelector("i");
        icon.className = isHidden ? "fas fa-chevron-down" : "fas fa-chevron-up";
    });
}

function updateSummary(tax, totalWithTax) {
    document.getElementById("tax").innerText = tax;
    document.getElementById("subtotal").innerText = totalWithTax;
}


const modalContainer = document.getElementById("navbar-loginModal");
const checkoutLoginLink = document.getElementById("checkoutLoginLink");

function openModal() {
    modalContainer.style.display = "block";
}

function closeModal() {
    modalContainer.style.display = "none";
}


// Close modal when clicking outside the modal content
window.onclick = function(event) {
    if (event.target === modalContainer) {
        closeModal();
    }
};

// Optional: Close modal when pressing the `Esc` key
document.addEventListener("keydown", function(event) {
    if (event.key === "Escape" && modalContainer.style.display === "block") {
        closeModal();
    }
});


document.querySelector('.edit-link').addEventListener('click', (e) => {  
    e.preventDefault();
    window.location.href = '/bangalifood/jsp/menu.jsp'; // Adjust path as needed.
});

document.addEventListener("DOMContentLoaded", function () {
    const cartItems = JSON.parse(localStorage.getItem('cartItems')) || [];
    const specialNotesContainer = document.getElementById('special-notes');

    // Clear container initially
    specialNotesContainer.innerHTML = "";

    cartItems.forEach((item, index) => {
        if (item.specialNote && item.specialNote.trim() !== "") {
            const specialNote = item.specialNote;
            const noteDiv = document.createElement('div');
            noteDiv.className = 'note-item';

         // Dynamically insert the special note and delete icon
            noteDiv.innerHTML = `<p>Special Note: ` + specialNote + `</p>` +
                                `<i class="fas fa-trash-alt delete-note-icon" data-index="` + index + `"></i>`;


            specialNotesContainer.appendChild(noteDiv);
        }
    });

    // Add event listener for delete icons (event delegation)
    specialNotesContainer.addEventListener('click', function (e) {
        if (e.target && e.target.classList.contains('delete-note-icon')) {
            const index = e.target.getAttribute('data-index');
            deleteSpecialNote(index, cartItems, e.target.closest('.note-item'));
        }
    });
});
function deleteSpecialNote(index, cartItems, noteDiv) {
    delete cartItems[index].specialNote; // Remove the specialNote property from the specific item
    localStorage.setItem('cartItems', JSON.stringify(cartItems)); // Update localStorage
    noteDiv.remove(); // Remove the noteDiv from the DOM
}


document.addEventListener("DOMContentLoaded", function () {
    const creditCardBtn = document.getElementById("creditCardBtn");
    const applePayBtn = document.getElementById("applePayBtn");
    const googlePayBtn = document.getElementById("googlePayBtn");

    const creditCardForm = document.getElementById("creditCardForm");
    const applePayForm = document.getElementById("applePayForm");
    const googlePayForm = document.getElementById("googlePayForm");

    const submitButton = document.getElementById("submitButton");

    // Function to switch between payment methods
    function switchPaymentMethod(selectedBtn, formToShow, buttonText) {
        // Reset active state on buttons
        [creditCardBtn, applePayBtn, googlePayBtn].forEach((btn) => btn.classList.remove("active"));

        // Hide all forms
        [creditCardForm, applePayForm, googlePayForm].forEach((form) => form.classList.add("hidden"));

        // Activate selected button and show corresponding form
        selectedBtn.classList.add("active");
        formToShow.classList.remove("hidden");

        // Update the submit button text
        submitButton.textContent = buttonText;
    }

    // Event listeners for buttons
    creditCardBtn.addEventListener("click", () =>
        switchPaymentMethod(creditCardBtn, creditCardForm, "Place Order with Credit Card")
    );
    applePayBtn.addEventListener("click", () =>
        switchPaymentMethod(applePayBtn, applePayForm, "Proceed with Apple Pay")
    );
    googlePayBtn.addEventListener("click", () =>
        switchPaymentMethod(googlePayBtn, googlePayForm, "Proceed with Google Pay")
    );

    // Add event listener for the submit button
    submitButton.addEventListener("click", function (event) {
        event.preventDefault(); // Prevent actual form submission
        const activePaymentMethod = document.querySelector(".switch-btn.active").textContent.trim();
        alert(`You selected: ${activePaymentMethod}`);
    });
});



document.addEventListener("DOMContentLoaded", function () {
    // Full Name: Only Letters
    document.getElementById("cardName").addEventListener("input", function () {
        const error = document.getElementById("cardNameError");
        this.value = this.value.replace(/[^a-zA-Z\s]/g, ""); // Remove numbers and special characters
        if (/[^\sa-zA-Z]/.test(this.value)) {
            error.style.display = "block";
        } else {
            error.style.display = "none";
        }
    });

    // Expiry Date: Auto Add "/" After 2 Digits
    document.getElementById("expiryDate").addEventListener("input", function () {
        const value = this.value.replace(/[^0-9]/g, ""); // Only numbers
        if (value.length >= 3) {
            this.value = value.substring(0, 2) + "/" + value.substring(2, 4);
        } else {
            this.value = value;
        }
    });

    // CVV: Adjust Length Based on Card Type
    document.getElementById("cardNumber").addEventListener("input", function () {
        const value = this.value.replace(/\D/g, "").substring(0, 16); // Only numbers, limit to 16 digits
        this.value = value.match(/.{1,4}/g)?.join(" ") || value; // Add space after every 4 digits

        const cvvInput = document.getElementById("cvv");
        if (/^3[47]/.test(value)) { // American Express cards start with 34 or 37
            cvvInput.maxLength = 4; // 4-digit CVV for Amex
            cvvInput.placeholder = "4-digit CVV";
        } else {
            cvvInput.maxLength = 3; // 3-digit CVV for other cards
            cvvInput.placeholder = "3-digit CVV";
        }
    });

    // CVV: Only Numbers
    document.getElementById("cvv").addEventListener("input", function () {
        this.value = this.value.replace(/[^0-9]/g, ""); // Only numbers
    });

    // ZIP Code: Only 5 Digits
    document.getElementById("zipCode").addEventListener("input", function () {
        this.value = this.value.replace(/[^0-9]/g, "").substring(0, 5); // Only numbers, limit to 5 digits
    });
});



document.getElementById('guestPhone').addEventListener('input', function (e) {
    let input = e.target.value.replace(/\D/g, ''); // Remove all non-numeric characters
    if (!input.startsWith('1')) {
        input = '1' + input; // Ensure the number starts with '1'
    }
    input = input.substring(0, 11); // Limit the input to 11 digits (including '1')
    e.target.value = '+' + input.replace(/(\d{1})(\d{3})(\d{3})(\d{4})/, '$1 $2 $3 $4'); // Format as +1 000 000 0000
});
function validateZipCode(input) {
    const error = document.getElementById('zipCodeError');

    // Allow only numeric input and limit to 5 characters
    input.value = input.value.replace(/[^0-9]/g, '').substring(0, 5);

    if (input.value.length !== 5) {
        error.style.display = 'block';
        error.textContent = 'ZIP code must be exactly 5 digits.';
    } else {
        error.style.display = 'none';
    }
}


document.getElementById('guestEmail').addEventListener('input', function () {
    const emailInput = this;
    const emailError = document.getElementById('emailError');
    const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;

    if (emailPattern.test(emailInput.value)) {
        emailError.style.display = 'none';
    } else {
        emailError.style.display = 'block';
    }
});


document.addEventListener('DOMContentLoaded', function () {
    const createAccountCheckbox = document.getElementById('createAccount');
    const passwordFields = document.getElementById('passwordFields');
    const confirmPasswordFields = document.getElementById('confirmPasswordFields');

    // Toggle visibility of password fields
    createAccountCheckbox.addEventListener('change', function () {
        if (this.checked) {
            passwordFields.classList.remove('hidden');
            confirmPasswordFields.classList.remove('hidden');
        } else {
            passwordFields.classList.add('hidden');
            confirmPasswordFields.classList.add('hidden');
        }
    });

    // Toggle password visibility for password and confirm password fields
    const togglePasswordIcon = document.getElementById('togglePassword');
    const toggleConfirmPasswordIcon = document.getElementById('toggleConfirmPassword');

    togglePasswordIcon.addEventListener('click', function () {
        togglePasswordVisibility('password', this);
    });

    toggleConfirmPasswordIcon.addEventListener('click', function () {
        togglePasswordVisibility('confirmPassword', this);
    });

    function togglePasswordVisibility(fieldId, icon) {
        const input = document.getElementById(fieldId);
        if (input.type === 'password') {
            input.type = 'text'; // Show password
            icon.textContent = 'visibility_off'; // Switch to 'visibility_off' icon
        } else {
            input.type = 'password'; // Hide password
            icon.textContent = 'visibility'; // Switch back to 'visibility' icon
        }
    }

    // Validate password complexity
    document.getElementById('password').addEventListener('input', function () {
        const error = document.getElementById('passwordError');
        const passwordPattern = /^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;

        if (!passwordPattern.test(this.value)) {
            error.style.display = 'block';
        } else {
            error.style.display = 'none';
        }
    });

    // Confirm password match
    document.getElementById('confirmPassword').addEventListener('input', function () {
        const confirmPasswordError = document.getElementById('confirmPasswordError');
        const password = document.getElementById('password').value;

        if (this.value !== password) {
            confirmPasswordError.style.display = 'block';
        } else {
            confirmPasswordError.style.display = 'none';
        }
    });
});



document.addEventListener('DOMContentLoaded', function () {
    const subtotalElement = document.getElementById('subtotal');
    const tipOptions = document.querySelectorAll('.tip-option');
    const customTipInput = document.getElementById('customTip');

    // Store the original subtotal
    let originalSubtotal = parseFloat(subtotalElement.textContent) || 0;

    // Function to display the tip amount
    function displayTipAmount(tipAmount) {
        tipOptions.forEach(option => {
            const percent = option.getAttribute('data-percent');
            if (percent) {
                const calculatedTip = (originalSubtotal * parseInt(percent) / 100).toFixed(2);
                option.querySelector('.amount').textContent = calculatedTip;
            }
        });
    }

    // Update the total including tip
    function updateTotal(tipAmount = 0) {
        const totalIncludingTip = originalSubtotal + tipAmount; // Add tip to the original subtotal
        subtotalElement.textContent = totalIncludingTip.toFixed(2); // Update total in the UI
    }

    // Select a tip percentage
    function selectTip(element) {
        // Reset all options and hide custom tip input
        tipOptions.forEach(option => option.classList.remove('selected'));
        customTipInput.classList.add('hidden');

        // Highlight selected tip option
        element.classList.add('selected');

        // Calculate the tip amount
        const tipPercent = parseInt(element.getAttribute('data-percent'), 10);
        const tipAmount = (originalSubtotal * tipPercent) / 100;

        // Update the total
        updateTotal(tipAmount);
    }

    // Show the custom tip input
    function showCustomTipInput() {
        // Reset all options and show custom tip input
        tipOptions.forEach(option => option.classList.remove('selected'));
        customTipInput.classList.remove('hidden');
        customTipInput.value = ''; // Reset input field
        customTipInput.focus(); // Focus on input
    }

    // Handle custom tip input
    customTipInput.addEventListener('input', function () {
        const customTipAmount = parseFloat(this.value) || 0;
        updateTotal(customTipAmount);
    });

    // Set default value for custom tip input on blur
    customTipInput.addEventListener('blur', function () {
        if (!this.value.trim()) {
            this.value = '0.00'; // Display 0.00 if left empty
            updateTotal(0); // Ensure no tip is added
        }
    });

    // Attach click event to tip options
    tipOptions.forEach(option => {
        if (!option.classList.contains('other')) {
            option.addEventListener('click', function () {
                selectTip(this);
            });
        } else {
            option.addEventListener('click', showCustomTipInput);
        }
    });

    // Initialize tip amounts and total on page load
    displayTipAmount(0); // Display the initial tip amounts
    updateTotal();
});
document.addEventListener("DOMContentLoaded", function () {
    const creditCardFields = ["cardName", "cardNumber", "expiryDate", "cvv", "zipCode"];
    const submitButton = document.getElementById("submitButton");

    // Function to validate Credit Card Form
    function validateCreditCardForm() {
        let allFilled = true;

        creditCardFields.forEach((fieldId) => {
            const input = document.getElementById(fieldId);
            if (input.value.trim() === "") {
                allFilled = false;
            }
        });

        // Enable or disable the submit button based on validation
        submitButton.disabled = !allFilled;
    }

    // Add event listeners to credit card fields for validation
    creditCardFields.forEach((fieldId) => {
        const input = document.getElementById(fieldId);
        input.addEventListener("input", validateCreditCardForm);
    });

    // Initial validation check
    validateCreditCardForm();
});


document.addEventListener("DOMContentLoaded", function () {
    const TAX_RATE = 0.07;
    const subtotalElement = document.getElementById('total-amount');
    const taxElement = document.getElementById('tax');
    const tipOptions = document.querySelectorAll('.tip-option');
    const customTipInput = document.getElementById('customTip');
    let subtotal = 0;

    // Calculate subtotal from cart items and update tax
    function calculateSubtotal() {
        const items = JSON.parse(localStorage.getItem('cartItems')) || [];
        subtotal = items.reduce((sum, item) => sum + item.itemPrice * item.quantity, 0);
        const tax = subtotal * TAX_RATE;
        taxElement.textContent = tax.toFixed(2);
        return subtotal + tax;
    }

    // Update the total amount (including tip)
    function updateTotalWithTip(tipAmount = 0) {
        const total = calculateSubtotal() + tipAmount;
        subtotalElement.textContent = total.toFixed(2);
    }

    // Initialize tip values
    function initializeTips() {
        tipOptions.forEach(option => {
            const percent = option.getAttribute('data-percent');
            if (percent) {
                const calculatedTip = (subtotal * parseInt(percent) / 100).toFixed(2);
                option.querySelector('.amount').textContent = calculatedTip;
            }
        });
    }

    // Handle tip selection
    function selectTip(option) {
        // Reset selected state and hide custom input
        tipOptions.forEach(opt => opt.classList.remove('selected'));
        customTipInput.classList.add('hidden');

        // Highlight selected option
        option.classList.add('selected');
        const percent = option.getAttribute('data-percent');
        const tipAmount = percent ? (subtotal * parseFloat(percent) / 100) : 0;
        updateTotalWithTip(tipAmount);
    }

    // Handle custom tip input
    customTipInput.addEventListener('input', function () {
        const customTip = parseFloat(this.value) || 0;
        updateTotalWithTip(customTip);
    });

    customTipInput.addEventListener('focus', function () {
        tipOptions.forEach(opt => opt.classList.remove('selected'));
        customTipInput.classList.remove('hidden');
    });

    // Attach event listeners to tip options
    tipOptions.forEach(option => {
        if (!option.classList.contains('other')) {
            option.addEventListener('click', function () {
                selectTip(option);
            });
        } else {
            option.addEventListener('click', function () {
                customTipInput.classList.remove('hidden');
                customTipInput.focus();
            });
        }
    });

    // Initialize the page
    calculateSubtotal();
    initializeTips();
    updateTotalWithTip();
});


</script>


</body>
</html>
