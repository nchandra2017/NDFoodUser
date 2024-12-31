
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Store Control</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/css/Admin-Store-Control.css">
</head>
<body>

<jsp:include page="/jsp/admin_control/sidebar.jsp" />

<div class="container">
    <h2>Manage Store Hours</h2>

    <!-- Display success message if updateSuccess attribute is true -->
    <%
        Boolean updateSuccess = (Boolean) request.getAttribute("updateSuccess");
        if (updateSuccess != null && updateSuccess) {
    %>
        <div class="success-message">Store hours updated successfully!</div>
    <%
        }
    %>

    <div class="form-section">
        <form action="/bangalifood/UpdateStoreHoursServlet" method="post">
            <h3>Morning Hours</h3>
            <label for="morningOpeningTime">Opening Time:</label>
            <input type="time" id="morningOpeningTime" name="morningOpeningTime" required>
            
            <label for="morningClosingTime">Closing Time:</label>
            <input type="time" id="morningClosingTime" name="morningClosingTime" required>
            
            <h3>Evening Hours</h3>
            <label for="eveningOpeningTime">Opening Time:</label>
            <input type="time" id="eveningOpeningTime" name="eveningOpeningTime" required>
            
            <label for="eveningClosingTime">Closing Time:</label>
            <input type="time" id="eveningClosingTime" name="eveningClosingTime" required>

            <button type="submit">Update Store Hours</button>
        </form>
    </div>
</div>

</body>
</html>
