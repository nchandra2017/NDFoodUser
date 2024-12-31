<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <!-- Buttons to open modals -->
    <button onclick="openModal('categoryModal')">Update/Delete Category</button>
    <button onclick="openModal('itemModal')">Update/Delete Item</button>
</div>

<!-- Popup Modal for Update/Delete Category -->
<div id="categoryModal" class="modal-category" style="display:none;">
    <div class="modal-content-category">
        <span class="close" onclick="closeModal('categoryModal')">&times;</span>
        
        <!-- Include the content from updateDeleteCategory.jsp -->
        <jsp:include page="/jsp/admin_control/updateDeleteCategory.jsp" />
    </div>
</div>

<!-- Popup Modal for Update/Delete Item -->
<div id="itemModal" class="modal-item" style="display:none;">
    <div class="modal-content-item">
        <span class="close" onclick="closeModal('itemModal')">&times;</span>
        
        <!-- Include the content from updateDeleteItem.jsp -->
        <jsp:include page="/jsp/admin_control/updateDeleteItem.jsp" />
    </div>
</div>

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
</script>

</body>
</html>
