<title>Update/Delete Category</title>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/update.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    /* Message Box Styling */
    #messageBox {
        display: none;
        margin-top: 20px;
        background-color: #2b2b2b;
        color: #00ff00;
        padding: 10px;
        border-radius: 5px;
        text-align: center;
    }
</style>
</head>
<body>

<h2>Update/Delete Category</h2>

<!-- Flex container for the forms -->
<div class="flex-container">
    <!-- Add New Category Form -->
    <div class="form-section-category">
        <h3>Add New Category</h3>
        <form id="addCategoryForm" method="post" action="<%= request.getContextPath() %>/AddDeleteCategoryServlet" enctype="multipart/form-data">
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

    <!-- Delete Category Form -->
    <div class="form-section-category">
        <h3>Delete Category</h3>
        <form id="deleteCategoryForm" method="post" action="<%= request.getContextPath() %>/AddDeleteCategoryServlet">
            <label>Select Category to Delete:</label>
            <select id="categorySelect" name="category_to_delete" required>
                <option value="" disabled selected>Select Category</option>
                <!-- Categories will be loaded via AJAX -->
            </select>
            <input type="hidden" name="action" value="deleteCategory">
            <br><br>
            <button type="submit">Delete Category</button>
        </form>
    </div>
</div>

<!-- Message Box for Success/Failure -->
<div id="messageBox"></div>

<!-- JavaScript to Load Categories and Handle Form Submission -->
<script>
    $(document).ready(function() {
        // Load categories via AJAX
        $.ajax({
            url: '<%= request.getContextPath() %>/LoadCategoriesServlet',
            method: 'GET',
            success: function(data) {
                var categorySelect = $('#categorySelect');
                categorySelect.empty(); // Clear the dropdown
                categorySelect.append('<option value="" disabled selected>Select Category</option>');
                
                data.forEach(function(category) {
                    categorySelect.append('<option value="' + category + '">' + category + '</option>');
                });
            },
            error: function() {
                alert('Failed to load categories');
            }
        });

        // Handle form submission for both Add and Delete Category
        $('#addCategoryForm, #deleteCategoryForm').on('submit', function(event) {
            event.preventDefault(); // Prevent default form submission

            var form = $(this);

            $.ajax({
                url: form.attr('action'),
                method: form.attr('method'),
                data: new FormData(this),
                processData: false,
                contentType: false,
                success: function(response) {
                    showMessage("Operation successful!"); // Success message

                    // Clear the form fields after successful submission
                    form[0].reset();
                },
                error: function() {
                    showMessage("Operation failed!"); // Failure message
                }
            });
        });
    });

    // Function to show message, auto-close after 2 seconds, and reload the page
    function showMessage(message) {
        var messageBox = $('#messageBox');
        messageBox.text(message);
        messageBox.fadeIn(); // Show message

        // Hide message after 2 seconds and reload the page
        setTimeout(function() {
            messageBox.fadeOut(); // Hide the message
            location.reload();    // Reload the page
        }, 1000);
    }
</script>


</body>
</html>
