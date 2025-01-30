<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurant Landing Page</title>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/Navigation.css">
   
<style>



</style>
    
    
    
</head>

<body>
<!-- Navbar -->
<nav class="navbar">
    <div class="logo">
        <img src="<%=request.getContextPath()%>/images/R Logo.png" alt="Logo">
        <span class="logo-text">ND BENGALI FOOD</span>
    </div>
    
    <!-- Hamburger Icon for Mobile -->
    <div class="hamburger" id="hamburger">
        <i class="fas fa-bars"></i>
    </div>
    
    <ul class="navigation-links" id="navigationLinks">
        <% 
            String userFirstName = (String) session.getAttribute("userFirstName");
        %>
        <li class="account-dropdown">
            <% if (userFirstName != null) { %>
                <a href="<%=request.getContextPath()%>/jsp/UserAccount.jsp" class="account-link">
        <i class="fas fa-user"></i> Welcome, <%= userFirstName %> <i class="fas fa-caret-down"></i>
    </a>
                <div class="dropdown-content">
                    <a href="<%=request.getContextPath()%>/jsp/UserAccount.jsp">Your Account</a>
                    <a href="<%=request.getContextPath()%>/jsp/Orders.jsp">Your Orders</a>
                    <a href="<%=request.getContextPath()%>/jsp/Profile.jsp">Profile</a>
                    <a href="<%=request.getContextPath()%>/jsp/Addresses.jsp">Your Addresses</a>
                    <a href="<%=request.getContextPath()%>/jsp/Payments.jsp">Your Payments</a>
                    <a href="<%=request.getContextPath()%>/jsp/Support.jsp">Customer Support</a>
                    <a href="<%= request.getContextPath() %>/LogoutServlet">
                    <i class="fas fa-sign-out-alt"></i> Sign Out </a>
                </div>
                
            <% } else { %>
                <a href="<%=request.getContextPath()%>/jsp/SignIn.jsp">
                    <i class="fas fa-user"></i> Sign In
                </a>
            <% } %>
        </li>

        <li>
            <a href="#" id="navbar-cartLink" onclick="openOrderSidebar()">
                <i class="fas fa-shopping-cart"> <span id="navbar-cart-count">0</span></i> Your Order 
            </a>
            <%@ include file="/jsp/order-sidebar.jsp" %>
        </li>

        <li><a href="<%=request.getContextPath()%>/index.jsp">Home</a></li>
        <li><a href="<%=request.getContextPath()%>/jsp/SignUp.jsp">Sign Up</a></li>
        <li><a href="<%=request.getContextPath()%>/jsp/menu.jsp">Menu</a></li>
         <li><a href="<%=request.getContextPath()%>/jsp/contact.jsp">Contact</a></li>
         <li><a href="<%= request.getContextPath() %>/LogoutServlet" class="mobile-signout">
         <i class="fas fa-sign-out-alt"></i> Sign Out</a></li>
    </ul>    
</nav>

<script>
// Sidebar open and close functionality
function openOrderSidebar() {
    const sidebar = document.getElementById("order-sidebar-dialog");
    const content = sidebar.querySelector(".order-sidebar-content");
    sidebar.style.display = "block";
    content.classList.remove("fly-out");
}

function closeOrderSidebar() {
    const sidebar = document.getElementById("order-sidebar-dialog");
    const content = sidebar.querySelector(".order-sidebar-content");
    content.classList.add("fly-out");
    setTimeout(() => {
        sidebar.style.display = "none";
        content.classList.remove("fly-out");
    }, 500);
}

function changeQuantity(index, delta) {
    if (index >= 0 && index < items.length) {
        items[index].quantity += delta;
        if (items[index].quantity < 1) {
            items[index].quantity = 1;
        }
        localStorage.setItem('cartItems', JSON.stringify(items));
        renderOrderList();
        updateCartCount();
    } else {
        console.error("Invalid index:", index);
    }
}

document.addEventListener("DOMContentLoaded", function () {
    const hamburger = document.getElementById("hamburger");
    const navLinks = document.querySelector(".navigation-links");
    const body = document.querySelector("body");

    // Toggle navigation menu on hamburger click
    if (hamburger && navLinks) {
        hamburger.addEventListener("click", function (event) {
            event.stopPropagation(); // Prevent click from propagating to the body
            navLinks.classList.toggle("active");
        });

        // Close the navigation menu when clicking outside
        body.addEventListener("click", function (event) {
            if (!navLinks.contains(event.target) && !hamburger.contains(event.target)) {
                navLinks.classList.remove("active");
            }
        });
    } else {
        console.error("Hamburger or navigation-links element is missing.");
    }
});

function placeOrder(payload) {
    fetch("/PaymentServlet", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload) // payload contains order data
    })
    .then(response => response.json())
    .then(data => {
        if (data.clearCart) {
            // Clear cart from localStorage
            localStorage.removeItem('cartItems');
            localStorage.setItem('cartCount', "0");

            // Update cart count in the navigation bar
            document.querySelector('#navbar-cart-count').innerText = "0";
            console.log("Cart has been cleared successfully.");

            // Redirect to the Order Confirmation Page
            window.location.href = '/jsp/OrderConfirmation.jsp';
        } else if (data.error) {
            console.error("Error: " + data.error);
            alert("Failed to place the order. Please try again.");
        }
    })
    .catch(error => console.error('Error:', error));
}





</script>

</body>
</html>