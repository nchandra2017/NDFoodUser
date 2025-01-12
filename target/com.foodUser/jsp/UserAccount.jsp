<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Account</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/UserAccount.css">
</head>
 <%@ include file="/jsp/Navigation.jsp" %>
<body>
    <div class="userAccount">
        <!-- Greeting Section -->
        <h6 class="user">Welcome, <%= session.getAttribute("userFirstName") %>!</h6>
        
       

        <h1 class="heading">Your Account</h1>
        <div class="grid">
            <!-- Card 1 -->
           <div class="card" onclick="location.href='<%=request.getContextPath()%>/jsp/user_order_page.jsp'">

             <i class="fas fa-box"></i>
             <h3>Your Orders</h3>
            <p>Track, return, cancel an order, or download invoices.</p>
             </div>

            <!-- Card 2 -->
            <div class="card" onclick="location.href='/profile'">
                <i class="fas fa-user"></i>
                <h4>Profile</h4>
                <p>Edit your login, name, and contact details.</p>
            </div>
            <!-- Card 3 -->
            <div class="card" onclick="location.href='/addresses'">
                <i class="fas fa-map-marker-alt"></i>
                <h4>Your Addresses</h4>
                <p>Manage your saved addresses.</p>
            </div>
            <!-- Card 4 -->
            <div class="card" onclick="location.href='/payments'">
                <i class="fas fa-credit-card"></i>
                <h4>Your Payments</h4>
                <p>Manage your payment methods and transactions.</p>
            </div>
            <!-- Card 5 -->
            <div class="card" onclick="location.href='/support'">
                <i class="fas fa-headset"></i>
                <h4>Customer Support</h4>
                <p>Contact support or browse help articles.</p>
            </div>
            <!-- Card 6 -->
            <div class="card" onclick="location.href='/messages'">
                <i class="fas fa-envelope"></i>
                <h4>Your Messages</h4>
                <p>View and respond to messages from the support team.</p>
            </div>
        </div>
    </div>
    
     <%@ include file="/jsp/footer.jsp" %>
</body>

</html>
