<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javaPage.contol.CartItem, java.util.List, java.util.Map, java.util.ArrayList, java.util.HashMap" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Confirmation</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/OrderConfirmation.css">
</head>
<%@ include file="/jsp/Navigation.jsp" %>
<body>
<div class="confirmation-container">
    <h1 class="confirmation-title">Thank You for Your Order!</h1>
    <p class="thank-you-message">Your order has been successfully placed.</p>

   <%
    // Retrieve session attributes
    String uniqueOrderId = (String) session.getAttribute("uniqueOrderId");
    
    String userLastName = (String) session.getAttribute("userLastName");
    		Object totalAmountObj = session.getAttribute("totalAmount");
    		Double totalAmount = totalAmountObj != null ? Double.parseDouble(totalAmountObj.toString()) : 0.0;



    // Handle preserved cart items
    Object orderCartItemsObj = session.getAttribute("orderCartItems");
    List<CartItem> cartItems = new ArrayList<>();

    if (orderCartItemsObj instanceof List<?>) {
        List<?> tempList = (List<?>) orderCartItemsObj;
        for (Object item : tempList) {
            if (item instanceof Map<?, ?>) {
                Map<?, ?> rawMap = (Map<?, ?>) item;
                String itemName = (String) rawMap.get("itemName");
                double itemPrice = Double.parseDouble(rawMap.get("itemPrice").toString());
                int quantity = Integer.parseInt(rawMap.get("quantity").toString());
                cartItems.add(new CartItem(itemName, itemPrice, quantity));
            }
        }
    }
%>

<!-- Display user name -->
<p class="user-name">
    Name: 
    <span class="user-fullname">
        <%= (userFirstName != null && userLastName != null) 
            ? userFirstName + " " + userLastName 
            : "N/A" %>
    </span>
</p>

<!-- Display unique order ID -->
<p class="unique-order-id">
    Order ID: <span><%= uniqueOrderId != null ? uniqueOrderId : "N/A" %></span>
</p>

<!-- Order Summary -->
<h5 class="order-summary-title">Order Summary</h5>
<ul class="order-summary-list">
    <%
        if (!cartItems.isEmpty()) {
            for (CartItem item : cartItems) {
    %>
                <li class="order-summary-item">
                    <%= item.getItemName() %> x <%= item.getQuantity() %> - 
                    $<%= String.format("%.2f", item.getItemPrice() * item.getQuantity()) %>
                </li>
    <%
            }
        } else {
    %>
            <li class="no-items">No items found in your order.</li>
    <%
        }
    %>
</ul>

<!-- Display Total -->
<h3 class="order-total">Total: $<%= String.format("%.2f", totalAmount) %></h3>

<!-- Continue Shopping -->
<a class="continue-shopping" href="<%= request.getContextPath() %>/jsp/menu.jsp">Continue Shopping</a>

</div>

<%@ include file="/jsp/footer.jsp" %>

<script>
document.addEventListener("DOMContentLoaded", function () {
    // Immediately reset the cart count to 0 on page load
    localStorage.removeItem('cartItems');
    localStorage.setItem('cartCount', "0");

    const cartCountElement = document.querySelector('#navbar-cart-count');
    if (cartCountElement) {
        cartCountElement.innerText = "0";
    }
});
</script>

</body>
</html>
