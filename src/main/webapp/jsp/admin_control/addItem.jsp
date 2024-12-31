<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Update/Delete Category and Items</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/update.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/AdminPanel.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/ProfileStyle.css">
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/AddAndDeleteForm.css">
</head>
<body>

<jsp:include page="/jsp/admin_control/sidebar.jsp" />

<!-- Centered Buttons for Update/Delete Category and Update/Delete Item -->
<div class="centered-buttons">
    
    <button onclick="openModal('itemModal')">Update/Delete Item</button>
</div>

<!-- Popup Modal for Update/Delete Category -->
<div id="categoryModal" class="modal-category">
    <div class="modal-content-category">
        <span class="close" onclick="closeModal('categoryModal')">&times;</span>

        <div class="flex-container-category">
            <!-- Add Category Section -->
            <div class="form-section-category">
                <h3>Add New Category</h3>
                <form id="addCategoryForm" method="post" action="<%= request.getContextPath() %>/AddDeleteCategoryServlet" enctype="multipart/form-data" target="hidden_iframe" onsubmit="formSubmissionHandler(); return false;">
                    <label>New Category Name:</label>
                    <input type="text" name="new_category_name" required>
                    <br><br>
                    <label>Category Image:</label>
                    <input type="file" name="category_image" accept="image/*">
                    <input type="hidden" name="action" value="addCategory">
                    <br><br>
                    <button type="submit">Add Category</button>
                </form>
            </div>

            <!-- Delete Category Section -->
            <div class="form-section-category">
                <h3>Delete Category</h3>
                <form method="post" action="<%= request.getContextPath() %>/AddDeleteCategoryServlet" target="hidden_iframe" onsubmit="formSubmissionHandler(); return false;">
                    <label>Select Category to Delete:</label>
                    <select id="categorySelect" name="category_to_delete" required>
                        <option value="" disabled selected>Select Category</option>
                        <!-- Categories will be loaded here via AJAX -->
                    </select>
                    <input type="hidden" name="action" value="deleteCategory">
                    <br><br>
                    <button type="submit">Delete Category</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Popup Modal for Update/Delete Item -->
<div id="itemModal" class="modal-item">
    <div class="modal-content-item">
        <span class="close" onclick="closeModal('itemModal')">&times;</span>

        <div class="flex-container-item">
            <!-- Add Item Section -->
            <div class="form-section-item">
                <h3>Add New Item</h3>
                <form id="addItemForm" method="post" action="<%= request.getContextPath() %>/UpdateServlet" enctype="multipart/form-data" target="hidden_iframe" onsubmit="formSubmissionHandler(); return false;">
                    <label>Select Category:</label>
                    <select id="addItemCategorySelect" name="category_for_item" required>
                        <option value="" disabled selected>Select Category</option>
                        <!-- Categories will be loaded here via AJAX -->
                    </select>
                    <br><br>
                    <label>New Item Name:</label>
                    <input type="text" name="new_item_name" required>
                    <br><br>
                    <label>Item Price:</label>
                    <input type="number" name="new_item_price" required>
                    <br><br>
                    <label>Item Description:</label>
                    <textarea name="new_item_description" required></textarea>
                    <br><br>
                    <button type="submit">Add Item</button>
                </form>
            </div>

            <!-- Delete Item Section -->
            <div class="form-section-item">
                <h3>Delete Item</h3>
                <form method="post" action="<%= request.getContextPath() %>/UpdateServlet" target="hidden_iframe" onsubmit="formSubmissionHandler(); return false;">
                    <label>Select Category:</label>
                    <select id="deleteItemCategorySelect" name="category_for_delete_item" required>
                        <option value="" disabled selected></option>
                        <!-- Categories will be loaded here via AJAX -->
                    </select>
                    <br><br>
                    <label>Select Item:</label>
                    <select id="itemSelect" name="item_to_delete" required>
                        <option value="" disabled selected>Select Item</option>
                        <!-- Items will be loaded here based on category via AJAX -->
                    </select>
                    <br><br>
                    <button type="submit">Delete Item</button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Hidden iframe to handle form submission -->
<iframe id="hidden_iframe" name="hidden_iframe" style="display:none;"></iframe>

<!-- Message Box for Success/Failure Messages -->
<div id="messageBox" style="display:none;"></div>

<!-- JavaScript Section -->
<script>
    // Function to open modal by modal ID
    function openModal(modalId) {
        document.getElementById(modalId).style.display = "block";
    }

    // Function to close modal by modal ID
    function closeModal(modalId) {
        document.getElementById(modalId).style.display = "none";
    }

    // Close the modal when clicking outside of it
    window.onclick = function(event) {
        var categoryModal = document.getElementById('categoryModal');
        var itemModal = document.getElementById('itemModal');

        if (event.target == categoryModal) {
            categoryModal.style.display = "none";
        } else if (event.target == itemModal) {
            itemModal.style.display = "none";
        }
    }

    // Function to load categories via AJAX for both modals
    function loadCategories() {
        openModal('categoryModal');

        const xhr = new XMLHttpRequest();
        xhr.open('GET', '/bangalifood/LoadCategories', true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                console.log("Data fetched successfully:", xhr.responseText);
                
                try {
                    const categories = JSON.parse(xhr.responseText);
                    const categorySelect = document.getElementById('categorySelect');
                    const addItemCategorySelect = document.getElementById('addItemCategorySelect');
                    const deleteItemCategorySelect = document.getElementById('deleteItemCategorySelect');

                    // Clear previous options and add the default "Select Category" option
                    categorySelect.innerHTML = '<option value="" disabled selected>Select Category</option>';
                    addItemCategorySelect.innerHTML = '<option value="" disabled selected>Select Category</option>';
                    deleteItemCategorySelect.innerHTML = '<option value="" disabled selected>Select Category</option>';
                    
                    if (categories.length > 0) {
                        categories.forEach(function (category) {
                            const option = document.createElement('option');
                            option.value = category;
                            option.textContent = category;

                            // Populate all select elements
                            categorySelect.appendChild(option.cloneNode(true));
                            addItemCategorySelect.appendChild(option.cloneNode(true));
                            deleteItemCategorySelect.appendChild(option.cloneNode(true));
                        });
                    } else {
                        const option = document.createElement('option');
                        option.textContent = "No Categories Available";
                        categorySelect.appendChild(option);
                        addItemCategorySelect.appendChild(option.cloneNode(true));
                        deleteItemCategorySelect.appendChild(option.cloneNode(true));
                    }
                } catch (e) {
                    console.error("Error parsing JSON:", e);
                    alert("Error loading categories.");
                }
            } else {
                console.error("Error fetching categories. Status:", xhr.status);
            }
        };
        xhr.onerror = function () {
            console.error("Request failed.");
        };
        xhr.send();

        // Set up event listener to load items when a category is selected in Delete Item form
        document.getElementById('deleteItemCategorySelect').addEventListener('change', loadItemsForCategory);
    }

  
    // Function to load items based on selected category via AJAX
    function loadItemsForCategory() {
        const selectedCategory = document.getElementById('deleteItemCategorySelect').value;

        // Make sure a category is selected
        if (!selectedCategory) return;

        const xhr = new XMLHttpRequest();
        xhr.open('GET', '<%= request.getContextPath() %>/LoadItemsServlet?categoryId=' + encodeURIComponent(selectedCategory), true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                const items = JSON.parse(xhr.responseText);
                const itemSelect = document.getElementById('itemSelect');
                itemSelect.innerHTML = '<option value="" disabled selected>Select Item</option>'; // Clear previous options and add default option

                if (items.length > 0) {
                    items.forEach(function (item) {
                        const option = document.createElement('option');
                        option.value = item.item_id;
                        option.textContent = item.item_name;
                        itemSelect.appendChild(option);
                    });
                } else {
                    const option = document.createElement('option');
                    option.textContent = "No Items Available";
                    itemSelect.appendChild(option);
                }
            } else {
                console.error("Error fetching items. Status:", xhr.status);
            }
        };

        xhr.onerror = function () {
            console.error("Request failed.");
        };

        xhr.send();
    }



    // Handle form submission and display success/failure message
    function formSubmissionHandler() {
        var messageBox = document.getElementById('messageBox');

        // Determine which form was submitted
        var iframeDoc = document.getElementById('hidden_iframe').contentDocument || document.getElementById('hidden_iframe').contentWindow.document;

        if (iframeDoc) {
            var responseText = iframeDoc.body.innerHTML.trim();
            var normalizedResponse = responseText.toLowerCase().trim();

            if (normalizedResponse.includes('successfully')) {
                messageBox.textContent = normalizedResponse.includes("category") ? "Category operation successful!" : "Item operation successful!";
                messageBox.style.color = "green";
            } else {
                messageBox.textContent = "Operation failed!";
                messageBox.style.color = "red";
            }

            messageBox.style.display = "block";

            // Close modal after 2 seconds and reload the page
            setTimeout(function() {
                closeModal('categoryModal');
                closeModal('itemModal');
                messageBox.style.display = "none"; 
                window.location.reload(); 
            }, 2000);
        }
    }
</script>

</body>
</html>
