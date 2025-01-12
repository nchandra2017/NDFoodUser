<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map, java.util.List, java.util.LinkedHashMap" %>

<%
    if (request.getAttribute("userOrdersList") == null) {
        request.getRequestDispatcher("/OrderPageServlet?orderPage=user_orders").forward(request, response);
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Orders</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/users_orders.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
</head>
<%@ include file="/jsp/Navigation.jsp" %>
<body>
     <div class="search-bar">
        <div class="search-input-container">
            <i class="fa-solid fa-magnifying-glass"></i>
            <input 
                type="text" 
                id="searchInput" 
                placeholder="Search order by order number" 
                class="order-search"
                oninput="formatOrderId(this)" 
                maxlength="13">
        </div>
        <button class="search-btn" onclick="searchOrder()">Search Order</button>
    </div>

    <div class="top-bar">
        <h1>Your Orders</h1>
    </div>

    <div class="order-list">
        <%
            List<Map<String, Object>> userOrdersList = (List<Map<String, Object>>) request.getAttribute("userOrdersList");

            if (userOrdersList != null && !userOrdersList.isEmpty()) {
                Map<String, List<Map<String, Object>>> groupedOrders = new LinkedHashMap<>();
                for (Map<String, Object> order : userOrdersList) {
                    String uniqueOrderId = (String) order.get("uniqueOrderId");
                    groupedOrders.putIfAbsent(uniqueOrderId, new java.util.ArrayList<>());
                    groupedOrders.get(uniqueOrderId).add(order);
                }

                for (Map.Entry<String, List<Map<String, Object>>> entry : groupedOrders.entrySet()) {
                    String uniqueOrderId = entry.getKey();
                    List<Map<String, Object>> items = entry.getValue();
                    Map<String, Object> firstItem = items.get(0);

                    String userLastName = (String) session.getAttribute("userLastName");
                    String orderDate = (String) firstItem.get("orderDate");
                    String orderTime = (String) firstItem.get("orderTime");
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
    <div class="toggle-container" onclick="toggleAddress(this)">
        <%= userFirstName %>
        <i class="fa-sharp fa-solid fa-angle-down toggle-icon"></i>
    </div>
    <div class="order-address" style="display: none;">
        <%= orderAddress %>
    </div>
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
   
    function toggleAddress(element) {
        // Find the next sibling of the clicked container
        const addressElement = element.nextElementSibling;

        if (!addressElement) {
            console.error('Address element not found.');
            return;
        }

        // Toggle the display of the address
        if (addressElement.style.display === 'none' || addressElement.style.display === '') {
            addressElement.style.display = 'block';
            const icon = element.querySelector('.toggle-icon');
            if (icon) {
                icon.classList.remove('fa-angle-down');
                icon.classList.add('fa-angle-up');
            }
        } else {
            addressElement.style.display = 'none';
            const icon = element.querySelector('.toggle-icon');
            if (icon) {
                icon.classList.remove('fa-angle-up');
                icon.classList.add('fa-angle-down');
            }
        }
    }

    function formatOrderId(inputElement) {
        // Remove any non-numeric characters except the dash (-)
        let value = inputElement.value.replace(/[^0-9]/g, '');

        // Add the dash after 8 digits
        if (value.length > 8) {
            value = value.slice(0, 8) + '-' + value.slice(8, 12);
        }

        // Update the input value
        inputElement.value = value;
    }
    function searchOrder() {
        const inputElement = document.getElementById('searchInput');
        if (!inputElement) {
            console.error('Search input element not found.');
            return;
        }

        const input = inputElement.value.trim().toLowerCase(); // Get user input
        const orders = document.querySelectorAll('.order-card'); // All order cards

        if (!/^\d{8}-\d{4}$/.test(input)) {
            // Ensure input matches the expected format (e.g., 00000000-0000)
            alert('Invalid Order ID format. Please enter a valid Order ID (e.g., 00000000-0000).');
            return;
        }

        let matchFound = false; // Track if a match is found

        orders.forEach(order => {
            // Get the Order ID from the respective card
            const orderIdElement = order.querySelector('.order-column:last-child div');
            if (!orderIdElement) return;

            const orderId = orderIdElement.innerText.trim().toLowerCase();

            if (orderId === input) {
                order.style.display = ''; // Show matching order
                matchFound = true;
            } else {
                order.style.display = 'none'; // Hide non-matching orders
            }
        });

        if (!matchFound) {
            alert(`No order found with ID: ${input}`);
        }
    }

  
    </script>
</body>
</html>