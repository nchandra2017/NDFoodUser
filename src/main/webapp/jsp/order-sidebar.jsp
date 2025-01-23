<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Sidebar</title>
    
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/order-sidebar.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/pickup-delivery.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
   <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/PickUpfrom.css"> 
   
<%@ page import="java.io.FileInputStream, java.util.Properties" %>
<%
    String googleMapsApiKey = "";
    try {
        // Specify the path to your config file
        String configFilePath = "C:/config/config.properties";
        Properties properties = new Properties();
        FileInputStream fis = new FileInputStream(configFilePath);
        properties.load(fis);
        fis.close();
        googleMapsApiKey = properties.getProperty("GOOGLE_MAPS_API_KEY", "");
        
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<script>
    const GOOGLE_MAPS_API_KEY = "<%= googleMapsApiKey %>";
    if (GOOGLE_MAPS_API_KEY) {
        const mapsScript = document.createElement('script');
        mapsScript.src = "https://maps.googleapis.com/maps/api/js?key=" + GOOGLE_MAPS_API_KEY + "&libraries=places&callback=initAutocomplete";
        mapsScript.async = true;
        mapsScript.defer = true;
        document.head.appendChild(mapsScript);
        console.log("Google Maps API Script Loaded:", mapsScript.src);
    } else {
        console.error("Google Maps API Key is missing!");
    }
</script>



 
 
  <style >
.pac-container {
    z-index: 10000 !important;
    position: absolute !important;
    width: 100% !important;
    max-width: 430px;
}
/* Responsive Styles for Mobile View */
@media screen and (max-width: 430px) {
    .modal-content {
        max-width: 90%; /* Adjust modal width */
        padding: 10px;
    }

    .form-group input,
    .form-group select {
        font-size: 12px; /* Adjust input font size */
    }

    .calendar-header {
        font-size: 14px; /* Smaller font size for header */
    }

    .calendar-days div {
        padding: 8px; /* Smaller padding for calendar days */
        font-size: 10px; /* Smaller font for better fit */
    }

    .close-popup-btn {
        font-size: 16px; /* Smaller close button */
    }

    .checkout-btn {
        font-size: 14px; /* Smaller font for button */
        padding: 8px 10px;
    }
}


  </style>


</head>
<body>

<div id="order-sidebar-dialog" class="dialog-box" style="display: none;">
    <div class="order-method">
        <div class="switch-container">
            <div id="pickupBtn" class="switch-button active" onclick="setOrderMethod('Pickup')">Pickup</div>
            <div id="deliveryBtn" class="switch-button" onclick="setOrderMethod('Delivery')">Delivery</div>
        </div>
    </div>

    <div id="order-method-message" class="order-method-message">
        <a href="#" id="pickup-delivery-link" onclick="handlePickupDeliveryClick()">
            <span class="delivery-or-pickup"></span> 
            <span class="date"></span>  
            <span class="time"></span> 
            <span class="address"></span>
        </a>
    </div>

    <div class="order-sidebar-content">
        <span class="close-btn" onclick="closeOrderSidebar()">X</span>
        <h2>Your Order</h2>
        <div id="order-list"></div>
        <div class="total-row">
    <span>Estimated sales tax 7%</span>
    <span>$<span id="tax">0.00</span></span>
</div>


<div class="delivery-row">
    <span class="delivery-fee-text">Delivery Fee  
     <img src="<%=request.getContextPath()%>/images/delivery-man.png" alt="Food Delivery Truck" class="delivery-truck">
     </span>
      <span>$<span id="deliveryFee">0.00</span></span>
    
     </div>






<div class="subtotal-row">
    <span>Total (Including Tax & Delivery Fee)</span>
    <span>$<span id="subtotal">0.00</span></span>
</div>

        <div class="checkout-btn-container">
            <button class="checkout-btn" id="proceed-btn" onclick="proceedToCheckout()">Proceed to Checkout</button>
        </div>
    </div>
</div>

<div id="orderModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close-popup-btn" onclick="closeOrderModal()">X</span>
        <h2 id="modal-title">Pickup or Delivery Details</h2>
        
         <div class="form-group" id="address-group" style="display: none;">
            <label for="order-address">Your Address</label>
            <input type="text" id="order-address" placeholder="Enter your address" autocomplete="off">

         </div>

        <div class="form-group">
            <label for="orderDate">Select Day:</label>
            <input type="text" id="orderDate" placeholder="MM-DD-YYYY" readonly
                onclick="openCalendar()" onchange="populateTimeOptions('orderDate', 'orderTime')">
        </div>

        <div id="date-picker-container" class="calendar-container" style="display: none;">
    <div class="calendar-header">
        <button id="prev-month" onclick="changeMonth(-1)">&#8249;</button>
        <span id="current-month"></span>
        <button id="next-month" onclick="changeMonth(1)">&#8250;</button>
    </div>
    <div id="calendar-days" class="calendar-days"></div>
</div>


        <div class="form-group">
            <label for="orderTime">Select Time:</label>
            <select id="orderTime">
                <option value="" disabled selected>Select Time</option>
            </select>
        </div>
        <div class="checkout-btn-container">
            <button class="checkout-btn" onclick="submitOrderDetails()">Update</button>
        </div>
    </div>
</div>


 <script>
 const TAX_RATE = 0.07;
 let items = [];
 let storeHours = {};
 let currentOrderMethod = "Pickup";
 let orderTypeSelected = false;

 // Google Maps Distance Matrix API setup
 let distanceService;

 document.addEventListener("DOMContentLoaded", function () {
     loadSavedItems();
     updateCartCount();
     renderOrderList();
     fetchStoreHours();
     initAutocomplete();
     initGoogleServices(); // Initialize Google Maps Distance API
     setMinDate();
 });



// Fetch Store Hours
function fetchStoreHours() {
	fetch('/com.foodUser/FetchStoreHoursServlet')
        .then(response => response.json())
        .then(data => {
            console.log("Fetched store hours:", data);
            storeHours = data;
        })
        .catch(error => console.error('Error fetching store hours:', error));
}



function setOrderMethod(method) {
    currentOrderMethod = method;

    // Update the active state for buttons
    document.getElementById("pickupBtn").classList.toggle("active", method === "Pickup");
    document.getElementById("deliveryBtn").classList.toggle("active", method === "Delivery");

    // Mark that the order type has been selected
    orderTypeSelected = true;

    // Reset delivery fee when Pickup is selected
    if (method === "Pickup") {
        localStorage.removeItem("deliveryFee"); // Clear the saved delivery fee
        document.getElementById("deliveryFee").innerText = "0.00"; // Reset UI
        document.querySelector(".delivery-row").style.display = "none"; // Hide delivery fee row
    } else if (method === "Delivery") {
        document.querySelector(".delivery-row").style.display = "flex"; // Show delivery fee row
    }

    // Open the modal based on the selected method
    openOrderModal();
}

function openCalendar() {
    const calendarContainer = document.getElementById('date-picker-container');
    if (calendarContainer) {
        calendarContainer.style.display = 'block'; // Show the calendar
        renderCalendar(new Date().getFullYear(), new Date().getMonth()); // Render the current month
    } else {
        console.error('Calendar container not found!');
    }
}
document.addEventListener('click', function (event) {
    const calendarContainer = document.getElementById('date-picker-container');
    const orderDateInput = document.getElementById('orderDate');
    if (!calendarContainer.contains(event.target) && event.target !== orderDateInput) {
        calendarContainer.style.display = 'none'; // Hide calendar
    }
});

const calendarDays = document.getElementById('calendar-days');
const currentMonth = document.getElementById('current-month');
const prevMonthButton = document.getElementById('prev-month');
const nextMonthButton = document.getElementById('next-month');

// Initialize variables
let selectedDate = new Date();
let currentYear = selectedDate.getFullYear();
let currentMonthIndex = selectedDate.getMonth();

function renderCalendar(year, month) {
    const today = new Date();
    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();

    calendarDays.innerHTML = ""; // Clear previous calendar days

    // Fill in days for the current month
    for (let day = 1; day <= daysInMonth; day++) {
        const currentDate = new Date(year, month, day);
        const isDisabled = currentDate < today.setHours(0, 0, 0, 0);

        const dayCell = document.createElement("div");
        dayCell.textContent = day;

        if (isDisabled) {
            dayCell.classList.add("disabled");
        } else {
            dayCell.classList.add("day-cell");
            dayCell.addEventListener("click", () => {
                selectDate(year, month, day); // Handle date selection
            });
        }

        calendarDays.appendChild(dayCell);
    }

    // Update the header
    const monthName = new Date(year, month).toLocaleString("default", { month: "long" });
    currentMonth.textContent = monthName + " " + year; 


    // Disable "prev" button if itâs before today
    prevMonthButton.disabled = new Date(year, month) < new Date(today.getFullYear(), today.getMonth(), 1);
}


function selectDate(year, month, day) {
    // Create a new Date object for the selected date
    const selectedDate = new Date(year, month, day);

    // Format the date as MM-DD-YYYY
    const formattedDate = formatDateToMMDDYYYY(selectedDate);

    // Set the value of the input field
    document.getElementById("orderDate").value = formattedDate;

    // Populate time options for the selected date
    populateTimeOptions("orderDate", "orderTime");

    // Close the calendar
    document.getElementById("date-picker-container").style.display = "none";

    console.log("Selected date set to:", formattedDate);
}




// Initialize the calendar when the DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    renderCalendar(currentYear, currentMonthIndex);
});

function openCalendar() {
    const calendarContainer = document.getElementById('date-picker-container');
    const orderDate = document.getElementById('orderDate');

    if (calendarContainer) {
        calendarContainer.style.display = 'block'; // Show the calendar
        const rect = orderDate.getBoundingClientRect(); // Get input field position
        calendarContainer.style.top = rect.bottom + 'px'; // Position below input
        calendarContainer.style.left = rect.left + 'px';

        renderCalendar(new Date().getFullYear(), new Date().getMonth());
    } else {
        console.error('Calendar container not found!');
    }
}
function changeMonth(direction) {
    const currentMonth = document.getElementById('current-month').textContent.split(" ");
    const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
    const year = parseInt(currentMonth[1]);
    const month = monthNames.indexOf(currentMonth[0]);

    const newDate = new Date(year, month + direction);
    renderCalendar(newDate.getFullYear(), newDate.getMonth());
}


function setMinDate() {
    console.log("setMinDate is invoked");

    const dateInput = document.getElementById("orderDate");
    const today = new Date();

    if (dateInput) {
        const year = today.getFullYear();
        const month = (today.getMonth() + 1).toString().padStart(2, "0");
        const day = today.getDate().toString().padStart(2, "0");

        const formattedMinDate = `${year}-${month}-${day}`; // YYYY-MM-DD format for HTML5 input

        dateInput.min = formattedMinDate; // Use `min` attribute for validation
        console.log("Min date set to:", formattedMinDate);
    } else {
        console.error("'orderDate' input not found");
    }
}

function formatDateToMMDDYYYY(date) {
    // Ensure that `date` is a valid Date object
    if (!(date instanceof Date) || isNaN(date)) {
        console.error("Invalid date provided:", date);
        return "";
    }

    const year = date.getFullYear();
    const month = (date.getMonth() + 1).toString().padStart(2, "0"); // Ensure 2-digit month
    const day = date.getDate().toString().padStart(2, "0"); // Ensure 2-digit day

    // Concatenate the date in MM-DD-YYYY format
    return month + "-" + day + "-" + year;
}



   function openOrderModal() {
	    const modalTitle = document.getElementById("modal-title");
	    const addressGroup = document.getElementById("address-group");

	    if (currentOrderMethod === "Pickup") {
	        modalTitle.innerText = "Pickup Details";
	        addressGroup.style.display = "none"; // Hide address for Pickup
	    } else {
	        modalTitle.innerText = "Delivery Details";
	        addressGroup.style.display = "block"; // Show address for Delivery
	    }

	    setMinDate(); // Ensure min date is always set when modal opens
	    document.getElementById("orderModal").style.display = "block";
	}


   function closeOrderModal() {
       document.getElementById("orderModal").style.display = "none";
   }
   
   
// Initialize Google Maps services
   function initGoogleServices() {
       distanceService = new google.maps.DistanceMatrixService();
   }

   // Calculate Delivery Fee
   function calculateDeliveryFee(userAddress) {
       if (!distanceService) {
           console.error("Google Maps Distance Matrix Service is not initialized.");
           return;
       }

       console.log("Calculating delivery fee for address:", userAddress);

       distanceService.getDistanceMatrix(
           {
               origins: ["5504 Cinderlane Pkwy, Orlando, FL"], // Store address
               destinations: [userAddress],
               travelMode: "DRIVING",
           },
           function (response, status) {
               if (status === "OK") {
                   console.log("Distance Matrix Response:", response); // Debug log for API response
                   const element = response.rows[0].elements[0];
                   if (element.status === "OK") {
                       const distance = element.distance.value / 1609.34; // Convert meters to miles
                       console.log("Distance in miles:", distance);

                       if (distance > 25) {
                           alert("Your address is outside our delivery area. Please choose Pickup.");
                           setOrderMethod("Pickup");
                           return;
                       }

                       const deliveryFee = distance * 2.50; // $2.50 per mile
                       console.log("Calculated Delivery Fee:", deliveryFee);

                       // Save and display the delivery fee
                       localStorage.setItem("deliveryFee", deliveryFee.toFixed(2));
                       const feeElement = document.getElementById("deliveryFee");
                       if (feeElement) {
                           feeElement.innerText = deliveryFee.toFixed(2);
                       } else {
                           console.error("Delivery Fee element not found in the DOM.");
                       }

                       // Update total calculation
                       renderOrderList();
                   } else {
                       console.error("Error with Distance Matrix element:", element.status);
                       alert("Unable to calculate delivery fee for the selected address.");
                   }
               } else {
                   console.error("Distance Matrix API error:", status);
                   alert("Error calculating delivery fee. Please try again.");
               }
           }
       );
   }

   
   

   function populateTimeOptions(dateSelectId, timeSelectId) {
	    const timeSelect = document.getElementById(timeSelectId);
	    const selectedDate = document.getElementById(dateSelectId).value;

	    timeSelect.innerHTML = "<option value='' disabled selected>Select Time</option>";

	    if (!selectedDate || !storeHours.morningOpeningTime || !storeHours.eveningOpeningTime) {
	        console.error("Store hours data is incomplete.");
	        return;
	    }

	    // Check if the selected date is a day when the store is closed
	    const selectedDay = new Date(selectedDate).getDay(); // 0 for Sunday, 1 for Monday, etc.
	    if (storeHours.closedDays && storeHours.closedDays.includes(selectedDay)) {
	        timeSelect.innerHTML = "<option value='' disabled selected>Store Closed Today</option>";
	        return;
	    }

	    const now = new Date();
	    const isToday = now.toDateString() === new Date(selectedDate).toDateString();
	    const bufferTime = new Date(now.getTime() + 45 * 60000); // Current time + 45 minutes buffer
	    const bufferHour = bufferTime.getHours();
	    const bufferMinute = bufferTime.getMinutes();
	    const timeIncrementMinutes = 15;

	    // Adjust store hours for +15 min after open and -15 min before close
	    const morningRange = {
	        startHour: parseInt(storeHours.morningOpeningTime.split(':')[0], 10),
	        startMinute: parseInt(storeHours.morningOpeningTime.split(':')[1], 10) + 15, // +15 minutes after open
	        endHour: parseInt(storeHours.morningClosingTime.split(':')[0], 10),
	        endMinute: parseInt(storeHours.morningClosingTime.split(':')[1], 10) - 15  // -15 minutes before close
	    };

	    const eveningRange = {
	        startHour: parseInt(storeHours.eveningOpeningTime.split(':')[0], 10),
	        startMinute: parseInt(storeHours.eveningOpeningTime.split(':')[1], 10) + 15, // +15 minutes after open
	        endHour: parseInt(storeHours.eveningClosingTime.split(':')[0], 10),
	        endMinute: parseInt(storeHours.eveningClosingTime.split(':')[1], 10) - 15  // -15 minutes before close
	    };

	    if (isToday) {
	        // Today: Apply buffer if it's within store hours
	        if (bufferHour < morningRange.endHour || (bufferHour === morningRange.endHour && bufferMinute <= morningRange.endMinute)) {
	            generateTimeOptions(
	                Math.max(bufferHour, morningRange.startHour), 
	                Math.max(bufferMinute, morningRange.startMinute), 
	                morningRange.endHour, 
	                morningRange.endMinute, 
	                timeSelect, 
	                timeIncrementMinutes
	            );
	        }
	        if (bufferHour < eveningRange.endHour || (bufferHour === eveningRange.endHour && bufferMinute <= eveningRange.endMinute)) {
	            generateTimeOptions(
	                Math.max(bufferHour, eveningRange.startHour), 
	                Math.max(bufferMinute, eveningRange.startMinute), 
	                eveningRange.endHour, 
	                eveningRange.endMinute, 
	                timeSelect, 
	                timeIncrementMinutes
	            );
	        }
	    } else {
	        // Future Days: Use standard adjusted store times
	        generateTimeOptions(morningRange.startHour, morningRange.startMinute, morningRange.endHour, morningRange.endMinute, timeSelect, timeIncrementMinutes);
	        generateTimeOptions(eveningRange.startHour, eveningRange.startMinute, eveningRange.endHour, eveningRange.endMinute, timeSelect, timeIncrementMinutes);
	    }
	}

	function generateTimeOptions(startHour, startMinute, endHour, endMinute, timeSelect, timeIncrementMinutes) {
	    for (let hour = startHour; hour <= endHour; hour++) {
	        for (let minutes = (hour === startHour ? startMinute : 0); minutes < 60; minutes += timeIncrementMinutes) {
	            if (hour > endHour || (hour === endHour && minutes >= endMinute)) {
	                return;
	            }

	            const period = hour >= 12 ? "PM" : "AM";
	            const displayHour = hour % 12 === 0 ? 12 : hour % 12;
	            const minuteString = minutes.toString().padStart(2, '0');
	            const timeString = displayHour + ":" + minuteString + " " + period;

	            const option = document.createElement("option");
	            option.value = timeString;
	            option.text = timeString;
	            timeSelect.appendChild(option);
	        }
	    }
	}



	function submitOrderDetails() {
	    const orderDate = document.getElementById('orderDate').value;
	    const orderTime = document.getElementById('orderTime').value;
	    let orderAddress;

	    // Set address based on the current order method
	    if (currentOrderMethod === "Pickup") {
	        // Fixed address for Pickup
	        orderAddress = "5504 Cinderlane Pkwy, Orlando, FL-32808";
	    } else if (currentOrderMethod === "Delivery") {
	        // Get user-provided address for Delivery
	        orderAddress = document.getElementById("order-address").value;

	        if (!orderAddress) {
	            alert("Please enter your delivery address!");
	            return;
	        }
	    }

	    // Validate date and time
	    if (!orderDate || !orderTime) {
	        alert("Please fill in all required fields!");
	        return;
	    }

	    // Convert the date to MM-DD-YYYY format (if needed)
	    const formattedDate = formatDateToMMDDYYYY(orderDate);

	    // Calculate delivery fee if the method is Delivery
	    if (currentOrderMethod === "Delivery") {
	        calculateDeliveryFee(orderAddress);
	    }

	    // Save order details in localStorage
	    localStorage.setItem("orderMethod", currentOrderMethod);
	    localStorage.setItem("orderDate", orderDate);
	    localStorage.setItem("orderTime", orderTime);
	    localStorage.setItem("orderAddress", orderAddress);

	    // Update UI with selected details
	    document.querySelector(".delivery-or-pickup").textContent = currentOrderMethod;
	    document.querySelector(".date").textContent = orderDate;
	    document.querySelector(".time").textContent = orderTime;
	    document.querySelector(".address").textContent = orderAddress;

	    document.getElementById("order-method-message").style.display = "block";

	    // Close the modal
	    closeOrderModal();
	}

	

	function initAutocomplete() {
	    const addressInput = document.getElementById("order-address");

	    if (!addressInput) {
	        console.error("Address input not found!");
	        return;
	    }

	    const autocomplete = new google.maps.places.Autocomplete(addressInput, {
	        types: ["address"],
	        componentRestrictions: { country: "us" },
	    });

	    // Ensure dropdown visibility on focus
	    addressInput.addEventListener("focus", () => {
	        setTimeout(() => {
	            addressInput.dispatchEvent(new Event("input"));
	        }, 300);
	    });

	    autocomplete.addListener("place_changed", () => {
	        const place = autocomplete.getPlace();
	        if (place && place.formatted_address) {
	            console.log("Selected Address:", place.formatted_address);
	            addressInput.value = place.formatted_address;
	        } else {
	            console.error("Invalid place selected.");
	        }
	    });
	}



	document.addEventListener("DOMContentLoaded", function () {
	    console.log("DOM fully loaded and parsed.");
	    initAutocomplete();
	});

   
   
   

	function closeOrderModal() {
	    const modal = document.getElementById("orderModal");
	    if (modal) {
	        modal.classList.add("fly-out"); // Add fly-out class
	        setTimeout(() => {
	            modal.style.display = "none";
	            modal.classList.remove("fly-out"); // Remove class after animation
	        }, 500); // Duration should match the animation duration (0.5s)
	    }
	}


   function loadSavedItems() {
       const savedItems = localStorage.getItem('cartItems');
       if (savedItems) {
           items = JSON.parse(savedItems);
           renderOrderList();
       }
   }

   function updateCartCount() {
	    const cartCountElement = document.getElementById("navbar-cart-count");
	    if (cartCountElement) {
	        const totalQuantity = items.reduce((sum, item) => sum + item.quantity, 0);
	        cartCountElement.innerText = totalQuantity; // Update count dynamically
	    }
	}




   function renderOrderList() {
	    const orderList = document.getElementById("order-list");
	    const cartItems = JSON.parse(localStorage.getItem('cartItems')) || []; // Always get latest items
	    const deliveryFeeElement = document.getElementById("deliveryFee");
	    const deliveryRow = document.querySelector(".delivery-row");
	    
	    orderList.innerHTML = ""; // Clear the current list

	 // If the cart is empty, reset totals and hide delivery fee row
	    if (cartItems.length === 0) {
	        orderList.innerHTML = "<p>Your cart is empty</p>";
	        document.getElementById("tax").innerText = "0.00";
	        document.getElementById("subtotal").innerText = "0.00";
	        deliveryFeeElement.innerText = "0.00";
	        deliveryRow.style.display = "none"; // Hide delivery fee row when the cart is empty
	        updateCartCount();
	        return;
	    }
	    
	    let subtotal = 0;

	    cartItems.forEach((item, index) => {
	        const itemTotal = (item.itemPrice * item.quantity).toFixed(2);
	        subtotal += parseFloat(itemTotal);

	        const itemElement = document.createElement("div");
	        itemElement.classList.add("order-item");
	        itemElement.innerHTML = `
              <div class="item-header">
                  <span>Item:  ` +  item.itemName + `</span>
                  <span class="delete-btn" onclick="removeItem(` + index + `)">
                      <i class="fas fa-trash-alt"></i>
                  </span>
              </div>
              <div class="quantity-controls">
                  <span>Add qty:</span>
                  <button onclick="changeQuantity(` + index + `, -1)">-</button>
                  <span id="item-quantity-` + index + `">` + item.quantity + `</span>
                  <button onclick="changeQuantity(` + index + `, 1)">+</button>
                  <span style="margin-left: auto;"> $` + parseFloat(item.itemPrice).toFixed(2) + `</span>
              </div>
          `;

          orderList.appendChild(itemElement);
      });

	 // Calculate and display tax
	    const tax = (subtotal * TAX_RATE).toFixed(2);
	    document.getElementById("tax").innerText = tax;

	    // Retrieve delivery fee from localStorage (default is 0)
	   // Check if the current order is for delivery
    let deliveryFee = 0.00;
    if (currentOrderMethod === "Delivery") {
        deliveryFee = parseFloat(localStorage.getItem("deliveryFee")) || 0.00;
        deliveryFeeElement.innerText = deliveryFee.toFixed(2); // Set the fee dynamically
        deliveryRow.style.display = "flex"; // Ensure the row is visible
    } else {
        deliveryFeeElement.innerText = "0.00"; // Reset fee for pickup
        deliveryRow.style.display = "none"; // Hide row for pickup
    }

	    // Calculate total (subtotal + tax + delivery fee)
	    const totalWithTaxAndDelivery = (subtotal + parseFloat(tax) + deliveryFee).toFixed(2);

	    // Update total in the UI
	    document.getElementById("subtotal").innerText = totalWithTaxAndDelivery;

	    // Update cart items in localStorage
	    localStorage.setItem("cartItems", JSON.stringify(cartItems));

	    // Update cart count in the UI
	    updateCartCount();
	}

   function changeQuantity(index, delta) {
       if (typeof items[index] !== 'undefined') {
           items[index].quantity += delta;
           if (items[index].quantity < 1) items[index].quantity = 1;
           renderOrderList();
       }
   }


   function removeItem(index) {
	    if (index >= 0 && index < items.length) {
	        items.splice(index, 1); // Remove the item at the given index
	        localStorage.setItem('cartItems', JSON.stringify(items)); // Update localStorage

	        renderOrderList(); // Immediately re-render the order list
	        updateCartCount(); // Immediately update the cart count in the navbar

	        // Check if the sidebar should be closed when empty
	        if (items.length === 0) {
	            closeOrderSidebar();
	        }
	    }
	}



   function openOrderSidebar() {
	    const dialog = document.getElementById("order-sidebar-dialog");
	    if (dialog) {
	        dialog.style.display = "block"; // Ensure visible
	        const content = dialog.querySelector(".order-sidebar-content");
	        if (content) {
	            content.classList.add("fly-in"); // Fly-in animation
	            setTimeout(() => content.classList.remove("fly-in"), 500); // Clear after animation
	        }
	    }
	}


	function closeOrderSidebar() {
	    const dialog = document.getElementById("order-sidebar-dialog");
	    const content = dialog.querySelector(".order-sidebar-content");
	    if (dialog) {
	        content.classList.add("fly-out"); // Add the fly-out animation class
	        setTimeout(() => {
	            dialog.style.display = "none";
	            content.classList.remove("fly-out"); // Remove the class after the animation completes
	        }, 500); // Match the animation duration
	    }
	}


	window.addEventListener("message", function(event) {
	    const data = event.data;
	    if (data.itemName && data.quantity && data.itemPrice) {
	        const existingItemIndex = items.findIndex(item => item.itemName === data.itemName);
	        if (existingItemIndex > -1) {
	            items[existingItemIndex].quantity += data.quantity;
	        } else {
	            items.push({
	                itemName: data.itemName,
	                itemPrice: parseFloat(data.itemPrice),
	                quantity: data.quantity,
	                specialNote: data.specialNote || "No special notes"
	            });
	        }
	        localStorage.setItem('cartItems', JSON.stringify(items));
	        renderOrderList();
	        updateCartCount();
	        openOrderSidebar(); // Ensure the sidebar opens
	    }
	});


   function submitPickupDetails() {
	    const pickupDate = document.getElementById('pickupDate').value; // Correct ID
	    const pickupTime = document.getElementById('timeSelect').value; // Correct ID

	    if (!pickupDate || !pickupTime) {
	        alert("Please select both Pickup Date and Time!");
	        return;
	    }

	    // Save order details to localStorage
	    localStorage.setItem('orderMethod', 'Pickup');
	    localStorage.setItem('orderDate', pickupDate);
	    localStorage.setItem('orderTime', pickupTime);
	    localStorage.setItem('orderAddress', '5504 Cinderlane Pkwy');

	    console.log('Order Method:', 'Pickup');
	    console.log('Order Date:', pickupDate);
	    console.log('Order Time:', pickupTime);
	    console.log('Order Address:', '5504 Cinderlane Pkwy');

	    // Update UI immediately
	    document.querySelector('.delivery-or-pickup').textContent = 'Pickup';
	    document.querySelector('.date').textContent = pickupDate;
	    document.querySelector('.time').textContent = pickupTime;
	    document.querySelector('.address').textContent = '-5504 Cinderlane Pkwy';

	    document.getElementById('order-method-message').style.display = 'block';

	    orderTypeSelected = true;
	    closePickupPopup();
	    enableProceedButton();
	}


// Submit Delivery Details
   function submitDeliveryDetails() {
       const deliveryAddress = document.getElementById('order-address').value;
       const deliveryDate = document.getElementById('orderDate').value;
       const deliveryTime = document.getElementById('orderTime').value;

       if (!deliveryAddress || !deliveryDate || !deliveryTime) {
           alert("Please fill in all fields!");
           return;
       }

       // Save delivery details
       localStorage.setItem("orderMethod", "Delivery");
       localStorage.setItem("orderDate", deliveryDate);
       localStorage.setItem("orderTime", deliveryTime);
       localStorage.setItem("orderAddress", deliveryAddress);

       console.log("Selected address:", deliveryAddress);

       // Calculate delivery fee based on the selected address
       calculateDeliveryFee(deliveryAddress);

       // Update UI
       document.querySelector('.delivery-or-pickup').textContent = "Delivery";
       document.querySelector('.date').textContent = deliveryDate;
       document.querySelector('.time').textContent = deliveryTime;
       document.querySelector('.address').textContent = deliveryAddress;

       document.getElementById("order-method-message").style.display = "block";
       orderTypeSelected = true;

       closeOrderModal();
   }



        function handlePickupDeliveryClick() {
            // Set modal title and visibility of address field based on current order method
            const modalTitle = document.getElementById("modal-title");
            const addressGroup = document.getElementById("address-group");

            if (currentOrderMethod === "Pickup") {
                modalTitle.innerText = "Edit Pickup Details";
                addressGroup.style.display = "none"; // Hide address for Pickup
            } else {
                modalTitle.innerText = "Edit Delivery Details";
                addressGroup.style.display = "block"; // Show address for Delivery
            }

            // Set previously selected values in modal fields
            document.getElementById('orderDate').value = localStorage.getItem('orderDate');
            document.getElementById('orderTime').value = localStorage.getItem('orderTime');
            if (currentOrderMethod === "Delivery") {
                document.getElementById('order-address').value = localStorage.getItem('orderAddress');
            }

            // Open the modal
            document.getElementById("orderModal").style.display = "block";
        }



        function enableProceedButton() {
            if (orderTypeSelected) {
                document.getElementById('proceed-btn').disabled = false;
            }
        }

      

        function openPickupPopup() {
            document.getElementById("pickupModal").style.display = "block";
        }

        function closePickupPopup() {
            document.getElementById("pickupModal").style.display = "none";
        }

        function openDeliveryPopup() {
            document.getElementById("deliveryModal").style.display = "block";
        }

        function closeDeliveryPopup() {
            document.getElementById("deliveryModal").style.display = "none";
        }
        function proceedToCheckout() {
            if (!orderTypeSelected || !localStorage.getItem('orderMethod')) {
                alert("Please select Pickup or Delivery before proceeding to checkout.");
                return;
            }

            // Redirect to the checkout page
            window.location.href = "/com.foodUser/jsp/PaymentStripe.jsp"; // Update path if necessary
        }

      


    </script>
</body>
</html>