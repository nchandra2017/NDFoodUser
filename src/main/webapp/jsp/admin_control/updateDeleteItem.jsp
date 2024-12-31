<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update/Delete Item</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/update.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/AdminPanel.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/ProfileStyle.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/AddAndDeleteForm.css">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/DeleteUpdateItem.css">
    
</head>
<body>

<h2>Update/Delete Item</h2>

<!-- Flex container for the forms -->
<div class="flex-container">
    <!-- Add New Item Form -->
    <div class="form-section-item">
        <h3>Add New Item</h3>
        <form id="addItemForm" enctype="multipart/form-data">
           
            <select id="addItemCategorySelect" name="category_for_item" required>
                <option value="" disabled selected>Select Category</option>
                <!-- Categories will be loaded via AJAX -->
            </select>
            <br><br>
           
            <input type="text" name="new_item_name" required placeholder="New Item Name:">
            <br><br>
            
            <input type="text" id="newItemPrice" name="new_item_price" required placeholder="Item Price: $10.99">
            <br><br>
           
            <textarea name="new_item_description" placeholder="Item Description:"></textarea>
            <br><br>
            <button type="button" onclick="submitAddItemForm()">Add Item</button>
        </form>
    </div>

    <!-- Delete/Update Item Form -->
    <div class="form-section-item">
        <h3>Delete/Update Item</h3>
        <form id="deleteItemForm" method="post" action="<%= request.getContextPath() %>/DeleteItemServlet" target="hidden_iframe" onsubmit="return confirmDelete();">
            
            <select id="deleteItemCategorySelect" name="category_for_delete_item" required>
                <option value="" disabled selected>Select Category</option>
                <!-- Categories will be loaded via AJAX -->
            </select>
            <br><br>
            
            <select id="itemSelect" name="itemId" required>
                <option value="" disabled selected>Select Item</option>
                <!-- Items will be loaded based on category via AJAX -->
            </select>
            <br><br>
            
            <input type="text" id="itemPrice" name="itemPrice" readonly placeholder="Item Price: $10.99">
            <br><br>
          
            <textarea id="itemDescription" name="itemDescription" readonly placeholder="Item Description:"></textarea>
            <br><br>
            
            <!-- Buttons container -->
            <div class="buttons-container">
                <button type="submit">Delete Item</button>
                <button type="button" id="enableUpdateBtn" onclick="enableUpdate()">Enable Update</button>
                <button type="button" id="updateItemBtn" style="display:none;" onclick="submitUpdateItem()">Update Item</button>
            </div>
        </form>
    </div>
</div>

<!-- Modal Popup for Confirm Delete -->
<div id="deleteModal" class="modal" style="display: none;">
    <div class="modal-content">
        
        <h3>Confirm Deletion</h3>
        <p>Are you sure you want to delete this item?</p>

        <div class="button-container">
            <button id="cancelDeleteBtn">Cancel</button>
            <button id="confirmDeleteBtn">Yes, Delete</button>
        </div>
    </div>
</div>

<!-- Hidden iframe to handle form submission -->
<iframe id="hidden_iframe" name="hidden_iframe" style="display:none;"></iframe>

<!-- Message Box for Success/Failure Messages -->
<div id="messageBox" class="message-box"></div>

<!-- JavaScript to handle category loading, form submission, and updates -->
<script>
    // Load categories and items
    function loadCategories() {
        const xhr = new XMLHttpRequest();
        xhr.open('GET', '<%= request.getContextPath() %>/LoadCategoriesServletItem', true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                const categories = JSON.parse(xhr.responseText);
                const addItemCategorySelect = document.getElementById('addItemCategorySelect');
                const deleteItemCategorySelect = document.getElementById('deleteItemCategorySelect');

                // Clear previous options
                addItemCategorySelect.innerHTML = '<option value="" disabled selected>Select Category</option>';
                deleteItemCategorySelect.innerHTML = '<option value="" disabled selected>Select Category</option>';

                // Populate category select options
                if (categories.length > 0) {
                    categories.forEach(function (category) {
                        const option = document.createElement('option');
                        option.value = category.category_id;  // Use category ID as the value
                        option.textContent = category.category_name;  // Display category name
                        addItemCategorySelect.appendChild(option.cloneNode(true));
                        deleteItemCategorySelect.appendChild(option.cloneNode(true));
                    });
                }
            } else {
                console.error("Error fetching categories.");
            }
        };

        xhr.onerror = function () {
            console.error("Request failed.");
        };

        xhr.send();

        // Set up event listener to load items when a category is selected
        document.getElementById('deleteItemCategorySelect').addEventListener('change', loadItemsForCategory);
    }

    // Load items for the selected category
    function loadItemsForCategory() {
        const selectedCategory = document.getElementById('deleteItemCategorySelect').value;
        if (!selectedCategory) return;

        const xhr = new XMLHttpRequest();
        xhr.open('GET', '<%= request.getContextPath() %>/LoadItemsServlet?categoryId=' + encodeURIComponent(selectedCategory), true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                const items = JSON.parse(xhr.responseText);
                const itemSelect = document.getElementById('itemSelect');
                itemSelect.innerHTML = '<option value="" disabled selected>Select Item</option>'; // Clear previous options

                if (items.length > 0) {
                    items.forEach(function (item) {
                        const option = document.createElement('option');
                        option.value = item.item_id;
                        option.textContent = item.item_name;
                        itemSelect.appendChild(option);
                    });

                    // Add an event listener to populate item details
                    document.getElementById('itemSelect').addEventListener('change', loadItemDetails);
                } else {
                    const option = document.createElement('option');
                    option.textContent = "No items available";
                    itemSelect.appendChild(option);
                }
            } else {
                console.error("Error fetching items.");
            }
        };

        xhr.onerror = function () {
            console.error("Request failed.");
        };

        xhr.send();
    }

    // Load item details when an item is selected
    function loadItemDetails() {
        const selectedItemId = document.getElementById('itemSelect').value;
        if (!selectedItemId) return;

        const xhr = new XMLHttpRequest();
        xhr.open('GET', '<%= request.getContextPath() %>/LoadItemDetailsServlet?itemId=' + encodeURIComponent(selectedItemId), true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                const itemDetails = JSON.parse(xhr.responseText);
                
                // Format and display the item price with "$" sign
                const formattedPrice = "$" + parseFloat(itemDetails.price).toFixed(2);
                document.getElementById('itemPrice').value = formattedPrice;
                document.getElementById('itemDescription').value = itemDetails.description;
            } else {
                console.error("Error fetching item details.");
            }
        };

        xhr.onerror = function () {
            console.error("Request failed.");
        };

        xhr.send();
    }
    
 // Function to handle form submission for Add Item via AJAX
    function submitAddItemForm() {
        const form = document.getElementById('addItemForm');
        const formData = new FormData(form);

        // Log the form data for debugging
        console.log('Form Data:', formData);

        // Send the form data via AJAX
        fetch('<%= request.getContextPath() %>/AddItemServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok.');
            }
            return response.text();
        })
        .then(data => {
            console.log('Server response:', data); // Log server response

            // Show success message
            showMessage('Item added successfully!', 'success');

            // Clear the form fields after successful submission
            form.reset();  // This will clear all input fields

            // Optionally, refresh the categories/items to reflect the new item
            loadCategories();
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Failed to add item.', 'error');
        });
    }


    // Enable update fields and button
    function enableUpdate() {
        document.getElementById('itemPrice').readOnly = false;
        document.getElementById('itemDescription').readOnly = false;
        document.getElementById('enableUpdateBtn').style.display = 'none';
        document.getElementById('updateItemBtn').style.display = 'inline-block';
    }

 // Handle Update Item submission via AJAX
    function submitUpdateItem() {
        const itemId = document.getElementById('itemSelect').value;
        let itemPrice = document.getElementById('itemPrice').value;
        const itemDescription = document.getElementById('itemDescription').value;

        // Remove "$" sign from price before sending
        itemPrice = itemPrice.replace('$', '');

        // Check if fields are empty
        if (!itemId || !itemPrice || !itemDescription) {
            showMessage('Please fill in all fields before updating.', 'error');
            return;
        }

        const formData = new URLSearchParams();
        formData.append('itemId', itemId);
        formData.append('itemPrice', itemPrice);
        formData.append('itemDescription', itemDescription);

        // Log the data to verify it's correct before sending
        console.log('Sending data:', {
            itemId: itemId,
            itemPrice: itemPrice,
            itemDescription: itemDescription
        });

        fetch('<%= request.getContextPath() %>/UpdateItemServlet', {
            method: 'POST',
            body: formData,
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'  // Send data in URL-encoded format
            }
        })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok.');
            }
            return response.text();
        })
        .then(data => {
            console.log('Server response:', data); // Log the server response
            showMessage('Item updated successfully!', 'success');

            // Clear the input fields after successful update
            document.getElementById('itemPrice').value = '';
            document.getElementById('itemDescription').value = '';

            // Lock the fields after successful update
            document.getElementById('itemPrice').readOnly = true;
            document.getElementById('itemDescription').readOnly = true;
            document.getElementById('enableUpdateBtn').style.display = 'inline-block';
            document.getElementById('updateItemBtn').style.display = 'none';

            // Optionally reload categories/items to reflect changes
            loadCategories();
        })
        .catch(error => {
            console.error('Error:', error);
            showMessage('Failed to update item.', 'error');
        });
    }


 // Function to handle delete submission
    function confirmDelete() {
        const itemId = document.getElementById('itemSelect').value;
        if (!itemId) {
            showMessage('Please select an item to delete.', 'error');
            return false; // Prevent form submission
        }

        const modal = document.getElementById('deleteModal');
        modal.style.display = 'block';

        // "Yes, Delete" button
        document.getElementById('confirmDeleteBtn').onclick = function() {
            modal.style.display = 'none';
            // Submit the delete form
            const formData = new URLSearchParams();
            formData.append('item_to_delete', itemId);

            fetch('<%= request.getContextPath() %>/DeleteItemServlet', {
                method: 'POST',
                body: formData,
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                }
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok.');
                }
                return response.text();
            })
            .then(data => {
                console.log('Server response:', data); // Log server response
                showMessage('Item deleted successfully!', 'success');

                // Clear the fields after successful deletion
                document.getElementById('itemPrice').value = '';
                document.getElementById('itemDescription').value = '';
                document.getElementById('itemSelect').value = '';
                document.getElementById('deleteItemCategorySelect').value = '';

                // Optionally, reload categories or items to reflect changes
                loadCategories();
            })
            .catch(error => {
                console.error('Error:', error);
                showMessage('Failed to delete item.', 'error');
            });
        };

        // "Cancel" button
        document.getElementById('cancelDeleteBtn').onclick = function() {
            modal.style.display = 'none'; // Close modal
        };

        // Prevent form submission until user confirms deletion
        return false;
    }

    // Function to show success/failure message
    function showMessage(message, status) {
        const messageBox = document.getElementById('messageBox');
        messageBox.textContent = message;
        messageBox.style.display = 'block';
        messageBox.style.color = status === 'success' ? 'green' : 'red';

        // Auto-hide message after 3 seconds
        setTimeout(() => {
            messageBox.style.display = 'none';
        }, 3000);
    }


    // Load categories on page load
    window.onload = function() {
        loadCategories();
    };
</script>

</body>
</html>
