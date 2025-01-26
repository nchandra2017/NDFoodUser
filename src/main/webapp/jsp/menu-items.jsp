<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, dataBasedConnection.DataBConnection" %>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <title>Menu Items</title>
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/menuItempage.css">
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/menu-category.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">



<style>


   

</style>
    <script>
   
    
    function openOrderPopup(itemName, itemPrice, itemDescription, categoryImage) {
        console.log("Opening popup with data:", JSON.stringify({ itemName, itemPrice, itemDescription, categoryImage }));

        document.getElementById("popup-item-name").innerText = itemName;
        document.getElementById("popup-item-price").innerText = itemPrice;
        document.getElementById("popup-item-description").innerText = itemDescription;
        document.getElementById("popup-category-image").src = categoryImage;

        // Reset to initial state when the popup is opened
        document.getElementById("quantity").innerText = 1;
        updateTotalPrice(1);

        // Show the Add to Cart button enabled by default
        const orderBar = document.getElementById("order-bar");
        orderBar.style.backgroundColor = "blue";  // Enable by default
        orderBar.style.pointerEvents = "auto";    // Enable clicking
        orderBar.style.cursor = "pointer";        // Change cursor to pointer

        // Reset allergen fields
        document.getElementById("allergen-notice").style.display = "none";  // Hide allergen notice initially
        document.getElementById("agree-checkbox").checked = false;          // Uncheck the agreement box
        document.getElementById("allergen-checkbox").checked = false;       // Uncheck Allergies? by default

        document.getElementById("order-popup").style.display = "flex";  // Show the popup
    }

    function closeOrderPopup() {
        document.getElementById("order-popup").style.display = "none";
    }

    function addToCartAndUpdateSidebar() {
        const itemName = document.getElementById("popup-item-name").innerText;
        const itemPrice = parseFloat(document.getElementById("popup-item-price").innerText);
        const quantity = parseInt(document.getElementById("quantity").innerText);
        const specialNote = document.getElementById("item-for").value || "No special notes";

        // Close the order popup window
        closeOrderPopup();

        // Send data to the order sidebar
        parent.postMessage({
            itemName: itemName,
            itemPrice: itemPrice,
            quantity: quantity,
            specialNote: specialNote // Missing comma fixed
        }, '*');

        // Update localStorage
        let cartItems = JSON.parse(localStorage.getItem('cartItems')) || [];
        cartItems.push({ itemName, itemPrice, quantity, specialNote });
        localStorage.setItem('cartItems', JSON.stringify(cartItems));
    }


    function toggleAllergenNotice() {
        const allergiesChecked = document.getElementById("allergen-checkbox").checked;
        const allergenNotice = document.getElementById("allergen-notice");
        const orderBar = document.getElementById("order-bar");

        if (allergiesChecked) {
            allergenNotice.style.display = "block";  // Show allergen notice if allergies are selected
            // Disable Add to Cart if allergies are checked
            orderBar.style.backgroundColor = "#ccc";  // Disable
            orderBar.style.pointerEvents = "none";    // Disable clicking
            orderBar.style.cursor = "not-allowed";    // Change cursor to not-allowed
        } else {
            allergenNotice.style.display = "none";   // Hide it if allergies are not selected
            // Enable Add to Cart if no allergies are checked
            orderBar.style.backgroundColor = "blue";  // Enable
            orderBar.style.pointerEvents = "auto";    // Enable clicking
            orderBar.style.cursor = "pointer";        // Change cursor to pointer
        }
    }


    function togglePrice() {
        const agreeChecked = document.getElementById("agree-checkbox").checked;
        const orderBar = document.getElementById("order-bar");
        const quantity = document.getElementById("quantity").innerText;

        if (agreeChecked) {
            updateTotalPrice(quantity);  // Update the total price
            orderBar.style.backgroundColor = "blue";  // Change the background to active state
            orderBar.style.pointerEvents = "auto";    // Enable clicking
            orderBar.style.cursor = "pointer";        // Set cursor to pointer
        } else {
            document.getElementById("total-price").innerText = "OPTIONS REQUIRED";  // Reset the total price
            orderBar.style.backgroundColor = "#ccc";  // Grey it out to indicate disabled
            orderBar.style.pointerEvents = "none";    // Prevent clicking
            orderBar.style.cursor = "not-allowed";    // Set cursor to not-allowed
        }
    }



    function toggleAllergyOptions() {
        const allergyOptions = document.getElementById("allergy-options");
        const agreeChecked = document.getElementById("agree-checkbox").checked;
        allergyOptions.style.display = agreeChecked ? "block" : "none";
    }

    function addAllergyToNotes() {
        const allergySelect = document.getElementById("allergy-select");
        const specialNoteInput = document.getElementById("item-for");
        const selectedAllergy = allergySelect.value;

        if (selectedAllergy) {
            const existingNotes = specialNoteInput.value;
            const newNotes = existingNotes ? existingNotes + ", " + selectedAllergy : selectedAllergy;
            specialNoteInput.value = newNotes;

            allergySelect.value = ""; 
        }
    }

    function increaseQuantity() {
        let quantity = parseInt(document.getElementById("quantity").innerText);
        quantity += 1;
        document.getElementById("quantity").innerText = quantity;
        updateTotalPrice(quantity);
    }

    function decreaseQuantity() {
        let quantity = parseInt(document.getElementById("quantity").innerText);
        if (quantity > 1) {
            quantity -= 1;
            document.getElementById("quantity").innerText = quantity;
            updateTotalPrice(quantity);
        }
    }

    function updateTotalPrice(quantity) {
        const itemPrice = parseFloat(document.getElementById("popup-item-price").innerText);
        const totalPrice = (itemPrice * quantity).toFixed(2);
        document.getElementById("total-price").innerText = totalPrice;
    }
    
    
    
</script>
</head>
<body>
   
<%

    String selectedCategory = request.getParameter("category"); // Get selected category from request
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = DataBConnection.getConnection();

        // Base query to get items
        String query = "SELECT c.category_name, c.category_image, i.item_name, i.item_price, i.item_description " +
                       "FROM categories c JOIN items i ON c.category_id = i.category_id";

        // If a category is selected, add a WHERE clause to filter items by that category
        if (selectedCategory != null && !selectedCategory.isEmpty()) {
            query += " WHERE c.category_name = ?";
        }

        pstmt = conn.prepareStatement(query);

        if (selectedCategory != null && !selectedCategory.isEmpty()) {
            pstmt.setString(1, selectedCategory); // Set the selected category in the query
        }

        rs = pstmt.executeQuery();

        String currentCategory = "";
        while (rs.next()) {
            String categoryName = rs.getString("category_name");
            String categoryImage = rs.getString("category_image");
            String itemName = rs.getString("item_name");
            String itemPrice = rs.getString("item_price");
            String itemDescription = rs.getString("item_description");

            // Display category header only when it changes
            if (!categoryName.equals(currentCategory)) {
                if (!currentCategory.isEmpty()) {
                    // Close the previous category's items container
                    out.println("</div>");
                }
                currentCategory = categoryName;

                // Display category header and image
%>
                <div class="category-container">
                    <img src="<%= request.getContextPath() + categoryImage %>" alt="<%= categoryName %>">
                    <h2><%= categoryName %></h2>
                </div>
                <div class="items-container">
                 </div>
<%
            }
%>
            <div class="item-container">
                <div class="item-header">
                    <h3><%= itemName %></h3>
                </div>
                <div class="item-details">
                    <span class="price">$<%= itemPrice %></span>
                    <span class="description"><%= itemDescription %></span>
                </div>
                <div>
                    <button class="add-to-order-btn" onclick="openOrderPopup('<%= itemName %>', '<%= itemPrice %>', '<%= itemDescription %>', '<%= request.getContextPath() + categoryImage %>')">
                        <i class="fas fa-shopping-cart"></i> Order Now
                    </button>
                </div>
            </div>
<%
        }
        if (!currentCategory.isEmpty()) {
            // Close the last category's items container
            out.println("</div>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error retrieving menu items.</p>");
    } finally {
        if (rs != null) rs.close();
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

    <!-- Include the Order Sidebar from separate JSP -->
    <%@ include file="/jsp/order-sidebar.jsp" %>

    <div id="order-popup" class="popup-overlay">
        <div class="popup-content">
            <span class="close-btn" onclick="closeOrderPopup()">X</span>
            <img id="popup-category-image" src="" alt="Category Image">
            <h2 id="popup-item-name"></h2>
            <p id="popup-item-description"></p>
            <div class="allergies-section">
                <label for="allergen-checkbox">Allergies? </label>
                <input type="checkbox" id="allergen-checkbox" onclick="toggleAllergenNotice()">
            </div>
            <div id="allergen-notice" style="display:none;">
                <div class="notice-label-row">
                    <label for="agree-checkbox">Allergen Notice Agreement</label>
                    <input type="checkbox" id="agree-checkbox" onclick="togglePrice(); toggleAllergyOptions();">
                </div>
                <div class="description-box">
                    <p style="color: red;">Required - Select 1</p>
                    <p>I agree that I’ve used Red Robin’s Interactive Allergen Menu (linked on the bottom of the Menu Page) to modify my menu selection.</p>
                </div>
                <div id="allergy-options" style="display: none; margin-top: 10px;">
                    <label for="allergy-select">Allergy Alert:</label>
                    <select id="allergy-select" onchange="addAllergyToNotes()">
                        <option value="" disabled selected>Select an allergy</option>
                        <option value="Gluten Allergy">Gluten Allergy</option>
                        <option value="Dairy Allergy">Dairy Allergy</option>
                        <option value="Tree Nut Allergy">Tree Nut Allergy</option>
                        <option value="No Onion/No Garlic">No Onion/No Garlic</option>
                        <option value="Vegan">Vegan</option>
                    </select>
                </div>
            </div>
            <p style="display: none;">Price: $<span id="popup-item-price"></span></p>
            <div class="additional-info">
                <label for="item-for">Any special note?</label>
                <input type="text" id="item-for" placeholder="Optional">
            </div>

            <div class="order-bar" id="order-bar" onclick="addToCartAndUpdateSidebar()">
                <div class="quantity-btn" onclick="decreaseQuantity(); event.stopPropagation();">
                    <i class="fas fa-minus"></i>
                </div>
                <span><span id="quantity">1</span> Add To Cart : $<span id="total-price">OPTIONS REQUIRED</span></span>
                <div class="quantity-btn" onclick="increaseQuantity(); event.stopPropagation();">
                    <i class="fas fa-plus"></i>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
