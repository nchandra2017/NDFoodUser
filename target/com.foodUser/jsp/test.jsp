<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map, java.util.List, java.util.LinkedHashMap" %>

<%
    if (request.getAttribute("userOrders") == null) {
        request.getRequestDispatcher("/OrdersServlet?page=user_orders").forward(request, response);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Orders</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/user_orders.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">

</head>
<%@ include file="/jsp/Navigation.jsp" %>
<body>
   
       
       
 <div class="search-bar">
    <div class="search-input-container">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" placeholder="Search order by order number" class="order-search">
    </div>
    <button class="search-btn">Search Order</button>
</div>

    
 <div class="top-bar">
 <h1>Your Orders</h1>
    </div>

        <!-- Order List -->
        <div class="order-list">
            <%
                List<Map<String, Object>> userOrders = (List<Map<String, Object>>) request.getAttribute("userOrders");

                if (userOrders != null && !userOrders.isEmpty()) {
                    Map<String, List<Map<String, Object>>> groupedOrders = new LinkedHashMap<>();
                    for (Map<String, Object> order : userOrders) {
                        String uniqueOrderId = (String) order.get("uniqueOrderId");
                        groupedOrders.putIfAbsent(uniqueOrderId, new java.util.ArrayList<>());
                        groupedOrders.get(uniqueOrderId).add(order);
                    }

                    for (Map.Entry<String, List<Map<String, Object>>> entry : groupedOrders.entrySet()) {
                        String uniqueOrderId = entry.getKey();
                        List<Map<String, Object>> items = entry.getValue();
                        Map<String, Object> firstItem = items.get(0);

                        // Use session attributes directly
                        
                        String userLastName = (String) session.getAttribute("userLastName");
                        String orderTime = (String) firstItem.get("orderTime");
                        String orderDate = (String) firstItem.get("orderDate");
                        String orderAddress = (String) firstItem.get("orderAddress");
                        String deliveryType = (firstItem.get("deliveryDate") != null) ? "Delivery" : "Pickup";
                        double totalAmount = (double) firstItem.get("totalAmount");
            %>
               </div>
                <!-- Order Card -->
                <div class="order-card">
                    <!-- Order Details Bar -->
                    <div class="order-bar">
                        <div class="order-column">
                            <strong>ORDER PLACED</strong>
                            <div><%= orderDate %></div>
                        </div>
                        
                        <div class="order-column">
                            <strong>TOTAL</strong>
                            <div>$<%= totalAmount %></div>
                        </div>
                        <div class="order-column">
                            <strong>PICKUP/DELIVERY TO</strong>
                            <div><%= userFirstName  %>
                            <i class="fa-sharp fa-solid fa-angle-down toggle-icon" onclick="toggleAddress(this)"></i>
                            </div> 
                            <div class="order-address" style="display: none;"><%= orderAddress %></div>
                            
                        </div>
                        <div class="order-column">
                            <strong>ORDER TYPE</strong>
                            <div><%= deliveryType + "-"+"Time To -" + orderTime %></div>
                        </div>
                        <div class="order-column">
                            <strong>ORDER ID#</strong>
                            <div><%= uniqueOrderId %></div>
                        </div>
                    </div>
                    <!-- Order Summary -->
                    <div class="order-summary">
                        <h4>Order Summary</h4>
                        
                        <ul>
                            <%
                                for (Map<String, Object> item : items) {
                                    String itemName = (String) item.get("itemName");
                                    int quantity = (int) item.get("quantity");
                            %>
                                <li><%= itemName %> x <%= quantity %></li>
                            <%
                                }
                            %>

                        </ul>
                     
                     </div>
                     <div class="order-status">
    <h3>Order Status</h3>
    <div>Status: <span style="color: green;">Processing</span></div>
</div>
                    <!-- Buttons -->
                    <div class="buttons">
                        <button class="track-btn" onclick="trackOrder('<%= uniqueOrderId %>')">Track Orders</button>
                        <button class="cancel-btn" onclick="cancelOrder('<%= uniqueOrderId %>')">Cancel Orders</button>
                        <button class="note-btn" onclick="addNoteForOrder('<%= uniqueOrderId %>')">Note for Orders</button>
                    </div>
                
            <%
                    }
                } else { 
            %>
                <div class="no-orders">No orders found!</div>
            <% } %>
        </div>

   
<%@ include file="/jsp/footer.jsp" %>
    <script>
    function toggleAddress(icon) {
        const addressElement = icon.parentElement.nextElementSibling;
        if (addressElement.style.display === 'none') {
            addressElement.style.display = 'block';
            icon.classList.remove('fa-angle-down');
            icon.classList.add('fa-angle-up');
        } else {
            addressElement.style.display = 'none';
            icon.classList.remove('fa-angle-up');
            icon.classList.add('fa-angle-down');
        }
    }
        function trackOrder(orderId) {
            alert('Tracking order: ' + orderId);
        }

        function cancelOrder(orderId) {
            alert('Cancelling order: ' + orderId);
        }

        function addNoteForOrder(orderId) {
            alert('Adding note for order: ' + orderId);
        }
    </script>
</body>
</html>