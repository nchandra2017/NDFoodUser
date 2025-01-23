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


       /* Base Styles */
body {
    font-family: Arial, sans-serif;
    background-color: #f4f4f4;
    margin: 0;
    padding: 20px;
}

/* Category Container Styles */
.category-container {
    display: flex;
    align-items: center;
    margin-bottom: 30px;
}

.category-container img {
    width: 150px;
    height: 150px;
    border-radius: 8px;
    margin-right: 2px;
}

.category-container h2 {
    font-size: 28px;
    color: #061668;
}

/* Item Container Styles */
.item-container {
    background-color: #f4f4f4;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.1);
    max-width: 800px;
    margin: 5px auto; /* Center align the item container */
    margin-bottom: 20px;
}

.item-header {
    margin-bottom: 20px;
}

.item-header h3 {
    margin: 0;
    font-size: 22px;
    color: #2a2a2a;
    font-weight: bold;
}

/* Item Details */
.item-details {
    font-size: 16px;
    color: #555;
     gap: 10px;
     display: flex;
    align-items: center;
     
    margin-bottom: 20px;
}

.item-details .price {
    font-size: 18px;
    font-weight: bold;
    color: #2a2a2a;
    margin-right: 10px;
}

.item-details .description {
    font-size: 14px;
    color: #555;
    flex-grow: 1;
}

/* Add to Order Button */
.add-to-order-btn {
    background-color: white;
    color: red;
    border: 1px solid blue;
    padding: 5px 10px;
    border-radius: 5px;
    font-size: 16px;
    cursor: pointer;
    transition: background-color 0.5s ease;
    display: flex;
    align-items: center;
    margin-top: 20px;
}

.add-to-order-btn:hover {
    background-color: #CC1936;
}

.add-to-order-btn i {
    margin-right: 10px;
    color: blue;
}
/* Mobile Styles */
@media (max-width: 768px) {
    /* Remove padding and margins for mobile */
    body {
        padding: 0;
        margin: 0;
    }

   .category-container {
   margin-top:80px;
    display: flex;
    flex-direction: column; /* Stack image and text vertically */
    align-items: center; /* Center-align image and text */
    text-align: center; /* Align the text centrally */
}

.category-container img {
    width: 90%; /* Adjust as needed */
    height: auto;
    margin-bottom: 10px; /* Add space between image and text */
}

.category-container h2 {
    font-size: 20px;
    margin: 0; /* Remove extra margin if any */
}


    /* Full-width Item Container */
    .item-container {
        max-width: 100%;
        margin: 20px 20px;
        padding: 15px;
    }

    /* Adjust Item Header and Details */
    .item-header h3 {
        font-size: 16px;
        
    }
   

    .item-details .price,
    .item-details .description {
        font-size: 14px;
    }

   .add-to-order-btn {
    font-size: 14px;
    padding: 5px 7px;
    margin-left: auto; 
}


    /* Image and Iframes */
    .image {
        margin-top: 0;
        padding-top: 0;
    }

    #category-frame, #items-frame {
        margin-top: 0;
        padding: 0;
        width: 100%;
    }

    /* Iframe Container */
    .iframe-container {
        padding-top: 0;
    }

    /* Hamburger Button Positioning */
    #hamburger-btn {
        margin-top: 0;
        top: 10px;
        position: absolute;
        left: 15px;
        display: block;
    }
}
    
       /* Popup Overlay */
.popup-overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: none; /* Initially hidden */
    justify-content: center;
    align-items: flex-start; /* Align content at the top */
    z-index: 9999;
    padding-top: 20px; /* Optional: add padding for spacing from top */
    overflow-y: auto; /* Enable scrolling if content is longer than screen */
}

/* Popup Content */
.popup-content {
    background: white;
    padding: 20px;
    border-radius: 10px;
    max-width: 400px;
    width: 90%;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    text-align: center;
    position: relative;
    margin-left: -200px;
}


        /* Close Button */
        .close-btn {
            position: absolute;
            top: 10px;
            right: 15px;
            font-size: 18px;
            cursor: pointer;
        }

        /* Category Image in Popup */
        #popup-category-image {
            width: 100%;
            max-height: 150px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        /* Popup Item Name */
        #popup-item-name {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-bottom: 10px;
        }

        /* Popup Item Description */
        #popup-item-description {
            font-size: 10px;
            color: #555;
            margin-bottom: 20px;
        }

       /* Allergies Section */
.allergies-section {
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 10px;
    font-weight: bold;
    color: red;
    border-bottom: 1px solid #ddd;
    padding-bottom: 10px;
    margin-bottom: 15px;
}

.allergies-section label {
    margin-right: 10px; /* Space between label and checkbox */
}

.allergies-section input[type="checkbox"] {
    width: 15px;
    height: 15px;
    border-radius: 50%; /* Makes the checkbox round */
    appearance: none; /* Remove default checkbox styling */
    -webkit-appearance: none; /* For Safari */
    background-color: white;
    border: 2px solid blue; /* Customize border color */
    cursor: pointer;
    position: relative;
}

.allergies-section input[type="checkbox"]:checked {
    background-color: blue; /* Color when checked */
    border: 2px solid red; /* Keep the same border */
}

.allergies-section input[type="checkbox"]:checked::after {
    content: '';
    position: center;
    width: 15px;
    height: 15px;
    border-radius: 50%;
    background-color: red; /* Inner circle color */
}
/* Allergen Notice Section */
#allergen-notice {
    display: flex;
    flex-direction: column;
    font-size: 10px;
    font-weight: bold;
    color: red;
    border-bottom: 1px solid #ddd;
    padding-bottom: 10px;
    margin-bottom: 15px;
}

/* Container for label and checkbox on the same line */
#allergen-notice .notice-label-row {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-bottom: 5px;
}

#allergen-notice .notice-label-row label {
    font-weight: bold;
    color: red;
}

#allergen-notice .description-box {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    padding: 10px;
    width: 90%; /* Set width for green box */
    border: 2px solid green; /* Green border around the text */
    border-radius: 10px;
    background-color: #f9f9f9;
    font-weight: bold;
    font-size: 10px;
    position: relative; /* Enables positioning of checkbox */
}

/* Style for the red "Required - Select 1" text */
#allergen-notice .description-box p:first-child {
    color: red;
    margin: 0;
    margin-bottom: 5px; /* Space between paragraphs */
    font-size: 10px;
}

/* Style for the black main description text */
#allergen-notice .description-box p:last-child {
    color: black;
    font-weight: normal;
    margin: 0;
    font-size: 10px;
}

/* Checkbox Style */
#allergen-notice input[type="checkbox"] {
    width: 15px;
    height: 15px;
    border-radius: 50%; /* Makes the checkbox round */
    appearance: none; /* Remove default checkbox styling */
    -webkit-appearance: none; /* For Safari */
    background-color: white;
    border: 2px solid blue; /* Customize border color */
    cursor: pointer;
    position: relative;
    margin-left: 10px;
}

#allergen-notice input[type="checkbox"]:checked {
    background-color: blue; /* Color when checked */
    border: 2px solid red;
}

#allergen-notice input[type="checkbox"]:checked::after {
    content: '';
    position: absolute;
    border-radius: 50%;
    background-color: white; /* Inner circle color */
}


/* Additional Info Section */
.additional-info {
    display: flex;
    align-items: center;
    margin-top: 15px;
    font-size: 8px;
    color: #333;
}

.additional-info label {
    margin-right: 10px; /* Space between label and input in desktop view */
    font-weight: bold;
    font-size: 15px;
    color: black; /* Color of the label text */
}

.additional-info input[type="text"] {
    padding: 8px 12px;
    font-size: 14px;
    border: 1px solid #ddd;
    border-radius: 5px; /* Rounded corners */
    outline: none;
    transition: border-color 0.3s ease; /* Smooth border transition */
    width: 100%;
    max-width: 200px; /* Adjust width as needed */
}

.additional-info input[type="text"]::placeholder {
    color: #999; /* Placeholder color */
}

.additional-info input[type="text"]:focus {
    border-color: #007BFF; /* Change border color on focus */
}

/* Mobile View Adjustments */
@media (max-width: 768px) {
    .additional-info {
        flex-direction: column; /* Stack label above input */
        align-items: flex-start;
    }

    .additional-info label {
        margin-bottom: 5px; /* Space between label and input field in mobile view */
        margin-right: 0; /* Remove right margin */
    }

    .additional-info input[type="text"] {
        width: 100%; /* Full width for mobile view */
        max-width: 95%; /* Remove max-width for mobile */
    }
}




/* Order Bar with Quantity Controls */
.order-bar {
    background-color: #ccc; /* Initially greyed out */
    color: #fff;
    padding: 10px 20px;
    font-size: 16px;
    border-radius: 5px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    cursor: not-allowed; /* Initially not clickable */
     margin-top: 15px;
}

.order-bar.enabled {
    background-color: blue; /* Active color */
    cursor: pointer; /* Pointer when enabled */
}



.quantity-btn {
    cursor: pointer;
    font-size: 18px;
    padding: 0 10px;
}

#total-price {
    font-weight: bold;
}

/* Quantity Input */
#quantity {
    font-size: 16px;
    margin: 0 10px;
}







.cart-overlay {
    position: fixed;
    top: 0;
    right: 0;
    width: 300px;
    height: 100%;
    background-color: #fff;
    box-shadow: -2px 0px 5px rgba(0, 0, 0, 0.5);
    transform: translateX(100%);
    transition: transform 0.3s ease-in-out;
    display: flex;
    flex-direction: column;
    z-index: 100;
}

.cart-content {
    padding: 20px;
    overflow-y: auto;
    height: 100%;
}

#cart-items-container {
    flex-grow: 1;
}

.cart-total {
    margin-top: auto;
    font-size: 18px;
    font-weight: bold;
}

.checkout-btn {
    background-color: blue;
    color: white;
    padding: 10px;
    width: 100%;
    border: none;
    cursor: pointer;
}

.close-btn {
    cursor: pointer;
    color: #555;
    font-size: 18px;
    float: right;
}

.cart-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 10px 0;
    border-bottom: 1px solid #ddd;
}

.cart-item-name {
    flex: 1;
}

.cart-item-quantity {
    display: flex;
    align-items: center;
}

.cart-item-price {
    font-weight: bold;
    color: green;
}
/* Popup Content - Adjustments for Mobile View */
@media (max-width: 768px) {
    .popup-content {
    max-width: 90%; /* Reduce width for mobile view */
    width: auto; /* Allow full width */
    padding: 15px; /* Add padding for mobile */
    margin: 40px auto; /* Center the popup and push it down */
    position: relative; /* Ensure the element respects margins */
    top: 20px; /* Move the popup box a little down */
}

    #popup-category-image {
        max-width: 100%; /* Ensure the image is responsive */
        height: auto; /* Adjust height automatically */
    }

    #popup-item-name {
        font-size: 20px; /* Slightly smaller font for mobile */
        margin-bottom: 8px;
    }

    #popup-item-description {
        font-size: 12px; /* Adjust font size for mobile */
    }

   .allergies-section {
        display: flex;
       
        justify-content: space-between; /* Space out the label and checkbox */
        font-size: 12px; /* Adjust the font size for mobile */
        width: 100%; /* Ensure it takes full width */
        padding: 5px; /* Adjust padding */
        margin-bottom: 10px; /* Adjust spacing */
    }

    .allergies-section label {
        flex: 1; /* Take available space */
        margin-right: 150px; /* Space between label and checkbox */
    }

    .allergies-section input[type="checkbox"] {
        width: 18px; /* Set the checkbox width */
        height: 18px; /* Set the checkbox height */
        margin-left: auto; /* Push the checkbox to the right */
        cursor: pointer; /* Add pointer cursor for checkbox */
    }
    .quantity-btn {
        font-size: 14px; /* Adjust font size for mobile */
        padding: 5px; /* Adjust padding for smaller buttons */
    }

    .order-bar {
        font-size: 14px; /* Adjust font size */
        padding: 8px 15px; /* Adjust padding */
        justify-content: space-between; /* Maintain space between elements */
    }

    /* Cart Overlay for Mobile */
    .cart-overlay {
        width: 100%; /* Full width for mobile */
        max-width: 400px; /* Limit width if needed */
        transform: translateX(0); /* Show cart when open */
    }

    /* Cart Items and Checkout Button */
    .cart-item {
        flex-direction: column; /* Stack items vertically */
        align-items: flex-start; /* Align items at the start */
    }

    .cart-item-quantity {
        justify-content: space-between;
        width: 100%;
        padding-top: 5px;
    }

    .checkout-btn {
        font-size: 14px; /* Adjust button size */
        padding: 12px;
    }
}


   

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
